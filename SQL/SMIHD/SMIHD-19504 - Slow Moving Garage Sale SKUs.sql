-- Slow Moving Garage Sale SKUs.rdl -- SMIHD-19504
-- ver 21.3.1
SELECT SS.SOPSKUBase 'SKUBase',
       S.ixSKU 'SKUVariant',   -- 4,554
       S.sSEMAPart 'PartType',
       S.sWebDescription 'Web Catalog Title', -- (aka Web Description)',
       S.mPriceLevel1 'Retail',
       S.dtCreateDate 'ItemCreationDate',
       VS.ixVendor 'PVNumber',
       (ISNULL(TMS.Qty,0) - ISNULL(TMR.Qty,0)) 'Adj12MoQtySold',
       SKUM.iQAV 'TotQAV',
       S.sHandlingCode,
       SB.dtDateFirstMadeWebActiveUtc as 'SKUBaseFirstMadeWebActive',
--sImageName (currently in tng.[tblskubaseimage])
       S.dtDiscontinuedDate 'DiscontinuedDate'
FROM tblSKU S
    left join (-- Total QAV all Locations
               select SKU.ixSKU,
                    SUM(SL.iQAV) 'iQAV'    -- Qty available = iQOS - iQC - iQCB - iQCBOM - iQCXFER
               from tblSKU SKU
                  join tblSKULocation SL on SKU.ixSKU = SL.ixSKU-- COLLATE SQL_Latin1_General_CP1_CI_AS
               where SKU.flgDeletedFromSOP = 0   
               group by SKU.ixSKU
               ) SKUM on SKUM.ixSKU = S.ixSKU
    left join tblProductLifeCycle PLC on PLC.ixProductLifeCycleCode = S.ixProductLifeCycleCode
    left join tblBrand B on S.ixBrand = B.ixBrand
    left join tblProductLine PL on S.ixProductLine = PL.ixProductLine
    left join tblVendorSKU VS on VS.ixSKU = S.ixSKU and VS.iOrdinality = 1
    left join tng.tblskuvariant SV on SV.ixSOPSKU = S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
    left join tng.tblskubase SB on SB.ixSKUBase = SV.ixSKUBase -- SB.dtDateFirstMadeWebActiveUtc
    --left join tng.tblskubaseimage SBI on SBI.ixSKUBase = SV.ixSKUBase
    left join (-- SALEABLE SKUs
                SELECT DISTINCT t.ixSOPSKU AS 'ixSOPSKU', t1.ixSOPSKUBase 'SOPSKUBase', t.ixSKUBase 'SKUBase'  -- 148,970 SKUs @40 seconds
                FROM tng.tblskuvariant t  -- IF RUNNING DIRECTLY ON DW REMOVE ->  
                    INNER JOIN tng.tblskubase t1 ON t.ixSKUBase = t1.ixSKUBase
                    INNER JOIN tng.tblproductpageskubase t2 ON t1.ixSKUBase = t2.ixSKUBase
                --     INNER JOIN tng.tblproductpage t3 ON t2.ixProductPage = t3.ixProductPage
                WHERE t.ixSOPSKU is NOT NULL
                    AND t.flgPublish = 1
                    AND t1.flgWebPublish = 1
                    -- AND t3.flgActive = 1   replaced with t1.flgWebActive = 1 check per SMIHD-17893
                    AND t1.flgWebActive = 1  
                    AND(t.iTotalQAV > 0 
                        OR t.flgBackorderable = 1)
               ) SS ON S.ixSKU = SS.ixSOPSKU COLLATE SQL_Latin1_General_CP1_CI_AS
        left join (--Twelve Month Sales 
                   SELECT OL.ixSKU AS SKU 
					    , Qty.Qty AS Qty
					    , SUM(ISNULL(OL.mExtendedPrice,0)) AS Sales 
						, SUM(ISNULL(OL.mExtendedPrice,0)) - SUM(ISNULL(OL.mExtendedCost,0)) AS GP 
				   FROM tblOrderLine OL  
			       LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder 
				   LEFT JOIN (SELECT OL.ixSKU AS SKU
								   , SUM(ISNULL(OL.iQuantity,0)) AS Qty 
							  FROM tblOrderLine OL
							  LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder  
							  WHERE O.dtOrderDate BETWEEN DATEADD(mm,-12,GETDATE()) AND GETDATE() 
							    AND O.sOrderStatus = 'Shipped' 
								AND O.sOrderType <> 'Internal' 
								AND O.mMerchandise > 0 
								AND O.ixOrder NOT LIKE '%-%' 
							  GROUP BY OL.ixSKU 
					         ) Qty ON Qty.SKU = OL.ixSKU 
				   WHERE O.dtOrderDate BETWEEN DATEADD(mm,-12,GETDATE()) AND GETDATE() 
					 AND O.sOrderStatus = 'Shipped' 
					 AND O.sOrderType <> 'Internal' 
					 AND O.mMerchandise > 0 
				   GROUP BY OL.ixSKU
						  , Qty.Qty
                  ) TMS ON TMS.SKU = S.ixSKU   
        left join (--Twelve Month Returns 
                   SELECT ixSKU AS SKU 
						, SUM(ISNULL(iQuantityReturned,0)) AS Qty
						, SUM(ISNULL(mExtendedPrice,0)) AS Sales
						, SUM(ISNULL(mExtendedCost,0)) AS Cost 
						, SUM(ISNULL(mExtendedPrice,0)) - SUM(ISNULL(mExtendedCost,0)) AS GP 
				   FROM tblCreditMemoDetail CMD 
				   LEFT JOIN tblCreditMemoMaster CMM ON CMM.ixCreditMemo = CMD.ixCreditMemo 
				   WHERE CMM.flgCanceled = '0'
					 and CMM.dtCreateDate BETWEEN DATEADD(mm,-12,GETDATE()) AND GETDATE()
				   GROUP BY ixSKU            
                  ) TMR ON TMR.SKU = S.ixSKU 
