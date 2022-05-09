-- Case SMIHD-762 - Afco BOM Transfers not updating
SELECT * FROM tblBOMTransferMaster 
where ixTransferNumber = '120070-1'

ixTransferNumber	ixFinishedSKU	iQuantity	iCompletedQuantity	flgReverseBOM	ixCreateDate	ixDueDate	dtCanceledDate	flgClosed	iOpenQuantity	dtDateLastSOPUpdate	ixTimeLastSOPUpdate	iReleasedQuantity
150105-1	        701-17310	    25	        16	                0	            17169	17197	NULL	1	0	2015-01-16 00:00:00.000	55658	9
150105-1	        701-17310	    25	        25	                0	            17169	17197	NULL	1	0	2015-05-11 00:00:00.000	57704	0

select * from tblDate where ixDate = 16770


SELECT BTM.ixFinishedSKU AS ixSKU 
, ixTransferNumber
, D2.dtDate AS CreateDate 
, SUM(BTM.iQuantity - ISNULL(BTM.iCompletedQuantity,0)) AS BOMQty
, D.dtDate AS DueDate ,
dtDateLastSOPUpdate 
FROM tblBOMTransferMaster BTM
LEFT JOIN tblDate D ON D.ixDate = BTM.ixDueDate 
LEFT JOIN tblDate D2 ON D2.ixDate = BTM.ixCreateDate
WHERE BTM.flgReverseBOM = 0
AND BTM.dtCanceledDate is NULL
AND ((ISNULL(BTM.iCompletedQuantity,0) < BTM.iQuantity 
AND iOpenQuantity = 0 
AND iReleasedQuantity > 0) 
OR iOpenQuantity > 0) 
--AND dtDateLastSOPUpdate < '05/11/2015'
-- AND ixFinishedSKU = 'ENTER SKU HERE'  COMMENT THIS LINE IN IF YOU WANT TO SEARCH FOR A SPECIFIC SKU 
GROUP BY BTM.ixFinishedSKU 
, ixTransferNumber
, D2.dtDate
, D.dtDate
, dtDateLastSOPUpdate
ORDER BY dtDateLastSOPUpdate -- ixTransferNumber DueDate DESC -- 1,565    1,548                 SMI 825

SELECT * FROM tblBOMTransferMaster
WHERE ixTransferNumber in ('108828-1','120070-1','123236-1')



