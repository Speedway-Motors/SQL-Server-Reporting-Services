-- Refeed Address data for tblOrder

select COUNT(*) from tblOrder where sShipToStreetAddress1 is NULL 
    AND dtShippedDate >= '01/01/2006'
    AND (dtDateLastSOPUpdate < '10/20/2014' or dtDateLastSOPUpdate is NULL)
/*
Rec     As of
====    ========
2.8M    10-27-14
2.0M    11-03-14
1.6M    11-10-14
950K    11-19-14
343K    11-26-14
235K    12-05-14
114K    12-09-14
*/

/******************************************************************  
     refeed orders missing address info 
     from the most recent and working back to 1/1/2006  
*******************************************************************/
-- Most recent batch to refeed
select --top 43354
    ixOrder, dtOrderDate, dtShippedDate --  30K ETA @9:15AM = 11:20AM   <-- kicked off 12-10-14 at 9:15am
from tblOrder O                         --  15K ETA @9:10AM = 11:
where  sShipToStreetAddress1 is NULL    --      ETA @ = 
    AND dtShippedDate between '01/01/2006' and '10/06/2007'
    AND (dtDateLastSOPUpdate is NULL
         or 
         dtDateLastSOPUpdate < '10/20/2014')    
order by dtOrderDate  desc  

-- All orders refed 10/06/2007 to present


-- QTY LEFT (breakdown by year)
select D.iYear, 
    COUNT(*), (COUNT(*)/14400) 'EstHrs' -- rate = approx 4 rec/sec
from tblOrder O
    join tblDate D on O.ixShippedDate = D.ixDate
where  sShipToStreetAddress1 is NULL
    AND dtShippedDate >= '01/01/2006'
    AND ixOrder NOT LIKE 'Q%'
    AND (dtDateLastSOPUpdate is NULL or dtDateLastSOPUpdate < '10/20/2014')    
group by D.iYear
order by D.iYear desc   
/*
                    Est
iYear       Qty     Hrs (@16K rec/hr)
=====   =======     ===
2006	3	        0
*/              



/*********** STATES REFED ***************/
/*
sShip
ToState	NULL	Populated   @
======= ======  =========   ==================
FL      10,093  109,576     2014-10-31 12:45 
IA	      8,010	 86,782     2014-10-27 10:16
IL        9,303 112,666     2014-10-29 13:49
IN        6,848  73,488     2014-10-27 12:23
KS        9,377 100,312     2014-10-28 10:22 
MO       13,670 132,659     2014-10-28 16:05
NE	     23,214	198,124     2014-10-27 10:16
NY        7,586  92,150     2014-11-03 10:15
OK        5,239  60,505     2014-11-03 17:25
PA	      7,674	 97,267     2014-10-27 16:03
WA	      7,585	 90,906     2014-10-27 10:16


-- counts by state
SELECT sShipToState, count(*) NULLcnt, NULL as 'Populated'
from tblOrder 
    join tblStates S on S.ixState = tblOrder.sShipToState and (S.flgContiguous = 1 or S.flgNonContiguous =1)
where sShipToState NOT in ('IA','IN','NE','WA','PA','FL', 'IL', 'KS', 'MO', 'NY', 'OK')
    AND dtShippedDate >= '01/01/2006'
    AND sShipToStreetAddress1 is NULL
group by  sShipToState   
UNION
SELECT sShipToState, NULL NULLcnt, count(*) as 'Populated'
from tblOrder 
    join tblStates S on S.ixState = tblOrder.sShipToState and (S.flgContiguous = 1 or S.flgNonContiguous =1)
where sShipToState NOT in ('IA','IN','NE','WA','PA','FL', 'IL', 'KS', 'MO', 'NY', 'OK')
    AND dtShippedDate >= '01/01/2006'
    AND sShipToStreetAddress1 is NOT NULL
group by  sShipToState  
order by Populated, sShipToState
*/


select * from vwDataFreshness
where sTableName = 'tblOrder'          



select O.ixOrder
from tblOrder O
    left join tblDate D on O.ixShippedDate = D.ixDate
where sShipToStreetAddress1 is NULL
  --  AND dtShippedDate >= '01/01/2006'
  --  AND ixOrder NOT LIKE 'Q%'
    (dtDateLastSOPUpdate is NULL or dtDateLastSOPUpdate < '6/10/2014')    
group by D.iYear
order by D.iYear desc   


select TOP 30000 ixOrder from tblOrder
where dtDateLastSOPUpdate < '6/10/2014'-- 69,371



