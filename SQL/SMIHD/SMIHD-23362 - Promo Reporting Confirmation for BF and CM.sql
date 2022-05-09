-- SMIHD-23362 - Promo Reporting Confirmation for BF and CM
/*
Promo/Reporting IDs:
1892 / 2137
1893 / 2138
*/

SELECT O.ixCustomer, ixPromoId, count(PC.ixOrder) 'OrdCnt'
FROM tblOrderPromoCodeXref PC
    left join tblOrder O on PC.ixOrder = O.ixOrder
WHERE PC.ixPromoId IN (2137,2138 )
    -- and O.sOrderStatus = 'Shipped'
    and O.dtOrderDate between '11/21/2021' and '12/05/2021'
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'  
    and O.mMerchandise > 0
GROUP BY O.ixCustomer,PC.ixPromoId
HAVING count(PC.ixOrder) > 1

/*
ixPromoId	OrdCnt
2137	    49
2138	    159
*/


select PC.ixPromoId, O.ixCustomer, PC.ixPromoCode, O.ixOrder, O.dtOrderDate, O.sOrderStatus, O.ixMasterOrderNumber 
FROM tblOrderPromoCodeXref PC
    left join tblOrder O on PC.ixOrder = O.ixOrder
where ixCustomer = 3011875
    and ixPromoId = 2137
order by ixMasterOrderNumber

select * FROM tblOrderPromoCodeXref
where ixPromoCode = '2021BFCMPI'







-- order that used a BasePromo
SELECT OP.sPromotionCode 'BasePromo'
    , O.ixCustomer, O.sOrderStatus, O.ixOrder, O.ixMasterOrderNumber 
FROM tng.tblOrder_promotion OP
    left join tng.tblorder TNGO on OP.ixOrder = TNGO.ixOrder
    left join tblOrder O on O.ixOrder = TNGO.ixSopOrderNumber
WHERE OP.sPromotionCode = '2021BFCMPI' 
ORDER BY O.ixCustomer
/*
BasePromo	ixCustomer	sOrderStatus	ixOrder	    ixMasterOrderNumber
2021BFCMPI	1388431	    Shipped	        10241286	10241286
2021BFCMPI	1735905	    Shipped	        10377584	10377584
2021BFCMPI	2617160	    Shipped	        10156785	10156785
2021BFCMPI	2651487	    Shipped	        10232385	10232385
2021BFCMPI	3011875	    Shipped	        10164181	10164181
2021BFCMPI	3011875	    Shipped	        10169180	10169180
2021BFCMPI	3011875	    Shipped	        10173185	10173185
2021BFCMPI	3011875	    Shipped	        10163180	10163180
2021BFCMPI	3011875	    Shipped	        10172185	10172185
2021BFCMPI	3032246	    Shipped	        10314184	10314184
2021BFCMPI	3132536	    Shipped	        10202984	10202984
2021BFCMPI	3992623	    Shipped	        10162880	10162880
*/



-- THE RECORDS BELOW (FOR tblPromoCodeMaster AND tblOrderPromoCodeXref) 
-- HAVE BEEN MODIFIED IN SOP AND WILL REFEED TONIGHT (Tue Dec 7th)
-- rerun the two queries below on Dec 8th to confirm everything updated as expected.

SELECT * 
FROM tblPromoCodeMaster
where ixPromoId in ('2137', '2138')
/*
ixPromoId	ixPromoCode         CHANGE TO
=========   ===============     =========
2137	    2021BFCMPI          BF21CMONPI 
2138	    2021BFCME           BFRI21CMEM

2137	    2021BFCM25OFFCA     stays the same -- was not really used and replaced with a shorter promo code
*/

select ixPromoId, ixPromoCode, count(*) 'RecCnt'
from tblOrderPromoCodeXref
where ixPromoId in ('2137', '2138')
group by ixPromoId, ixPromoCode
/*
ixPromoId	ixPromoCode	RecCnt      @12/7/21 10:35am
2138	    2021BFCME	186
2137	    2021BFCMPI	75

2138	2021BFCME	    186      @12/9/21 1:02pm   
2137	2021BFCMPI	    75
2137	BF21CMONPI	    15
2138	BFRI21CMEM	    13
*/


