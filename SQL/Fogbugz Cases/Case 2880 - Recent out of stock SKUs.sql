SELECT SKU.ixSKU    SKU,
SKU.sDescription    SKUDescription,
SKU.mPriceLevel1    Retail,
SKU.mLatestCost     Cost,
SKUSales.QTYSold,
BO.BOQty            QTYCommitted,
(CASE WHEN SKU.ixSKU in (select POD.ixSKU
                         from tblPODetail POD
                            join tblPOMaster POM on POM.ixPO = POD.ixPO
                                                and POM.flgIssued = 1
                                                and POM.flgOpen = 1)
     then 'Y'
     else 'N'
     end) as OutstandingPO

FROM tblSKU SKU
    join 
        (select YDAY.ixSKU 
         from 
         /****** yesterdays SKU's with 0 QOS *********/
         (select SNAP.ixSKU
          from tblSnapshotSKU SNAP 
            join tblDate D on D.ixDate = SNAP.ixDate 
                          and D.dtDate = DATEADD(dd, DATEDIFF(dd,0,getdate()), 0) -- yesterday         *NOTE: The date in tblSnapshotSKU is the date the values of the previous day were saved!  eg. TUESDAY'S ixDate is really the final data from MONDAY
          where SNAP.iFIFOQuantity = 0 or SNAP.iFIFOQuantity is null -- 32045
          ) YDAY

         join 
       /******  SKUs that had QOS > 0 two days ago *********/
            (select SNAP.ixSKU
             from tblSnapshotSKU SNAP                                       
                join tblDate D on D.ixDate = SNAP.ixDate 
                              and D.dtDate = DATEADD(dd, DATEDIFF(dd,1,getdate()), 0) -- 2 days ago
             where SNAP.iFIFOQuantity <> 0 and SNAP.iFIFOQuantity is not null-- 32781
             ) YDAY2 on YDAY2.ixSKU = YDAY.ixSKU
         ) NoQOS on NoQOS.ixSKU = SKU.ixSKU
     join tblBinSku BS on BS.ixSKU = SKU.ixSKU
     join tblBin B on B.ixBin = BS.ixBin
     /****** SALES *********/  
     left join
                        (select SNAP.ixSKU,
                                SUM(SNAP.AdjustedQTYSold) QTYSold
                         from tblSnapAdjustedMonthlySKUSales SNAP
                         where SNAP.iYearMonth in (select distinct iYearMonth 
                                                    from tblDate
                                                    where dtDate > DATEADD(mm, DATEDIFF(mm,0,getdate())-12, 0)    -- 1st of the month 12 months ago
                                                      and dtDate < DATEADD(mm, DATEDIFF(mm,0,getdate()), 0) -- 1st of the current month
                                                   )
                         group by  SNAP.ixSKU                       

                        ) SKUSales on SKUSales.ixSKU = SKU.ixSKU
    /****** QTY backordered *********/ 
     left join 
        (select OL.ixSKU, sum(OL.iQuantity) BOQty 
         from tblOrder O
            left join tblOrderLine OL on OL.ixOrder = O.ixOrder
         where O.sOrderStatus = 'Backordered'
         group by OL.ixSKU
         ) BO on BO.ixSKU = SKU.ixSKU
WHERE (SKU.iQOS is null or SKU.iQOS = 0)
     and (SKU.dtDIscontinuedDate is null or SKU.dtDIscontinuedDate > getdate()) 
     and SKU.ixSKU not like 'UP%'
--AND SKU.ixSKU = '8451000-16'
ORDER BY OutstandingPO, SKU.ixSKU



