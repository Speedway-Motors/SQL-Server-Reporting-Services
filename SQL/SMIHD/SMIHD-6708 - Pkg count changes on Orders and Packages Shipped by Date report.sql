-- SMIHD-6708 - Pkg count changes on Orders and Packages Shipped by Date report

/* THIS REQUEST WAS A TOTAL WASTE OF TIME.  The variance Lynn reported amounted to less than 0.3%/day

   Placed the following note in the report header:
   " *Any packages that are cancelled after the report is executed will not be counted the next time the report is run (thereby lowering the counts slightly)."
   
   Lynn's team has the ability to correct shiping issues after packages have been shipped.
   
*/   

/**** tblPackage snapshots for pkgs shipped	THURSDAY 02/16/2017  *******/

-- 1st snapshot (the day after the ship date, which is normally when the "Orders and Packages Shipped by Date" report runs)
-- Snapshot taken FRI 02/17/17
    SELECT * 
    into [SMITemp].dbo.PJC_tblPackageSnapShotFor20170216_taken20170217 -- 2270 rows    
    FROM tblPackage
    where ixShipDate = 17945 --	02/16/2017

-- Snapshot taken SAT 02/18/17
    SELECT * 
    into [SMITemp].dbo.PJC_tblPackageSnapShotFor20170216_taken20170218 --  2270 rows 
    FROM tblPackage
    where ixShipDate = 17945 --	02/16/2017

-- MISSED taking SUNDAY's snapshot

-- Snapshot taken MON 02/20/17
    SELECT * -- MONDAY
    into [SMITemp].dbo.PJC_tblPackageSnapShotFor20170216_taken20170220 --  2270 rows 
    FROM tblPackage
    where ixShipDate = 17945 --	02/16/2017

-- Snapshot taken TUE 02/21/17
    -- DROP TABLE [SMITemp].dbo.PJC_tblPackageSnapShotFor20170216_taken20170221
    SELECT * -- TUESDAY
    into [SMITemp].dbo.PJC_tblPackageSnapShotFor20170216_taken20170221 --  2270 rows  
    FROM tblPackage
    where ixShipDate = 17945 --	02/16/2017

-- Snapshot taken WED 02/16/17 
    SELECT * -- WEDNESDAY
    into [SMITemp].dbo.PJC_tblPackageSnapShotFor20170216_taken20170222 --  2270 rows
    FROM tblPackage
    where ixShipDate = 17945 --	02/16/2017

    -- Snapshot taken DAY 02/23/17 
    SELECT * -- THURSDAY
    into [SMITemp].dbo.PJC_tblPackageSnapShotFor20170216_taken20170223 --  2270 rows
    FROM tblPackage
    where ixShipDate = 17945 --	02/16/2017






    -- Snapshot taken DAY ##/##/17 
    SELECT * -- FRIDAY
    into [SMITemp].dbo.PJC_tblPackageSnapShotFor20170216_taken20170223 --  rows
    FROM tblPackage
    where ixShipDate = 17945 --	02/16/2017

    -- Snapshot taken DAY ##/##/17 
    SELECT * -- SATURDAY
    into [SMITemp].dbo.PJC_tblPackageSnapShotFor20170216_taken20170223 --  rows
    FROM tblPackage
    where ixShipDate = 17945 --	02/16/2017

    -- Snapshot taken DAY ##/##/17 
    SELECT * -- SUNDAY
    into [SMITemp].dbo.PJC_tblPackageSnapShotFor20170216_taken20170223 --  rows
    FROM tblPackage
    where ixShipDate = 17945 --	02/16/2017

SELECT ixShipDate, flgCanceled, COUNT(sTrackingNumber) Pkgs, GETDATE() 'AsOf'
FROM tblPackage
where ixVerificationDate between 17899 AND 17950 -- 1/1/17 TO 1/21/17
GROUP BY  ixShipDate, flgCanceled
ORDER BY ixShipDate, flgCanceled

/**** COMPARE DATA OF SNAPSHOTS  ***********/

SELECT sTrackingNumber,ixOrder,ixVerificationDate,ixVerificationTime,ixShipDate,ixShipTime,ixPacker,ixVerifier,
    ixShipper,dBillingWeight,dActualWeight,ixTrailer,mPublishedFreight,mShippingCost,ixVerificationIP,ixShippingIP,
    --dtDateLastSOPUpdate,ixTimeLastSOPUpdate,  
    ixShipTNT,flgMetals,flgCanceled,flgReplaced,dLength,dWidth,dHeight
    --,ixPackageDeliveredLocal, dtPackageDeliveredLocal -- all fields except SOP updates fields and delivered fields
FROM [SMITemp].dbo.PJC_tblPackageSnapShotFor20170216_taken20170217
WHERE flgCanceled = 0
ORDER BY ixOrder, sTrackingNumber

SELECT sTrackingNumber,ixOrder,ixVerificationDate,ixVerificationTime,ixShipDate,ixShipTime,ixPacker,ixVerifier,
    ixShipper,dBillingWeight,dActualWeight,ixTrailer,mPublishedFreight,mShippingCost,ixVerificationIP,ixShippingIP,
    --dtDateLastSOPUpdate,ixTimeLastSOPUpdate,  
    ixShipTNT,flgMetals,flgCanceled,flgReplaced,dLength,dWidth,dHeight
    --,ixPackageDeliveredLocal, dtPackageDeliveredLocal -- all fields except SOP updates fields and delivered fields
FROM [SMITemp].dbo.PJC_tblPackageSnapShotFor20170216_taken20170223
WHERE flgCanceled = 0
order by ixOrder, sTrackingNumber

