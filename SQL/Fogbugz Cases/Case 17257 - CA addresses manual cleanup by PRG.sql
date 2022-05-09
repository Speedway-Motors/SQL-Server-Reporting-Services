-- Case 17257 - CA addresses manual cleanup by PRG

select count(*) from vwCSTStartingPoolCANADA -- 7122 @10/1/13    1724 @10/4/13
select count(*) from vwCSTStartingPoolRequestorsCANADA-- 79 @10/1/13    81 @10/4/13



select  top 10
ixCustomer, Street1, City, Province, PostalCode  
from PJC_17257_Canadian_Addresses_BEFORE_validation


select count(*) from PJC_17257_CA_Addressess_PRGManualCleanup -- 3,531
select top 10 
ixCustomer, NewStreet1, NewCity, NewState, NewPostalCode 
from PJC_17257_CA_Addressess_PRGManualCleanup
--PostalCode	Province	City	Name	Name2	Street2	Street1	ixSourceCode	ixCustomer
--P1B4W6	  	NORTH BAY           	JASON BRYDGES                 	                              	                              	475 ALGONQUIN AVE             	BD01I     	505167 


-- comparing orig values to new
select PRG.ixCustomer,
Street1, 
NewStreet1,  
City, 
NewCity,
Province, 
NewState,
PostalCode,
NewPostalCode  


 -- all 3,512 come over after all conditions added
from PJC_17257_CA_Addressess_PRGManualCleanup PRG
    join PJC_17257_Canadian_Addresses_BEFORE_validation B4 on PRG.ixCustomer=B4.ixCustomer
where 
PRG.NewStreet1 <> B4.Street1 -- 1,846 standalone
OR
PRG.NewCity <> B4.City -- 1 standalone (orig had trailing spaces)
OR 
PRG.NewState <> B4.Province -- 218 standalone
OR 
PRG.NewPostalCode <> B4.PostalCode -- 2,617 standalone


-- pulling only fields needed to update SOP
-- put this data in a | delimited file for Al
select PRG.ixCustomer,
NewStreet1,  
NewCity, 
NewState,
NewPostalCode  
from PJC_17257_CA_Addressess_PRGManualCleanup PRG
    join PJC_17257_Canadian_Addresses_BEFORE_validation B4 on PRG.ixCustomer=B4.ixCustomer
where 
    PRG.NewStreet1 <> B4.Street1        -- 1,846 standalone
OR  PRG.NewCity <> B4.City              -- 1 standalone (orig had trailing spaces)
OR  PRG.NewState <> B4.Province         -- 218 standalone
OR  PRG.NewPostalCode <> B4.PostalCode  -- 2,617 standalone






/*****************************************************************
    AL HAS SUCCESSFULLY FED THE ADDRESS CHANGES TO SOP 
    AND DW-STAGING1 HAS RECEIVED THE UPDATED DATA
******************************************************************/     

-- CST Canada pool BEFORE & AFTER address changes
select COUNT(*) from vwCSTStartingPoolCANADA  -- 2,460 in CST Canadian Starting Pool prior to address updates 
                                              -- 4,946 after


-- WHERE CA CUSTOMERS ARE DROPPING OUT of the CST Starting Pool                                              
SELECT CF.PostalCode, C.sEmailAddress, C.sCustomerFirstName, C.sCustomerLastName, C.dtDateLastSOPUpdate, C.sMailToZip, C.ixCustomer, C.sMailToState -- 2,420 @3-26-2013
FROM tblCustomer C
    join [SMITemp].dbo.PJC_17257_CA_Address_Corrections_File CF on C.ixCustomer = CF.ixCustomer
WHERE C.flgDeletedFromSOP = 0
  and C.sMailToCountry = 'CANADA'                           -- 12,825 in CA Starting at this point
  and C.ixCustomer IN
        (-- Customers who've ordered in last 72 months      --  6,940 in CA Starting at this point 
         select distinct ixCustomer 
         from tblOrder 
         where sOrderStatus = 'Shipped'
             and dtShippedDate >= DATEADD(yy, -6, getdate()) 
         )     
  and C.sCustomerType = 'Retail'                                        
  and (C.sMailingStatus is NULL OR C.sMailingStatus = '0')   -- 6,884 in CA Starting at this point
  and LEN(C.sMailToZip) NOT between 6 and 7                  -- 4,946 in CA Starting at this point
--and C.sEmailAddress is NOT NULL
ORDER BY CF.PostalCode



