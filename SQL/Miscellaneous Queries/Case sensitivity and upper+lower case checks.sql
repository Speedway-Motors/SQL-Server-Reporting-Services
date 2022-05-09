select ixCustomer,
    sCustomerType,
    sMailToCity,
    sMailToState,
    dtAccountCreateDate,
    sCustomerFirstName,
    sCustomerLastName,
    sEmailAddress,
    sMailingStatus,
    flgDeletedFromSOP
from tblCustomer
where 
--    UPPER(sCustomerFirstName) like '%SUMMIT%' 
UPPER(sCustomerFirstName ) like '%JEGS%'
--or UPPER(sCustomerFirstName ) like '%JC WHITNEY%'
--or UPPER(sCustomerFirstName ) like '%JR MOTORSPORTS%' 
--or UPPER(sCustomerFirstName ) like '%DAY MOTORSPORTS%' 
--or UPPER(sCustomerFirstName ) like '%YOGI’S%' 
--or UPPER(sCustomerFirstName ) like '%TCI%' 
--or UPPER(sCustomerFirstName ) like '%SOUTHERN RODS%' 
--or UPPER(sCustomerFirstName ) like '%YEAR ONE%' 
--or UPPER(sCustomerFirstName ) like '%SMILEYS%' 
--or UPPER(sCustomerFirstName ) like '%PITSTOPUSA%' 
--or UPPER(sCustomerFirstName ) like '%SAFE RACER%'  


--or UPPER(sCustomerLastName) like '%SUMMIT%' 
or UPPER(sCustomerLastName ) like '%JEGS%'
--or UPPER(sCustomerLastName ) like '%JC WHITNEY%'
--or UPPER(sCustomerLastName ) like '%JR MOTORSPORTS%' 
--or UPPER(sCustomerLastName ) like '%DAY MOTORSPORTS%' 
--or UPPER(sCustomerLastName ) like '%YOGI’S%' 
--or UPPER(sCustomerLastName ) like '%TCI%' 
--or UPPER(sCustomerLastName ) like '%SOUTHERN RODS%' 
--or UPPER(sCustomerLastName ) like '%YEAR ONE%' 
--or UPPER(sCustomerLastName ) like '%SMILEYS%' 
--or UPPER(sCustomerLastName ) like '%PITSTOPUSA%' 
--or UPPER(sCustomerLastName ) like '%SAFE RACER%'    

--or UPPER(sEmailAddress) like '%SUMMIT%' 
or UPPER(sEmailAddress ) like '%JEGS%'
--or UPPER(sEmailAddress ) like '%JC WHITNEY%'
--or UPPER(sEmailAddress ) like '%JR MOTORSPORTS%' 
--or UPPER(sEmailAddress ) like '%DAY MOTORSPORTS%' 
--or UPPER(sEmailAddress ) like '%YOGI’S%' 
--or UPPER(sEmailAddress ) like '%TCI%' 
--or UPPER(sEmailAddress ) like '%SOUTHERN RODS%' 
--or UPPER(sEmailAddress ) like '%YEAR ONE%' 
--or UPPER(sEmailAddress ) like '%SMILEYS%' 
--or UPPER(sEmailAddress ) like '%PITSTOPUSA%' 
--or UPPER(sEmailAddress ) like '%SAFE RACER%'  





select top 10 *
from tblSKU
where dtCreateDate > '01/01/2011'
and flgDeletedFromSOP = 0
and ixSKU not in (select ixSKU from tblSKUIndex)
order by newID()

select * from tblSKUIndex


can you please check the errorlog file to see if there are error codes 1163 occuring after 10:50 today?


select dtAccountCreateDate, ixCustomer, sCustomerFirstName, sCustomerLastName, sEmailAddress
from tblCustomer
where 
    sCustomerFirstName != UPPER(sCustomerFirstName) 
 OR sCustomerLastName != UPPER(sCustomerLastName)
 OR sEmailAddress != UPPER(sEmailAddress)
