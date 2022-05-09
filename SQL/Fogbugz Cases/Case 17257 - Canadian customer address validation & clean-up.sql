-- Case 17257 - Canadian customer address validation/clean-up
select C.ixCustomer, C.sMailToZip, C.sMailToCountry
from tblCustomer C
where sMailToCountry = 'CANADA'
    --and len(sMailToZip) <> 7
    and sMailToZip NOT like '[A-Z][0-9][A-Z][0-9][A-Z][0-9]'    -- zips that are not A#A#A# format (including lengths longer or shorter)
    and sMailToZip NOT like '[A-Z][0-9][A-Z][-][0-9][A-Z][0-9]'  
    and sMailToZip NOT like '[A-Z][0-9][A-Z][ ][0-9][A-Z][0-9]'        
    and flgDeletedFromSOP = 0
order by len(sMailToZip) desc 


-- CUSTOMERS WITH ADDRESS CORRECTIONS THAT COULD QUALIFY FOR CST STARTING POOL
select count(CO.ixCustomer) 
from PJC_17257_CA_Custs_wAdrCrtns_and72MoOrders CO
where ixCustomer not in (SELECT ixCustomer
                            FROM PJC_17257_vwCSTStartingPoolCANADA
                          )



/* COMPARING the before and after data once we sent it through the validaiton company */

select count(*) from PJC_17257_Canadian_Addresses_BEFORE_validation -- 12507

select count(*) from PJC_17257_CA_Address_Corrections_File          -- 12507

select B4.* 
from PJC_17257_Canadian_Addresses_BEFORE_validation B4              -- 12507 100% match
    join PJC_17257_CA_Address_Corrections_File CF on B4.ixCustomer = CF.ixCustomer
 
select ReturnCode, count(*)
from PJC_17257_CA_Address_Corrections_File
group by ReturnCode
order by ReturnCode

select ErrorCodes, count(*)
from PJC_17257_CA_Address_Corrections_File
group by ErrorCodes
order by ErrorCodes

select top 10 * from PJC_17257_Canadian_Addresses_BEFORE_validation
/*
P1B4W6	  	NORTH BAY           	JASON BRYDGES                 	                              	                              	475 ALGONQUIN AVE             	BD01I     	505167 
G8T8R3	  	QUEBEC              	PATRICK VERNER                	                              	1101 JACOB                    	ST-LOUIS DE FRANCE            	202I      	506904 
M2R2C2	  	TORONTO ONTARIO     	KEVIN BALL                    	                              	                              	11 GOLDFINCH CT SUITE 809     	203I      	507650 
T7B5E3	  	THUNDERBAY          	DON GOODFELLOW                	                              	                              	RR 12 SITE 20 BOX 25          	          	552510 
L2J2E1	  	NIGARA FALLS,ONT    	JIM ARMSTRONG                 	                              	                              	2921 GAIL AVE                 	          	552607 
L6V2P8	  	BRAMPTON ONTERIO    	TOM RICKER                    	CHASSIS UNLIMITED             	                              	242VODDEN STREET EAST         	206I      	564577 
N4W 1S	  	LISTOWEL            	MIKE WICK                     	                              	                              	689 BARBAER AVE. NORTH 16     	212Q      	645877 
F     	  	RICHMOND            	GORDON JAMES                  	                              	                              	4497 FORTUNE AVE              	EMAILSE8R7	734033 
T3L2P6	  	CALGORY, ALBERTA    	DARWIN BANASH                 	                              	                              	36 BEARS PAW POINTE WAY       	EMAILSE8S5	766627 
V4W1T3	  	ALDERGROVE,BC       	REGINALD VAILLANT             	                              	                              	24937 54TH AVE                	          	785552 
*/
select top 10 * from PJC_17257_CA_Address_Corrections_File


