-- AMAZON PRIME TESTING
SELECT * FROM tblSourceCode 
WHERE ixSourceCode like '%PRIME%'

SELECT top 10 * 
FROM tblOrder
WHERE sSourceCodeGiven like '%PRIME%'
or sMatchbackSourceCode like '%PRIME%'
/*  Amazon orders switch to AmazonPrime for testing purposes.  Will be changed back to Amazon orders on 6-7-18

ixOrder	ixCustomer	ixOrderDate	sOrderType	sOrderChannel	sSourceCodeGiven	iShipMethod	sMethodOfPayment	sOrderTaker	mMerchandise	sOrderStatus
7334997	2728194	    18419	    Retail	    AMAZON	        AMAZONPRIME	        2	        AMAZON	            WEB	        29.99	        Shipped
7335996	2728199	    18419	    Retail	    AMAZON	        AMAZONPRIME	        2	        AMAZON	            WEB	        27.99	        Shipped
7384991	2740197	    18419	    Retail	    AMAZON	        AMAZONPRIME	        2	        AMAZON	            WEB	        169.99	        Open
*/
select * from vwDailyOrdersTaken
where dtDate = '06/05/2018'

select ixOrder, dtOrderDate, ixCustomer, sSourceCodeGiven, mMerchandise, sOrderStatus, sShipToState
from tblOrder
where dtOrderDate>= '06/06/2018'
and sSourceCodeGiven like 'AMAZONP%'
--AND sOrderStatus in ('Shipped','Open','Shipped')
--and ixOrder > 7445001
order by dtOrderDate
-- mMerchandise

SELECT * FROM tblPackage
where ixOrder in ('7334997','7335996')

/* temporarily changing and AMAZON SC to AMAZONPRIME for testing

BEGIN TRAN

    UPDATE tblOrder
    set sSourceCodeGiven = 'AMAZONPRIME'
    WHERE ixOrder = '7445194'

ROLLBACK TRAN

*/

SELECT * FROM tblOrder where sSourceCodeGiven = 'AMAZONPRIME'


