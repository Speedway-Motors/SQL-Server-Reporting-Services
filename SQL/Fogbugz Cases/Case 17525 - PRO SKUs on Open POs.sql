SELECT POM.ixVendor
     , POD.ixSKU
     , POD.ixPO
     , D.dtDate AS ExpectedDelivery
     , SUM(POD.iQuantity - ISNULL(POD.iQuantityReceivedPending,0)- ISNULL(POD.iQuantityPosted,0)) AS POQty -- outstanding PO Qty
FROM tblPODetail POD
JOIN tblPOMaster POM on POM.ixPO = POD.ixPO
                    and POM.flgIssued = 1
                    and POM.flgOpen = 1
LEFT JOIN tblDate D on D.ixDate = POD.ixExpectedDeliveryDate
LEFT JOIN tblSKU S ON S.ixSKU = POD.ixSKU 
WHERE S.ixPGC = 'PX'
  AND (POD.iQuantity - ISNULL(POD.iQuantityReceivedPending,0)- ISNULL(POD.iQuantityPosted,0)) > 0
GROUP BY POM.ixVendor, POD.ixSKU, POD.ixPO, D.dtDate
ORDER BY D.dtDate

--Verify these are all PGC = "PX" 
SELECT *
FROM tblSKU 
WHERE ixSKU IN ('10SR350-20', '10SR450-20', '10SR550-20', '8SR375-20', '8SR600-20', '9/250-20', '9/300-20', 
				'ADJBB1001', 'ADJBB1112-10', 'B276-10', 'C307-10', 'C309-10', 'C336-10', 'C342-10', 'C371-10',
				'C372-10', 'C376-10', 'C377-10', 'C401-10', 'PGA3000S-10', 'PGA5003', 'PGA5004', 'PGA9009', 
				'PGA9013-10', 'PGAC20010-10', 'WB200S', 'CHROME1', 'S505', 'ANODIZE-4', 'ANODIZE-4B', 'ANODIZE-6',
				'B201-ZINC','B276-ZINC', 'S502-ZINC', 'S507-ZINC', 'TA2000-10', 'TA2005-10', 'TA2007-10', 'TA2009-10', 
				'LANDRWK', 'IMPACTASB', '9913', 'C303-10', 'B210', 'B210SS', 'KDV8N', 'IMPACTA')