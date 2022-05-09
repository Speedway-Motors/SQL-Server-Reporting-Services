-- Case 19912 - process Cat 354 & 355 deceased files from Dingley

/*
-- DECEASED FILES files from RRD
Cat Descripiton     StartDate  File (F)ed (R)eady
343	2012 STR FALL	2012-10-01 F    <-- 1st Catalog to use the new flagging rules we instructed RRD to use
347	2012 FALL RACE	2012-10-22 F
344	2012 STR LTFALL	2012-11-05 F
357	2013 RACE WNTR	2012-12-17 F
362	2013 SPRNT WNTR	2013-01-07 F
349	2013 ST ERLYSPG	2013-01-14 F
367	AFCO ERLY SPRNG	2013-01-28 F
358	2013 RACE SPRG1	2013-02-11 F
350	2013 SPRNG RMAL	2013-02-25 F
365 2013 WINT TBUCK 2013-03-04 R
359 2013 SPRING     2013-03-11 R
351 2013 LT SPRING  2013-03-15 R
363 '13 SPRINT SPRG 2013-03-27 R
368 AFCO LATE SPRG  2013-04-16 R
352	'13 EARLY SUM.  2013-04-22 R   <-- last deceased file we will get from RRD

-- DECEASED FILES files from DINGLEY
                    Cat        Dec          Dec         Dec         Dec         Dec
                    ty         File         Qty         Qty         Qty After   Exempt         
Cat Descripiton     StartDate  Created      In File     B4 update   update      Qty After Update
=== =============== =========  =========    =======     =========   =========   ======== 
360	'13 RACE SPRNG2 05-20-13   05-29-13           0                 3,787                       <-- 1st Catalog from Dingley
353	'13 SR MID SUM. 06-17-13   06-17-13         140     233         314
366	2013 FALL TB    07-01-13   07-22-13?        314                             
364 FALL '13 SPRINT 07-08-13
354	'13 SR LATE SUM	2013-08-12 
355	'13 SR EAR FALL	2013-09-30
  
*/

-- verify we have ALL of the of the deceased files from recent catalogs
-- 2-5 bus days after we send catalog pull file RRD returns a deceased file
select ixCatalog 'Cat',sDescription 'Description',dtStartDate 'StartDate'
from [SMI Reporting].dbo.tblCatalogMaster
where dtStartDate >= '08/12/2013'
order by dtStartDate

select * from [SMI Reporting].dbo.tblCatalogMaster
where ixCatalog = '354'



-- Flagged DECEASED
select count(*) from [SMI Reporting].dbo.tblCustomer 
where sMailingStatus = 8                             
    and flgDeletedFromSOP = 0                            
/*
1,754 @03-04-13 @1PM
3,838 @03-05-13 @3PM after processing batch of deceased files
3,664 @05-29-13 @4PM
3,787 @05-29-13 @#  after processing batch of deceased files
3,774 @06-20-13 @9AM
  233 @07-19-13 B4 processing theCat 353 batch
  314 @07-19-13 After processing theCat 353 batch
  314 @07-22-13 B4 processing theCat 364 & 366 batches
  
  315 @07-22-13 After processing theCat 364 & 366 batches
  300 @10-14-13 after running the dezombifier to reactive customers who've ordered since they're deceased flagged date  
  300 @10-14-13 B4 processing theCat 354 & 355 batches  
  328 @10-14-13 after processing theCat 354 & 355 batches after
  327 @10-14-13 after running the dezombifier
  
*/



-- # of customers marked as Deceased Exempt in SOP (they will NEVER get flagged as deceased again)
select count(*) from [SMI Reporting].dbo.tblCustomer 
where flgDeceasedMailingStatusExempt = 1
    and flgDeletedFromSOP = 0  
-- 292 @10-14-2013



-- total YTD Sales from Deceased Exempt customers
SELECT C.ixCustomer, sum(O.mMerchandise) Sales -- $128K as of 10-13-2013 !?!
from [SMI Reporting].dbo.tblOrder O
    join [SMI Reporting].dbo.tblCustomer C on O.ixCustomer = C.ixCustomer
where C.flgDeceasedMailingStatusExempt = 1
    and C.flgDeletedFromSOP = 0  
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtShippedDate >= '01/01/2013'
group by  C.ixCustomer   



select * from tblSourceCode where ixSourceCode = '35480'


/***** 1ST FILE - CAT 354   *******************
       78 customers
*/
-- DROP TABLE PJC_19912_DeceasedCat354FileDate10102013
select count(ixCustomer) CustCount, 
    count(distinct ixCustomer) DstnctCustCount
from PJC_19912_DeceasedCat354FileDate10102013
 -- PJC_19912_DeceasedCat354FileDate07222013
/*
CustCount	DstnctCustCount
78          78

*/
select DC.ixCustomer, C.flgDeletedFromSOP, C.sMailingStatus,
    C.dtDeceasedStatusUpdateDate, C.ixDeceasedStatusSource, C. flgDeceasedMailingStatusExempt
from PJC_19912_DeceasedCat354FileDate10102013 DC
    left join [SMI Reporting].dbo.tblCustomer C on DC.ixCustomer = C.ixCustomer
where  (C.sMailingStatus not in ('8','9')
        OR C.sMailingStatus is NULL
        )
  and C.flgDeletedFromSOP = 0
  and C.flgDeceasedMailingStatusExempt is NULL
-- 18 in file to give to Al   
/*
410196
1952818
1319815
1618500
1521145
1969362
1715746
241831
750488
1012682
1069476
1953562
1771960
1903669
830018
328338
1747366
1951712
*/

select * from tblCustomer where ixCustomer = '1260069'

select O.ixCustomer, max(O.dtOrderDate) LastOrd
    from [SMI Reporting].dbo.tblOrder O
    join PJC_19912_DeceasedCat354FileDate10102013 DC on O.ixCustomer = DC.ixCustomer
group by  O.ixCustomer
order by   LastOrd desc 



/***** 2ND FILE - CAT 355 ******************
       82 customers (71 were dupes from 354 list)
*/
-- DROP table PJC_19912_DeceasedCat355FileDate09182013
select count(ixCustomer) CustCount, 
    count(distinct ixCustomer) DstnctCustCount
from PJC_19912_DeceasedCat355FileDate09182013
 -- PJC_19912_DeceasedCat355FileDate09182013
/*
CustCount	DstnctCustCount
82	        82

*/

-- remove DUPES (customers already in the previous file)
DELETE 
from PJC_19912_DeceasedCat355FileDate09182013
where ixCustomer in (select ixCustomer from PJC_19912_DeceasedCat354FileDate10102013)

select * from PJC_19912_DeceasedCat355FileDate09182013

-- customers for file to give to Al
select DC.ixCustomer, C.flgDeletedFromSOP, C.sMailingStatus,
    C.dtDeceasedStatusUpdateDate, C.ixDeceasedStatusSource, C.flgDeceasedMailingStatusExempt
from PJC_19912_DeceasedCat355FileDate09182013 DC
    left join [SMI Reporting].dbo.tblCustomer C on DC.ixCustomer = C.ixCustomer
where   (C.sMailingStatus not in ('8','9')
        OR C.sMailingStatus is NULL
        )
  and C.flgDeletedFromSOP = 0
  and C.flgDeceasedMailingStatusExempt is NULL        
order by flgDeletedFromSOP desc 
-- 10 records to give Al






-- run the <12> Update deceased exempt list job in SOP under <20> Reporting Menu



select max(dtOrderDate)
from [SMI Reporting].dbo.tblOrder where ixCustomer = '723102'
