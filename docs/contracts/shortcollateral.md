# `ShortCollateral`

Holds collateral from users who are selling (shorting) options to the OptionMarket.

## Modifiers:

- `onlyOptionMarket()`

- `notGlobalPaused()`

## Functions:

- `init(contract OptionMarket _optionMarket, contract LiquidityPool _liquidityPool, contract OptionToken _optionToken, contract SynthetixAdapter _synthetixAdapter, contract ERC20 _quoteAsset, contract ERC20 _baseAsset) (external)`

- `updateDelegateApproval() (external)`

- `sendQuoteCollateral(address recipient, uint256 amount) (external)`

- `sendBaseCollateral(address recipient, uint256 amount) (external)`

- `routeLiquidationFunds(address trader, address liquidator, enum OptionMarket.OptionType optionType, struct OptionToken.LiquidationFees liquidationFees) (external)`

- `boardSettlement(uint256 amountBase, uint256 amountQuote) (external)`

- `settleOptions(uint256[] positionIds) (external)`

- `_reclaimInsolvency(uint256 baseInsolventAmount, uint256 quoteInsolventAmount) (internal)`

- `_sendLongCallProceeds(address account, uint256 amount, uint256 strikePrice, uint256 priceAtExpiry) (internal)`

- `_sendLongPutProceeds(address account, uint256 amount, uint256 strikePrice, uint256 priceAtExpiry) (internal)`

- `_sendShortCallBaseProceeds(address account, uint256 userCollateral, uint256 amount, uint256 strikeToBaseReturnedRatio) (internal)`

- `_sendShortCallQuoteProceeds(address account, uint256 userCollateral, uint256 amount, uint256 strikePrice, uint256 priceAtExpiry) (internal)`

- `_sendShortPutQuoteProceeds(address account, uint256 userCollateral, uint256 amount, uint256 strikePrice, uint256 priceAtExpiry) (internal)`

- `_getInsolvency(uint256 userCollateral, uint256 ammProfit) (internal)`

- `_sendQuoteCollateral(address recipient, uint256 amount) (internal)`

- `_sendBaseCollateral(address recipient, uint256 amount) (internal)`

- `_exchangeAndSendBaseCollateral(address recipient, uint256 amountBase) (internal)`

## Events:

- `BoardSettlementCollateralSent(uint256 amountBaseSent, uint256 amountQuoteSent, uint256 lpBaseInsolvency, uint256 lpQuoteInsolvency, uint256 LPBaseExcess, uint256 LPQuoteExcess)`

- `PositionSettled(uint256 positionId, address settler, address optionOwner, uint256 strikePrice, uint256 priceAtExpiry, enum OptionMarket.OptionType optionType, uint256 amount, uint256 settlementAmount, uint256 insolventAmount)`

- `QuoteSent(address receiver, uint256 amount)`

- `BaseSent(address receiver, uint256 amount)`

- `BaseExchangedAndQuoteSent(address recipient, uint256 amountBase, uint256 quoteReceived)`

### Modifier `onlyOptionMarket()`

### Modifier `notGlobalPaused()`

### Function `init(contract OptionMarket _optionMarket, contract LiquidityPool _liquidityPool, contract OptionToken _optionToken, contract SynthetixAdapter _synthetixAdapter, contract ERC20 _quoteAsset, contract ERC20 _baseAsset) external`

Initialize the contract.

### Function `updateDelegateApproval() external`

In case of an update to the synthetix contract that revokes the approval

### Function `sendQuoteCollateral(address recipient, uint256 amount) external`

Transfers quoteAsset to the recipient. This should only be called by OptionMarket in the following cases:

- A short is closed, in which case the premium for the option is sent to the LP

- A user reduces their collateral position on a quote collateralized option

#### Parameters:

- `recipient`: The recipient of the transfer.

- `amount`: The amount to send.

### Function `sendBaseCollateral(address recipient, uint256 amount) external`

Transfers baseAsset to the recipient. This should only be called by OptionMarket when a user is reducing

their collateral on a base collateralized option.

#### Parameters:

