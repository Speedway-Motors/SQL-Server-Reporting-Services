-- SMIHD-19357 - 2 reports to identify SKUs with incorrect SLAPR assignements


select sPackageType, FORMAT(count(*),'###,###') 'SKUCnt'
from tblSKU
--where flgActive = 1
group by sPackageType


select ixSKU, sDescription,sPackageType, flgActive, dtDiscontinuedDate
from tblSKU
where sPackageType = 'ENV' 


-- SKUs flagged as SLAPR but didn't ship as a SLAPPER
DECLARE @ShippedDate datetime
SELECT @ShippedDate = '11/24/2020'

SELECT distinct OL.ixSKU, count(P.sTrackingNumber) 'Pkgs'
--O.ixOrder, O.dtShippedDate, OL.ixSKU, O.sOrderTaker--, P.ixBoxSKU, P.ixSuggestedBoxSKU, S.sPackageType 'SKUPkgType'
from tblOrder O
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
    left join tblSKU S on OL.ixSKU = S.ixSKU
    left join tblPackage P on OL.sTrackingNumber = P.sTrackingNumber
                    and OL.ixOrder = P.ixOrder
where O.dtShippedDate = @ShippedDate -- 153
    and O.sOrderStatus = 'Shipped'
    and OL.flgLineStatus = 'Shipped'
    and S.sPackageType = 'SLAPR' 
    and O.iShipMethod NOT IN (1,8)
    and P.ixBoxSKU is NOT NULL
    and P.ixBoxSKU != OL.ixSKU
    and OL.ixSKU NOT LIKE 'NS%'
    and OL.ixSKU NOT LIKE 'UP%'
    and OL.ixSKU NOT LIKE 'AUP%'
group by OL.ixSKU

-- SKUs shipped as SLAPPER but are nto flagged as SLAPPER
select distinct OL.ixSKU
--O.ixOrder, O.dtShippedDate, OL.ixSKU, O.sOrderTaker--, P.ixBoxSKU, P.ixSuggestedBoxSKU, S.sPackageType 'SKUPkgType'
from tblOrder O
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
    left join tblSKU S on OL.ixSKU = S.ixSKU
    left join tblPackage P on OL.sTrackingNumber = P.sTrackingNumber
                    and OL.ixOrder = P.ixOrder
where O.dtShippedDate = '11/17/2020'
    and O.sOrderStatus = 'Shipped'
    and OL.flgLineStatus = 'Shipped'
    and S.sPackageType <> 'SLAPR' 
    and O.iShipMethod NOT IN (1,8)
    and P.ixBoxSKU is NOT NULL
    and P.ixBoxSKU = OL.ixSKU
    and OL.ixSKU NOT LIKE 'NS%'
    and OL.ixSKU NOT LIKE 'UP%'
    and OL.ixSKU NOT LIKE 'AUP%'



    select distinct(OL.ixSKU) 
    from tblOrder O
        left join  tblPackage P on O.ixOrder = P.ixOrder
        left join  tblOrderLine OL on OL.ixOrder = O.ixOrder
                        and OL.sTrackingNumber = P.sTrackingNumber
        left join  tblSKU S on S.ixSKU = OL.ixSKU
    where O.dtShippedDate = '11/17/20'
        and sPackageType = 'SLAPR'
        and sOrderStatus = 'Shipped'
        and OL.flgLineStatus = 'Shipped'
        and P.ixBoxSKU != OL.ixSKU
        and P.ixBoxSKU is not null
        and O.iShipMethod not in ('1', '8')



    select * from tblBusinessUnit
    select from tblPackage


 SELECT * 
 from tblOrder
 where dtShippedDate = datepart("dd",DATEADD(dd, -1, getdate()) )

 select  datepart("dd",DATEADD(dd, -1, getdate()) )
 select DATEADD(dd, -1, getdate())              


