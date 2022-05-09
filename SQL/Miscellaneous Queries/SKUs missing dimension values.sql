-- SKUs missing dimension values
select SKU.ixSKU, SKU.sDescription, 
    SKU.iLength,
    SKU.iWidth,
    SKU.iHeight,
    SKU.dWeight,
    SKU.flgActive,
    SKU.flgIntangible,
    S.Est12moQtySold,
    S.Est12moSales,
    SKU.ixCreator,    
    SKU.dtCreateDate
 
from tblSKU SKU
JOIN (-- ESTIMATED SALES 12 mo
      SELECT OL.ixSKU, flgLineStatus, SUM(OL.iQuantity) 'Est12moQtySold', SUM(OL.mExtendedPrice) 'Est12moSales'
      FROM tblOrderLine OL
      WHERE ixShippedDate >= 16929
          and flgLineStatus = 'Shipped'
          and OL.mExtendedPrice > 0
      GROUP BY OL.ixSKU, flgLineStatus
      HAVING SUM(OL.iQuantity) > 0 
            AND SUM(OL.mExtendedPrice) > 0
      --ORDER BY flgLineStatus
      ) S on S.ixSKU = SKU.ixSKU
where SKU.flgIntangible = 0
and SKU.flgDeletedFromSOP = 0
and SKU.flgActive = 1                   --200,544
and (
    (SKU.iLength is NULL or SKU.iLength = 0)
    or
    (SKU.iWidth is NULL or SKU.iWidth = 0)
    or
    (SKU.iHeight is NULL or SKU.iHeight = 0)
    )   
and SKU.flgIsKit = 1         
ORDER BY Est12moSales desc   
  