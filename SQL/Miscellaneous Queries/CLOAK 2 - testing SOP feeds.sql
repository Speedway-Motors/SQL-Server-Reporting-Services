/*****  SMI  *********
select top 10
ixOrder, sOrderStatus, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
from [SMI Reporting].dbo.tblOrder
where dtOrderDate between '04/01/2010' and '04/01/2012'
and sOrderStatus = 'Shipped'
and dtDateLastSOPUpdate < '12/01/2012'
order by newid() desc
*/

-- SMI test orders
select ixOrder, sOrderStatus
    , CONVERT(VARCHAR, dtOrderDate, 101) OrderDate
    , CONVERT(VARCHAR, dtDateLastSOPUpdate, 101) LastSOPUpdate
    , ixTimeLastSOPUpdate
from [SMI Reporting].dbo.tblOrder
where ixOrder in ('4884914','3936163','4868106','4513719','3563490','4364301','3749974','4625712','3600073','4558402')
order by ixOrder
/*      sOrder              Last        ixTimeLast
ixOrder	Status	OrderDate	SOPUpdate	SOPUpdate
3563490	Shipped	11/04/2010	10/30/2012	57690
3600073	Shipped	05/21/2010	10/22/2012	43904
3749974	Shipped	06/07/2010	10/30/2012	30844
3936163	Shipped	04/02/2010	10/22/2012	55429
4364301	Shipped	01/17/2011	11/13/2012	59347
4513719	Shipped	04/11/2011	10/23/2012	33059
4558402	Shipped	02/02/2011	11/05/2012	49430
4625712	Shipped	04/17/2011	10/17/2012	68889
4868106	Shipped	02/23/2011	10/30/2012	36489
4884914	Shipped	05/02/2011	10/17/2012	61424
*/


/*****  AFCO  *********

select top 10
ixCustomer, ixOrder, sOrderStatus, dtOrderDate, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
from [AFCOReporting].dbo.tblOrder
where dtOrderDate between '04/01/2010' and '04/01/2012'
    and sOrderStatus = 'Shipped'
    and dtDateLastSOPUpdate < '04/01/2013' 
and ixCustomer NOT IN ('26101','26103') -- excluding SMI internal orders
order by newid() desc
*/

-- AFCO test orders
select ixOrder, sOrderStatus
    , CONVERT(VARCHAR, dtOrderDate, 101) OrderDate
    , CONVERT(VARCHAR, dtDateLastSOPUpdate, 101) LastSOPUpdate
    , ixTimeLastSOPUpdate
from [AFCOReporting].dbo.tblOrder
where ixOrder in ('628032','651752','634527','651623','635065-1','651648','624859','635071','639115','640060')
/*          sOrder              Last        ixTimeLast
ixOrder	    Status	OrderDate	SOPUpdate	SOPUpdate
624859	    Shipped	04/08/2010	01/29/2013	37171
628032	    Shipped	05/17/2010	01/29/2013	37529
634527	    Shipped	08/16/2010	01/29/2013	38338
635065-1	Shipped	08/25/2010	01/29/2013	38404
635071	    Shipped	08/25/2010	01/29/2013	38405
639115	    Shipped	11/15/2010	01/28/2013	59405
640060	    Shipped	12/07/2010	01/28/2013	59468
651623	    Shipped	04/25/2011	01/29/2013	40492
651648	    Shipped	04/25/2011	01/29/2013	40501
651752	    Shipped	04/26/2011	01/29/2013	40549
*/