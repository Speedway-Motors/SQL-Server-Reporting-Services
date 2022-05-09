-- Case 19607 - determine SOP speed benchmarks
USE [SMITemp]

-- DROP TABLE PJC_10K_Random_Customer_Set1
select top 10000 ixCustomer
into PJC_10K_Random_Customer_Set1
from [SMI Reporting].dbo.tblCustomer
where flgDeletedFromSOP = 0
order by newID()

-- DROP TABLE PJC_10K_Random_Customer_Set2
select top 10000 ixCustomer
into PJC_10K_Random_Customer_Set2
from [SMI Reporting].dbo.tblCustomer
where flgDeletedFromSOP = 0
order by newID()

-- DROP TABLE PJC_10K_Random_Customer_Set3
select top 10000 ixCustomer
into PJC_10K_Random_Customer_Set3
from [SMI Reporting].dbo.tblCustomer
where flgDeletedFromSOP = 0
order by newID()

select * from PJC_10K_Random_Customer_Set1 order by newid() --ixCustomer
select * from PJC_10K_Random_Customer_Set2 order by ixCustomer
select * from PJC_10K_Random_Customer_Set3 order by ixCustomer

/******  Customer File #1 ******/
select count(C.ixCustomer)
from [SMI Reporting].dbo.tblCustomer C
    join PJC_10K_Random_Customer_Set1 S on C.ixCustomer = S.ixCustomer
where C.dtDateLastSOPUpdate = '06/21/2013' 
  and C.ixTimeLastSOPUpdate > 46500 -- 12:55
-- 1250 seconds for SOP to complete
-- 8.00 rec/sec SOP
-- 2214 seconds from first record update to last for LNK-STAGING1 (finished 10 mins after SOP completed)
-- 4.51 rec/sec STAGING
select min(C.ixTimeLastSOPUpdate) MinUD,
       max (C.ixTimeLastSOPUpdate) MaxUD,
       (max (C.ixTimeLastSOPUpdate) - min(C.ixTimeLastSOPUpdate)) TotUDSec
from [SMI Reporting].dbo.tblCustomer C
    join PJC_10K_Random_Customer_Set1 S on C.ixCustomer = S.ixCustomer
where C.dtDateLastSOPUpdate = '06/21/2013' 
  and C.ixTimeLastSOPUpdate between  46500 and 48960 -- 12:55

/******  Customer   File #2 ******/
select count(C.ixCustomer)
from [SMI Reporting].dbo.tblCustomer C
    join PJC_10K_Random_Customer_Set2 S on C.ixCustomer = S.ixCustomer
where C.dtDateLastSOPUpdate = '06/21/2013' 
  and C.ixTimeLastSOPUpdate > 48960 -- 13:36  
-- 1126 seconds for SOP to complete
-- 8.88 rec/sec SOP
-- 1651 seconds from first record update to last for LNK-STAGING1
-- 6.05 rec/sec STAGING
select min(C.ixTimeLastSOPUpdate) MinUD,
       max (C.ixTimeLastSOPUpdate) MaxUD,
       (max (C.ixTimeLastSOPUpdate) - min(C.ixTimeLastSOPUpdate)) TotUDSec
from [SMI Reporting].dbo.tblCustomer C
    join PJC_10K_Random_Customer_Set2 S on C.ixCustomer = S.ixCustomer
where C.dtDateLastSOPUpdate = '06/21/2013' 
  and C.ixTimeLastSOPUpdate between 48960 and 50820 -- 13:36



select * from [SMI Reporting].dbo.tblTime where chTime = '09:45:00'
select chTime from [SMI Reporting].dbo.tblTime where ixTime = '49156' -- 13:39:16
select [SMI Reporting].dbo.chTime from  where ixTime = '00000'
  
/******  Customer   File #3 ******/
select count(C.ixCustomer)
from [SMI Reporting].dbo.tblCustomer C
    join PJC_10K_Random_Customer_Set3 S on C.ixCustomer = S.ixCustomer
where C.dtDateLastSOPUpdate = '06/21/2013' 
  and C.ixTimeLastSOPUpdate > 50820 -- 14:07  
-- 1134 seconds for SOP to complete
-- 8.82 rec/sec SOP
-- 1710 seconds from first record update to last for LNK-STAGING1 (finished 10 mins after SOP completed)
-- 5.85 rec/sec STAGING
select min(C.ixTimeLastSOPUpdate) MinUD,
       max (C.ixTimeLastSOPUpdate) MaxUD,
       (max (C.ixTimeLastSOPUpdate) - min(C.ixTimeLastSOPUpdate)) TotUDSec
from [SMI Reporting].dbo.tblCustomer C
    join PJC_10K_Random_Customer_Set3 S on C.ixCustomer = S.ixCustomer
where C.dtDateLastSOPUpdate = '06/27/2013' 
  and C.ixTimeLastSOPUpdate > 50820  -- 14:07  
  
    



