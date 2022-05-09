-- SMIHD-24051 - Add fields to Receivers Closed and not Posted report

-- Receivers - Closed and not Posted
-- ver 22.7.1
SELECT ST.ixReceiver 'Receiver', 
    CONVERT(VARCHAR, D.dtDate, 101) 'OnDockDate',
    SUBSTRING(T.chTime,1,5) 'OnDockTime', 
    -- between current timestamp and timestamp on dock)
    ((DATEDIFF(HH,Getdate(),(D.dtDate+T.chTime))*-1)/24.0) 'DaysDelay', -- determining the total hour dif first then converting to days       
	ST.iQty 'QTY',
    ST.ixSKU 'SKU', 
    ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription',
    --sToLocation,	sWarehouse,	sToWarehouse,	sToBin,sToCID,sToGID,sGID,flgBinScanned,ST.ixJob, sTransactionInfo, -- = Receiver+'*'+PO
    ST.sCID 'CID',	
    POM.sPaymentTerms 'PmtTerms',
    SUBSTRING(sTransactionInfo, 8, 10) 'PO',
    POM.ixVendor,			
    V.sName 'VendorName',
    ST.sBin 'Bin',
	D2.dtDate 'DueDate',
	SL.sPickingBin 'PickBin',
	P.sortpriority 'SortPriority',
    (case when sortpriority = '1' then 'Hot'
         when sortpriority = '2' then 'Warm'
         else 'Cold'
    end)'Priority'
FROM tblSKUTransaction ST
    LEFT JOIN tblPOMaster POM on SUBSTRING(sTransactionInfo, 8, 5) = POM.ixPO COLLATE SQL_Latin1_General_CP1_CI_AS
		LEFT JOIN tblPODetail POD on POM.ixPO = POD.ixPO
								  and POD.ixSKU = ST.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS

    LEFT JOIN tblVendor V on POM.ixVendor = V.ixVendor
    LEFT JOIN tblSKU S on S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = ST.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
    LEFT JOIN tblReceiver R on ST.ixReceiver COLLATE SQL_Latin1_General_CP1_CI_AS = R.ixReceiver COLLATE SQL_Latin1_General_CP1_CI_AS
    LEFT JOIN tblDate D on R.ixOnDockDate = D.ixDate
	LEFT JOIN tblDate D2 on POD.ixExpectedDeliveryDate = D2.ixDate
    LEFT JOIN tblTime T on R.ixOnDockTime = T.ixTime
	LEFT JOIN tblSKULocation SL on SL.ixSKU = POD.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
								and SL.ixLocation = 99 -- WILL NEED TO CHANGE TO   and SL.ixLocation = POM.ixLocation once that field is added to POM
    LEFT JOIN (-- Priority
				SELECT R.ixReceiver,
                min(case when SKU.iQAV < 0 and POD.iQuantity > POD.iQuantityPosted then 1
                         when SKU.iQAV = 0 and POD.iQuantity > POD.iQuantityPosted then 2
                         else 3
                    end) sortpriority
                FROM tblReceiver R 
                    left join tblPODetail POD on POD.ixPO = R.ixPO
                    left join vwSKULocalLocation SKU on SKU.ixSKU = POD.ixSKU
                WHERE R.flgStatus IN ('Open', 'Closed')
                GROUP BY  R.ixReceiver
                ) P on P.ixReceiver = R.ixReceiver
WHERE R.flgStatus = 'Closed'
    AND R.flgDeletedFromSOP = 0
-- AND R.ixReceiver = '360143'
ORDER BY POM.sPaymentTerms, POM.ixPO, ST.ixReceiver, ST.ixSKU, ST.sCID
/*
select * from
tblReceiver
where ixReceiver = '360143'

select * from
tblPOMaster POM where ixPO = '62448'

select * from tblSKUTransaction
where SUBSTRING(sTransactionInfo, 8, 5) = '62448'

select * from tblSKUTransaction
where sToCID = '4453366'

select * from tblSKU where ixSKU = '1020'

select * from tblSKUTransaction
where ixSKU = '1020'
order by ixDate desc

select * from tblPODetail
where ixPO = '62626#2'

select * from tblSKULocation
where ixSKU = '1020'

select distinct ixLocation 
from tblSKULocation
*/



