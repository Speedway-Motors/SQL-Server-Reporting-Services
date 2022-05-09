-- SMIHD-13067 - AFCO - Insert Dewitts BOM Usage numbers for Feb-Dec 2018 into tblSKUTransaction

 -- 68 different Primary Vendors for Dewitts SKUs !?!
ca


 
 select max(iSeq) from tblSKUTransaction -- 80213

 select min(ixDate) from tblSKUTransaction -- 17533

 -- INSERT TEST RECORD
 insert into [AFCOReporting].dbo.tblSKUTransaction
 --      ixDate ixTime       iSeq        ixSKU  iQty                    sWarehouse       sBin                                      ixJob
 VALUES (17533, NULL, NULL, 99999, NULL, '123', -999, NULL, NULL, NULL, NULL,            NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
 
ixTime = 86399 -- 23:59:59  
sUser = 'PJC'
sTransactionType = 'BOM'
ixLocation = 99
sWarehouse = 'MAIN'
sTransactionInfo = 'Dewitts Historical Data insert'

 SELECT * FROM tblTime

  
 select * from tblSKUTransaction
 where --ixDate = 17533
  iSeq > 90000


 select distinct ixSKU
 from tblSKUTransaction
 where --ixDate = 17533
  iSeq > 90000
  order by ixSKU

  /*
32-1239066M
32-4139066M
32-512
32-701
32-868D
*/


 -- verify report logic handles test record correctly
            SELECT ST.ixSKU AS ixSKU
               , ISNULL(SUM(ST.iQty),0) * -1 AS TotalQty 
		  FROM tblSKUTransaction ST 
		  LEFT JOIN tblDate D ON D.ixDate = ST.ixDate 
		  WHERE D.ixDate = 17533
                --D.dtDate BETWEEN DATEADD(yy, -1, GETDATE()) AND GETDATE()
		    AND ST.sTransactionType = 'BOM' 
			AND ST.iQty < 0
	      GROUP BY ST.ixSKU

-- DELETE test record          
 BEGIN TRAN
    DELETE FROM tblSKUTransaction
    where ixDate = 17533
        and iSeq = 99999
 ROLLBACK TRAN

SELECT * FROM tblSKUTransaction
where ixSKU = '32-701'
and iSeq > 90000















 




SELECT COUNT(*) FROM SMIHD13067_Dewitts2018BOMUsage_SKUTransactions
                     SMIHD13067_Dewitts2018BOMUsage_SKUTransactions

SELECT COUNT(distinct ixSKU) from SMIHD13067_Dewitts2018BOMUsage_SKUTransactions

select ixSKU, count(*)
from SMIHD13067_Dewitts2018BOMUsage_SKUTransactions
group by ixSKU
order by count(*)

SELECT sum(iQty) 
from SMIHD13067_Dewitts2018BOMUsage_SKUTransactions


INSERT INTO SMIHD13067_Dewitts2018BOMUsage_SKUTransactions
SELECT *
FROM IMPORT$




select * from IMPORT$

SELECT ixDate, count(*)
from IMPORT$
group by ixDate
order by ixDate

delete from IMPORT$ where ixDate is NULL

select ixSKU, count(*)
from IMPORT$
group by ixSKU
order by count(*)


SELECT ixSKU from IMPORT$
where ixSKU IN (SELECT ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS from [AFCOReporting].dbo.tblSKU)





\