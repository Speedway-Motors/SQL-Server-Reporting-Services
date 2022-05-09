-- FLAIR HAIR (Sales by Year template)

SELECT * FROM tblSKULocation where ixSKU in ('1931000','1931002','1931004','1932000','1932002','1932004','1933000','1933002')
and ixLocation = 99

select OL.ixSKU, S.sDescription, 
    SUM(OL.iQuantity) 'QtySold', 
    --D.iYear 'Year',
    -- SUM(OL.mExtendedCost), SUM(OL.mExtendedPrice), 
    SUM(OL.mExtendedPrice)-SUM(OL.mExtendedCost) AS 'GrossP'
from tblOrderLine OL
    join tblOrder O on OL.ixOrder = O.ixOrder
    join tblSKU S on OL.ixSKU = S.ixSKU
    join tblDate D on O.ixShippedDate = D.ixDate
where OL.ixSKU in ('1931000','1931002','1931004','1932000','1932002','1932004','1933000','1933002')
    and  O.sOrderStatus = 'Shipped'
    and O.dtShippedDate between '01/01/2009' and '12/31/2016'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
group by --D.iYear, 
    OL.ixSKU, S.sDescription
order by OL.ixSKU--, D.iYear desc