-- Ran a DIF of the above 2 query results.  Identical except for the delivered fields and the last SOP update fields



-- query from "Orders and Packages Shipped by Date" run against 1st snapshot
DECLARE @StartDate datetime,        @EndDate datetime
SELECT  @StartDate = '02/16/17',    @EndDate = '02/16/17' 

SELECT O.iShipMethod as 'Ship Method',
        SM.sDescription,
	    count (distinct O.ixOrder) as 'Orders Shipped',
	    count(1) as 'Packages Shipped',
	    SUM(dActualWeight) 'ActualWeight'
FROM tblOrder O
	join [SMITemp].dbo.PJC_tblPackageSnapShotFor20170216_taken20170217 P on P.ixOrder = O.ixOrder -- DO NOT USE LEFT JOIN!  WE ONLY WANT TO COUNT ORDERS IF THEY ACTUALLY HAD A PHYSICAL PACKAGE THAT WAS SHIPPED
    left join tblShipMethod SM on SM.ixShipMethod = O.iShipMethod
	--left join tblDate D on D.ixDate = P.ixShipDate  <-- this was requiring a value to be in tblPackage so it was excluding Orders that didn't have packages
	left join tblDate D on D.ixDate = O.ixShippedDate
WHERE D.dtDate between @StartDate and @EndDate
    and O.iShipMethod <> 1  -- excluding counter orders
    and (P.flgCanceled is NULL or P.flgCanceled = 0)
    and  (P.flgReplaced is NULL or P.flgReplaced= 0)
 /* and (P.dActualWeight is NULL       
         OR                         -- add to find only packages without weights
         P.dActualWeight = 0)  
 */         
GROUP BY O.iShipMethod,SM.sDescription
ORDER BY O.iShipMethod

-- query using 2nd snapshot
DECLARE @StartDate datetime,        @EndDate datetime
SELECT  @StartDate = '02/16/17',    @EndDate = '02/16/17' 

SELECT O.iShipMethod as 'Ship Method',
        SM.sDescription,
	    count (distinct O.ixOrder) as 'Orders Shipped',
	    count(1) as 'Packages Shipped',
	    SUM(dActualWeight) 'ActualWeight'
FROM tblOrder O
	join [SMITemp].dbo.PJC_tblPackageSnapShotFor20170216_taken20170221 P on P.ixOrder = O.ixOrder -- DO NOT USE LEFT JOIN!  WE ONLY WANT TO COUNT ORDERS IF THEY ACTUALLY HAD A PHYSICAL PACKAGE THAT WAS SHIPPED
    left join tblShipMethod SM on SM.ixShipMethod = O.iShipMethod
	--left join tblDate D on D.ixDate = P.ixShipDate  <-- this was requiring a value to be in tblPackage so it was excluding Orders that didn't have packages
	left join tblDate D on D.ixDate = O.ixShippedDate
WHERE D.dtDate between @StartDate and @EndDate
    and O.iShipMethod <> 1  -- excluding counter orders
    and (P.flgCanceled is NULL or P.flgCanceled = 0)
    and  (P.flgReplaced is NULL or P.flgReplaced= 0)
 /* and (P.dActualWeight is NULL       
         OR                         -- add to find only packages without weights
         P.dActualWeight = 0)  
 */         
GROUP BY O.iShipMethod,SM.sDescription
ORDER BY O.iShipMethod

-- IDENTICAL REPORT OUTPUTS!




select * from tblPackage
where ixVerificationDate >= 17899    -- 125,479
and flgCanceled = 1                  --  25,489
and flgReplaced = 0                  -- 654
and ixShipDate is NOT NULL               --  25,477


select * from tblPackage
where ixVerificationDate >= 17899    -- 125,479
and flgReplaced = 1                  --  24,835
and flgCanceled = 1                  --  24,835
and ixShipDate is NULL               --  25,477



SELECT COUNT(*), COUNT(distinct sTrackingNumber)
FROM [SMITemp].dbo.PJC_SMIHD6708_CancelledPkgs
--576	576

SELECT COUNT(*), COUNT(distinct sTrackingNumber)
FROM [SMITemp].dbo.PJC_SMIHD6708_ReplacedPkgs
--22742	22742

SELECT P.sTrackingNumber, P.ixShipDate, P.flgCanceled, P.flgReplaced
FROM tblPackage P
    join [SMITemp].dbo.PJC_SMIHD6708_CancelledPkgs CP on P.sTrackingNumber = CP.sTrackingNumber
order by  P.flgCanceled, P.ixShipDate  

SELECT P.sTrackingNumber, P.ixShipDate, P.flgCanceled, P.flgReplaced
FROM tblPackage P
    join [SMITemp].dbo.PJC_SMIHD6708_ReplacedPkgs CP on P.sTrackingNumber = CP.sTrackingNumber
order by P.ixShipDate  

Cancelled File: All are flagged as cancelled in tblPackage.  
                None of them are flagged as replaced. 
                11 of them have ship dates.
                
Replaced File:  All but 10 are flagged as replaced in tblPackage (every one of those is flagged as cancelled as well.  
                10 of them are NOT flagged as replaced (all 10 are not marked cancelled either)have ship dates.
                None of them have ship dates.
                
                
                
                41,593,491
                
                
SELECT sTrackingNumber FROM tblPackage
where LEN(sTrackingNumber) = 8 -- 330,290
and flgReplaced = 1


Can SOP remove a ship date from a package? I have packages that are missing ship dates and I need to know if they used to have one.
