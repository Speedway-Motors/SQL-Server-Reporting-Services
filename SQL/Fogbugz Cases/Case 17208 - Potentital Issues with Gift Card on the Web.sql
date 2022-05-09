SELECT O.ixOrder 
     , O.ixCustomer 
     , O.mMerchandise
     , O.dtOrderDate 
     , GCD.ixGiftCard
     , GCD.mAmountRedeemed 
  --   , GCD.ixRedeemingCustomer
FROM tblOrder O 
JOIN tblGiftCardDetail GCD ON GCD.ixOrderRedeemed = O.ixOrder 
WHERE O.dtOrderDate BETWEEN '01/07/13' AND GETDATE()
  AND O.sOrderChannel = 'WEB'
  AND O.sOrderType <> 'Internal' 
  AND O.mMerchandise > 0 ;
  AND O.sOrderStatus <> 'Cancelled'
ORDER BY O.dtOrderDate   


