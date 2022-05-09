-- Case 19014 - process Cat 353 deceased file from Dingley

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
                    Cat        Dec File     Dec Qty     Dec Qty     Dec Qty
Cat Descripiton     StartDate  Created      In File     B4 update   After update
=== =============== =========  =========    =======     =========   ============    
360	'13 RACE SPRNG2 05-20-13   05-29-13           0                 3,787       <-- 1st Catalog from Dingley
353	'13 SR MID SUM. 06-17-13   06-17-13         140     233         314
366	2013 FALL TB    07-01-13

  
*/

-- verify we have all of the deceased files
-- 2-5 bus days after we send catalog pull file RRD returns a deceased file
select * from [SMI Reporting].dbo.tblCatalogMaster
where dtStartDate >= '06/17/2013'
order by dtStartDate

select * from [SMI Reporting].dbo.tblCatalogMaster
where ixCatalog = '366'



-- Flagged Deceased Count
select count(*) from [SMI Reporting].dbo.tblCustomer 
where sMailingStatus = 8                             
and flgDeletedFromSOP = 0                            
/*
1,754 @03-04-13 @1PM
3,838 @03-05-13 @3PM after processing batch of deceased files
3,664 @05-29-13 @4PM
3,787 @05-29-13 @#  after processing batch of deceased files
3,774 @06-20-13 @9AM
  233 @07-19-13 Before processing theCat 353 batch
  314 @07-19-13 After processing theCat 353 batch
*/



/***** 1ST FILE - CAT 353   *******************/
-- DROP TABLE PJC_19014_DeceasedCat353FileDate06182013
select count(ixCustomer) CustCount, 
    count(distinct ixCustomer) DstnctCustCount
from PJC_19014_DeceasedCat353FileDate06182013
/*
CustCount	DstnctCustCount
140	        140

*/
select DC.ixCustomer, C.flgDeletedFromSOP, C.sMailingStatus,
    C.dtDeceasedStatusUpdateDate, C.ixDeceasedStatusSource, C. flgDeceasedMailingStatusExempt
from PJC_19014_DeceasedCat353FileDate06182013 DC
    left join [SMI Reporting].dbo.tblCustomer C on DC.ixCustomer = C.ixCustomer
where  (C.sMailingStatus not in ('8','9')
        OR C.sMailingStatus is NULL
        )
  and C.flgDeletedFromSOP = 0
-- 101 in file to give to Al   

select * from tblCustomer where ixCustomer = '1260069'

-- customers with NULL mailing status
select ixCustomer, dtAccountCreateDate, dtDateLastSOPUpdate 
from [SMI Reporting].dbo.tblCustomer 
where sMailingStatus is NULL
  and flgDeletedFromSOP = 0
 -- and dtDateLastSOPUpdate < '06/20/2013'--s NULL
order by dtAccountCreateDate
         dtDateLastSOPUpdate

/* How many of the above were sent the previous catalog (360)
   but not returned as deceased by Dingley?
*/   
select count(DC.ixCustomer) --  22
from PJC_19014_DeceasedCat353FileDate06182013 DC
    join ASC_18593_CST_OutputFile_360 SENT360 on DC.ixCustomer = SENT360.ixCustomer


select O.ixCustomer, max(O.dtOrderDate) LastOrd
    from [SMI Reporting].dbo.tblOrder O
    join PJC_19014_DeceasedCat353FileDate06182013 DC on O.ixCustomer = DC.ixCustomer
group by  O.ixCustomer
order by   LastOrd desc 


/***** 2ND FILE - CAT 359   *******************/
select count(ixCustomer) CustCount, 
    count(distinct ixCustomer) DstnctCustCount
from PJC_18383_DeceasedCat359FileDate03112013
/*
CustCount	DstnctCustCount
22	        22

*/
select DC359.ixCustomer, C.flgDeletedFromSOP, C.sMailingStatus
from PJC_18383_DeceasedCat359FileDate03112013 DC
    left join [SMI Reporting].dbo.tblCustomer C on DC.ixCustomer = C.ixCustomer
where   C.sMailingStatus <> 8 
  and C.flgDeletedFromSOP = 0
order by flgDeletedFromSOP desc 
-- 0 flagged as deleted

select * from PJC_18383_DeceasedCat359FileDate03112013
where ixCustomer not in (Select ixCustomer from PJC_19014_DeceasedCat353FileDate06182013)-- CAT 365
-- 17 in file to give to Al   





/***** 3RD FILE - CAT  351   *******************/
select count(ixCustomer) CustCount, 
    count(distinct ixCustomer) DstnctCustCount
from PJC_18383_DeceasedCat351FileDate03152013

/*
CustCount	DstnctCustCount
258	        258

*/
select DC.ixCustomer, C.flgDeletedFromSOP, C.sMailingStatus
from PJC_18383_DeceasedCat351FileDate03152013 DC
    left join [SMI Reporting].dbo.tblCustomer C on DC.ixCustomer = C.ixCustomer
where   C.sMailingStatus <> 8 
  and C.flgDeletedFromSOP = 0
order by flgDeletedFromSOP desc 
-- 0 flagged as deleted

select * from PJC_18383_DeceasedCat351FileDate03152013
where ixCustomer not in (Select ixCustomer from PJC_19014_DeceasedCat353FileDate06182013)-- CAT 365
  and ixCustomer not in (Select ixCustomer from PJC_18383_DeceasedCat359FileDate03112013)-- CAT 359
-- 237 in file to give to Al   












select ixCustomer from [SMI Reporting].dbo.tblCustomer 
where sMailingStatus = 8                             
and flgDeletedFromSOP = 0  





