-- OrderLines with no ixPicker values
SELECT COUNT(OL.ixOrder) from tblOrderLine OL
     join tblOrder O on OL.ixOrder = O.ixOrder
     left join tblSKU S on OL.ixSKU = S.ixSKU --and S.flgIntangible = 1
where O.sOrderStatus = 'Shipped'
and O.dtShippedDate >= '01/01/2017'
and OL.flgLineStatus = 'Shipped'
and OL.ixPicker is NULL -- 1,093k have values 330lk are NULL
and (S.flgIsKit is NULL or S.flgIsKit = 0)
                 


SELECT 
--OL.ixSKU, S.sDescription, S.mPriceLevel1, S.dDimWeight, S.dWeight, S.iLength, S.iWidth, S.iHeight, 
--sSEMACategory, --sSEMASubCategory, sSEMAPart,
COUNT(OL.ixOrder) OrdersWithSKU
from tblOrderLine OL
     join tblOrder O on OL.ixOrder = O.ixOrder
     left join tblSKU S on OL.ixSKU = S.ixSKU --and S.flgIntangible = 0
where O.sOrderStatus = 'Shipped'
    and O.dtShippedDate >= '01/01/2017'
    and OL.flgLineStatus = 'Shipped'
    and OL.ixPicker is NULL -- 1,093k have values 330lk are NULL
    and (S.flgIsKit is NULL or S.flgIsKit = 0)
    and (S.flgIntangible = 0 or S.flgIntangible is NULL)
    and OL.ixSKU NOT LIKE 'INS%'
    and S.sDescription NOT LIKE '%CAT%'
    and S.sDescription NOT LIKE '%GIFT%'
    and S.sDescription NOT LIKE '%DECAL%'    
GROUP BY --OL.ixSKU, S.sDescription, S.mPriceLevel1, S.dDimWeight, S.dWeight, S.iLength, S.iWidth, S.iHeight, 
--sSEMACategory--, sSEMASubCategory, sSEMAPart
order by COUNT(OL.ixOrder)desc



/*  RESULTS

                     
OrderLines with no picker                            
Shipped 1/1/17 to 8/18/17                                             
=============================================================
YTD 1,424k shipped orderlines
    1,093k (77%) Shipped orderlines have a picker
      330k (23%) have no picker 
                66k are kits
                60k are for intangible SKUs
                65k are for Catalogs, Inserts, or Gift Cards
                 7k are for Decals
               133k are for ?
               


*/
