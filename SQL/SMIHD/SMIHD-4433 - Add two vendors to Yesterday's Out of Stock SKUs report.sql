-- SMIHD-4433 - Add two vendors to Yesterday's Out of Stock SKUs report

-- This report now needs to include V#0106 and 0311

SELECT 
    SKU.ixSKU           SKU,
    SKU.sDescription    SKUDescription,
    SKU.mPriceLevel1    Retail,
    SKU.mLatestCost     Cost,
    SKUSales.QTYSold,
    BO.BOQty            QTYCommitted,
    VS.ixVendor,
    (CASE WHEN SKU.ixSKU in (select POD.ixSKU
                             from tblPODetail POD
                                join tblPOMaster POM on POM.ixPO = POD.ixPO
                             where POM.flgIssued = 1
                               and POM.flgOpen = 1)
         then 'Y'
         else 'N'
         end) as OutstandingPO
FROM vwSKULocalLocation SKU
    JOIN (SELECT YDAY.ixSKU 
          FROM (-- yesterdays SKU's with 0 QOS
                    select SNAP.ixSKU
                    from tblSnapshotSKU SNAP 
                        join tblDate D on D.ixDate = SNAP.ixDate 
                    where (SNAP.iFIFOQuantity = 0 or SNAP.iFIFOQuantity is null) -- 32045
                        and D.dtDate = DATEADD(dd, DATEDIFF(dd,0,getdate()), 0) -- yesterday   *NOTE: The date in tblSnapshotSKU is the date the values of the previous day were saved!  eg. TUESDAY'S ixDate is really the final data from MONDAY
                ) YDAY
            JOIN (-- SKUs that had QOS > 0 two days ago 
                    select SNAP.ixSKU
                    from tblSnapshotSKU SNAP                                       
                        join tblDate D on D.ixDate = SNAP.ixDate 
                    where SNAP.iFIFOQuantity <> 0 
                        and SNAP.iFIFOQuantity is not null-- 32781
                        and D.dtDate = DATEADD(dd, DATEDIFF(dd,1,getdate()), 0) -- 2 days ago
                ) YDAY2 on YDAY2.ixSKU = YDAY.ixSKU
         ) NoQOS on NoQOS.ixSKU = SKU.ixSKU
     LEFT JOIN (-- SALES
                 select SNAP.ixSKU,
                        SUM(SNAP.AdjustedQTYSold) QTYSold
                 from tblSnapAdjustedMonthlySKUSales SNAP
                 where SNAP.iYearMonth in (select distinct iYearMonth 
                                           from tblDate
                                           where dtDate > DATEADD(mm, DATEDIFF(mm,0,getdate())-12, 0)    -- 1st of the month 12 months ago
                                             and dtDate < DATEADD(mm, DATEDIFF(mm,0,getdate()), 0)) -- 1st of the current month
                 group by  SNAP.ixSKU                       
                ) SKUSales on SKUSales.ixSKU = SKU.ixSKU
     LEFT JOIN  (-- QTY backordered
                 select OL.ixSKU, sum(OL.iQuantity) BOQty 
                 from tblOrder O
                    left join tblOrderLine OL on OL.ixOrder = O.ixOrder
                 where O.sOrderStatus = 'Backordered'
                 group by OL.ixSKU
                 ) BO on BO.ixSKU = SKU.ixSKU
    LEFT JOIN tblVendorSKU VS on VS.ixSKU = SKU.ixSKU 
WHERE (SKU.iQOS is null or SKU.iQOS = 0)
    and (SKU.dtDiscontinuedDate is null or SKU.dtDiscontinuedDate > getdate()) 
    and SKU.ixSKU not like 'UP%'
    and VS.iOrdinality = 1 -- Primary Vendor
    and VS.ixVendor NOT IN ('0009','0108','0313')
ORDER BY OutstandingPO, VS.ixVendor, SKU.ixSKU