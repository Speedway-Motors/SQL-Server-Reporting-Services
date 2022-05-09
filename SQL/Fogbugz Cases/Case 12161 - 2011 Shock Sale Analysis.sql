SELECT DISTINCT O.ixOrder AS 'Order #'
      ,O.sShipToState AS 'Ship to State'
      ,O.iShipMethod AS 'Ship Method' 
      ,SRB.SRBQty
      ,OTHSRB.OTHQty
      ,(SRB.SRBQty) + (OTHSRB.OTHQty) AS 'Total Units'
      ,SRB.SRBSales
      ,OTHSRB.OTHSales
      ,(SRB.SRBSales) + (OTHSRB.OTHSales) AS 'Total Sales' 
      ,SRB.SRBCost
      ,OTHSRB.OTHCost
      ,(SRB.SRBCost) + (OTHSRB.OTHCost) AS 'Total Cost'
      ,O.mShipping AS FreightCharge
      ,(O.mPublishedShipping * 0.68) AS FreightCost
      --,[TNT Days]exclude per CCC 
FROM tblOrder O 
JOIN (SELECT DISTINCT OL.ixOrder
           , SUM (OL.iQuantity) AS SRBQty
           , SUM (OL.mExtendedPrice) AS SRBSales
           , SUM (OL.mExtendedCost) AS SRBCost
      FROM tblOrderLine OL 
      JOIN tblBinSku BS ON OL.ixSKU = BS.ixSKU
      WHERE --OL.ixSKU LIKE 'SHOCKRB%' AND
         BS.sPickingBin = 'SHOCK'
      GROUP BY OL.ixOrder
      HAVING SUM (OL.iQuantity) >= 1
              ) AS SRB ON O.ixOrder = SRB.ixOrder 
JOIN (SELECT DISTINCT OL.ixOrder
           , SUM (OL.iQuantity) AS OTHQty
           , SUM (OL.mExtendedPrice) AS OTHSales
           , SUM (OL.mExtendedCost) AS OTHCost
      FROM tblOrderLine OL 
      JOIN tblBinSku BS ON OL.ixSKU = BS.ixSKU
      WHERE --OL.ixSKU LIKE 'SHOCKRB%' AND
         BS.sPickingBin <> 'SHOCK'
         AND OL.ixSKU NOT LIKE '910017%'
      GROUP BY OL.ixOrder
      HAVING SUM (OL.iQuantity) >= 1
              ) AS OTHSRB ON O.ixOrder = OTHSRB.ixOrder 
WHERE O.dtShippedDate BETWEEN '01/01/11' AND '12/31/11'
  AND O.sOrderType = 'Retail' 
  AND O.iShipMethod NOT IN ('1', '3', '4', '8')
  AND O.mShipping > 0
ORDER BY O.ixOrder --SRB.SRBQty DESC
