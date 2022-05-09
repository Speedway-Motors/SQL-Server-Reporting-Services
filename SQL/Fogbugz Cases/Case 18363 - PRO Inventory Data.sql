SELECT S.ixSKU AS SKU
     , SL.iQAV AS QOH
     , ISNULL(SL.iQOS,0) - ISNULL(SL.iQAV,0) AS QtyAllocated
	 , Xfers.QtyRequested
	 , Xfers.QtyCompleted
	 , Xfers.QtyRemaining
	 , PO.POQty
-- ADD IN BOM Xfer report    
FROM tblSKU S 
LEFT JOIN tblSKULocation SL ON SL.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS = S.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS
                            AND SL.ixLocation = '99' 
LEFT JOIN tblVendorSKU VS ON VS.ixSKU = S.ixSKU   
LEFT JOIN ( --Open BOM Transfers 
			SELECT BTM.ixFinishedSKU AS ixSKU
			     , BTM.ixTransferNumber
			     , BTM.iQuantity AS QtyRequested
                 , BTM.iCompletedQuantity  AS QtyCompleted
                 , (BTM.iQuantity-isnull(BTM.iCompletedQuantity,0)) AS QtyRemaining
                 , (D.dtDate) AS DeliveryDate
		    FROM tblBOMTransferMaster BTM
			JOIN tblDate D on D.ixDate = BTM.ixDueDate
			WHERE BTM.flgReverseBOM = 0
			  AND BTM.dtCanceledDate IS NULL
			  AND ISNULL(BTM.iCompletedQuantity,0) < BTM.iQuantity
		  ) AS Xfers ON Xfers.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS = S.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS  
LEFT JOIN ( --Open PO 
			SELECT POD.ixSKU
				 , POD.ixPO
				 , D.dtDate ExpectedDelivery
				 , SUM(POD.iQuantity-ISNULL(POD.iQuantityReceivedPending,0)-ISNULL(POD.iQuantityPosted,0)) POQty -- outstanding PO Qty
		    FROM tblPODetail POD
			JOIN tblPOMaster POM on POM.ixPO = POD.ixPO
			LEFT JOIN tblDate D on D.ixDate = POD.ixExpectedDeliveryDate
			WHERE POM.flgIssued = 1
			  AND POM.flgOpen = 1
			  AND (POD.iQuantity-isnull(POD.iQuantityReceivedPending,0)-isnull(POD.iQuantityPosted,0)) > 0
			GROUP BY POD.ixSKU, POD.ixPO, D.dtDate
		  ) AS PO ON PO.ixSKU = S.ixSKU 	                         
WHERE ixPGC = 'PX'                            
  AND S.flgActive = '1'
  AND S.flgDeletedFromSOP = '0' 
  AND VS.ixVendor = '0018'
  
  
 


