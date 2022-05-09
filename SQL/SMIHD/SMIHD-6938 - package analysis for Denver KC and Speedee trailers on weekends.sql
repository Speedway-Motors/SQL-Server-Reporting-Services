-- SMIHD-6938 - package analysis for Denver KC and Speedee trailers on weekends

/*
SELECT * FROM tblTrailer

DEN	- UPS Denver
KC	- UPS KC
LPU	- SpeeDee Lincoln
DSM	- SpeeDee Des Moines


OMN	UPS Omaha (Midnight)
OMS	UPS Omaha (Sunrise)
DMS	Des Moines Sunday

*/
SELECT P.sTrackingNumber, ORT.ixPrintPrimaryTrailer 'ORTPrimaryPrintTrailer', P.ixTrailer 'PKGShippedTrailer', 
    D.dtDate 'AvailableToPrint' ,
    D3.dtDate 'PkgShipped',
     D2.dtDate 'PrintedDate',
     D3.dtDate 'PkgShippedDate',     
     D.sDayOfWeek3Char 'AvailableToPrintDAY' -- D.dtDate 'OrderPrinted'
from tblPackage P
    join tblOrder O on P.ixOrder = O.ixOrder
    join tblOrderRouting ORT on ORT.ixOrder = O.ixOrder
    left join tblDate D on ORT.ixAvailablePrintDate = D.ixDate
    left join tblDate D2 on ORT.ixPrintDate = D2.ixDate
    left join tblDate D3 on D3.ixDate = P.ixShipDate
where (P.ixTrailer in ('DEN','KC','LPU', 'DSM') -- , 'DMS'
    --  OR ORT.ixPrintPrimaryTrailer in ('DEN','KC','LPU', 'DSM') -- , 'DMS'
      )
     and P.flgCanceled = 0
     and P.ixShipDate is NOT NULL
     and D3.dtDate IN ('02/18/2017','02/19/2017') --.dtShippedDate = '03/06/2017'
     and O.iShipMethod <> 1
-- and D2.dtDate is NULL 
-- and  ORT.ixPrintPrimaryTrailer <> P.ixTrailer
ORDER BY  D3.dtDate --D.sDayOfWeek3Char

SELECT ixOrder, sTrackingNumber
from tblPackage where sTrackingNumber in ('1Z6353580339738633','1Z6353580339740488','1Z6353580339742968','1Z6353580339742977','1Z6353580339742986','SP0103850342174478','1Z6353580339749229','1Z6353580339754179','1Z6353580339761009','1Z6353580339756695','1Z6353580339754188','SP0103850342175404','1Z6353580339754071','1Z6353580339754080','1Z6353580339755025','1Z6353580339743869','1Z6353580339743878','1Z6353580339755678')
order by ixOrder



-- Do we want it based off the PrimaryPrintTrailer in tblOrderRouting or the ixTrailer in tblPackage?
-- Are we looking at orders only PRINTED on Saturday & Sunday?


SELECT --ORT.ixPrintPrimaryTrailer 'ORTPrimaryPrintTrailer', 
P.ixTrailer 'PKGShippedTrailer', 
  --  D3.dtDate 'PkgShipped',
   --  D2.dtDate 'PrintedDate',
    -- D3.dtDate 'PkgShippedDate',     
     D3.sDayOfWeek3Char 'ShippedDay',        
    -- D.sDayOfWeek3Char 'AvailableToPrintDAY' -- D.dtDate 'OrderPrinted'
COUNT(Distinct P.sTrackingNumber) 'PkgCount'    
from tblPackage P
    join tblOrder O on P.ixOrder = O.ixOrder
    join tblOrderRouting ORT on ORT.ixOrder = O.ixOrder
    left join tblDate D on ORT.ixAvailablePrintDate = D.ixDate
    left join tblDate D2 on ORT.ixPrintDate = D2.ixDate
    left join tblDate D3 on D3.ixDate = P.ixShipDate
where (P.ixTrailer in ('DEN','KC','LPU', 'DSM') -- , 'DMS'
    --  OR ORT.ixPrintPrimaryTrailer in ('DEN','KC','LPU', 'DSM') -- , 'DMS'
      )
     and P.flgCanceled = 0
     and P.ixShipDate is NOT NULL
     and D3.dtDate >= '02/10/2016'
     and D3.sDayOfWeek3Char  in ('SAT', 'SUN')
     and O.iShipMethod <> 1
-- and D2.dtDate is NULL 
-- and  ORT.ixPrintPrimaryTrailer <> P.ixTrailer
GROUP BY P.ixTrailer,D3.sDayOfWeek3Char
ORDER BY D3.sDayOfWeek3Char,  P.ixTrailer--D.sDayOfWeek3Char


