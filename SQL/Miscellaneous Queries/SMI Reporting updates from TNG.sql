-- SMI Reporting updates from TNG

-- tblBrand
    select CAST(convert(datetime, getdate(),20) as varchar (19)) 'As of             ',
        count(*) 'Records',
        CAST(convert(datetime, dtLastTNGUpdate,20) as varchar (19)) 'LastTNGUpdate    ', flgDeletedFromSOP
    from tblBrand
    group by CAST(convert(datetime, dtLastTNGUpdate,20) as varchar (19)), flgDeletedFromSOP
    /*
    As of             	Records	LastTNGUpdate       flgDeletedFromSOP
    =================== ======= =================== ================
    May  6 2016 11:08AM	1	    Apr 14 2016 11:10PM	0
    May  6 2016 11:08AM	1	    Apr 15 2016 11:10PM	0
    May  6 2016 11:08AM	1	    Apr 18 2016 11:10PM	0
    May  6 2016 11:08AM	1	    Apr 19 2016 11:10PM	0
    May  6 2016 11:08AM	1	    Apr 27 2016 11:10PM	0
    May  6 2016 11:08AM	1	    May  2 2016 11:10PM	0
    May  6 2016 11:08AM	1	    May  5 2016 11:10PM	0
    May  6 2016 11:08AM	9	    May  5 2016 11:30PM	0
    May  6 2016 11:08AM	513	    May  6 2016 10:35AM	0
    May  6 2016 11:08AM	3	    May  6 2016 11:07AM	0
    May  6 2016 11:08AM	43	    NULL	            1
    */

SELECT * from tblBrand
where flgDeletedFromSOP =1
and dtLastTNGUpdate is NOT NULL


    -- CHECK to confirm SOP is no longer pushing data to ixBrand
    select dtDateLastSOPUpdate, count(*)
    from tblBrand
    where flgDeletedFromSOP = 0
    group by dtDateLastSOPUpdate
    /*
    2016-03-23 00:00:00.000	515
    2016-04-11 23:30:01.687	9
    */


-- tblSKU
    select CAST(convert(datetime, getdate(),20) as varchar (19)) 'As of             ',
        count(*) 'Records',
        CAST(convert(datetime, dtLastTNGUpdate,20) as varchar (19)) 'LastTNGUpdate    '
    from tblSKU
    group by CAST(convert(datetime, dtLastTNGUpdate,20) as varchar (19))
    /*
    As of             	Records	LastTNGUpdate  
    =================== ======= ===================  
    May  6 2016 10:27AM	318512	NULL
    */


-- tblProductLine
    select CAST(convert(datetime, getdate(),20) as varchar (19)) 'As of             ',
        count(*) 'Records',
        CAST(convert(datetime, dtLastTNGUpdate,20) as varchar (19)) 'LastTNGUpdate    '
    from tblProductLine
    group by CAST(convert(datetime, dtLastTNGUpdate,20) as varchar (19))
    /*
    As of             	Records	LastTNGUpdate   
    =================== ======= ===================     
    May  6 2016 10:27AM	6135	NULL
    */

    select * from tblProductLine



SELECT * from tblBrand
where dtLastTNGUpdate is NULL
or dtLastTNGUpdate <'05/06/2009'



BEGIN TRAN
    ALTER TABLE dbo.tblProductLine
         ADD dtLastTNGUpdate datetime NULL
ROLLBACK TRAN



SELECT ixOrder, ixOrderDate, ixCustomerType, sMethodOfPayment, sOrderType, O.iShipMethod, sOrderChannel, sOrderTaker, sOrderStatus, ixOrderTime, dtOrderDate, T.chTime 'OrderTime', ixConvertedOrder, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
FROM tblOrder O
    join tblTime T on O.ixOrderTime = T.ixTime
where ixOrder in ('6803662','6985268','6986268','6998161','Q1802686','Q1802719','Q1802723','Q1802727','Q1802734','Q1802784','Q1802788','Q1802803','Q1802819','Q1802836','Q1802839')
order by dtOrderDate, T.chTime   