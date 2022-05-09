
SELECT O.sShipToZip AS 'Postal Code' 
     , COUNT(1) AS '# of Orders' 
     , SUM(O.mMerchandise) AS 'Merch.'
     , REF.TotalMerch AS 'Refund'
     , EXC.TotalMerch AS 'Exch./Credit'
   --  , SUM (P.dActualWeight) AS 'Total Weight'
     , SUM (P.dBillingWeight) AS 'Pkg. Weight'
FROM tblOrder O 
LEFT JOIN tblPackage P ON P.ixOrder = O.ixOrder 
LEFT JOIN (SELECT DISTINCT O.sShipToZip
                , SUM(CMM.mMerchandise)AS TotalMerch
           FROM tblOrder O 
           LEFT JOIN tblCreditMemoMaster CMM ON CMM.ixOrder = O.ixOrder 
           WHERE CMM.sMemoType = 'Refund'
             AND O.dtShippedDate BETWEEN '04/01/11' AND '03/31/12'
           GROUP BY O.sShipToZip
          ) AS REF ON REF.sShipToZip = O.sShipToZip 
LEFT JOIN (SELECT DISTINCT O.sShipToZip
                , SUM(CMM.mMerchandise)AS TotalMerch
           FROM tblOrder O 
           LEFT JOIN tblCreditMemoMaster CMM ON CMM.ixOrder = O.ixOrder 
           WHERE CMM.sMemoType = 'Exchange'
             AND O.dtShippedDate BETWEEN '04/01/11' AND '03/31/12'
           GROUP BY O.sShipToZip
          ) AS EXC ON EXC.sShipToZip = O.sShipToZip              
WHERE O.sShipToCountry IN ('CA', 'CANADA') 
  AND O.dtShippedDate BETWEEN '04/01/11' AND '03/31/12'
  AND O.sOrderStatus = 'Shipped'
  AND O.sOrderType <> 'Internal' 
  AND O.sOrderChannel <> 'INTERNAL'
  AND O.mMerchandise > 1 
  AND O.sShipToZip <> 'F'
GROUP BY O.sShipToZip, REF.TotalMerch, EXC.TotalMerch  
ORDER BY '# of Orders' DESC



