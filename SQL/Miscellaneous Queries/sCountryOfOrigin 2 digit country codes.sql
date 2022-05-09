-- sCountryOfOrigin 2 digit country codes

SELECT sCountryOfOrigin, COUNT(*) SKUs -- 11,400 are 2 chars long
from tblSKU
Where flgDeletedFromSOP = 0
group by sCountryOfOrigin
order by LEN(sCountryOfOrigin), sCountryOfOrigin
/*
AR	78
AU	4
BR	10
CA	143
CH	48
CN	17353
CZ	68
DE	20
ES	2
GB	969
HR	105
ID	30
IN	169
IT	75
JP	111
KR	111
MX	86
PH	8
SG	2
TH	4
TN	44
TW	1406
US	294730
*/

select * from tblSKU
where ixSKU in ('UP67846','465332765')

/**********  SMI *********/
    SELECT sCountryOfOrigin,ixSKU
    from tblSKU
    where flgDeletedFromSOP = 0
        --and sCountryOfOrigin is NULL
        and dtDateLastSOPUpdate < '07/25/2016' -- 4,444        6K max               1,674 took @925 Sec according to SOP         
    /*                                       ETA  2:30 PM
            start@ 14:50:55                         44-49
            end@     :        ETA 15:17

            Tot sec 3,748
            Rec/Sec = 1.7-4.5
    */



SELECT COUNT(*) SKUs, sCountryOfOrigin -- 11,400 are 2 chars long
from tblSKU
where flgDeletedFromSOP = 0
AND sCountryOfOrigin is NULL --121,934 @8-15-16 12:18pm
group by sCountryOfOrigin
order by LEN(sCountryOfOrigin), sCountryOfOrigin


    
/**********  AFCO *********/
    SELECT ixSKU
    from [AFCOReporting].dbo.tblSKU
    where flgDeletedFromSOP = 0
        and len(sCountryOfOrigin) > 2 

        and dtDateLastSOPUpdate > '08/01/2016' -- 4,194              
    /*
            start@ 10:50:08  
            end@   11:30:28           ETA 11:05

            Tot sec 2,398
            Rec/Sec = 1.7-4.5
    */    


SELECT COUNT(*) SKUs, sCountryOfOrigin -- 11,400 are 2 chars long
from [AFCOReporting].dbo.tblSKU
where flgDeletedFromSOP = 0
group by sCountryOfOrigin
order by LEN(sCountryOfOrigin), sCountryOfOrigin

select ixOrder,sWebOrderID, sOrderChannel, sSourceCodeGiven  from tblOrder where sWebOrderID like 'CA%'


select * from tblDropship
where mShippingCharge > 0
order by dtActualShipDate desc


select * from tblDropship where ixOrder = '6375680'
GO
select ixOrder,ixCustomer,ixSKU,iQuantity,mUnitPrice,mExtendedPrice,flgLineStatus,dtOrderDate,dtShippedDate,mCost,mExtendedCost,flgKitComponent,iOrdinality,iKitOrdinality,,mSystemUnitPrice,mExtendedSystemPrice,ixPriceDevianceReasonCode,sPriceDevianceReason,ixPicker,sTrackingNumber,iMispullQuantity,dtDateLastSOPUpdate,ixTimeLastSOPUpdate,flgOverride
from tblOrderLine where ixOrder = '6375680'
GO
select * from tblOrder where ixOrder = '6375680'

select COUNT(*) from tblDropship -- 44534

SELECT DS.*
from tblDropship DS 
join tblOrder O on O.ixOrder = DS.ixOrder



    SELECT *
    from tblSKU
    where flgDeletedFromSOP = 0
        and dtDateLastSOPUpdate < '08/11/2016' -- changes were deployed 8/10... all SKUs need to be updated 8/11 or later.
        
        
select * from vwDataFreshness where sTableName = 'tblSKU'        
/*
sTableName	Records	DaysOld
tblSKU	77481	   <=1
tblSKU	162794	   2-7
tblSKU	75118	  8-30
*/
select * from vwDataFreshness where sTableName = 'tblCustomer'  
sTableName	Records	DaysOld
tblCustomer	3901	   <=1
tblCustomer	10659	   2-7
tblCustomer	29390	  8-30
tblCustomer	323185	 31-180
tblCustomer	1434751	181 +



-- SELECT COUNT(*)
SELECT ixCustomer, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
from tblCustomer
where flgDeletedFromSOP = 0
    and dtDateLastSOPUpdate = '10/20/2015'
    and ixTimeLastSOPUpdate <= 60100
order by dtDateLastSOPUpdate, ixTimeLastSOPUpdate -- 50701-51100     23,834


select ixCustomer, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
FROM tblCustomer
where ixCustomer in ('644865','644866','644867','644873','644874','644876','644870','644881','644882','644883','644884','644886','644896','644898','644901','644904','644908','644911','644915')
order by dtDateLastSOPUpdate, ixTimeLastSOPUpdate, ixCustomer 

