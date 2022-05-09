SELECT ixOrder
      ,ixCustomer
      ,sOrderChannel
      ,sSourceCodeGiven
      ,sMatchbackSourceCode
      ,sOrderTaker
      ,sPromoApplied
      ,ixOrderType
FROM tblOrder 
WHERE sPromoApplied IN ('BJ11512', 'BJ11512H', 'CB11012', 'CB11012H')
  AND sOrderStatus = 'Shipped'
ORDER BY sMatchbackSourceCode
