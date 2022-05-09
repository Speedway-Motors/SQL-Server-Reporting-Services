-- REFEED SOP Data for SMI and AFCO 

/******* SUMMARY OF WHAT WAS REFED ******************
REFED
 <2> Bins -- SMI all bins and sToBins from tblSKUTransaction since 1/15    
 <3> BOMs ALL
 <4> BOM Sequences ALL
 <5> BOM Transfers -- looked at the sequential ixTransferNumber from the past few days and created a list from the first gap to much higher
 <6> Brands  ALL
 <7> Catalog Requests  -- SMI: ALL	AFCO: n/a
 <8> Customers -- AFCO:refed all ixCustomer between 10001 and 60000 	SMI: refed all ixCustomer between 2200940 and 2441939   
 <9> Customer Offers 1/16-1/19  
<10> Dropships ALL
<11> Employees ALL
<12> Inventory Forecast -- AFCO: ALL	SMI: too long to update...will let it run normally Tuesday A.M.
<13> Inventory Receipts 1/16-1/19
<14> Job Clock 1/16-1/19
<15> Kits -- ALL Afco.  For SMI: select ixSKU from tblSKU where flgIsKit = 1  and dtCreateDate >= '01/01/2015'
<16> Mailing Opt In -- AFCO: N/A  	SMI: all customer created YTD
<17> Orders (Carol refed all cancelled ytd, all open, all back0rders, all shipped  1/16-1/19)
<18> Packages 1/16-1/19
<19> PGC ALL
<20> Receivers  1/16-1/19
<21> SKUs (refed all that had transactions 1/16-1/19)
<22> SKU transactions 1/16-1/19
<23> Source Codes ALL
<24> Time Clock 1/16-1/19 SMI
<25> Transaction Types ALL
<26> Vendors ALL


CREDIT MEMOS (sequential. not able to refeed manually) 
	Gave Carol a list of 5 to refeed on SMI side.  
	None appear to be missing on AFCO.

POs (not able to refeed manually) 
	Asked Carol to refeed any POs created or issued since 01/16/15
	
*/	

select ixDate, count(*) Qty
from tblSKUTransaction
where ixDate >= 17183 
group by ixDate
order by ixDate
/*
        Init    Cur
ixDate	Qty     QTY    SOP
17183	31469   31469  100%   
17184	8235     8235  100%
17185	39      14289  14289   100%
17186	2814     6940   5190   100%
*/


ixDate	Date	    sDayOfWeek
17186	01/19/2015	MONDAY
17185	01/18/2015	SUNDAY
17184	01/17/2015	SATURDAY
17183	01/16/2015	FRIDAY


select * from tblTime where ixTime = 58094

CAROL REFED ORDERS( on both sides)
all cancelled ytd
all open
all back0rders
all shipped friday or later

select count(*) from tblBOMTransferMaster

select * from tblBOMTransferMaster
where ixCreateDate > 17183
order by ixTransferNumber

select * from tblBOMTransferMaster
where ixTransferNumber > '51796-1'
and len(ixTransferNumber) >= 7

SELECT COUNT(*) from tblSourceCode
SELECT COUNT(*) from tblKit -- 70,224
select ixSKU from tblSKU where flgIsKit = 1  and dtCreateDate >= '01/01/2015'


SELECT COUNT(*) from tblKit -- 70,224

select * from tblCustomer
where dtAccountCreateDate >= '01/01/15'

select count(*) from tblCustomer 
where dtAccountCreateDate between '01/15/15' and '01/18/15' -- 754

select count(*) from tblCustomer where ixCustomer >= 2200940 -- 21,712
select min(dtAccountCreateDate) from tblCustomer where ixCustomer >= 2200940 
select max(ixCustomer) from tblCustomer where dtAccountCreateDate > '01/01/2015'
select max(ixCustomer) from tblCustomer where ixCustomer between 2200940 and 2428505 5398657 8675308-- 21,712

select ixCustomer,dtAccountCreateDate, dtDateLastSOPUpdate, flgDeletedFromSOP
from tblCustomer where ixCustomer >= 2200940 
order by dtAccountCreateDate

select count(ixCustomer) from tblCustomer where ixCustomer between 2 200 940 and 2 428 505

select count(*) from tblCustomer
where ixCustomer > 2428505

        CREATE TABLE #temp (
           table_name sysname ,
           row_count INT,
           reserved_size VARCHAR(50),
           data_size VARCHAR(50),
           index_size VARCHAR(50),
           unused_size VARCHAR(50))
        SET NOCOUNT ON
        INSERT #temp
        EXEC sp_MSforeachtable 'sp_spaceused ''?'''
            SELECT a.table_name                                     sTableName,
                   a.row_count                                      sRowCount
            FROM #temp a
               INNER JOIN INFORMATION_SCHEMA.COLUMNS b ON a.table_name collate database_default = b.table_name collate database_default
            WHERE   a.table_name in ('tblCardUser','tblCreditMemoReasonCode','tblDatabaseSchemaLog','tblFIFODetail','tblOrder','tblSnapshotSKU')
            GROUP BY a.table_name, a.row_count, a.data_size
        DROP TABLE #temp
        

select * from tblCustomer where dtAccountCreateDate >= '01/01/2015'
select * from tblMailingOptIn        


select ixSKU from tblSKU
where dtCreateDate >= '01/01/2015'

select count(*) from tblBOMTemplateMaster


SELECT count(*) FROM tblBOMSequence -- 560
where dtDateLastSOPUpdate >= '01/19/15'


SELECT * FROM tblBin -- 184K

select * from tblBin
where ixCreateDate > = '01/01/15'

select ixCreateDate, count(*)
from tblBin
where ixCreateDate >= 17180
group by ixCreateDate
order by ixCreateDate

17180	41
17181	3
17182	4
17186	4


SELECT A.ixBin FROM 
(
select distinct sBin ixBin   -- 6800
from tblSKUTransaction
where ixDate >= 17183
UNION
select distinct sToBin ixBin-- 1665
from tblSKUTransaction
where ixDate >= 17183
) A
WHERE NOT EXISTS (select ixBin from tblBin)


SELECT COUNT(*) FROM tblCatalogRequest

select top 10 * from tblCatalogRequest

select -- min(ixTimeLastSOPUpdate), max(ixTimeLastSOPUpdate),
max(ixTimeLastSOPUpdate)-min(ixTimeLastSOPUpdate) TotSec,
count(*)
from tblCatalogRequest
where dtDateLastSOPUpdate = '01/19/2015'


select * from tblInventoryForecast


select * from tblCreditMemoMaster
where dtCreateDate > '01/15/2015'
order by ixCreditMemo


select * from tblPOMaster
where ixPODate >= 17183
or ixIssueDate >= 17183
order by ixPO

order by ixPODate desc


where dtCreateDate > '01/15/2015'
order by ixCreditMemo