/******  Customer Offers  File #1 ******/
-- DROP TABLE PJC_10K_Random_CustomerOffer_Set1
select top 10000 ixCustomerOffer
into PJC_10K_Random_CustomerOffer_Set1
from [SMI Reporting].dbo.tblCustomerOffer
where ixCreateDate >= 16438 -- 01/01/2013
order by newID()

select * from PJC_10K_Random_CustomerOffer_Set1

select * from [SMI Reporting].dbo.tblCustomerOffer
where ixCreateDate >= 16438
    and dtDateLastSOPUpdate is NOT null

select min(CO.ixTimeLastSOPUpdate) MinUD,
       max (CO.ixTimeLastSOPUpdate) MaxUD,
       (max (CO.ixTimeLastSOPUpdate) - min(CO.ixTimeLastSOPUpdate)) TotUDSec
from [SMI Reporting].dbo.tblCustomerOffer CO
    join PJC_10K_Random_CustomerOffer_Set1 S on CO.ixCustomerOffer = S.ixCustomerOffer
where CO.dtDateLastSOPUpdate = '06/21/2013' 
  and CO.ixTimeLastSOPUpdate > 55200  -- 15:20      
-- 1685 seconds for SOP to complete
-- 5.93 rec/sec SOP
-- 2196 seconds from first record update to last for LNK-STAGING1 
-- 4.55 rec/sec STAGING



select top 10000 ixCustomerOffer
into PJC_10K_Random_CustomerOffer_Set1
from [SMI Reporting].dbo.tblCustomerOffer
where ixCreateDate >= 16438 -- 01/01/2013
order by newID()

select * from PJC_10K_Random_CustomerOffer_Set1

select * from [SMI Reporting].dbo.tblCustomerOffer
where ixCreateDate >= 16438
    and dtDateLastSOPUpdate is NOT null

select min(CO.ixTimeLastSOPUpdate) MinUD,
       max (CO.ixTimeLastSOPUpdate) MaxUD,
       (max (CO.ixTimeLastSOPUpdate) - min(CO.ixTimeLastSOPUpdate)) TotUDSec
from [SMI Reporting].dbo.tblCustomerOffer CO
    join PJC_10K_Random_CustomerOffer_Set1 S on CO.ixCustomerOffer = S.ixCustomerOffer
where CO.dtDateLastSOPUpdate = '06/21/2013' 
  and CO.ixTimeLastSOPUpdate > 55200  -- 15:20      
-- 1685 seconds for SOP to complete
-- 5.93 rec/sec SOP
-- 2196 seconds from first record update to last for LNK-STAGING1 
-- 4.55 rec/sec STAGING




-- NEW SPEED TEST @6-27-2013
/******  File #1 ******/
select min(C.ixTimeLastSOPUpdate) MinUD,
       max (C.ixTimeLastSOPUpdate) MaxUD,
       (max (C.ixTimeLastSOPUpdate) - min(C.ixTimeLastSOPUpdate)) TotUDSec,
       count(C.ixCustomer) RecCnt,
       (count(C.ixCustomer) /(max (C.ixTimeLastSOPUpdate) - min(C.ixTimeLastSOPUpdate))) RecPerSec
from [SMI Reporting].dbo.tblCustomer C
    join PJC_10K_Random_Customer_Set1 S on C.ixCustomer = S.ixCustomer
where C.dtDateLastSOPUpdate >= '06/27/2013' 
  and C.ixTimeLastSOPUpdate > 35100 -- 09:45
/*
MinUD	MaxUD	TotUDSec	RecCnt	RecPerSec
35831	36210	379	        9998	26
*/  
  
/******  Customer Offers  File #1 ******/
-- DROP TABLE PJC_10K_Random_CustomerOffer_Set1
select top 10000 ixCustomerOffer
into PJC_10K_Random_CustomerOffer_Set1
from [SMI Reporting].dbo.tblCustomerOffer
where ixCreateDate >= 16438 -- 01/01/2013
order by newID()

-- records to give to Al
select * from PJC_10K_Random_CustomerOffer_Set1 order by newid() 

select min(CO.ixTimeLastSOPUpdate) MinUD,
       max (CO.ixTimeLastSOPUpdate) MaxUD,
       (max (CO.ixTimeLastSOPUpdate) - min(CO.ixTimeLastSOPUpdate)) TotUDSec,
       count(CO.ixCustomerOffer) RecCnt,
       (count(CO.ixCustomerOffer) /(max (CO.ixTimeLastSOPUpdate) - min(CO.ixTimeLastSOPUpdate))) RecPerSec
from [SMI Reporting].dbo.tblCustomerOffer CO
    join PJC_10K_Random_CustomerOffer_Set1 S on CO.ixCustomerOffer = S.ixCustomerOffer
where CO.dtDateLastSOPUpdate >= '06/27/2013' 
  and CO.ixTimeLastSOPUpdate between 36120 and 37112 -- 10:02      
/*
MinUD	MaxUD	TotUDSec	RecCnt	RecPerSec
36446	37112	666	        9998	15

select * from [SMI Reporting].dbo.tblTime where chTime = '10:02:00'

