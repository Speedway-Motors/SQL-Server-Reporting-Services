-- AFCO Report parameter values for testing

/*
select * from tblCatalogMaster
where dtStartDate between '01/01/2022' and '4/30/2022'
*/
ixCatalog = LA2022

/*			SKUs on Open POs
select ixSKU, count(POD.ixSKU)
from tblPOMaster POM
	left join tblPODetail POD on POM.ixPO = POD.ixPO
where POM.ixIssueDate >= 19816
and POM.flgIssued = 1
and POM.flgOpen = 1
group by ixSKU
order by count(POD.ixSKU) desc
*/
ixSKU
32-869
32-869A
28325-1CR
TASB640
TASB653

select ixPO
from tblPOMaster POM
where POM.ixIssueDate >= 19816
	and POM.flgIssued = 1
	and POM.flgOpen = 1
order by POM.ixIssueDate desc




/* Open BOM Transfer SKUs
SELECT ixFinishedSKU, count(ixTransferNumber) 'Transfers' 
FROM tblBOMTransferMaster
WHERE dtCanceledDate is NULL
and iCompletedQuantity < iQuantity
and flgReverseBOM = 0
and flgClosed = 0
and iOpenQuantity > 0
group by ixFinishedSKU
order by count(ixTransferNumber) desc
*/
ixFinishedSKU
0000817.01B
0000817.24B
1000152
1001153.10
1001153.16