-- CREATE COMPARISON SET TO PUT INTO EXCEL
-- PER PHILIP WE ARE ONLY GOING TO CONSIDER ADDRESS CORRECTING CUSTOMERS THAT WOULD QUALIFY FOR CST
select B4.ixCustomer,  
    RTRIM(B4.Street1) OrigStreet1, UPPER(CF.DeliveryLine1) NewStreet1,
    RTRIM(B4.Street2) OrigStreet2, UPPER(CF.DeliveryLine2) NewStreet2,
    RTRIM(B4.City) OrigCity,UPPER(CF.City) NewCity,
    RTRIM(B4.Province) as OrigState, UPPER(CF.State) NewState,
    RTRIM(B4.PostalCode) as OrigPostalCode, CF.ZipAddon NewPostalCode,
    CF.ReturnCode,
    CF.ErrorCodes
from PJC_17257_Canadian_Addresses_BEFORE_validation B4              -- 12507 100% match
    join PJC_17257_CA_Address_Corrections_File CF on B4.ixCustomer = CF.ixCustomer 
where CF.ReturnCode > 0
    AND CF.ZipAddon is NOT null
    AND CF.ZipAddon not like '% %'
    AND -- one or more of the paired fields don't match
        (RTRIM(B4.Street1) <> UPPER(CF.DeliveryLine1)
        OR RTRIM(B4.Street2) <> UPPER(CF.DeliveryLine2)
        OR RTRIM(B4.City) <> UPPER(CF.City)
        OR RTRIM(B4.Province) <> UPPER(CF.State)
        OR RTRIM(B4.PostalCode) <> CF.ZipAddon )

    AND B4.ixCustomer in ( -- CST basic starting pool rules  e.g. ordered last 6 yrs, valid mailing status, etc
                        SELECT DISTINCT ixCustomer
                        FROM [SMI Reporting].dbo.tblCustomer -- 443,566 as of 6-1-12
                        WHERE (sMailingStatus is NULL OR sMailingStatus = '0')      
                          and sCustomerType = 'Retail'
                          and flgDeletedFromSOP = 0
                          --  and sMarket <>''   -- customer market (street, race etc)      add 65.2 to tblCustomer
                          and ixCustomer in (select distinct ixCustomer  -- checking to see if customer has placed an order
                                             from [SMI Reporting].dbo.tblOrder -- vwOrderAllHistory
                                             where sOrderStatus = 'Shipped'
                                                 and dtShippedDate >= DATEADD(yy, -6, getdate()) 
                                             )  
                                             -- 2,358 customers ordered in the past 72 months
                                             -- 5,938 customers ordered in entire Order History
                        /*** SPECIFICS FOR CANADA ****/
                            and  sMailToCountry = 'CANADA'
                        )    
order by B4.ixCustomer    






select ixCustomer,  Name1, Name2, Street1, Street2,  -- DeliveryLine1, DeliveryLine2, 
CityNew, State,-- Province, 
ZipAddon --LastLine ,
--ReturnCode, ErrorCodes
from PJC_17257_CA_Address_Corrections_File
where ReturnCode <> '-99'
and ixCustomer in ('1050649',
                    '1318938',
                    '1335513',
                    '1339646',
                    '1406042',
                    '1419024',
                    '1612530',
                    '1726838',
                    '183343',
                    '1927626',
                    '1962334',
                    '196271',
                    '451029',
                    '471879',
                    '794610',
                    '842553',
                    '898636',
                    '925111',
                    '938968',
                    '981834')

select * from PJC_17257_Canadian_Addresses_BEFORE_validation
where ixCustomer = '1000504'


select * from PJC_17257_CA_Address_Corrections_File
where ixCustomer = '1000504'



select * from PJC_17257_Canadian_Addresses_BEFORE_validation


select count(*) from PJC_17257_Canadian_Addresses_BEFORE_validation



-- New Postal Codes provided
SELECT C.ixCustomer,'|',ACF.ZipAddon 
--B4.Street1, ACF.Street2,
--B4.City, ACF.CityNew,
--C.sMailToState, ACF.State
--C.sMailToZip, ACF.ZipAddon 
--ACF.ReturnCode -- 1941
FROM [SMI Reporting].dbo.tblCustomer C
    LEFT join PJC_17257_CA_Address_Corrections_File ACF on C.ixCustomer = ACF.ixCustomer
    LEFT join PJC_17257_Canadian_Addresses_BEFORE_validation B4 on B4.ixCustomer = C.ixCustomer
