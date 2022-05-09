
SELECT POM.ixPO AS PONumber --(482 rows) 
     , POM.ixVendor AS VendorNumber
     , POM.ixBuyer AS Buyer
     , POD.ixSKU AS Items
     , D.dtDate AS dtPODate
     , POD.iQuantity AS QtyOnOrder
     , POD.iQuantityPosted AS QtyReceived 
     , ISNULL(POD.iQuantity, 0) - ISNULL(POD.iQuantityPosted, 0) AS QtyOutstanding
     , D2.dtDate AS dtDeliveryDate
     , POD.mCost AS Cost
     , POD.mCost * POD.iQuantity AS ExtendedCost 
     --, PRINT FLAG?? -- Per Laurie this is no longer a needed field
     , D3.dtDate AS dtConfirmedDate 
     , POM.ixVendorConfirmEmployee AS ConfirmedBy
     , ISNULL(POM.sNotes, 'N/A') AS Notes
FROM tblPOMaster POM 
JOIN tblPODetail POD ON POD.ixPO = POM.ixPO 
LEFT JOIN tblDate D ON D.ixDate = POM.ixPODate 
LEFT JOIN tblDate D2 ON D2.ixDate = POD.ixExpectedDeliveryDate 
LEFT JOIN tblDate D3 ON D3.ixDate = POM.ixVendorConfirmDate
WHERE flgOpen = '1' 
  AND iOrdinality = '1' --??
 -- AND POD.iQuantity > 0 --?? why would this be 
 -- AND ISNULL(POD.iQuantity, 0) - ISNULL(POD.iQuantityPosted, 0) > 0 --?? why would this be 
ORDER BY dtDeliveryDate

