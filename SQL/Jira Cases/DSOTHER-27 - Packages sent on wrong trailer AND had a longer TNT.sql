-- DSOTHER-27 - Packages sent on wrong trailer AND had a longer TNT

SELECT top 10 * from tblOrderRouting order by NEWID()
/*
ixOrder	sDropRecord	ixCommitmentDate	ixCommitmentTime	ixCommitmentPrimaryTrailer	ixCommitmentSecondaryTrailer	iCommitmentBestTNT	ixCommitmentDeliveryDate	ixAvailablePrintDate	ixAvailablePrintTime	ixAvailablePrintPrimaryTrailer	ixAvailablePrintSecondaryTrailer	iAvailablePrintBestTNT	ixAvailablePrintDeliveryDate	ixPrintDate	ixPrintTime	ixPrintPrimaryTrailer	ixPrintSecondaryTrailer	iPrintBestTNT	ixPrintDeliveryDate	ixVerifyDate	ixVerifyTime	ixVerifyPrimaryTrailer	ixVerifySecondaryTrailer	iVerifyBestTNT	ixVerifyDeliveryDate	dtDateLastSOPUpdate	ixTimeLastSOPUpdate
4354371	UPS.DROP	16227	            54056	            OMH	                        NULL	                        99	                16227	                    16227	                56291	                OMH	                            NULL	                            99	                    16227	                        16227	    57584	    KC	                    OMH	                    NULL	        NULL	            16227	        61704	        OMH	                    OMN	                        NULL	        NULL	                NULL	            NULL


ixOrder, sDropRecord, ixCommitmentDate, ixCommitmentTime, , iCommitmentBestTNT, ixCommitmentDeliveryDate, ixAvailablePrintDate, ixAvailablePrintTime, , , iAvailablePrintBestTNT, ixAvailablePrintDeliveryDate, ixPrintDate, ixPrintTime, ixPrintPrimaryTrailer, ixPrintSecondaryTrailer, iPrintBestTNT, ixPrintDeliveryDate, ixVerifyDate, ixVerifyTime, ixVerifyPrimaryTrailer, ixVerifySecondaryTrailer, iVerifyBestTNT, ixVerifyDeliveryDate, dtDateLastSOPUpdate, ixTimeLastSOPUpdate

ixCommitmentPrimaryTrailer
ixCommitmentSecondaryTrailer
ixAvailablePrintPrimaryTrailer
ixAvailablePrintSecondaryTrailer
*/

SELECT top 10 * from tblPackage order by NEWID()
/*
sTrackingNumber	ixOrder	ixVerificationDate	ixVerificationTime	ixShipDate	ixShipTime	ixPacker	ixVerifier	ixShipper	dBillingWeight	dActualWeight	ixTrailer	mPublishedFreight	mShippingCost	ixVerificationIP	ixShippingIP	dtDateLastSOPUpdate	ixTimeLastSOPUpdate
319320270147720	4591254	16110	            32984	            16110	    35103	    CLB1	    AMP	        SAH	        8.000	        11.400	        LNF	        NULL	            NULL	        NULL	            NULL	        NULL	            NULL
*/


SELECT top 10 * from tblPackage where ixVerificationDate >= 16923 order by NEWID()
/*
sTrackingNumber	        ixOrder	ixVerificationDate	ixVerificationTime	ixShipDate	ixShipTime	ixPacker	ixVerifier	ixShipper	ixTrailer	mPublishedFreight	mShippingCost	ixVerificationIP	ixShippingIP	dtDateLastSOPUpdate	ixTimeLastSOPUpdate
9405510200828186787784	5659064	16936	            58707	            16936	    60821	    ABF	        EJP2	    SAT	        NULL	    NULL	            NULL	        192.168.240.35	    192.168.240.36	2014-05-14          60745
*/


SELECT top 10 * from tblTrailerZipTNT  order by NEWID()
/*
ixKey	ixZipCode	ixTrailer	iTNT	iOrdinality	dtDateLastSOPUpdate	ixTimeLastSOPUpdate
OMN*49629	49629	OMN	3	2	2014-03-14 00:00:00.000	NULL
*/



select O.ixOrder, O.iShipMethod, 
    SM.sDescription 'MoS',
    ORT.ixAvailablePrintPrimaryTrailer 'ORTPrintTNT',
    TZ1.ixTrailer 'PrintTrailer', TZ1.iTNT 'TZ1PrintTNT', 
    TZ2.ixTrailer 'ShippedTrailer', TZ2.iTNT 'ShippedTNT' -- Based on package
FROM tblOrder O
    left join tblPackage P on O.ixOrder = P.ixOrder   
    left join tblOrderRouting ORT on O.ixOrder = ORT.ixOrder
    left join tblShipMethod SM on O.iShipMethod = SM.ixShipMethod
    left join tblTrailerZipTNT TZ1 on TZ1.ixZipCode = O.sShipToZip and TZ1.iOrdinality = 1
    left join tblTrailerZipTNT TZ2 on TZ2.ixTrailer = P.ixTrailer    
    
    
select ixOrder, iShipMethod, iAvailablePrintBestTNT
from tblOrder
where sOrderStatus = 'Shipped'
and dtShippedDate >= '05/01/2014'    
 
 


 
ixShipTime
ixShipDate
ixShipTrailer 
ixShipTNT
 
    
    
select * from tblOrderTNT    
    
select COUNT(*) from tblPackage
where   ixVerificationDate >= 16923  -- 30,474

  
SELECT ixShipTNT, COUNT(*)
from tblPackage
where ixVerificationDate >= 16923    