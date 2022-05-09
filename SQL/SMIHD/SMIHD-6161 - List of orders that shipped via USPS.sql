-- SMIHD-6161 - List of orders that shipped via USPS

/*
    need a list of order numbers that were keyed in between 
    3pm Friday and 11:30am Saturday that have a shipping method of 6, which is USPS.
    The date ranges I need this list is as follows:

    3pm 12/2 – 11:30a 12/3
    3pm 11/18 – 11:30a 11/19
    3pm 11/11 – 11:30a 11/12
    3pm 11/4 – 11:30a 11/5
    
*/


select O.ixOrder, O.dtOrderDate, T.chTime 'OrderTime', O.sOrderStatus, O.sOrderChannel, O.sOrderTaker, O.iShipMethod
    ,P.sTrackingNumber, D.dtDate 'PkgShippedDate', T2.chTime 'PkgShippedTime'
from tblOrder O
    JOIN tblTime T on O.ixOrderTime = T.ixTime
    LEFT JOIN tblPackage P on P.ixOrder = O.ixOrder and P.flgCanceled = 0 and P.flgReplaced = 0
    LEFT JOIN tblDate D on P.ixShipDate = D.ixDate
    LEFT JOIN tblTime T2 on P.ixShipTime = T2.ixTime
where iShipMethod = 6
    AND (
         (dtOrderDate = '12/2/2016' and ixOrderTime > 54000)
            OR
          (dtOrderDate = '12/3/2016' and ixOrderTime < 41400)
        )

UNION
select O.ixOrder, O.dtOrderDate, T.chTime 'OrderTime', O.sOrderStatus, O.sOrderChannel, O.sOrderTaker, O.iShipMethod
    ,P.sTrackingNumber, D.dtDate 'PkgShippedDate', T2.chTime 'PkgShippedTime'
from tblOrder O
    JOIN tblTime T on O.ixOrderTime = T.ixTime
    LEFT JOIN tblPackage P on P.ixOrder = O.ixOrder and P.flgCanceled = 0 and P.flgReplaced = 0
    LEFT JOIN tblDate D on P.ixShipDate = D.ixDate
    LEFT JOIN tblTime T2 on P.ixShipTime = T2.ixTime
where iShipMethod = 6
    AND (
         (dtOrderDate = '11/18/2016' and ixOrderTime > 54000)
            OR
          (dtOrderDate = '11/19/2016' and ixOrderTime < 41400)
        )
UNION
select O.ixOrder, O.dtOrderDate, T.chTime 'OrderTime', O.sOrderStatus, O.sOrderChannel, O.sOrderTaker, O.iShipMethod
    ,P.sTrackingNumber, D.dtDate 'PkgShippedDate', T2.chTime 'PkgShippedTime'
from tblOrder O
    JOIN tblTime T on O.ixOrderTime = T.ixTime
    LEFT JOIN tblPackage P on P.ixOrder = O.ixOrder and P.flgCanceled = 0 and P.flgReplaced = 0
    LEFT JOIN tblDate D on P.ixShipDate = D.ixDate
    LEFT JOIN tblTime T2 on P.ixShipTime = T2.ixTime
where iShipMethod = 6
    AND (
         (dtOrderDate = '11/11/2016' and ixOrderTime > 54000)
            OR
          (dtOrderDate = '11/12/2016' and ixOrderTime < 41400)
        )        
UNION
select O.ixOrder, O.dtOrderDate, T.chTime 'OrderTime', O.sOrderStatus, O.sOrderChannel, O.sOrderTaker, O.iShipMethod
    ,P.sTrackingNumber, D.dtDate 'PkgShippedDate', T2.chTime 'PkgShippedTime'
from tblOrder O
    JOIN tblTime T on O.ixOrderTime = T.ixTime
    LEFT JOIN tblPackage P on P.ixOrder = O.ixOrder and P.flgCanceled = 0 and P.flgReplaced = 0
    LEFT JOIN tblDate D on P.ixShipDate = D.ixDate
    LEFT JOIN tblTime T2 on P.ixShipTime = T2.ixTime
where iShipMethod = 6
    AND (
         (dtOrderDate = '11/4/2016' and ixOrderTime > 54000)
            OR
          (dtOrderDate = '11/5/2016' and ixOrderTime < 41400)
        )        
ORDER BY dtOrderDate,  T.chTime, O.ixOrder, P.sTrackingNumber


              
select * from tblTime where chTime in ('15:00:00', '11:30:00')
/*
ixTime	chTime
41400	11:30:00  
54000	15:00:00  
*/



/*
    3pm 12/9 – 11:30a 12/10
    3pm 12/16 – 11:30a 12/17
*/



select O.ixOrder, O.dtOrderDate, T.chTime 'OrderTime', O.sOrderStatus, O.sOrderChannel, O.sOrderTaker, O.iShipMethod
    ,P.sTrackingNumber, D.dtDate 'PkgShippedDate', T2.chTime 'PkgShippedTime'
from tblOrder O
    JOIN tblTime T on O.ixOrderTime = T.ixTime
    LEFT JOIN tblPackage P on P.ixOrder = O.ixOrder and P.flgCanceled = 0 and P.flgReplaced = 0
    LEFT JOIN tblDate D on P.ixShipDate = D.ixDate
    LEFT JOIN tblTime T2 on P.ixShipTime = T2.ixTime
where iShipMethod = 6
    AND (
         (dtOrderDate = '12/9/2016' and ixOrderTime > 54000)
            OR
          (dtOrderDate = '12/10/2016' and ixOrderTime < 41400)
        )

UNION
select O.ixOrder, O.dtOrderDate, T.chTime 'OrderTime', O.sOrderStatus, O.sOrderChannel, O.sOrderTaker, O.iShipMethod
    ,P.sTrackingNumber, D.dtDate 'PkgShippedDate', T2.chTime 'PkgShippedTime'
from tblOrder O
    JOIN tblTime T on O.ixOrderTime = T.ixTime
    LEFT JOIN tblPackage P on P.ixOrder = O.ixOrder and P.flgCanceled = 0 and P.flgReplaced = 0
    LEFT JOIN tblDate D on P.ixShipDate = D.ixDate
    LEFT JOIN tblTime T2 on P.ixShipTime = T2.ixTime
where iShipMethod <> 6
    AND (
       --  (dtOrderDate = '12/16/2016' and ixOrderTime > 54000)
        --    OR
          (dtOrderDate = '12/17/2016' and ixOrderTime < 45000) -- 41400)
        )
ORDER BY T.chTime         