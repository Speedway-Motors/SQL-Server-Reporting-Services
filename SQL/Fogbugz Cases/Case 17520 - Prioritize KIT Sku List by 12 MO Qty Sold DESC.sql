SELECT DKS.ixSKU 
     , SKU.Qty
FROM dbo.ASC_17520_DistinctKitSKUs DKS
LEFT JOIN (SELECT OL.ixSKU
                , SUM(ISNULL(OL.iQuantity,0)) AS Qty
           FROM [SMI Reporting].dbo.tblOrderLine OL 
           LEFT JOIN [SMI Reporting].dbo.tblOrder O ON O.ixOrder = OL.ixOrder 
           WHERE O.dtShippedDate BETWEEN DATEADD(dd, -365, GETDATE()) AND GETDATE() 
             AND O.sOrderType <> 'Internal'
             AND O.sOrderChannel <> 'INTERNAL'
             AND O.sOrderStatus = 'Shipped' 
             AND O.mMerchandise > '0' 
           GROUP BY OL.ixSKU 
           ) SKU ON SKU.ixSKU = DKS.ixSKU 
ORDER BY SKU.Qty DESC           
   
