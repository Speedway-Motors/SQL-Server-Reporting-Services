-- SMIHD-15758 - Packages per Kit Report
select S.ixSKU, SALES.QtySold12Mo, S.flgShipAloneStatus
INTO #MostActiveKits -- drop table #MostActiveKits
from tblSKU S
    LEFT JOIN tblSKULocation SL on S.ixSKU = SL.ixSKU and SL.ixLocation = 99
    LEFT JOIN (-- SALEABLE SKUs
                SELECT DISTINCT t.ixSOPSKU AS 'ixSOPSKU', t1.ixSOPSKUBase 'SOPSKUBase', t.ixSKUBase 'SKUBase'  -- 168,191 SKUs
                FROM TngRawData.tngLive.tblskuvariant t
                    INNER JOIN TngRawData.tngLive.tblskubase t1 ON t.ixSKUBase = t1.ixSKUBase
                    INNER JOIN TngRawData.tngLive.tblproductpageskubase t2 ON t1.ixSKUBase = t2.ixSKUBase
                    INNER JOIN TngRawData.tngLive.tblproductpage t3 ON t2.ixProductPage = t3.ixProductPage
                WHERE t.ixSOPSKU is NOT NULL
                    AND t.flgPublish = 1
                    AND t1.flgWebPublish = 1
                    AND t3.flgActive = 1
                    AND(t.iTotalQAV > 0 
                        OR t.flgBackorderable = 1)
               ) SS on SS.ixSOPSKU = S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS  --17,287
    LEFT JOIN (-- 12 Mo SALES & QTY SOLD
                SELECT OL.ixSKU,SUM(OL.iQuantity) AS 'QtySold12Mo', 
                    SUM(OL.mExtendedPrice) 'Sales12Mo', SUM(OL.mExtendedCost) 'CoGS12Mo'
                FROM tblOrderLine OL 
                    left join tblDate D on D.dtDate = OL.dtOrderDate 
                WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
                    and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
                GROUP BY OL.ixSKU
                ) SALES on SALES.ixSKU = S.ixSKU  
where S.flgDeletedFromSOP = 0
    and S.flgActive = 1
    and S.flgIsKit = 1 -- 24,148
    and SS.ixSOPSKU is NOT NULL -- Salable SKU  21,032
    and SALES.QtySold12Mo > 1 -- 189 @100+ 12MoQtySold      375 @50+ 12MoQtySold     1,090 @10+ 12MoQtySold     2,347 @1+ 12MoQtySold

select top 10 * from #MostActiveKits
order by QtySold12Mo desc
/*          Qty
ixSKU	    Sold12Mo
========    ========
91013824	1724
91632504	1133
91632501	716
91013822	669
91013832	604
91025617	580
91012800	568
91083110	563
91005999	542
91015460	532
*/




select * from tblOrderLine where ixSKU = '91013824'

select * from tblOrderLine where ixOrder = '4036305'


select * from tblKit
where ixKitSKU = '91013824'





SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = N'tblSKU'


select * from #MostActiveKits
order by flgShipAloneStatus


