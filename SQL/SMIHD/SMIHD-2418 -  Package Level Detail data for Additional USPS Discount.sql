-- SMIHD-2418 -  Package Level Detail data for Additional USPS Discount

/*
*File format: .CSV, TXT, Excel

Critical fields needed:
+ Destination ZIP Code
• Actual Weight – Billed Weight
? Current Service Level
+ Origin ZIP Code(s)
• Length, Width, Height measurements by average weight of the packag-ing used (box and or poly indicated)

Send file to Lynn.  If it's over 7MB call Lynn to make other arrangements.

(FTP, CD, DVD, or flash drive).
*Instructions for downloading shipping files vary depending on the shipping system. Technical assistance is available for obtaining your shipping data.

PER CCC: use data from April 2015


*/
/*
select top 10 * from tblPackage where ixShipDate = 17438
                            ixVerification  ixVerification  ixShip  ixShip                                      dBilling    dActual             mPublished  mShipping   ixVerification  ixShipping  ixShip  flg     flg         flg
sTrackingNumber	    ixOrder	Date	        Time	        Date	Time	ixPacker	ixVerifier	ixShipper	Weight	    Weight	ixTrailer	Freight	    Cost	    IP	            IP	        TNT    	Metals	Canceled    Replaced
1Z4315530301112541	6640232	17438	        39117	        17438	53397	MSD47	    5MSR	    5MSR	    2.000	    2.100	EVN	        NULL	    NULL	    172.18.1.242	172.18.1.15	2	    0	    0	        0
*/


select P.dActualWeight
    ,P.sTrackingNumber
    ,O.sShipToZip
    ,SM.sDescription 'Service'
from tblPackage P                                                  
    left join tblOrder O on P.ixOrder = O.ixOrder                   
    left join tblShipMethod SM on O.iShipMethod = SM.ixShipMethod
where P.ixShipDate between 17258 and 17287 --   69,937      + 2,659 for Afco <--April 2015    
    and P.flgCanceled = 0                  --   63,670
    and O.sShipToCountry = 'US'            --   62,861
    and O.iShipMethod NOT IN (1,8)         --   62,657      + 2,391 for AFCO
    
order by O.sShipToCountry



select O.iShipMethod, SM.sDescription, COUNT(P.sTrackingNumber) -- 63,670 packages
from tblPackage P
 left join tblOrder O on P.ixOrder = O.ixOrder                   
    left join tblShipMethod SM on O.iShipMethod = SM.ixShipMethod
where P.ixShipDate between 17258 and 17287 
    and P.flgCanceled = 0    
    and  O.iShipMethod <> 1 
group by O.iShipMethod , SM.sDescription





/************* TESTINGT NEW FIELDS *******************/

select dLength, dWidth, dHeight, (dLength+dWidth+dHeight) 'TotDim',
count(sTrackingNumber) 'PkgCnt'
from tblPackage
where dLength is NOT NULL
    or dWidth is NOT NULL
    or dHeight is NOT NULL
group by dLength, dWidth, dHeight 
order by (dLength+dWidth+dHeight) desc


select * from tblPackage


select count(sTrackingNumber) 'PkgCnt'
from tblPackage
where dLength is NOT NULL
    or dWidth is NOT NULL
    or dHeight is NOT NULL







select P.dActualWeight  -- SMI 60,753 have pkg Dims 1,904 do not   = 3.0% are missing Package Dimensions
    ,P.sTrackingNumber   -- SMI 1,938 have pkg Dims 453 do not   = 18.9% are missing Package Dimensions
    ,P.dLength, P.dWidth, P.dHeight
    ,O.sShipToZip
    ,SM.sDescription 'Service'
    ,P.dtDateLastSOPUpdate
from tblPackage P                                                  
    left join tblOrder O on P.ixOrder = O.ixOrder                   
    left join tblShipMethod SM on O.iShipMethod = SM.ixShipMethod
where P.ixShipDate between 17258 and 17287 --   69,937      + 2,659 for Afco <--April 2015    
    and P.flgCanceled = 0                  --   63,670
    and O.sShipToCountry = 'US'            --   62,861
    and O.iShipMethod NOT IN (1,8)         --   62,657      + 2,391 for AFCO
    AND (dLength is NULL
    or dWidth is NULL
    or dHeight is NULL)


select 
    SM.sDescription 'SERVICE'
    ,'47601' as 'ORIGIN' -- 68528 = lnk     47601 = Boonville
    ,O.sShipToZip 'DESTZIP'    
    ,P.dActualWeight 'ACTUALWT'  -- SMI 60,753 have pkg Dims 1,904 do not   = 3.0% are missing Package Dimensions
    ,P.dLength 'LENGTH'
    ,P.dWidth 'WIDTH'
    ,P.dHeight 'HEIGHT'
    ,P.sTrackingNumber   -- SMI 1,938 have pkg Dims 453 do not   = 18.9% are missing Package Dimensions
from tblPackage P                                                  
    left join tblOrder O on P.ixOrder = O.ixOrder                   
    left join tblShipMethod SM on O.iShipMethod = SM.ixShipMethod
where P.ixShipDate between 17258 and 17287 --   69,937      + 2,659 for Afco <--April 2015    
    and P.flgCanceled = 0                  --   63,670
    and O.sShipToCountry = 'US'            --   62,861
    and O.iShipMethod NOT IN (1,8)         --   62,657      + 2,391 for AFCO
    AND (dLength is NOT NULL
    or dWidth is NOT NULL
    or dHeight is NOT NULL)



select * from tblPackage where sTrackingNumber in ('1Z6353580332330568','1Z6353580332296454','1Z4315530300915882','1Z6353580332285279','1Z6353580332294509','1Z6353580332467019','1Z6353580332527267')


SELECT * From tblOrder where sShipToState = 'IN'
and dtOrderDate >= '10/01/2015'
order by sShipToCity



select sTrackingNumber
from tblPackage P                                                  
    left join tblOrder O on P.ixOrder = O.ixOrder                   
    left join tblShipMethod SM on O.iShipMethod = SM.ixShipMethod
where P.ixShipDate >= 13881
    and P.flgCanceled = 0                  --   63,670
    and O.sShipToCountry = 'US'            --   62,861
    and O.iShipMethod NOT IN (1,8)         --   62,657      + 2,391 for AFCO
    AND (dLength is NULL
    or dWidth is NULL
    or dHeight is NULL)