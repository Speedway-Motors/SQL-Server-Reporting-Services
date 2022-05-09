-- Case 15182 - add dtDateLastSOPUpdate & ixTimeLastSOPUpdate fields to SMI/AFCO Reporting tables
-- add these two fields to all Production tables that are feed by SOP

dtDateLastSOPUpdate datetime
ixTimeLastSOPUpdate int

/* copy and paste into the update procs
,
	@dtDateLastSOPUpdate datetime,
	@ixTimeLastSOPUpdate int
	
	ixInventoryReceipt	ixCreateDate	ixCreateTime	ixCreateUser	ixLastUpdateDate	ixLastUpdateTime	ixLastUpdateUser	ixLocation	ixReceiptPointer	ixPostPointer	flgPost	ixReceiver	iQuantityReceived	ixSKU	ixPO	dtDateLastSOPUpdate	ixTimeLastSOPUpdate
001*70840*62092	15370	35718	NLB	15370	35718	NLB	99	NULL	NULL	NULL	70840	0	001	NULL	NULL	NULL
*/

select top 10 * from tblInventoryReceipt
select count(*) from tblInventoryReceipt    -- 219,059
select * from tblErrorCode where sDescription like '%tblInventoryReceipt%' 
-- 1155	Failure to update tblInventoryReceipt
-- time of first test feeds = approx 11:15 AM


select count(*) QtyCnt, ixPO
from tblInventoryReceipt
group by ixPO
/*
QtyCnt	ixPO
219059	NULL
*/

select count(*) --1549 8-12-12 @8:46AM
from tblInventoryReceipt
where dtDateLastSOPUpdate is NOT NULL

select count(*) 
from tblInventoryReceipt
where ixTimeLastSOPUpdate is NOT NULL 

select count(*) 
from tblInventoryReceipt
where ixPO is NOT NULL 

select ixInventoryReceipt, ixPO,
    dtDateLastSOPUpdate,ixTimeLastSOPUpdate
from tblInventoryReceipt
where ixTimeLastSOPUpdate is NOT NULL     

select * from tblTime
where ixTime = 35011

select top 30 ixInventoryReceipt
from tblInventoryReceipt
where dtAccountCreateDate > '08/01/2012'
and flgDeletedFromSOP = 0
order by newid()


-- check SOP error codes for "1163 - Failure to update tblSKU."

/** CHANGES to apply to UPDATE PROCS  to MANUALLY CALCULATE rather than have SOP pass

,
        dtDateLastSOPUpdate = DATEADD(dd,0,DATEDIFF(dd,0,getdate())),
        ixTimeLastSOPUpdate = dbo.GetCurrentixTime ()


		 
*/			 
			 			            
/***** TABLES UPDATED AS OF 8-13-2012
tblCreditMemoReasonCode
tblCustomer            8-23-12
tblInventoryReceipt    8-24-12
tblJob                 9-18-12
tblSKU



SELECT name 
FROM sysobjects 
WHERE id IN ( SELECT id FROM syscolumns WHERE (name) = 'dtDateLastSOPUpdate' )
ORDER BY name

*/

select * from PJC_SMI_ExemptCustomers
-- drop table PJC_SMI_ExemptCustomers

select getdate()

select * from tblTime where ixTime =  35672        

select min(dtDateLastSOPUpdate) 'Min_SOPUpdate', -- 2-12-12 is the default date applied to all NULL values (such as SOP items that were deleted when the field was intially populated)
       max(dtDateLastSOPUpdate) 'Max_SOPUpdate'
from tblCustomer   



 

