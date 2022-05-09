-- Case 23454 - UPS package cost analysis

SELECT DISTINCT ISNULL(JAN.sTrackingNumber, ISNULL(FEB.sTrackingNumber, ISNULL(MAR.sTrackingNumber, ISNULL(APR.sTrackingNumber, MAY.sTrackingNumber)))) AS TrackingNumber 
     , ISNULL(JAN.ixOrder, ISNULL(FEB.ixOrder, ISNULL(MAR.ixOrder, ISNULL(APR.ixOrder, MAY.ixOrder)))) AS OrderNumber
     , ISNULL(JAN.TotalBill, ISNULL(FEB.TotalBill, ISNULL(MAR.TotalBill, ISNULL(APR.TotalBill, MAY.TotalBill)))) AS TotalBill
     , (ISNULL(JAN.TotalBill, ISNULL(FEB.TotalBill, ISNULL(MAR.TotalBill, ISNULL(APR.TotalBill, MAY.TotalBill))))  -- total bill 
         / NULLIF(dActualWeight,0)) AS BilledPerPound     
FROM ASC_Jan2014_UPS_ShipDataAGG JAN 
FULL OUTER JOIN ASC_Feb2014_UPS_ShipDataAGG FEB ON FEB.ixOrder = JAN.ixOrder
FULL OUTER JOIN ASC_Mar2014_UPS_ShipDataAGG MAR ON MAR.ixOrder = JAN.ixOrder
FULL OUTER JOIN ASC_Apr2014_UPS_ShipDataAGG APR ON APR.ixOrder = JAN.ixOrder
FULL OUTER JOIN ASC_May2014_UPS_ShipDataAGG MAY ON MAY.ixOrder = JAN.ixOrder
LEFT JOIN [SMI Reporting].dbo.tblPackage P ON P.ixOrder = ISNULL(JAN.ixOrder, ISNULL(FEB.ixOrder, ISNULL(MAR.ixOrder, ISNULL(APR.ixOrder, MAY.ixOrder))))
WHERE ISNULL(JAN.ixOrder, ISNULL(FEB.ixOrder, ISNULL(MAR.ixOrder, ISNULL(APR.ixOrder, MAY.ixOrder)))) = '5838147' 
  AND P.flgCanceled = 0 
ORDER BY TotalBill DESC     




-- ALAINA'S AGGREGATED MONTHLY TABLES
select * from ASC_Jan2014_UPS_ShipDataAGG

select COUNT(*) from ASC_Jan2014_UPS_ShipDataAGG    -- 23,027
select COUNT(*) from ASC_Feb2014_UPS_ShipDataAGG    -- 31,940
select COUNT(*) from ASC_Mar2014_UPS_ShipDataAGG    -- 51,319
select COUNT(*) from ASC_Apr2014_UPS_ShipDataAGG    -- 42,202
select COUNT(*) from ASC_May2014_UPS_ShipDataAGG    -- 11,144
--                                                    =======
                                                   -- 159,632
                          
select COUNT(*) from ASC_AllMonths_UPS_DistinctShipDataAGG -- 158,503
select COUNT(distinct *) from ASC_AllMonths_UPS_DistinctShipDataAGG -- 158,503

/*
DROP TABLE PJC_Jan2014_UPS_ShipData
DROP TABLE PJC_Feb2014_UPS_ShipData
DROP TABLE PJC_Mar2014_UPS_ShipData
DROP TABLE PJC_Apr2014_UPS_ShipData
DROP TABLE PJC_May2014_UPS_ShipData
*/

select COUNT(*) from ASC_Jan2014_UPS_ShipData -- 38,082
select COUNT(*) from ASC_Feb2014_UPS_ShipData -- 47,422
select COUNT(*) from ASC_Mar2014_UPS_ShipData -- 76,493
select COUNT(*) from ASC_Apr2014_UPS_ShipData -- 62,840
select COUNT(*) from ASC_May2014_UPS_ShipData -- 16,354
--                                              =======
--                                              241,191 Total


-- Copying the Raw data from each Alaina's 5 monthly tables
select * into PJC_Jan2014_UPS_ShipData -- 38,082
from ASC_Jan2014_UPS_ShipData

select * into PJC_Feb2014_UPS_ShipData -- 47,422
from ASC_Feb2014_UPS_ShipData

