-- SMIHD-15166 - Discontinued SKUs that do not have the correct Primary Vendor




-- SKUs with a past discontinued date that do not have PV of 9999 or 0999
select VS.ixVendor 'PrimaryVendor', FORMAT(COUNT(distinct S.ixSKU),'###,###') 'DiscontinuedSKUs'
from tblSKU S
    left join tblVendorSKU VS on VS.ixSKU = S.ixSKU and VS.iOrdinality = 1
where S.flgDeletedFromSOP = 0
    and S.dtDiscontinuedDate <= getdate()
    and VS.ixVendor NOT IN ('9999','0999')
group by VS.ixVendor
order by COUNT(distinct S.ixSKU) desc
/*      Discontinued
PV	    SKUs
0219	296
0119	46
0005	18
0010	16
0019	10
*/

2,176 for 0009 (GS)
   79 for 0106 (AFCO RACING)

select * from tblVendor where ixVendor in ('6298','5566','7892','6076','5302','9000','5181','5115','5320','5316','5000','5041','5025','5105','7477','5346','7712','7525','5148','5026','6133','5725','5133','5567','5534','5002','7157','5064','5537','6125','5117','7860','5033','5034')  --('0219','0119','0005','0010','0019','0013','0040','0003', '0008','0007','0006','0055','0044','0315','0215','0140')
select * from tblVendor where ixVendor = '0106'



select VS.ixVendor 'PrimaryVendor', S.ixSKU 
 -- FORMAT(COUNT(distinct S.ixSKU),'###,###') 'DiscontinuedSKUs'
from tblSKU S
    left join tblVendorSKU VS on VS.ixSKU = S.ixSKU and VS.iOrdinality = 1
where S.flgDeletedFromSOP = 0
    and S.dtDiscontinuedDate <= getdate()

    select VS.ixVendor 'PrimaryVendor', FORMAT(COUNT(distinct S.ixSKU),'###,###') 'SKUCnt'
from tblSKU S
    left join tblVendorSKU VS on VS.ixSKU = S.ixSKU and VS.iOrdinality = 1
where S.flgDeletedFromSOP = 0
    and VS.ixVendor IN ('9999','0999')
GROUP BY VS.ixVendor
order by COUNT(distinct S.ixSKU) desc


-- AFCO
SELECT S.ixSKU, S.dtDiscontinuedDate -- 14,683 @11:22   9,579  4.25 rec/sec          ETA 2:30
FROM [AFCOReporting].dbo.tblSKU S    --  9,202 @11:52
    left join [AFCOReporting].dbo.tblVendorSKU VS on VS.ixSKU = S.ixSKU and VS.iOrdinality = 1
WHERE flgDeletedFromSOP = 0
    and dtDiscontinuedDate <= GETDATE() -- today
    and VS.ixVendor NOT IN ('9999','0999')


SELECT T.ixSKU, VS.ixVendor 'PV'
FROM [SMITemp].dbo.PJC_TEMP_AFCODiscontinuedSKUs T
    left join [AFCOReporting].dbo.tblVendorSKU VS on VS.ixSKU = T.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS and VS.iOrdinality = 1
WHERE VS.ixVendor NOT IN ('9999')




-- SMI discontinued dates in the past but not assigned to 9999 or 0999
SELECT S.ixSKU, S.dtDiscontinuedDate, VS.ixVendor 'PV', V.sName 'PVName', S.dtDateLastSOPUpdate -- 77,712
FROM tblSKU S
    left join tblVendorSKU VS on VS.ixSKU = S.ixSKU and VS.iOrdinality = 1
    left join tblVendor V on V.ixVendor = VS.ixVendor
WHERE flgDeletedFromSOP = 0
    and dtDiscontinuedDate <= GETDATE() -- today
    and VS.ixVendor NOT IN ('9999','0999')
ORDER BY newid() -- S.dtDateLastSOPUpdate


select * from tblSKULocation
where ixLocation <> 99

BEGIN TRAN

DELETE FROM tblSKULocation WHERE ixLocation = 46

ROLLBACK TRAN


select * from [AFCOReporting].dbo.tblLocation


select ixLocation, FORMAT(count(ixSKU),'###,###') 'SKUCnt'
from [AFCOReporting].dbo.tblSKULocation
group by ixLocation


select O.iShipMethod, P.* -- count(sTrackingNumber)
from tblPackage P
    left join tblOrder O on P.ixOrder = O.ixOrder
