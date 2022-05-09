-- Case 17377 - Testing SMI data for sAttributedCompany in tblOrder

USE [SMITemp]

select *
-- drop table PJC_17377_tblOrder_BACKUP
into PJC_17377_tblOrder_BACKUP
from [SMI Reporting].dbo.tblOrder

-- TEST ORDERS
select top 100 ixOrder
into PJC_17377_OrdersForTesting
from [SMI Reporting].dbo.tblOrder
order by newid()


-- Order to refeed to [SMI Reporting]
select * from PJC_17377_OrdersForTesting


select count(O.ixOrder) OrdCount, sOrderStatus
from PJC_17377_OrdersForTesting OFT
    join [SMI Reporting].dbo.tblOrder O on O.ixOrder = OFT.ixOrder
group by sOrderStatus
/*
OrdCount	sOrderStatus
6	        Cancelled
1	        Pick Ticket
93	        Shipped
*/


select count(O.ixOrder) OrdCount, dtDateLastSOPUpdate
from PJC_17377_OrdersForTesting OFT
    join [SMI Reporting].dbo.tblOrder O on O.ixOrder = OFT.ixOrder
group by dtDateLastSOPUpdate
/*
OrdCount	dtDateLastSOPUpdate
1	NULL
99	2013-01-28 00:00:00.000
*/

select O.*, dtDateLastSOPUpdate
from PJC_17377_OrdersForTesting OFT
    join [SMI Reporting].dbo.tblOrder O on O.ixOrder = OFT.ixOrder
where dtDateLastSOPUpdate is NULL

select count(O.ixOrder) OrdCount, sAttributedCompany
from PJC_17377_OrdersForTesting OFT
    join [SMI Reporting].dbo.tblOrder O on O.ixOrder = OFT.ixOrder
group by sAttributedCompany


select count(O.ixOrder) OrdCount, sAttributedCompany
from [SMI Reporting].dbo.tblOrder O 
group by sAttributedCompany

select dtOrderDate, count(*) OrdCount
from [SMI Reporting].dbo.tblOrder
where sAttributedCompany is not NULL
group by dtOrderDate

select * from [SMI Reporting].dbo.tblOrder where ixOrder like 'PC%'


select * from [SMI Reporting].dbo.tblErrorCode where ixErrorCode in (1064,1059)



            
            
select dtDate, count(*)            
from [SMI Reporting].dbo.tblErrorLogMaster
where ixErrorCode = 1060
and dtDate >= '01/01/2013'
group by dtDate
order by dtDate


select count(*) from PJC_17257_Canadian_Addresses_BEFORE_validation