- `recipient`: The recipient of the transfer.

- `amount`: The amount to send.

### Function `routeLiquidationFunds(address trader, address liquidator, enum OptionMarket.OptionType optionType, struct OptionToken.LiquidationFees liquidationFees) external`

Transfers quote/base fees and remaining collateral when `OptionMarket.liquidatePosition()` called

- liquidator: liquidator portion of liquidation fees

- LiquidityPool: premium to close position + LP portion of liquidation fees

- OptionMarket: SM portion of the liquidation fees

- position owner: remaining collateral after all above fees deducted

#### Parameters:

- `trader`: address of position owner

- `liquidator`: address of liquidator

- `optionType`: OptionType

- `liquidationFees`: fee/collateral distribution as determined by OptionToken

### Function `boardSettlement(uint256 amountBase, uint256 amountQuote) → uint256 lpBaseInsolvency, uint256 lpQuoteInsolvency external`

Transfers quoteAsset and baseAsset to the LiquidityPool on board settlement.

#### Parameters:

- `amountBase`: The amount of baseAsset to transfer.

- `amountQuote`: The amount of quoteAsset to transfer.

#### Return Values:

- lpBaseInsolvency total base amount owed to LP but not sent due to large amount of user insolvencies

- lpQuoteInsolvency total quote amount owed to LP but not sent due to large amount of user insolvencies

### Function `settleOptions(uint256[] positionIds) external`

Routes profits or remaining collateral for settled long and short options.

#### Parameters:

- `positionIds`: The ids of the relevant OptionTokens.

### Function `_reclaimInsolvency(uint256 baseInsolventAmount, uint256 quoteInsolventAmount) internal`

Send quote or base owed to LiquidityPool due to large number of insolvencies

### Function `_sendLongCallProceeds(address account, uint256 amount, uint256 strikePrice, uint256 priceAtExpiry) → uint256 settlementAmount internal`

### Function `_sendLongPutProceeds(address account, uint256 amount, uint256 strikePrice, uint256 priceAtExpiry) → uint256 settlementAmount internal`

### Function `_sendShortCallBaseProceeds(address account, uint256 userCollateral, uint256 amount, uint256 strikeToBaseReturnedRatio) → uint256 settlementAmount, uint256 insolvency internal`

### Function `_sendShortCallQuoteProceeds(address account, uint256 userCollateral, uint256 amount, uint256 strikePrice, uint256 priceAtExpiry) → uint256 settlementAmount, uint256 insolvency internal`

### Function `_sendShortPutQuoteProceeds(address account, uint256 userCollateral, uint256 amount, uint256 strikePrice, uint256 priceAtExpiry) → uint256 settlementAmount, uint256 insolvency internal`

### Function `_getInsolvency(uint256 userCollateral, uint256 ammProfit) → uint256 returnCollateral, uint256 insolvency internal`

### Function `_sendQuoteCollateral(address recipient, uint256 amount) internal`

### Function `_sendBaseCollateral(address recipient, uint256 amount) internal`

### Function `_exchangeAndSendBaseCollateral(address recipient, uint256 amountBase) internal`

### Event `BoardSettlementCollateralSent(uint256 amountBaseSent, uint256 amountQuoteSent, uint256 lpBaseInsolvency, uint256 lpQuoteInsolvency, uint256 LPBaseExcess, uint256 LPQuoteExcess)`

Emitted when a board is settled

### Event `PositionSettled(uint256 positionId, address settler, address optionOwner, uint256 strikePrice, uint256 priceAtExpiry, enum OptionMarket.OptionType optionType, uint256 amount, uint256 settlementAmount, uint256 insolventAmount)`

Emitted when an Option is settled.

### Event `QuoteSent(address receiver, uint256 amount)`

Emitted when quote is sent to either a user or the LiquidityPool

### Event `BaseSent(address receiver, uint256 amount)`

Emitted when base is sent to either a user or the LiquidityPool

### Event `BaseExchangedAndQuoteSent(address recipient, uint256 amountBase, uint256 quoteReceived)`
