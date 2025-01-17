# `OptionMarketWrapperWithSwaps`

Allows users to open/close positions in any market with multiple stablecoins

## Functions:

- `updateContractParams(contract ICurve _curveSwap, contract SynthetixAdapter _synthetixAdapter, contract IFeeCounter _tradingRewards, uint256 _minReturnPercent) (external)`

- `addCurveStable(contract ERC20 token, uint8 id) (external)`

- `removeCurveStable(uint8 id) (external)`

- `addMarket(contract OptionMarket optionMarket, uint8 id, struct OptionMarketWrapperWithSwaps.OptionMarketContracts _marketContracts) (external)`

- `removeMarket(uint8 id) (external)`

- `openPosition(struct OptionMarketWrapperWithSwaps.OptionPositionParams params) (external)`

- `closePosition(struct OptionMarketWrapperWithSwaps.OptionPositionParams params) (external)`

- `forceClosePosition(struct OptionMarketWrapperWithSwaps.OptionPositionParams params) (external)`

- `_openPosition(struct OptionMarketWrapperWithSwaps.OptionPositionParams params) (internal)`

- `_closePosition(struct OptionMarketWrapperWithSwaps.OptionPositionParams params, bool forceClose) (internal)`

- `_getReturnDetails(struct OptionMarketWrapperWithSwaps.OptionPositionParams params, struct OptionMarket.Result result, int256 swapFee) (internal)`

- `getMarketAndErcIds() (public)`

- `getBalancesAndAllowances(address owner) (external)`

- `_returnQuote(contract ERC20 quoteAsset, contract ERC20 inputAsset) (internal)`

- `_returnBase(contract ERC20 baseAsset, contract OptionToken token, uint256 positionId) (internal)`

- `_isLong(enum OptionMarket.OptionType optionType) (internal)`

- `_swapWithCurve(contract ERC20 from, contract ERC20 to, uint256 amount, uint256 expected, address receiver) (internal)`

- `_checkValidStable(address token) (internal)`

- `quoteCurveSwap(address fromToken, address toToken, uint256 amountIn) (external)`

- `_transferBaseCollateral(enum OptionMarket.OptionType optionType, uint256 currentCollateral, uint256 setCollateralTo, contract ERC20 baseAsset) (internal)`

- `_transferAsset(contract ERC20 asset, address from, address to, uint256 amount) (internal)`

- `_approveAsset(contract ERC20 asset, address approving) (internal)`

- `_composeTradeParams(struct OptionMarketWrapperWithSwaps.OptionPositionParams params) (internal)`

- `_emitEvent(struct OptionMarketWrapperWithSwaps.ReturnDetails returnDetails, bool isOpen, bool isLong) (internal)`

- `_incrementTradingRewards(address market, address trader, uint256 amount, uint256 totalCost, uint256 totalFee) (internal)`

## Events:

- `PositionTraded(bool isOpen, bool isLong, address market, uint256 positionId, address owner, uint256 amount, uint256 totalCost, uint256 totalFee, int256 swapFee, address token)`

- `WrapperParamsUpdated(contract ICurve curveSwap, contract SynthetixAdapter synthetixAdapter, contract IFeeCounter tradingRewards, uint256 minReturnPercent)`

- `SetCollateralTo(uint256 newCollateral)`

### Function `updateContractParams(contract ICurve _curveSwap, contract SynthetixAdapter _synthetixAdapter, contract IFeeCounter _tradingRewards, uint256 _minReturnPercent) external`

Initialises the contract

#### Parameters:

- `_curveSwap`: The Curve contract address

### Function `addCurveStable(contract ERC20 token, uint8 id) external`

Adds stablecoin with desired index reflected in the curve contract

#### Parameters:

- `token`: Address of the stablecoin

- `id`: Desired id to set the stablecoin

### Function `removeCurveStable(uint8 id) external`

### Function `addMarket(contract OptionMarket optionMarket, uint8 id, struct OptionMarketWrapperWithSwaps.OptionMarketContracts _marketContracts) external`

### Function `removeMarket(uint8 id) external`

### Function `openPosition(struct OptionMarketWrapperWithSwaps.OptionPositionParams params) → struct OptionMarketWrapperWithSwaps.ReturnDetails returnDetails external`

### Function `closePosition(struct OptionMarketWrapperWithSwaps.OptionPositionParams params) → struct OptionMarketWrapperWithSwaps.ReturnDetails returnDetails external`