WHERE (C.sMailingStatus is NULL OR C.sMailingStatus = '0')      
  and C.sCustomerType = 'Retail'
  and C.flgDeletedFromSOP = 0
  --and C.ixCustomer in ( -- Customers who've ordered in last 72 months
  --                   select distinct ixCustomer 
  --                   from [SMI Reporting].dbo.tblOrder 
  --                   where sOrderStatus = 'Shipped'
  --                       and dtShippedDate >= DATEADD(yy, -6, getdate()) 
  --                   )  
                     -- 2,358 customers ordered in the past 72 months
                     -- 5,938 customers ordered in entire Order History
/*** SPECIFICS FOR CANADA ****/
    and  C.sMailToCountry = 'CANADA'
    and LEN(C.sMailToZip) NOT between 6 and 7
    and LEN(ACF.ZipAddon) between 6 and 7    
order by    ACF.ReturnCode, ACF.ZipAddon 
    
    
-- New State/Province provided  
SELECT C.ixCustomer,'|', 
--B4.Street1, ACF.Street2,
--B4.City, ACF.CityNew,
--C.sMailToState, 
ACF.State
--C.sMailToZip, ACF.ZipAddon, 
--ACF.ReturnCode -- 1941
FROM [SMI Reporting].dbo.tblCustomer C
    LEFT join PJC_17257_CA_Address_Corrections_File ACF on C.ixCustomer = ACF.ixCustomer
    LEFT join PJC_17257_Canadian_Addresses_BEFORE_validation B4 on B4.ixCustomer = C.ixCustomer
WHERE (C.sMailingStatus is NULL OR C.sMailingStatus = '0')      
  and C.sCustomerType = 'Retail'
  and C.flgDeletedFromSOP = 0
  --and C.ixCustomer in ( -- Customers who've ordered in last 72 months
  --                   select distinct ixCustomer 
  --                   from [SMI Reporting].dbo.tblOrder 
  --                   where sOrderStatus = 'Shipped'
  --                       and dtShippedDate >= DATEADD(yy, -6, getdate()) 
  --                   )  
  --                   -- 2,358 customers ordered in the past 72 months
                     -- 5,938 customers ordered in entire Order History
/*** SPECIFICS FOR CANADA ****/
    and  C.sMailToCountry = 'CANADA'
    and C.sMailToState NOT in ('AB','BC','MB','NB','NL','NT','NS','NU','ON','PE','QC','SK','YT')
    and len(ACF.State) = 2
--    and ACF.State <> C.sMailToState
 --   and ACF.State not like ' %'  
order by  C.sMailToState  




-- New State/Province provided  
SELECT C.ixCustomer,'|', -- 242
--B4.Street1, ACF.Street2,
--B4.City, ACF.CityNew,
--C.sMailToState, 
ACF.State
--C.sMailToZip, ACF.ZipAddon, 
--ACF.ReturnCode -- 1941
FROM [SMI Reporting].dbo.tblCustomer C
    LEFT join PJC_17257_CA_Address_Corrections_File ACF on C.ixCustomer = ACF.ixCustomer
    LEFT join PJC_17257_Canadian_Addresses_BEFORE_validation B4 on B4.ixCustomer = C.ixCustomer
WHERE (C.sMailingStatus is NULL OR C.sMailingStatus = '0')      
  and C.sCustomerType = 'Retail'
  and C.flgDeletedFromSOP = 0
  --and C.ixCustomer in ( -- Customers who've ordered in last 72 months
  --                   select distinct ixCustomer 
  --                   from [SMI Reporting].dbo.tblOrder 
  --                   where sOrderStatus = 'Shipped'
  --                       and dtShippedDate >= DATEADD(yy, -6, getdate()) 
  --                   )  
                     -- 2,358 customers ordered in the past 72 months
                     -- 5,938 customers ordered in entire Order History
/*** SPECIFICS FOR CANADA ****/
    and  C.sMailToCountry = 'CANADA'
    and C.sMailToState NOT in ('AB','BC','MB','NB','NL','NT','NS','NU','ON','PE','QC','SK','YT')
    and len(ACF.State) = 2
