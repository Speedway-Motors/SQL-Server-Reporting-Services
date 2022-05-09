-- tblMailingOptIn checks

/**************** ERROR CODES & ERROR LOG history ***********************/

select * from tblErrorCode where sDescription like '%Mailing%'

select * from tblErrorCode

--  ixErrorCode	sDescription
--  NO CODE SET UP YET

-- ERROR COUNTS by Day
SELECT dtDate
    ,count(*) AS 'ErrorQty'
FROM tblErrorLogMaster
WHERE ixErrorCode = '1144'
 -- and dtDate >=  DATEADD(month, -3, getdate())  -- past 3 months
GROUP BY dtDate 
--HAVING count(*) > 10
ORDER BY dtDate Desc

/************************************************************************/

-- tblMailingOptIn is populated by spUpdateBOMTransferMaster

select count(*) from tblMailingOptIn    -- 7,179,075 @9-24-2013

select count(*) from tblMailingOptIn 
where dtDateLastSOPUpdate is NULL       -- 7,017,690 @9-24-2013

select count(*) from tblMailingOptIn 
where dtDateLastSOPUpdate is NOT NULL   --   161,385 @9-24-2013

select max(dtLastUpdate) 'Latest Update Date' from tblMailingOptIn -- 2013-09-24



-- customers with more or less than 5 markets

select '<> 5 Markets', ixCustomer, count(*) 'Cust Cnt'
from tblMailingOptIn
group by ixCustomer 
having count(*) <> 5
order by count(*) desc


-- each market should have the same number of customers
select ixMarket, count(*) 'Cust Cnt' -- 1,228,490 ea. @5-01-12
from tblMailingOptIn                 -- 1,419,909 ea. @8-07-13
group by ixMarket                    -- 1,435,815 ea. @9-24-13
order by count(*) desc



-- counts of each Opt In Status
select sOptInStatus, count(*) Qty
from tblMailingOptIn
group by sOptInStatus 
order by count(*) desc
/*
sOptInStatus	Qty
UK	        6,882,279
Y	          213,807
N	           82,989
*/



/************************************************************************ 
 ***** initial insert of all of the Markets with UK as the status.  ***** 
 ***** ran this once for each of the markets, by replacing XX with  ***** 
 ***** the appropriate market abbreviation                          ***** 
 ************************************************************************/
/*        
INSERT into tblMailingOptIn

select                     ixCustomer, 
    'XX'                as ixMarket, 
    'UK'                as sOptInStatus,
    ixAccountCreateDate as dtLastUpdate, 
    1                   as ixLastUpdateTime, 
    'SQL'               as sUserLastUpdated  
from tblCustomer 
where flgDeletedFromSOP = 0
  and ixCustomer = '1554623'
*/    



select distinct ixMarket from tblMailingOptIn
/*
2B
AD
R
SM
SR
*/

select sUserLastUpdated, COUNT(distinct ixCustomer)
from tblMailingOptIn
where dtLastUpdate >= '09/08/2013' 
    and ixCustomer in (
                    -- Customers from this year explicitly opted in or out of all 5 markets
                    select distinct V.ixCustomer 
                    from vwCustomerMailingMarketOptIn V
                    join tblCustomer C on V.ixCustomer = C.ixCustomer
                    -- 23,584 opted out.... 23,495 of those have no Market maked with UK
                    where SM = 'N'
                    and SR <> 'UK'
                    and AD <> 'UK'
                    and TB <> 'UK'
                    and R <> 'UK'
                    and C.dtAccountCreateDate >= '02/01/2013'
                    and (SM = 'Y' or SR = 'Y' or AD = 'Y' or TB = 'Y' or R = 'Y')
                    )
group by sUserLastUpdated
                 

select * --sUserLastUpdated, COUNT(distinct ixCustomer)
from tblMailingOptIn
where dtLastUpdate >= '02/01/2013' 
    and ixCustomer in (
                    -- Customers from this year explicitly opted in or out of all 5 markets
                    select distinct V.ixCustomer 
                    from vwCustomerMailingMarketOptIn V
                    join tblCustomer C on V.ixCustomer = C.ixCustomer
                    -- 23,584 opted out.... 23,495 of those have no Market maked with UK
                    where SM = 'N'
                    and SR <> 'UK'
                    and AD <> 'UK'
                    and TB <> 'UK'
                    and R <> 'UK'
                    and C.dtAccountCreateDate >= '02/01/2013'
                    and (SM = 'Y' or SR = 'Y' or AD = 'Y' or TB = 'Y' or R = 'Y')
                    )
and sUserLastUpdated = 'DLK'


select * from vwCustomerMailingMarketOptIn


select COUNT(distinct ixCustomer) -- * --sUserLastUpdated, 
from tblMailingOptIn
where dtLastUpdate < '02/01/2013' 