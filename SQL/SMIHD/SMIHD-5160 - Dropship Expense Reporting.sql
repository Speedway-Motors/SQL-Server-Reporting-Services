-- SMIHD-5160 - Dropship Expense Reporting

-- POTENTIALLY useful fields
SELECT O.ixOrder, O.ixCustomer, 
    sOrderType, sOrderChannel,
    iShipMethod, sMethodOfPayment, 
    mMerchandise, mShipping, mTax, mCredits,  mMerchandiseCost, 
    O.dtOrderDate, O.dtShippedDate, mAmountPaid
    /******ORDERLINE*******/
    ixSKU, iQuantity, mUnitPrice, mExtendedPrice, flgLineStatus,  mCost, mExtendedCost, flgKitComponent
FROM tblOrder O
left join tblOrderLine OL on O.ixOrder = OL.ixOrder
where O.ixOrder in ('6184086','6243883','6345181','6447188','6487387','6441482','6595073')
order by O.ixOrder

