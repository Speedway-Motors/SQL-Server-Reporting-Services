--SMIHD-20143 - SpeeDee Shipments through Des Moines for Clay


DECLARE @StartDate datetime,        @EndDate datetime,      @Location int
SELECT  @StartDate = '02/09/21',    @EndDate = '02/11/21',  @Location= 99 -- 47, 85, 99

SELECT --O.iShipMethod as 'Ship Method',
        SM.sDescription 'Ship Method',
        P.ixTrailer 'Trailer',
        FORMAT (O.dtShippedDate,'MM/dd/yyyy') 'Shiped',
	    count (distinct (O.ixOrder)) as 'Orders',
	    count(1) as 'Packages',
	    SUM(dActualWeight) 'Actual Weight',
        SUM(CASE WHEN O.flgGuaranteedDeliveryPromised = 0 then 1
            ELSE 0
            END) 'GuaranteedCount'
FROM tblOrder O
	join tblPackage P on P.ixOrder = O.ixOrder -- DO NOT USE LEFT JOIN!  WE ONLY WANT TO COUNT ORDERS IF THEY ACTUALLY HAD A PHYSICAL PACKAGE THAT WAS SHIPPED
    left join tblShipMethod SM on SM.ixShipMethod = O.iShipMethod
	--left join tblDate D on D.ixDate = P.ixShipDate  <-- this was requiring a value to be in tblPackage so it was excluding Orders that didn't have packages
	left join tblDate D on D.ixDate = O.ixShippedDate
WHERE D.dtDate between @StartDate and @EndDate
    and O.iShipMethod <> 1  -- excluding counter orders
    and (P.flgCanceled is NULL or P.flgCanceled = 0)
    and  (P.flgReplaced is NULL or P.flgReplaced= 0)
    and O.ixPrimaryShipLocation IN (@Location)
    and O.iShipMethod = 9
    and P.ixTrailer = 'DSM'
 /* and (P.dActualWeight is NULL       
         OR                         -- add to find only packages without weights
         P.dActualWeight = 0)  
 */         
GROUP BY O.iShipMethod,SM.sDescription, P.ixTrailer, O.dtShippedDate
ORDER BY O.dtShippedDate




DECLARE @StartDate datetime,        @EndDate datetime,      @Location int
SELECT  @StartDate = '02/09/21',    @EndDate = '02/11/21',  @Location= 99 -- 47, 85, 99

SELECT --O.iShipMethod as 'Ship Method',
    DISTINCT 
    O.ixOrder,
    O.ixCustomer,
    O.sShipToZip,
        SM.sDescription 'Ship Method',
        P.ixTrailer 'Trailer',
    O.flgGuaranteedDeliveryPromised, ixGuaranteeDelivery, dtGuaranteedDelivery, O.mMerchandise, O.mShipping, O.sOrderStatus
FROM tblOrder O
	join tblPackage P on P.ixOrder = O.ixOrder -- DO NOT USE LEFT JOIN!  WE ONLY WANT TO COUNT ORDERS IF THEY ACTUALLY HAD A PHYSICAL PACKAGE THAT WAS SHIPPED
    left join tblShipMethod SM on SM.ixShipMethod = O.iShipMethod
	--left join tblDate D on D.ixDate = P.ixShipDate  <-- this was requiring a value to be in tblPackage so it was excluding Orders that didn't have packages
	left join tblDate D on D.ixDate = O.ixShippedDate
WHERE D.dtDate between @StartDate and @EndDate
    and O.iShipMethod <> 1  -- excluding counter orders
    and (P.flgCanceled is NULL or P.flgCanceled = 0)
    and  (P.flgReplaced is NULL or P.flgReplaced= 0)
    and O.ixPrimaryShipLocation IN (@Location)
    and O.iShipMethod = 9
    and P.ixTrailer = 'DSM'