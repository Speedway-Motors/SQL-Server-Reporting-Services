-- SSA job - SmiJob_SMI Mass Update tblOrder Invoice Date

/*
select count(*)
from tblOrder
where ixShippedDate >= 13881 -- 01/01/2006
and sOrderStatus = 'Shipped'
and ixInvoiceDate is NULL -- 5,467,482
*/


-- LNK SQL LIVE-1
select FORMAT(count(*),'###,###') 'Orders', getdate() 'AsOf'
from tblOrder where ixInvoiceDate is NOT NULL -- 207,038	2019-04-04 12:34:52.520
/*
Orders	    AsOf
=========   ======================     -- final should be approx  5,667,000 records
5,665,747	2019-04-05 10:31:33.350
5,620,439	2019-04-05 09:27:02.797
5,528,769	2019-04-05 09:11:48.353
2,288,614	2019-04-04 17:31:32.000
1,651,110	2019-04-04 16:21:59.717
831,084	    2019-04-04 14:37:29.427

*/

-- RUN THIS ON DW.SPEEDWAY2.COM
-- dw.speedway2.com

select FORMAT(count(*),'###,###') 'Orders', getdate() 'AsOf'
from Transfer.tblOrder where ixInvoiceDate is NOT NULL -- 197,038

/*
Orders	    AsOf  (UST time here)   Records Behind SMI Reporting
=========   ======================  ============================
5,665,747	2019-04-05 15:31:53.223
2,226,112	2019-04-04 22:31:45.257 62k
2,184,442	2019-04-04 22:26:17.523 67k
2,117,241	2019-04-04 22:19:09.040
1,568,832	2019-04-04 21:22:11.930
871,084	    2019-04-04 20:11:58.717
503,084	    2019-04-04 19:20:26.247
*/

select count(*)
from tblOrder
where ixInvoiceDate is NOT NULL
    and ixShippedDate is NOT NULL
    and sOrderStatus = 'Shipped' -- 137,046


select count(O.ixOrder), D.iYear
from tblOrder O
    left join tblDate D on O.ixShippedDate = D.ixDate
where ixInvoiceDate is NULL
and ixShippedDate is NOT NULL
and sOrderStatus = 'Shipped' -- 137,046
group by  D.iYear
order by  D.iYear



SELECT * FROM [SMITemp].dbo.PJC_InvoceDate_Updates
    
WHERE flgProcessed = 0
    
where ixOrder in (select ix

