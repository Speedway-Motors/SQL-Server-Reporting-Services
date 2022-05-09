-- Call Center Orders - Specified dates and times
/*
[11:26 AM] Chris A. Kelley
    Hi Patrick! I'm a new supervisor in the call center. I'm working on some data validation for Aaron. 
    In period 9 can you confirm how many orders we placed on Saturday from the 21:00-22:00? 

Any restrictions on the type of order placed and are we talking CST?

[11:38 AM] Chris A. Kelley
    the business unit would be CX orders only and yes CST. 

    */

    select * from tblDate
    where iYear= 2019
    and iPeriod = 9
    and sDayOfWeek3Char = 'SAT'

select * from tblDate  
WHERE ixDate in (18871,18878,18885,18892) -- the SATs of 2019 p9


select * from tblOrder
WHERE ixOrderDate in (18871,18878,18885,18892)
and ixBusinessUnit = 110 -- PHONE
and ixOrderTime between 75600 and 79200

select sOrderChannel 'OrderChannel', count(*) 'OrderCount'
from tblOrder
WHERE ixOrderDate in (18871,18878,18885,18892)
--and sOrderChannel = 'PHONE' -- = 110 -- PHONE
    and ixOrderTime between 75600 and 79200
    and ixOrder NOT LIKE 'Q%'
    and ixOrder NOT LIKE 'PC%'
group by sOrderChannel



select * 
from tblTime 
where chTime in ('21:00:00', '22:00:00')



select * from tblBusinessUnit

select * from tblBusinessUnit