select * into PJC_Mar2014_UPS_ShipData -- 76,493
from ASC_Mar2014_UPS_ShipData

select * into PJC_Apr2014_UPS_ShipData -- 62,840
from ASC_Apr2014_UPS_ShipData

select * into PJC_May2014_UPS_ShipData -- 16,354
from ASC_May2014_UPS_ShipData

-- combining the 5 monthly tables
-- DROP TABLE  PJC_Combo_UPS_ShipData_RAW
select sTrackingNumber,sSource,sServiceText,'Jan' as 'OrigMonth',mBill 
into PJC_Combo_UPS_ShipData_RAW -- 38,082
 from PJC_Jan2014_UPS_ShipData

insert into  PJC_Combo_UPS_ShipData_RAW
select sTrackingNumber,sSource,sServiceText,'Feb' as 'OrigMonth',mBill  
from PJC_Feb2014_UPS_ShipData  -- 47,422

insert into  PJC_Combo_UPS_ShipData_RAW
select sTrackingNumber,sSource,sServiceText,'Mar' as 'OrigMonth',mBill  
from PJC_Mar2014_UPS_ShipData  -- 76,493

insert into  PJC_Combo_UPS_ShipData_RAW
select sTrackingNumber,sSource,sServiceText,'Apr' as 'OrigMonth',mBill  
from PJC_Apr2014_UPS_ShipData -- 62,840

insert into  PJC_Combo_UPS_ShipData_RAW
select sTrackingNumber,sSource,sServiceText,'May' as 'OrigMonth',mBill 
from PJC_May2014_UPS_ShipData -- 16,354

