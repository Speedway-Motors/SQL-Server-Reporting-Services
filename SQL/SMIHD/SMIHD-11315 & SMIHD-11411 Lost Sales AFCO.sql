-- SMIHD-11315 & SMIHD-11411 Lost Sales AFCO

-- from Lost Sales Report.rdl in AFCO Inventory project
SELECT DISTINCT S.ixSKU AS SKU
     , S.sDescription AS Description 
     , S.mPriceLevel1 AS Retail
     , S.mAverageCost AS Cost
     , S.mPriceLevel1 - S.mAverageCost AS GP
     , SUM(ISNULL(OL.iQuantity,0)) AS QtyLost 
     , (ISNULL(S.mPriceLevel1,0) - ISNULL(S.mAverageCost,0)) * (SUM(ISNULL(OL.iQuantity,0))) AS LostGP
     , SL.sPickingBin AS PickBin --IF THE PART IS STORED IN MULTIPLE BINS IT IS SHOWING UP MULTIPLE TIMES 
     , SL.iQOS AS QOS 
     , ISNULL(SL.iQOS,0) - ISNULL(SL.iQAV,0) AS QtyComtd 
     -- ADD in PO Report 
     , O.sOrderTaker 
     , O.ixOrder --?? not on request 
     , O.dtOrderDate
     , O.sOrderStatus 
FROM tblOrderLine OL 
LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU      
--LEFT JOIN tblBinSku BS ON BS.ixSKU = S.ixSKU 
                      --  AND BS.ixLocation = '99'
LEFT JOIN tblSKULocation SL ON SL.ixSKU = S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
                           AND SL.ixLocation = '99'
LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder 
WHERE OL.flgLineStatus = 'Lost'
  --AND OL.dtOrderDate BETWEEN DATEADD(dd, -365, GETDATE()) AND GETDATE() -- @StartDate AND @EndDate 
  --AND S.flgActive = '1' --??
  AND OL.ixSKU = '80195NDP-16'
GROUP BY S.ixSKU 
       , S.sDescription
       , S.mPriceLevel1        
       , S.mAverageCost
       , S.mPriceLevel1 - S.mAverageCost 
       , SL.sPickingBin
       , SL.iQOS
       , ISNULL(SL.iQOS,0) - ISNULL(SL.iQAV,0)
       , O.sOrderTaker 
       , O.ixOrder
       , O.dtOrderDate
       , O.sOrderStatus
ORDER BY S.ixSKU

SELECT * FROM tblSKU where ixSKU = '80195NDP-16'


select  distinct ixOrder, ixSKU, flgLineStatus, FORMAT(dtDateLastSOPUpdate,'MM/dd/yy') 'DateLastSOPUpdate', ixTimeLastSOPUpdate, dtDateLastSOPUpdate--, count(*) 'OrderLines'
from tblOrderLine
where ixSKU = '80195NDP-16'
order by dtDateLastSOPUpdate desc, flgLineStatus

select distinct ixOrder, dtDateLastSOPUpdate from tblOrderLine where  ixSKU = '80195NDP-16'
-- refed all above orders.  No change in flgLineStatus


select ixSKU, SUM(iQuantity) 'QtyLostYTD'
from tblOrderLine where flgLineStatus = 'Lost'
and ixOrder not LIKE 'Q%'
and ixOrder not LIKE 'P%'
and dtOrderDate >= '01/01/2018'
group by ixSKU



select count(distinct ixOrder) 'OrdCnt'--, SUM(iQuantity) 'QtyLostYTD'
from tblOrderLine 
where flgLineStatus = 'Lost'
and ixOrder not LIKE 'Q%'
and ixOrder not LIKE 'P%'
and dtOrderDate >= '01/01/2018'


SMI 2,019 out of 408,044 orders (0.5%) with Lost orderlines YTD
AFCO   35 out of   9,172 orders (0.4%) with Lost orderlines YTD





select-- dDimWeight, 
    count(*) -- 10,973 NULL   14,731
from tblPackage
where ixShipDate >= 18264
and flgCanceled = 0
and dDimWeight is NOT NULL
group by dDimWeight
order by dDimWeight

