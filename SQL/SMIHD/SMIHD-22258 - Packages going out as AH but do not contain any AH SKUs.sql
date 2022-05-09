-- SMIHD-22258 - Packages going out as AH but do not contain any AH SKUs

    select * from tblOrder   
    where sOrderType != 'Customer Service'   
        and sOrderStatus = 'Shipped'   
        and flgGuaranteedDeliveryPromised = '1'   
        and dtOrderDate >= '08/01/21'   
        and flgDeliveryPromiseMet != '1'   
    
    
    select distinct O.ixOrder -- 1,391
    from tblOrder O   
        join tblOrderLine OL on OL.ixOrder = O.ixOrder  
         where O.dtOrderDate >= '08/12/21'

L 48"
W 30"
Wt 70lbs

-- Orders that had at least 1 AH (add. handling) package
SELECT distinct P.ixOrder
into #AH_Orders -- DROP TABLE #AH_Orders
from tblPackage P
    left join tblOrder O on P.ixOrder = P.ixOrder
where P.ixShipDate between 19572 and 19578 -- Aug 1st-7th
    and O.sOrderStatus = 'Shipped' -- 18,190 packages shipped
    and (P.dLength >= 48
         OR
         P.dWidth >= 30
         OR
         P.dActualWeight >= 70)     -- 748   4.1% of the packages qualified as "additional handling"

-- orders that don't contain SKUs meeting AH requirements
SELECT AHO.ixOrder, 
    max(S.iLength) 'MaxLength',
    max(S.iWidth) 'MaxWidth',
    max(S.dWeight) 'MaxWeight',
    max(S.flgAdditionalHandling) 'AHflag',
    O.mShipping
into #OrdersWithNo_AH_SKUs -- DROP TABLE #OrdersWithNo_AH_SKUs
from #AH_Orders AHO
    left join tblOrder O on AHO.ixOrder = O.ixOrder
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
    left join tblSKU S on OL.ixSKU = S.ixSKU
GROUP BY AHO.ixOrder, O.mShipping
HAVING max(S.iLength) < 47 -- using 1" less than the max so that it can FIT IN THE BOX
    AND max(S.iWidth) < 29 -- using 1" less than the max so that it can FIT IN THE BOX
    AND max(S.dWeight) < 70 
ORDER BY max(S.dWeight)         -- 83 out of the 748 AH orders (11%) do not contain a SKU with AH Length, Width, or Weight

SELECT DISTINCT ixOrder, mShipping
from #OrdersWithNo_AH_SKUs
order by mShipping


select distinct AHO.ixOrder, P.ixBoxSKU, S2.iLength, S2.iWidth, S2.iHeight
from #OrdersWithNo_AH_SKUs AHO
    left join tblOrderLine OL on AHO.ixOrder = OL.ixOrder
    left join tblSKU S on OL.ixSKU = S.ixSKU
    left join tblPackage P on OL.sTrackingNumber = P.sTrackingNumber
                        and OL.ixOrder = P.ixOrder
    left join tblSKU S2 on S2.ixSKU = P.ixBoxSKU
where flgLineStatus = 'Shipped'
order by P.ixBoxSKU










select top 10 * from tblSKU

flgAdditionalHandling
1

select flgAdditionalHandling, count(*)
from tblSKU
where flgDeletedFromSOP = 0
    and flgIntangible = 0
    and flgActive = 1
group by flgAdditionalHandling
order by flgAdditionalHandling

-- SKUs flagged as AH but have measurements and weight under thresholds
select ixSKU, iLength, iWidth, dWeight, ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription', -- 8,640
    flgAdditionalHandling,  flgORMD, sBattery, sLiquid, sLimitedQuantity, sSDS,
    sSEMACategory, sSEMASubCategory, dtDateLastSOPUpdate
from tblSKU S
where flgDeletedFromSOP = 0
    and flgIntangible = 0
    and flgActive = 1
    and flgAdditionalHandling = 1
    and iLength < 48
    and iWidth < 30
    and dWeight < 70
order by sSEMACategory, ixSKU









SELECT distinct P.ixOrder
into #AH_Orders -- DROP TABLE #AH_Orders
from tblPackage P
    left join tblOrder O on P.ixOrder = P.ixOrder
where P.ixShipDate between 19572 and 19578 -- Aug 1st-7th
    and O.sOrderStatus = 'Shipped' -- 18,190 packages shipped
    and (P.dLength >= 48
         OR
         P.dWidth >= 30
         OR
         P.dActualWeight >= 70) 



SELECT P.ixOrder, P.sTrackingNumber, 
    P.dLength 'PKGLength',
    P.dWidth 'PKGWidth',
    P.dActualWeight 'PKGWeight'














    select sTrackingNumber, P.ixOrder, mPublishedFreight, mShippingCost, O.mShipping
from tblPackage P
    left join tblOrder O on P.ixOrder = O.ixOrder
where O.dtShippedDate = '08/01/2021'



select count(*) 
from tblPackage
where ixShipDate between 19541 and 19571 -- 7/1/21 to 7/31/2021
and flgCanceled = 0
and flgReplaced = 0  -- 89,695
and ixBoxSKU = ixSuggestedBoxSKU -- 27,256


select sTrackingNumber, ixBoxSKU, ixSuggestedBoxSKU
from tblPackage
where ixShipDate between 19541 and 19571 -- 7/1/21 to 7/31/2021
and flgCanceled = 0
and flgReplaced = 0  -- 89,695
and ixBoxSKU <> ixSuggestedBoxSKU -- 27,256
and ixSuggestedBoxSKU <> 'SLAPPER'

select ixSuggestedBoxSKU, count(*) 'NotUsed'
from tblPackage
where ixShipDate between 19541 and 19571 -- 7/1/21 to 7/31/2021
and flgCanceled = 0
and flgReplaced = 0  -- 89,695
and ixBoxSKU <> ixSuggestedBoxSKU -- 27,256
and ixSuggestedBoxSKU <> 'SLAPPER'
group by ixSuggestedBoxSKU
order by count(*) desc
/* top 10

SugBox
SKU	    NotUsed
BOX-108	6065
ENV-0	5721
BOX-101	5244
BOX-111	3558
ENV-5	3110
BOX-123	2619
ENV-2	2311
UP137315	1552
BOX-105	1524
BOX-112	1449
*/

SELECT ixSKU, iLength, iWidth, iHeight
from tblSKU
where ixSKU = 'BOX-108'
/*
ixSKU	iLength	iWidth	iHeight
BOX-108	24.7	6.6	5.2
*/

select count(*) 
from tblPackage
where ixShipDate between 19541 and 19571 -- 7/1/21 to 7/31/2021
and flgCanceled = 0
and flgReplaced = 0  -- 89,695
and ixBoxSKU = ixSuggestedBoxSKU -- 27,256

/*
ixSKU	iLength	iWidth	iHeight
BOX-108	24.7	6.6	5.2
*/
SELECT OL.ixSKU, S.iLength, iWidth, iHeight
from tblPackage P
    left join tblOrderLine OL on OL.sTrackingNumber = P.sTrackingNumber     
                                and OL.ixOrder = P.ixOrder
    left join tblSKU S on S.ixSKU = OL.ixSKU
where ixShipDate between 19541 and 19571 -- 7/1/21 to 7/31/2021
    and flgCanceled = 0
    and flgReplaced = 0  -- 89,695
    and ixBoxSKU <> ixSuggestedBoxSKU -- 27,256
    and ixSuggestedBoxSKU = 'BOX-108'
order by S.iLength desc