WHERE S.flgDeletedFromSOP = 0
   and SS.ixSOPSKU is NOT NULL -- in the saleable SKU sub-query
   and VS.ixVendor = '0009'
   and S.flgBackorderAccepted = 0
   and SKUM.iQAV > 0
   and SV.flgFactoryShip = 0
   and (S.sHandlingCode is NULL
        OR S.sHandlingCode <> 'TR')
   and SV.ixSKUBase in (select ixSKUBase 
                        from tng.tblskubaseimage sbi 
                        where iImageSizeNumber = 0)
   -- and (S.dtCreateDate is NULL or dtCreateDate < '01/11/2019') -- 3,364
   -- and TMS.Qty < 10
ORDER BY S.dtCreateDate




select ixSOPSKU, iTotalQAV
from tng.tblskuvariant
where iTotalQAV between 101 and 499 -- 91031058	482

select SL.ixSKU, SL.iQAV, SL.ixLocation, SV.iTotalQAV 'SVTotalQAV'
into #TempQAVcheck
from tblSKULocation SL
    join tng.tblskuvariant SV on SV.ixSOPSKU = SL.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
where SL.iQAV > 0
    OR SV.iTotalQAV > 0 
order by SL.ixSKU, SL.ixLocation desc

select ixSKU, SVTotalQAV, SUM(iQAV) 'SLQAV'
from #TempQAVcheck
group by ixSKU, SVTotalQAV -- 152k SKUs
having SVTotalQAV <> SUM(iQAV) -- 101k QAV doesn't match... of those tblSKULocation shows 0 QAV for 92k SKUs
order by SLQAV

select iImageSizeNumber from tng.tblskuvariant where flgFactoryShip = 1

 select * from tng.tblskubaseimage sbi where iImageSizeNumber = 0



select sHandlingCode, count(*)
from tblSKU
where flgDeletedFromSOP = 0
group by sHandlingCode
-- TR	3645

[11:12 AM] Ronald M. Desimone
  select * from tng.tblskuvariant s where sShippingCode = 'TR'


For flgIncurLargePackageSurcharge:
select top 20 s.ixSOPSKU from tng.tblskuvariant s
inner join tng.tblsaveshippingquote_itemtype ssqi on s.ixSaveShippingQuoteItemType = ssqi.ixSaveShippingQuoteItemType
inner join tng.tblsaveshippingquote ssq on ssq.ixSaveShippingQuoteItemType = ssqi.ixSaveShippingQuoteItemType
where flgIncurLargePackageSurcharge = 1


select * from tblSKU
where dtCreateDate is NULL
and flgActive = 1



SELECT SKU.ixSKU, 
    TNG.ixSOPSKUBase,
    TNG.dtDateFirstMadeWebActiveUtc as 'dtSKUBaseFirstMadeWebActive',
    SKU.dtCreateDate
FROM tblSKU SKU        -- 336,890
    left join openquery([TNGREADREPLICA], '
                SELECT -- 326,574
                  SV.ixSOPSKU,
                  SB.ixSOPSKUBase,
                  SB.dtDateFirstMadeWebActiveUtc
                from tblskuvariant SV
                    left join tblskubase SB ON SV.ixSKUBase = SB.ixSKUBase
               ') TNG on TNG.ixSOPSKU COLLATE SQL_Latin1_General_CP1_CI_AS = SKU.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE SKU.flgDeletedFromSOP = 0 -- 326,557
    and SKU.flgActive = 1           -- 227,795
    and SKU.flgIntangible = 0       -- 222,730



    select WSB.ixSOPSku 'SOPSKU', WSB.sBrandName 'Brand', WSB.PreviousBrandName,
    WSB.dtStartEffectiveDate 'BrandEffectiveDate',
    SS.SKUBaseFirstMadeWebActive
from vwSkuVariantWebSnapshotBrand WSB
    LEFT JOIN (-- SALEABLE SKUs
               SELECT DISTINCT t.ixSOPSKU AS 'ixSOPSKU', t1.ixSOPSKUBase 'SOPSKUBase', t.ixSKUBase 'SKUBase', 
                    FORMAT((t1.dtDateFirstMadeWebActiveUtc AT TIME ZONE 'UTC'  AT TIME ZONE 'Central Standard Time'),'yyyy-MM-dd') 'SKUBaseFirstMadeWebActive'
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
               ) SS ON WSB.ixSOPSku = SS.ixSOPSKU --COLLATE SQL_Latin1_General_CP1_CI_AS
where dtStartEffectiveDate = @Date --'03/04/2020'
    AND SS.ixSOPSKU IS NOT NULL -- SALEABLE
order by WSB.sBrandName, SS.ixSOPSKU