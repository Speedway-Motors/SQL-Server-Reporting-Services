-- SMIHD-8815 - OTUs used from EMi Promo IDs

-- OTUs are NOT stored in SMI Reporting.  Leslie said she just needs the order numbers for each of the Promo IDs

SELECT PCX.ixOrder, PCX.ixPromoId, PCX.ixPromoCode, O.sOrderStatus, O.mMerchandise, O.mMerchandiseCost, O.dtOrderDate, O.dtShippedDate
FROM tblOrderPromoCodeXref PCX
    join tblOrder O on PCX.ixOrder = O.ixOrder
where ixPromoId in ('1297','1301','1305','1326','1363','1402')
order by ixPromoId, ixPromoCode


select * from tblPromoCodeMaster where ixPromoId in ('1297','1301','1305','1326','1363','1402')