-- verifying combo table
    
    
    select * from PJC_Combo_UPS_ShipData_RAW -- 241,191v matches Total

    select COUNT(distinct sTrackingNumber) 
    from PJC_Combo_UPS_ShipData_RAW         -- 187,817 packages

    SELECT TOP 5 * FROM PJC_Combo_UPS_ShipData_RAW 
    
    -- looking at other columns
    select COUNT(*) Qty, sSource
    from PJC_Combo_UPS_ShipData_RAW
    group by sSource
    order by COUNT(*) desc
    /*
    Qty	sSource
    179066	Host Manifest
    44152	Res/Com Adjust
    5559	Shipping Charge Correction
    2652	Collect
    2632	Returns: Label Surcharge
    2160	Third Party
    2135	Returns: Transportation
    1274	Worldwide Service
    557	    Address Corrections
    395	    UPS WorldShip
    280	    Closed Loop Billing
    105	    Undeliverable Returns
    76	    UPS Shipping Document
    72	    Delivery Intercept
    20	    Internet
    18	    Residential Adjustments
    16	    Fees
    6	    Guaranteed Service Refund (CallIn)
    5	    Saturday Delivery Not Billed
    4	    Delivery Confirmation Sig Chg Not Billed
    3	    Adjustments
    1	    Adult Sig Required Not Billed
    1	    Void Credits
    1	    Chargebacks
    1	    On-Call Pickup Requests
    */
    select COUNT(*) Qty, sServiceText
    from PJC_Combo_UPS_ShipData_RAW
    group by sServiceText
    order by COUNT(*) desc
    /*
    154345	GND
    22076	COMMERCIAL
    22076	RESIDENTIAL
    15013	2DA
    8581	NULL
    4613	GROUND
    2628	PRINT LABEL
    2379	USG
    2135	RETURNS GROUND COMMERCIAL
    2081	GROUND COMMERCIAL COLLECT
    1059	GROUND RESIDENTIAL THIRD PARTY
    988	GROUND COMMERCIAL THIRD PARTY
    866	2ND DAY AIR
    500	WORLDWIDE EXPEDITED
    465	1DA
    212	WORLDWIDE EXPEDITED SHIPMENT
    155	GROUND RESIDENTIAL
    116	NEXT DAY AIR
    111	WORLDWIDE SAVER
    101	GROUND UNDELIVERABLE RETURN
    100	GROUND COMMERCIAL
    93	STANDARD TO CANADA
    84	GROUND RESIDENTIAL COLLECT
    75	GROUND COMMERCIAL S.D.P.
    64	STANDARD SHIPMENT
    46	GROUND S.D.P.
    26	EXPEDITED
    22	2ND DAY AIR RESIDENTIAL
    21	GROUND RETURN TO SENDER
    16	WORLDWIDE SAVER SHIPMENT
    16	SERVICE CHARGES
    15	2ND DAY AIR COMMERCIAL
    13	CANADA RESIDENTIAL
    12	GROUND COMMERCIAL COLLECT S.D.P.
    10	UPS SUREPOST - 1 LB OR GREATER
    7	3 DAY SELECT COMMERCIAL COLLECT
    7	GROUND COMMERCIAL THIRD PARTY S.D.P.
    7	3 DAY SELECT UNDELIVERABLE RETURN
    6	NEXT DAY AIR COMMERCIAL THIRD PARTY
    5	WORLDWIDE SAVER LETTER
    5	2ND DAY AIR RESIDENTIAL THIRD PARTY
    4	3 UPS PICKUP ATTEMPTS
    3	NEXT DAY AIR RESIDENTIAL
    3	2ND DAY AIR COMMERCIAL COLLECT
    3	3 DAY SELECT RETURN TO SENDER
    3	2ND DAY AIR COMMERCIAL THIRD PARTY
    2	NEXT DAY AIR COMMERCIAL LETTER
    2	GROUND RESIDENTIAL UPS
    2	NEXT DAY AIR COMMERCIAL
    2	3 DAY SELECT RESIDENTIAL THIRD PARTY
    2	NEXT DAY AIR COMMERCIAL COLLECT
    2	NEXT DAY AIR RESIDENTIAL THIRD PARTY
    1	WORLDWIDE EXPRESS LETTER
    1	BILLING ADJUSTMENT FOR W/E 02/08/2014 SHIPMENT NOT PREVIOUSLY BILLED DUPLICATE TRACKING # DEST ZIP 45338 DEL DATE 10/4/2013 12:01: TRACKING NUMBER(S): 1Z6353580325054362
    1	GROUND HUNDREDWEIGHT UNDELIVERABLE RETURN
    1	WORLDWIDE EXPRESS
    1	BILLING ADJUSTMENT FOR W/E 03/15/2014 SHIPMENT NOT PREVIOUSLY BILLED UNBILLED - PUDATE: 02/13/2014 TRACKING NUMBER(S): 43359170601
    1	BILLING ADJUSTMENT FOR W/E 07/20/2013 INCORRECT ACCOUNT RECEIVED CHARGEBACK\SHIPPER BILLED WRONG COLLECT #E73156\GROUND 31LB\ZONE 6\SHIPPED 7/18 TRACKING NUMBER(S): 1Z6353580374446294
    1	USG(URG)
    1	1Z6353580125945699
    1	1Z6353580125849052
    1	1Z6353580225943411
    1	1Z6353580225943073
    1	1Z6353580225848051
    1	1DM
    */

 -- NOW ADD and populate iShipMethod  ixShipDate fields
    update COMBO -- 226,353
    set ixShipDate = P.ixShipDate
    from PJC_Combo_UPS_ShipData_RAW COMBO
     join [SMI Reporting].dbo.tblPackage P on COMBO.sTrackingNumber = P.sTrackingNumber 
    where P.ixShipDate >= 16803 -- 01/01/2014 to avoid older tracking numbers that have been re-used

    -- RESET
    -- update PJC_Combo_UPS_ShipData_RAW
    -- set ixShipDate = NULL

    select MIN(ixShipDate), MAX(ixShipDate)
    from PJC_Combo_UPS_ShipData_RAW -- 16804 1/2/14 	16924 5/2/14

    select COUNT(*) from PJC_Combo_UPS_ShipData_RAW -- 226,353
    where ixShipDate is NOT NULL

    select * from [SMI Reporting].dbo.tblDate where ixDate = 16924

    update COMBO -- 226,353
    set iShipMethod = O.iShipMethod
    from PJC_Combo_UPS_ShipData_RAW COMBO
     join [SMI Reporting].dbo.tblPackage P on COMBO.sTrackingNumber = P.sTrackingNumber 
     join [SMI Reporting].dbo.tblOrder O on P.ixOrder = O.ixOrder
    where P.ixShipDate >= 16803

        select iShipMethod, COUNT(*) Qty
        from PJC_Combo_UPS_ShipData_RAW
        group by iShipMethod
        order by COUNT(*) desc
        /*
        iShip
        Method	Qty
        2	    204034  UPS Ground
        32	    17455   UPS 2 Day Economy
        NULL	14838
        18	    2345
        10	    880
        4	    604
        3	    357
        12	    287
        8	    258
        11	    133
        */

        select * from [SMI Reporting].dbo.tblShipMethod
        where ixCarrier = 'UPS'
        and sTransportMethod like '%Ground%'
        /*
        2	UPS Ground
        12	UPS Standard
        18	UPS SurePost
        19	Canada Post
        32	UPS 2 Day Economy
        */


