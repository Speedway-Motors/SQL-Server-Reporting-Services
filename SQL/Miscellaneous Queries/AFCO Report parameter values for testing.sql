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
where POM.ixIssueDate >= 19830
and POM.flgIssued = 1
and POM.flgOpen = 1
group by ixSKU
order by count(POD.ixSKU) desc
*/
ixSKU
324122448
324122454
324122485
324122492

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
91002107
9002520
3001000.2
1061000319
