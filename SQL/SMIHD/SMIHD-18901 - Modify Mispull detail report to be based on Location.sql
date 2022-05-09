-- Mispull Detail - TOL.rdl
--   ver 20.42.1

DECLARE @StartDate DATETIME,       @EndDate DATETIME
SELECT @StartDate = '01/01/2020',   @EndDate = '10/12/2020'    -- @99=61 in 10 sec        85=5 in 1 sec
    
-- Mispulls SHIPPED between date Start and End dates
SELECT OL.ixOrder, OL.ixSKU, SKU.sDescription,                 
    OL.ixPicker, OL.iQuantity, OL.iMispullQuantity,
    PB.sPickingBin as 'PickBin',
    O.sOrderStatus, O.dtOrderDate,
    MIN(D.dtDate) as 'FirstVerifDate', -- placeholder for min verif date dat of any pkg
    dbo.GetLatestOrderTimePrinted (O.ixOrder) 'Printed'
FROM tblOrderLine OL
    join tblOrder O on O.ixOrder = OL.ixOrder
    left join tblPackage P on O.ixOrder = P.ixOrder
    left join tblDate D on D.ixDate = P.ixVerificationDate    
    left join tblSKU SKU on OL.ixSKU = SKU.ixSKU
    left join (-- Getting Picking Bin
               Select distinct ixSKU, sPickingBin
               from tblBinSku where ixLocation = '99'
               ) PB on SKU.ixSKU = PB.ixSKU 
WHERE O.dtShippedDate between @StartDate and @EndDate
    and O.sOrderStatus = 'Shipped'
    and OL.flgLineStatus NOT in ('Backordered','Cancelled')
    and SKU.flgIntangible = 0  
    and OL.iMispullQuantity > 0
    and PB.sPickingBin NOT like 'B%'
    and O.ixPrimaryShipLocation = 99
GROUP BY OL.ixOrder, OL.ixSKU, SKU.sDescription,                 
    OL.ixPicker, OL.iQuantity, OL.iMispullQuantity,
    PB.sPickingBin,
    O.sOrderStatus, O.dtOrderDate,
    dbo.GetLatestOrderTimePrinted (O.ixOrder)  
UNION 

-- Misspulls on ALL OPEN orders
SELECT OL.ixOrder, OL.ixSKU, SKU.sDescription,                 
    OL.ixPicker, OL.iQuantity, OL.iMispullQuantity,
    PB.sPickingBin as 'PickBin',
    O.sOrderStatus, O.dtOrderDate,
    MIN(D.dtDate) as 'FirstVerifDate',
    dbo.GetLatestOrderTimePrinted (O.ixOrder) 'Printed'
FROM tblOrderLine OL
    join tblOrder O on O.ixOrder = OL.ixOrder
    left join tblPackage P on O.ixOrder = P.ixOrder
    left join tblDate D on D.ixDate = P.ixVerificationDate
    left join tblSKU SKU on OL.ixSKU = SKU.ixSKU
    left join (-- Getting Picking Bin
               Select distinct ixSKU, sPickingBin
               from tblBinSku where ixLocation = '99'
               ) PB on SKU.ixSKU = PB.ixSKU 
WHERE O.sOrderStatus =  'Open'
    and OL.flgLineStatus NOT in ('Backordered','Cancelled')
    and SKU.flgIntangible = 0  
    and OL.iMispullQuantity > 0
    and PB.sPickingBin NOT like 'B%'
    and O.ixPrimaryShipLocation = 99
GROUP BY OL.ixOrder, OL.ixSKU, SKU.sDescription,                 
    OL.ixPicker, OL.iQuantity, OL.iMispullQuantity,
    PB.sPickingBin,
    O.sOrderStatus, O.dtOrderDate,
    dbo.GetLatestOrderTimePrinted (O.ixOrder) 
HAVING  (MIN(D.dtDate) between @StartDate and @EndDate    
                 OR MIN(D.dtDate) is NULL)
ORDER BY O.sOrderStatus, O.dtOrderDate


/**/
DECLARE @StartDate DATETIME,       @EndDate DATETIME
SELECT @StartDate = '01/01/2020',   @EndDate = '10/12/2020'    -- @99=61 in 10 sec        85=5 in 1 sec 

-- Counts of eligible OLs vs count of mispulled OLs
SELECT count(OL.ixOrder) OLcount,  -- for 9/2/14  8,412 
    SUM(Case when iMispullQuantity > 0 then 1
        else 0
        end) OLMispulls
FROM tblOrderLine OL
    join tblOrder O on O.ixOrder = OL.ixOrder
    left join tblSKU SKU on OL.ixSKU = SKU.ixSKU
    left join -- Getting Picking Bin
        (Select distinct ixSKU, sPickingBin
         from tblBinSku where ixLocation = '99'
         ) PB on SKU.ixSKU = PB.ixSKU 
WHERE O.sOrderStatus = 'Shipped' 
    and O.dtShippedDate  between @StartDate and @EndDate
    and O.ixPrimaryShipLocation = 99
    and OL.flgLineStatus NOT in ('Backordered','Cancelled')
    and SKU.flgIntangible = 0  
    and (PB.sPickingBin is NULL
         OR
         PB.sPickingBin NOT like 'B%') -- excluding B-side items per Korth

select ixPrimaryShipLocation, count(ixOrder)
from tblOrder O
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
where sOrderStatus = 'Shipped'
and O.dtShippedDate >= '01/01/2020'
    and OL.iMispullQuantity > 0
group by ixPrimaryShipLocation


select OL.iMispullQuantity
from tblOrder O
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
where sOrderStatus = 'Shipped'
and O.dtShippedDate >= '01/01/2020'
    and OL.iMispullQuantity > 0
group by ixPrimaryShipLocation

select iMispullQuantity, FORMAT(count(*),'###,###') 'OrderLines'
from tblOrderLine
group by iMispullQuantity

select * from tblOrderLine where iMispullQuantity > 0


select distinct dtOrderDate, ixOrder, dtDateLastSOPUpdate 
from tblOrderLine where iMispullQuantity is NULL
and ixOrder not LIKE 'PC%'
--and dtOrderDate >= '01/01/2014'
and dtDateLastSOPUpdate is NOT NULL
order by dtDateLastSOPUpdate desc





select iMispullQuantity, FORMAT(count(OL.ixOrder),'###,###') 'OrderLines'
from tblOrderLine OL
    left join tblOrder O on OL.ixOrder = O.ixOrder
where O.ixPrimaryShipLocation = 47
group by iMispullQuantity