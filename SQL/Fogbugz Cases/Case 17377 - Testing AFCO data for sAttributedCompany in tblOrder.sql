-- Case 17377 - Testing AFCO data for sAttributedCompany in tblOrder

USE [AFCOTemp]

select *
into PJC_17377_tblOrder_BACKUP
from [AFCOReporting].dbo.tblOrder

-- TEST ORDERS
select top 100 ixOrder
into PJC_17377_OrdersForTesting
from [AFCOReporting].dbo.tblOrder
order by newid()


-- Order to refeed to [AFCOReporting]
select * from PJC_17377_OrdersForTesting


select count(O.ixOrder) OrdCount, sOrderStatus
from PJC_17377_OrdersForTesting OFT
    join [AFCOReporting].dbo.tblOrder O on O.ixOrder = OFT.ixOrder
group by sOrderStatus
/*
OrdCount	sOrderStatus
6	Cancelled
94	Shipped
*/


select count(O.ixOrder) OrdCount, dtDateLastSOPUpdate
from PJC_17377_OrdersForTesting OFT
    join [AFCOReporting].dbo.tblOrder O on O.ixOrder = OFT.ixOrder
group by dtDateLastSOPUpdate
/*
OrdCount	dtDateLastSOPUpdate
100	        2013-01-28 00:00:00.000
*/

select count(O.ixOrder) OrdCount, sAttributedCompany
from PJC_17377_OrdersForTesting OFT
    join [AFCOReporting].dbo.tblOrder O on O.ixOrder = OFT.ixOrder
group by sAttributedCompany




select count(O.ixOrder) OrdCount, sAttributedCompany
from [AFCOReporting].dbo.tblOrder O 
group by sAttributedCompany
/*

OrdCount	sAttributedCompany  
148289	    NULL                @8:35 1-29-13
135     	AFCO
16	        PROSHOCKS

110252	    NULL                @8:35 1-29-13
14187	    AFCO
174	        PROSHOCKS

6253	NULL                    @4:45 1-29-13
117798	AFCO
584	PROSHOCKS
 
5653	NULL                    @8:10AM 1-30-13
118488	AFCO
592	PROSHOCKS

124203	AFCO                    @2:30PM 1-30-13
627	    PROSHOCKS
*/


select count(O.ixOrder) OrdCount, sAttributedCompany
from [SMI Reporting].dbo.tblOrder O 
group by sAttributedCompany



select dtOrderDate, count(*) OrdCount
from [AFCOReporting].dbo.tblOrder
where sAttributedCompany is not NULL
group by dtOrderDate


select top 32000 ixOrder
from [AFCOReporting].dbo.tblOrder
where sAttributedCompany is NULL
order by dtOrderDate desc


select min(dtOrderDate)
from [AFCOReporting].dbo.tblOrder
where sAttributedCompany is NOT NULL
