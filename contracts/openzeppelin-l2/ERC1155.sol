// SPDX-License-Identifier: MIT

pragma solidity ^0.7.6;

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155MetadataURI.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/introspection/ERC165.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "./Address.sol";

/**
 *
 * @dev Implementation of the basic standard multi-token.
 * See https://eips.ethereum.org/EIPS/eip-1155
 * Originally based on code by Enjin: https://github.com/enjin/erc-1155
 *
 * _Available since v3.1._
 */
contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
  using SafeMath for uint;
  using Address for address;

  // Mapping from token ID to account balances
  mapping(uint => mapping(address => uint)) private _balances;

  // Mapping from account to operator approvals
  mapping(address => mapping(address => bool)) private _operatorApprovals;

  // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
  string private _uri;

  /*
   *     bytes4(keccak256('balanceOf(address,uint256)')) == 0x00fdd58e
   *     bytes4(keccak256('balanceOfBatch(address[],uint256[])')) == 0x4e1273f4
   *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
   *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
   *     bytes4(keccak256('safeTransferFrom(address,address,uint256,uint256,bytes)')) == 0xf242432a
   *     bytes4(keccak256('safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)')) == 0x2eb2c2d6
   *
   *     => 0x00fdd58e ^ 0x4e1273f4 ^ 0xa22cb465 ^
   *        0xe985e9c5 ^ 0xf242432a ^ 0x2eb2c2d6 == 0xd9b67a26
   */
  bytes4 private constant _INTERFACE_ID_ERC1155 = 0xd9b67a26;

  /*
   *     bytes4(keccak256('uri(uint256)')) == 0x0e89341c
   */
  bytes4 private constant _INTERFACE_ID_ERC1155_METADATA_URI = 0x0e89341c;

  /**
   * @dev See {_setURI}.
   */
  constructor(string memory uri_) {
    _setURI(uri_);

    // register the supported interfaces to conform to ERC1155 via ERC165
    _registerInterface(_INTERFACE_ID_ERC1155);

    // register the supported interfaces to conform to ERC1155MetadataURI via ERC165
    _registerInterface(_INTERFACE_ID_ERC1155_METADATA_URI);
  }

  /**
   * @dev See {IERC1155MetadataURI-uri}.
   *
   * This implementation returns the same URI for *all* token types. It relies
   * on the token type ID substitution mechanism
   * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
   *
   * Clients calling this function must replace the `\{id\}` substring with the
   * actual token type ID.
   */
  function uri(uint) external view virtual override returns (string memory) {
    return _uri;
  }

  /**
   * @dev See {IERC1155-balanceOf}.
   *
   * Requirements:
   *
   * - `account` cannot be the zero address.
   */
  function balanceOf(address account, uint id) public view virtual override returns (uint) {
    require(account != address(0), "ERC1155: balance query for the zero address");
    return _balances[id][account];
  }

  /**
   * @dev See {IERC1155-balanceOfBatch}.
   *
   * Requirements:
   *
   * - `accounts` and `ids` must have the same length.
   */
  function balanceOfBatch(address[] memory accounts, uint[] memory ids)
    public
    view
    virtual
    override
    returns (uint[] memory)
  {
    require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");

    uint[] memory batchBalances = new uint[](accounts.length);

    for (uint i = 0; i < accounts.length; ++i) {
      batchBalances[i] = balanceOf(accounts[i], ids[i]);
    }

    return batchBalances;
  }

  /**
   * @dev See {IERC1155-setApprovalForAll}.
   */
  function setApprovalForAll(address operator, bool approved) public virtual override {
    require(_msgSender() != operator, "ERC1155: setting approval status for self");

    _operatorApprovals[_msgSender()][operator] = approved;
    emit ApprovalForAll(_msgSender(), operator, approved);
  }

  /**
   * @dev See {IERC1155-isApprovedForAll}.
   */
  function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
    return _operatorApprovals[account][operator];
  }

  /**
   * @dev See {IERC1155-safeTransferFrom}.
   */
  function safeTransferFrom(
    address from,
    address to,
    uint id,
    uint amount,
    bytes memory data
  ) public virtual override {
    require(to != address(0), "ERC1155: transfer to the zero address");
    require(from == _msgSender() || isApprovedForAll(from, _msgSender()), "ERC1155: caller is not owner nor approved");

    address operator = _msgSender();

    _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);

    _balances[id][from] = _balances[id][from].sub(amount, "ERC1155: insufficient balance for transfer");
    _balances[id][to] = _balances[id][to].add(amount);

    emit TransferSingle(operator, from, to, id, amount);
  }

  /**
   * @dev See {IERC1155-safeBatchTransferFrom}.
   */
  function safeBatchTransferFrom(
    address from,
    address to,
    uint[] memory ids,
    uint[] memory amounts,
    bytes memory data
  ) public virtual override {
    require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
    require(to != address(0), "ERC1155: transfer to the zero address");
    require(
      from == _msgSender() || isApprovedForAll(from, _msgSender()),
      "ERC1155: transfer caller is not owner nor approved"
    );

    address operator = _msgSender();

    _beforeTokenTransfer(operator, from, to, ids, amounts, data);

    for (uint i = 0; i < ids.length; ++i) {
      uint id = ids[i];
      uint amount = amounts[i];

      _balances[id][from] = _balances[id][from].sub(amount, "ERC1155: insufficient balance for transfer");
      _balances[id][to] = _balances[id][to].add(amount);
    }

    emit TransferBatch(operator, from, to, ids, amounts);
  }

  /**
   * @dev Sets a new URI for all token types, by relying on the token type ID
   * substitution mechanism
   * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
   *
   * By this mechanism, any occurrence of the `\{id\}` substring in either the
   * URI or any of the amounts in the JSON file at said URI will be replaced by
   * clients with the token type ID.
   *
   * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
   * interpreted by clients as
   * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
   * for token type ID 0x4cce0.
   *
   * See {uri}.
   *
   * Because these URIs cannot be meaningfully represented by the {URI} event,
   * this function emits no events.
   */
  function _setURI(string memory newuri) internal virtual {
    _uri = newuri;
  }

  /**
   * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
   *
   * Emits a {TransferSingle} event.
   *
   * Requirements:
   *
   * - `account` cannot be the zero address.
   * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
   * acceptance magic value.
   */
  function _mint(
    address account,
    uint id,
    uint amount,
    bytes memory data
  ) internal virtual {
    require(account != address(0), "ERC1155: mint to the zero address");

    address operator = _msgSender();

    _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);

    _balances[id][account] = _balances[id][account].add(amount);
    emit TransferSingle(operator, address(0), account, id, amount);
  }

  /**
   * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
   *
   * Requirements:
   *
   * - `ids` and `amounts` must have the same length.
   * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
   * acceptance magic value.
   */
  function _mintBatch(
    address to,
    uint[] memory ids,
    uint[] memory amounts,
    bytes memory data
  ) internal virtual {
    require(to != address(0), "ERC1155: mint to the zero address");
    require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");

    address operator = _msgSender();

    _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);

    for (uint i = 0; i < ids.length; i++) {
      _balances[ids[i]][to] = amounts[i].add(_balances[ids[i]][to]);
    }

    emit TransferBatch(operator, address(0), to, ids, amounts);
  }

  /**
   * @dev Destroys `amount` tokens of token type `id` from `account`
   *
   * Requirements:
   *
   * - `account` cannot be the zero address.
   * - `account` must have at least `amount` tokens of token type `id`.
   */
  function _burn(
    address account,
    uint id,
    uint amount
  ) internal virtual {
    require(account != address(0), "ERC1155: burn from the zero address");

    address operator = _msgSender();

    _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");

    _balances[id][account] = _balances[id][account].sub(amount, "ERC1155: burn amount exceeds balance");

    emit TransferSingle(operator, account, address(0), id, amount);
  }

  /**
   * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
   *
   * Requirements:
   *
   * - `ids` and `amounts` must have the same length.
   */
  function _burnBatch(
    address account,
    uint[] memory ids,
    uint[] memory amounts
  ) internal virtual {
    require(account != address(0), "ERC1155: burn from the zero address");
    require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");

    address operator = _msgSender();

    _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");

    for (uint i = 0; i < ids.length; i++) {
      _balances[ids[i]][account] = _balances[ids[i]][account].sub(amounts[i], "ERC1155: burn amount exceeds balance");
    }

    emit TransferBatch(operator, account, address(0), ids, amounts);
  }

  /**
   * @dev Hook that is called before any token transfer. This includes minting
   * and burning, as well as batched variants.
   *
   * The same hook is called on both single and batched variants. For single
   * transfers, the length of the `id` and `amount` arrays will be 1.
   *
   * Calling conditions (for each `id` and `amount` pair):
   *
   * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
   * of token type `id` will be  transferred to `to`.
   * - When `from` is zero, `amount` tokens of token type `id` will be minted
   * for `to`.
   * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
   * will be burned.
   * - `from` and `to` are never both zero.
   * - `ids` and `amounts` have the same, non-zero length.
   *
   * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
   */
  function _beforeTokenTransfer(
    address operator,
    address from,
    address to,
    uint[] memory ids,
    uint[] memory amounts,
    bytes memory data
  ) internal virtual {}

  function _asSingletonArray(uint element) private pure returns (uint[] memory) {
    uint[] memory array = new uint[](1);
    array[0] = element;

    return array;
  }
}