
SELECT DISTINCT V.ixVendor AS Vendor
     , V.sName AS VendorName
     , POM.ixPO AS PONumber
     , D.dtDate AS ExpectedReceiptDate
     , POM.sPaymentTerms AS VendorTerms--Vendor terms? 
     , POT.Total AS PO$Total
FROM tblPOMaster POM
LEFT JOIN tblPODetail POD ON POD.ixPO = POM.ixPO 
LEFT JOIN tblVendor V ON V.ixVendor = POM.ixVendor  
LEFT JOIN (SELECT POD.ixPO
                , POD.ixSKU
                , POD.mCost * POD.iQuantity AS Total
           FROM tblPODetail POD 
           GROUP BY POD.ixPO
                  , POD.ixSKU
                  , POD.mCost * POD.iQuantity 
          ) AS POT ON POT.ixPO = POM.ixPO 
LEFT JOIN tblDate D ON D.ixDate = POD.ixExpectedDeliveryDate    
LEFT JOIN tblInventoryReceipt IR ON IR.ixPO COLLATE SQL_Latin1_General_CP1_CI_AS = POM.ixPO   
WHERE POD.iOrdinality = '1'
  AND IR.ixPO IN (SELECT DISTINCT IR.ixPO 
                   FROM tblInventoryReceipt IR 
                   LEFT JOIN tblDate D ON D.ixDate = IR.ixCreateDate
                   WHERE D.dtDate BETWEEN '08/01/12' AND '08/29/12')
GROUP BY V.ixVendor
       , V.sName
       , POM.ixPO
       , D.dtDate 
       , POM.sPaymentTerms --Vendor terms? 
       , POT.Total
       




--SELECT DISTINCT ixPO
--     , D.dtDate AS CreateDate 
--FROM tblInventoryReceipt
--LEFT JOIN tblDate D ON D.ixDate = ixCreateDate 
--WHERE D.dtDate BETWEEN '08/01/12' and GETDATE()
--ORDER BY ixPO, CreateDate
