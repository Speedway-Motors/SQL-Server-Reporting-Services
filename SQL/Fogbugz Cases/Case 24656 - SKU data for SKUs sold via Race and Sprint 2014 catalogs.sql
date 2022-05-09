-- Case 24656 - SKU data for SKUs sold via Race and Sprint 2014 catalogs

select ixSKU, count(sum(qtySKUSold)) from tblOrderLine
where ixMatchbackSourceCode in (select source codes for all 2014 Sprint and Race catalogs)



select OL.ixSKU, SKU.sDescription, mPriceLevel1, mLatestCost, mAverageCost, ixPGC, dWeight, flgAdditionalHandling, ixBrand, flgIsKit, iLength, iWidth, iHeight, 
    flgShipAloneStatus, flgIntangible, sSEMACategory, sSEMASubCategory, sSEMAPart, flgMadeToOrder, 
    flgBackorderAccepted, sHandlingCode, ixProductLine, mMSRP, flgORMD,  sum(OL.iQuantity) QTYSold
from tblOrderLine OL
    left join tblOrder O on OL.ixOrder = O.ixOrder
    left join tblSKU SKU on OL.ixSKU = SKU.ixSKU
    left join tblSourceCode SC on O.sMatchbackSourceCode = SC.ixSourceCode
    left join tblCatalogMaster CM on SC.ixCatalog = CM.ixCatalog
where CM.dtStartDate >= '11/01/2013'
    and CM.sMarket in ('SM','R')
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and SKU.flgActive = 1
    and SKU.flgIntangible = 0
    and mPriceLevel1 > 0
GROUP by OL.ixSKU,SKU.sDescription, mPriceLevel1, mLatestCost, mAverageCost, ixPGC, dWeight, flgAdditionalHandling, ixBrand, flgIsKit, iLength, iWidth, iHeight, 
    flgShipAloneStatus, flgIntangible, sSEMACategory, sSEMASubCategory, sSEMAPart, flgMadeToOrder, 
    flgBackorderAccepted, sHandlingCode, ixProductLine, mMSRP, flgORMD   

order by ixSKU

 desc    

    ixSKU, sDescription, mPriceLevel1, mLatestCost, mAverageCost, ixPGC, dWeight, flgAdditionalHandling, ixBrand, flgIsKit, iLength, iWidth, iHeight, 
    flgShipAloneStatus, flgIntangible, sSEMACategory, sSEMASubCategory, sSEMAPart, flgMadeToOrder, 
    flgBackorderAccepted, sHandlingCode, ixProductLine, mMSRP, flgORMD




select * from tblCatalogMaster   where dtStartDate >= '11/01/2013'
and sMarket in ('SM','R')


select * from tblMarket

SM	SprintMidget
R	Race