order by dtAccountCreateDate desc

--and flgDeletedFromSOP = 0

select * from 
--
-- TO VERIFY FIELD CONTAINS NO LOWER CASE CHARACTERS
SELECT *
FROM <tablename>
where UPPER(<fieldname>) != <fieldname>



select top 10000 ixCustomer, sCustomerFirstName, sCustomerLastName, sEmailAddress
from tblCustomer
where sEmailAddress like '%@%' -- != upper(sEmailAddress)




select * from tblCustomer
where 
    sEmailAddress like '%@DayMotorsports.COM'
 OR sEmailAddress like '%@JCWhitney.COM'
 OR sEmailAddress like '%@JCWhitney.COM@Jegs.COM'
 OR sEmailAddress like '%@JCWhitney.COM@JRMotorsports.COM'
 OR sEmailAddress like '%@JCWhitney.COM@PitStopUsa.COM'
 OR sEmailAddress like '%@JCWhitney.COM@SafeRacer.COM'
 OR sEmailAddress like '%@JCWhitney.COM@Smileys.COM'
 OR sEmailAddress like '%@JCWhitney.COM@SouthernRods.COM'
 OR sEmailAddress like '%@JCWhitney.COM@Summit.COM'
 OR sEmailAddress like '%@JCWhitney.COM@TCI.COM'
 OR sEmailAddress like '%@JCWhitney.COM@YearOne.COM'
 OR sEmailAddress like '%@JCWhitney.COM@Yogis.COM'
 
 
 
 select * from tblCustomer
where 
    sEmailAddress LIKE '%@DAYMOTORSPORTS.COM'
 OR sEmailAddress LIKE '%@JCWHITNEY.COM'
 OR sEmailAddress LIKE '%@JEGS.COM'
 OR sEmailAddress LIKE '%@JRMOTORSPORTS.COM'
 OR sEmailAddress LIKE '%@PITSTOPUSA.COM'
 OR sEmailAddress LIKE '%@SAFERACER.COM'
 OR sEmailAddress LIKE '%@SMILEYS.COM'
 OR sEmailAddress LIKE '%@SOUTHERNRODS.COM'
 OR sEmailAddress LIKE '%@SUMMIT.COM'
 OR sEmailAddress LIKE '%@TCI.COM'
 OR sEmailAddress LIKE '%@YEARONE.COM'
 OR sEmailAddress LIKE '%@YOGIS.COM'
 
 select * from tblSKU where ixSKU = '91036120-PLN'
 
 
 
 
select * 
from tblCustomer
where sMailToState = 'IN'
and UPPER(sCustomerLastName) LIKE 'BAKER%'
--and UPPER(sMailToCity) LIKE 'LE%'
and (
    UPPER(sCustomerFirstName) like '%RIC%'
    OR  UPPER(sCustomerFirstName) = 'DICK'
    )
    
--
Cust #	FirstName	LastName CreateDate	ST	City	        Zip
470901	RICHAD L	BAKER	2000-01-28  IN	JEFFERSONVILLE	47130
888945	RICK	    BAKER	2007-01-16  IN	CAMBY	        46113
687618	RICK	    BAKER	2003-09-23  IN	CAMBY	        46113
135265	RICHARD	    BAKER	1990-03-09  IN	BEDFORD	        47421




select sCustomerFirstName, sCustomerLastName, sEmailAddress
from tblCustomer
where 
sCustomerFirstName != upper(sCustomerFirstName) 
OR sCustomerLastName != upper(sCustomerLastName)
OR sEmailAddress != upper(sEmailAddress)



select ixDate, count(*) Qty
from tblSnapshotSKU
where ixDate >= 16303 -- 
group by ixDate
order by ixDate desc



select COUNT(distinct sShipToZip) -- 30736
from tblOrder
where sOrderStatus = 'Shipped'
and (sShipToCountry is NULL
    or sShipToCountry in ('US','USA')
    )
    
    




    