/**** new table with only shipmethod 2 data ****/
select * 
into PJC_UPS_ShipMethod2_RAW -- 204,034
from PJC_Combo_UPS_ShipData_RAW
where iShipMethod = 2

select COUNT (distinct sTrackingNumber) -- 158,504
from PJC_UPS_ShipMethod2_RAW

    -- looking at packages with more than 1 charge
    select * from PJC_UPS_ShipMethod2_RAW
    where exists (select sTrackingNumber, COUNT(*)
                              from PJC_UPS_ShipMethod2_RAW -- 98% of packages with more than 1 charge have 3 charges, some have as many as 8
                              group by sTrackingNumber
                              having COUNT(*) > 1
                              --order by COUNT(*) desc
                              )

/*** AGG table of all ShipMethod 2 packages shipped after 1/1/14 *****/
select sTrackingNumber, SUM(mBill) as 'TotalBill' -- 158,504
into PJC_UPS_ShipMethod2_AGG
from PJC_UPS_ShipMethod2_RAW
group by sTrackingNumber

select SUM(TotalBill) from PJC_UPS_ShipMethod2_AGG                 -- 1,668,894.86   almost identical results at this stage!  
select SUM(TotalBill) from ASC_AllMonths_UPS_DistinctShipDataAGG   -- 1,668,819.89

select top 10 * from ASC_AllMonths_UPS_DistinctShipDataAGG

dActualWeight and ixOrder




 -- ADD and populate dActualWeight and ixOrder fields
    update AGG -- 158,504
    set dActualWeight = P.dActualWeight
    from PJC_UPS_ShipMethod2_AGG AGG
     join [SMI Reporting].dbo.tblPackage P on AGG.sTrackingNumber = P.sTrackingNumber 
    where P.ixShipDate >= 16803 -- 01/01/2014 to avoid older tracking numbers that have been re-used

select * from PJC_UPS_ShipMethod2_AGG
order by dActualWeight
-- 175  NULL
-- 2189 0.000 
-- max weight = 147.90

select SUM(dActualWeight) from PJC_UPS_ShipMethod2_AGG -- 1,988,293.140

/** RESET
   update PJC_UPS_ShipMethod2_AGG
   set ixOrder = NULL
**/   
    

    select MIN(ixShipDate), MAX(ixShipDate)
    from PJC_UPS_ShipMethod2_AGG -- 16804 1/2/14 	16924 5/2/14

    select COUNT(*) from PJC_UPS_ShipMethod2_AGG -- 226,353
    where ixShipDate is NOT NULL

    select * from [SMI Reporting].dbo.tblDate where ixDate = 16924

    update AGG -- 158,504
    set ixOrder = O.ixOrder
    from PJC_UPS_ShipMethod2_AGG AGG
     join [SMI Reporting].dbo.tblPackage P on AGG.sTrackingNumber = P.sTrackingNumber 
     join [SMI Reporting].dbo.tblOrder O on P.ixOrder = O.ixOrder
    where P.ixShipDate >= 16803
    -- and O.ixShippedDate >= 16803 

select * from PJC_UPS_ShipMethod2_AGG
order by ixOrder  -- looks fine

select COUNT(distinct ixOrder) from PJC_UPS_ShipMethod2_AGG -- 116,151 Orders

/*** At this point we have a list of packages with their:
    sTrackingNumber
    dWeight
    TotalBill
    ixOrder #
    
*/  


/* STOPPING HERE....  
    we did not understand what was needed and wasted a LOT of time.  
    Alaina knows what Chris wants now and what she needs to do to get it.
*/    






