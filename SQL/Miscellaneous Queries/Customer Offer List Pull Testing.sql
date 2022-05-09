
select ixSourceCode, COUNT(*) from tblCustomerOffer
where ixSourceCode  like '%TEST%'
--in ('INSTEST','INSTEST.11','TEST','TESTJBM','TESTJM','TESTJM1')
group by ixSourceCode


select min(ixTimeLastSOPUpdate), max(ixTimeLastSOPUpdate) --* 
from tblCustomerOffer
where ixSourceCode = 'TESTJM1'


72 rec/sec


select * 
-- DELETE
from tblCustomerOffer where ixSourceCode = 'TESTJM1'



select * from tblTime where chTime 



select count(*) from tblOrder where sShipToState = 'WA'
and dtShippedDate >= '01/01/2007'

/*
Kicked off Cust Offer loading routine at 9:42 AM

yesterday's speed (4.6 rec/sec) would have an ETA of 4:25PM

4:00PM would = 16.6 rec/sec
4:07PM would = 10.0 rec/sec
4:25PM would =  4.6 rec/sec (Monday's speed)
4:50PM would =  2.8 rec/sec (the slowest speed CST had 

*/

select count(*) from [SMIArchive].dbo.tblOrderArchive
where dtOrderDate between '01/01/2006' and '12/31/2006'
and sShipToState = 'WA'


select count(*) from [SMI Reporting].dbo.tblOrder
where dtOrderDate between '01/01/2006' and '12/31/2006'
and sShipToState = 'WA'

select ixOrder,dtDateLastSOPUpdate  --, ixCustomer 
from [SMI Reporting].dbo.tblOrder
where dtOrderDate between '01/01/2006' and '12/31/2006' -- 6989
and sShipToState = 'WA'
and sShipToStreetAddress1 is NULL
--and dtShippedDate > '01/01/2007'
and (dtDateLastSOPUpdate < '10/10/2014'
    or dtDateLastSOPUpdate is NULL)






select ixOrder --count(*)
from tblOrder
where dtOrderDate between '01/01/2013' and '07/01/2014' -- 6989
and sShipToZip = '68005'
and dtDateLastSOPUpdate < '10/10/2014'




select count(*) -- ixOrder --    27516
from tblOrder
where dtOrderDate between '01/01/2006' and '12/31/2006' -- 27516
and sShipToState in ('NE','IN')
and dtDateLastSOPUpdate = '10/10/2014'


select min(ixTimeLastSOPUpdate), max(ixTimeLastSOPUpdate)
from tblOrder
where dtOrderDate between '01/01/2006' and '12/31/2006' -- 27516
and sShipToState in ('NE','IN')
and dtDateLastSOPUpdate = '10/10/2014'

40415	41052
