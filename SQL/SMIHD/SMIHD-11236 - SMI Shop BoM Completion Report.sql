-- SMIHD-11236 - SMI Shop BoM Completion Report
/*

How many BoM's the SMI Shop has completed since Jan. 1st. Vendor # 0916

This would also include the total hours clocked into them.

All of 2017, 2018 YTD, and MTD
*/

select * from tblPromoCodeMaster where ixPromoId = '1561'

select * from tblJobClock
--05
07
17
where ixJob like '05%'


select * from tblJob
where ixJob like '05%'
or ixJob like '07%'
or ixJob like '17%'


select * from tblBOMTransferMaster