where ixShipDate between 18865 and 18895
and flgCanceled = 0
and flgReplaced = 0

order by O.iShipMethod

and dActualWeight = 0
and dActualWeight is NOT NULL
and dActualWeight <> 0


3,214 Total Packages shipped past 30 days from AFCO
2,182 (67.9%) had a scale weight > 0
   46 (1.4%) had a scale weight = 0




select * from tblSKULocai


select * from tblSKU where dtDiscontinuedDate between  '09/27/2019' and '09/30/2019'



-- SKUs scheduled to be discontinued in the near future
select S.ixSKU 'SKU', VS.ixVendor 'PrimaryVendor', 
    S.ixMerchant 'Merchant', SL.iQOS 'QtyOnHand', 
    FORMAT(S.dtDiscontinuedDate,'MM/dd/yy') 'Discontinued', 
    FORMAT(LS.LastSold,'MM/dd/yy') 'LastSold'   --S.dtDateLastSOPUpdate -- 488
from tblSKU S
    left join tblVendorSKU VS on VS.ixSKU = S.ixSKU and VS.iOrdinality = 1
    left join tblSKULocation SL on SL.ixSKU = VS.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS and ixLocation = 99
    LEFT JOIN (-- LAST SOLD
        SELECT OL.ixSKU
                ,MAX(dtOrderDate) 'LastSold'
        FROM tblOrderLine OL 
                left join tblDate D on D.dtDate = OL.dtOrderDate 
        WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
        GROUP BY OL.ixSKU
        ) LS on LS.ixSKU = S.ixSKU
where S.flgDeletedFromSOP = 0
    and dtDiscontinuedDate between '09/27/2019' and '12/31/2019'
    and VS.ixVendor NOT IN ('9999','0999')
order by dtDiscontinuedDate, VS.ixVendor, S.ixSKU



-- 1) SKUs with a past discontinued date that do not have PV of 9999 or 0999 -- 8,061
SELECT
    VS.ixVendor 'PrimaryVendor', S.ixSKU,
    SL.iQOS 'QtyOnHand',  SL.sPickingBin, 
    S.ixMerchant 'Merchant',
    S.dtDiscontinuedDate, --FORMAT(S.dtDiscontinuedDate,'MM/dd/yy') 'Discontinued', 
    FORMAT(LS.LastSold,'MM/dd/yy') 'LastSold'
   -- FORMAT(S.dtDateLastSOPUpdate,'MM/dd/yy') 'LastSOPUpdate' 
FROM tblSKU S
    LEFT JOIN tblVendorSKU VS on VS.ixSKU = S.ixSKU and VS.iOrdinality = 1
    LEFT JOIN tblSKULocation SL on SL.ixSKU = VS.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS and ixLocation = 99
    LEFT JOIN (-- LAST SOLD
                SELECT OL.ixSKU
                        ,MAX(dtOrderDate) 'LastSold'
                FROM tblOrderLine OL 
                        left join tblDate D on D.dtDate = OL.dtOrderDate 
                WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
                GROUP BY OL.ixSKU
                ) LS on LS.ixSKU = S.ixSKU
WHERE S.flgDeletedFromSOP = 0
    AND S.dtDiscontinuedDate <= getdate() --between @StartDate and @EndDate -- <= getdate()
    and  VS.ixVendor NOT IN ('9999','0999')
--ORDER BY S.ixMerchant --S.dtDateLastSOPUpdate -- LS.LastSold, S.dtDiscontinuedDate desc --VS.ixVendor  --S.dtDiscontinuedDate



-- 4) Discontinued PV but future discontinued date
select     
    S.ixVendor 'PrimaryVendor', S.ixSKU,
    SL.iQOS 'QtyOnHand',  SL.sPickingBin, 
    S.ixMerchant 'Merchant',
    S.dtDiscontinuedDate, --FORMAT(S.dtDiscontinuedDate,'MM/dd/yy') 'Discontinued', 
    FORMAT(LS.LastSold,'MM/dd/yy') 'LastSold'
            'Y' as 'FutureDisconuedDate' -- 948
from tblSKU S
    left join tblVendorSKU VS on VS.ixSKU = S.ixSKU and VS.iOrdinality = 1
where S.flgDeletedFromSOP = 0
    and VS.ixVendor IN ('9999','0999')
    and dtDiscontinuedDate > getdate()
order by S.dtDiscontinuedDate desc


select *
from tblSKULocation where ixSKU like '123%'