--    and ACF.State <> C.sMailToState
 --   and ACF.State not like ' %'  
order by  C.sMailToState  



-- New City provided  
SELECT C.ixCustomer,'|', -- 242
--B4.Street1, ACF.Street2,
--B4.City, 
--C.sMailToCity,
UPPER(ACF.CityNew)
--C.sMailToState, 
--ACF.State
--C.sMailToZip, ACF.ZipAddon, 
--ACF.ReturnCode -- 1941
FROM [SMI Reporting].dbo.tblCustomer C
    LEFT join PJC_17257_CA_Address_Corrections_File ACF on C.ixCustomer = ACF.ixCustomer
    LEFT join PJC_17257_Canadian_Addresses_BEFORE_validation B4 on B4.ixCustomer = C.ixCustomer
WHERE (C.sMailingStatus is NULL OR C.sMailingStatus = '0')      
  and C.sCustomerType = 'Retail'
  and C.flgDeletedFromSOP = 0
  --and C.ixCustomer in ( -- Customers who've ordered in last 72 months
  --                   select distinct ixCustomer 
  --                   from [SMI Reporting].dbo.tblOrder 
  --                   where sOrderStatus = 'Shipped'
  --                       and dtShippedDate >= DATEADD(yy, -6, getdate()) 
  --                   )  
                     -- 2,358 customers ordered in the past 72 months
                     -- 5,938 customers ordered in entire Order History
/*** SPECIFICS FOR CANADA ****/
    and  C.sMailToCountry = 'CANADA'
   -- and C.sMailToState NOT in ('AB','BC','MB','NB','NL','NT','NS','NU','ON','PE','QC','SK','YT')
   -- and len(ACF.State) = 2
--    and ACF.State <> C.sMailToState
 --   and ACF.State not like ' %'  
    and UPPER(C.sMailToCity) <> UPPER(ACF.CityNew)
    and C.flgDeletedFromSOP = 0
order by   UPPER(ACF.CityNew)  

select ixCustomer, dtDateLastSOPUpdate,ixTimeLastSOPUpdate
from [SMI Reporting].dbo.tblCustomer
where ixCustomer in ('1017136','1489133','1159964','1605729','313411','1973547','127597','713796','243287','244650','735464','1030649')

select * from [SMI Reporting].dbo.tblTime where ixTime = 56488

-- New Street provided  
SELECT C.ixCustomer,'|', -- 242
B4.Street1, 
--ACF.Street2, 
UPPER(ACF.DeliveryLine1)
FROM [SMI Reporting].dbo.tblCustomer C
    LEFT join PJC_17257_CA_Address_Corrections_File ACF on C.ixCustomer = ACF.ixCustomer
    LEFT join PJC_17257_Canadian_Addresses_BEFORE_validation B4 on B4.ixCustomer = C.ixCustomer
WHERE (C.sMailingStatus is NULL OR C.sMailingStatus = '0')      
  and C.sCustomerType = 'Retail'
  and C.flgDeletedFromSOP = 0
  --and C.ixCustomer in ( -- Customers who've ordered in last 72 months
  --                   select distinct ixCustomer 
  --                   from [SMI Reporting].dbo.tblOrder 
  --                   where sOrderStatus = 'Shipped'
  --                       and dtShippedDate >= DATEADD(yy, -6, getdate()) 
  --                   )  
                     -- 2,358 customers ordered in the past 72 months
                     -- 5,938 customers ordered in entire Order History
/*** SPECIFICS FOR CANADA ****/
    and  C.sMailToCountry = 'CANADA'
    and UPPER(B4.Street1) <> UPPER(ACF.DeliveryLine1)
--    and UPPER(B4.City) <> UPPER(ACF.CityNew)
order by   UPPER(ACF.DeliveryLine1)


select distinct C.sMailToState
from [SMI Reporting].dbo.tblCustomer C
join [SMI Reporting].dbo.vwCSTStartingPoolCANADA SP on C.ixCustomer = SP.ixCustomer











and (
      (@KitSKU = 'Part1' and KitSKU < '8352601874')
      OR 
      (@KitSKU = 'Part2' and KitSKU >= '8352601874')
      )