### Function `forceClosePosition(struct OptionMarketWrapperWithSwaps.OptionPositionParams params) → struct OptionMarketWrapperWithSwaps.ReturnDetails returnDetails external`

### Function `_openPosition(struct OptionMarketWrapperWithSwaps.OptionPositionParams params) → struct OptionMarketWrapperWithSwaps.ReturnDetails returnDetails internal`

Attempts to open positions within bounds, reverts if the returned amount is outside of the accepted bounds.

#### Parameters:

- `params`: The params required to open a position

### Function `_closePosition(struct OptionMarketWrapperWithSwaps.OptionPositionParams params, bool forceClose) → struct OptionMarketWrapperWithSwaps.ReturnDetails returnDetails internal`

Attempts to close some amount of an open position within bounds, reverts if the returned amount is outside of

the accepted bounds.

#### Parameters:

- `params`: The params required to open a position

### Function `_getReturnDetails(struct OptionMarketWrapperWithSwaps.OptionPositionParams params, struct OptionMarket.Result result, int256 swapFee) → struct OptionMarketWrapperWithSwaps.ReturnDetails internal`

### Function `getMarketAndErcIds() → uint8[], uint8[] public`

### Function `getBalancesAndAllowances(address owner) → struct OptionMarketWrapperWithSwaps.StableAssetView[], struct OptionMarketWrapperWithSwaps.MarketAssetView[], struct OptionMarketWrapperWithSwaps.LiquidityBalanceAndAllowance[] external`

Returns addresses, balances and allowances of all supported tokens for a list of markets

#### Parameters:

- `owner`: Owner of tokens

### Function `_returnQuote(contract ERC20 quoteAsset, contract ERC20 inputAsset) → uint256 quoteBalance, int256 swapFee internal`

Returns quote back in the desired stablecoin

#### Parameters:

- `inputAsset`: Stablecoin to be returned

### Function `_returnBase(contract ERC20 baseAsset, contract OptionToken token, uint256 positionId) internal`

Returns excess baseAsset back to user

#### Parameters:

- `baseAsset`: Base asset to be returned

- `token`: OptionToken to check if active

- `positionId`: Is the positionId

### Function `_isLong(enum OptionMarket.OptionType optionType) → bool internal`

### Function `_swapWithCurve(contract ERC20 from, contract ERC20 to, uint256 amount, uint256 expected, address receiver) → uint256 amountOut, int256 swapFee internal`

Attempts to swap the input token with the desired stablecoin.

#### Parameters:

- `from`: The token being swapped

- `to`: The token being received

- `amount`: Quantity of from being exchanged

- `expected`: Minimum quantity of to received in order for the transaction to succeed

- `receiver`: The receiving address of the tokens

### Function `_checkValidStable(address token) → bool internal`

checks if the token is in the stablecoin mapping

### Function `quoteCurveSwap(address fromToken, address toToken, uint256 amountIn) → address pool, uint256 amountOut external`

returns amount of toToken after a swap

#### Parameters:

- `amountIn`: the amount of input tokens for the swap

#### Return Values:

- pool the address of the swap pool

- amountOut the amount of output tokens for the swap

### Function `_transferBaseCollateral(enum OptionMarket.OptionType optionType, uint256 currentCollateral, uint256 setCollateralTo, contract ERC20 baseAsset) internal`

### Function `_transferAsset(contract ERC20 asset, address from, address to, uint256 amount) internal`

### Function `_approveAsset(contract ERC20 asset, address approving) internal`

### Function `_composeTradeParams(struct OptionMarketWrapperWithSwaps.OptionPositionParams params) → struct OptionMarket.TradeInputParameters tradeParameters internal`

### Function `_emitEvent(struct OptionMarketWrapperWithSwaps.ReturnDetails returnDetails, bool isOpen, bool isLong) internal`

### Function `_incrementTradingRewards(address market, address trader, uint256 amount, uint256 totalCost, uint256 totalFee) internal`

### Event `PositionTraded(bool isOpen, bool isLong, address market, uint256 positionId, address owner, uint256 amount, uint256 totalCost, uint256 totalFee, int256 swapFee, address token)`

Emitted when a position is traded

### Event `WrapperParamsUpdated(contract ICurve curveSwap, contract SynthetixAdapter synthetixAdapter, contract IFeeCounter tradingRewards, uint256 minReturnPercent)`

Emitted when the contract parameters are updated

### Event `SetCollateralTo(uint256 newCollateral)`

Emitted collateral is changed for a position
