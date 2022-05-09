-- Repair ixPromoId values in tblShippingPromo

-- RUN DAILY on LNK-SQL-LIVE-1 UNTIL Web Dev team fixes issue.

-- Get list of promo ID's that need to be "repaired"
SELECT count(*) 'OrderCount',ixPromoId 'PromoId' --ixId, ixOrder, ixPromoId
FROM tblShippingPromo SP
WHERE len(ixPromoId) > 4
    --and ixPromoId like '%1653%'
GROUP BY ixPromoId
ORDER BY count(*) desc
    /*
    Order   BAD
    Count   PromoId     as of 01-14-18
    =====   ===========
    79	    7631653
    35	    763763
    35	    16531653
    29	    76376316531653  -- 36 new records since 12-19-18
    7	    11611161
    1	    15291529
    1	    156157
    1	    76316531653
    1	    359157
    1	    393157
    1	    431157


    Order   BAD
    Count   PromoId     as of 12-19
    =====   ===========
    79	    7631653
    35	    763763
    29	    76376316531653
    19	    16531653                -- 6 new records since 12-7
    6	    11611161
    1	    15291529
    1	    156157
    1	    76316531653
    1	    359157
    1	    393157
    1	    431157


    Order   BAD
    Count   PromoId     as of 12-7
    =====   ===========
    79	    7631653
    35	    763763
    29	    76376316531653
    13	    16531653
    6	    11611161
    1	    15291529
    1	    156157
    1	    76316531653
    1	    359157
    1	    393157
    1	    431157  


SELECT count(*) 'OrderCount',ixPromoId, O.iShipMethod  --ixId, ixOrder, ixPromoId
FROM tblShippingPromo SP
    left join tblOrder O on SP.ixOrder = O.ixOrder
WHERE len(ixPromoId) > 4
    --and ixPromoId like '%1653%'
    and O.sOrderStatus in ('Shipped','Open')
GROUP BY ixPromoId, O.iShipMethod
ORDER BY count(*) desc

174 orders with bad promo ID's		
	of those 155 are Shipped or Open	
		of those all but 2 were shipped Best Way


-- examples of orders with the bad promo codes

select ixOrder, ixPromoId
from tblShippingPromo
where ixPromoId in ('7631653','763763','76376316531653','16531653','11611161','15291529','156157','76316531653','359157','393157','431157')
order by newid()


SELECT O.ixOrder, 
    FORMAT(O.dtOrderDate,'MM/dd/yy') as 'OrderDate',
    FORMAT(O.dtShippedDate,'MM/dd/yy') as 'ShippedDate',
    O.sOrderStatus,
    O.sOrderChannel,
    O.sOrderTaker,
    --O.sSourceCodeGiven,
    O.iShipMethod,
    SP.ixPromoId --ixId, ixOrder, ixPromoId
FROM tblShippingPromo SP
    left join tblOrder O on SP.ixOrder = O.ixOrder
WHERE len(ixPromoId) > 4
    and O.dtOrderDate >= '12/08/2018'
    and O.sOrderStatus in ('Shipped','Open')
    -- and O.ixOrder in ('8915910','8350128','4815291','8974221','8973321','5650142','8973416','8951213','8167322','8986907','8951119','8958414')
    --and ixPromoId like '%1653%'
    
    */

BEGIN TRAN
    UPDATE [SMI Reporting].dbo.tblShippingPromo -- 118
    SET ixPromoId = '1653'
    WHERE ixPromoId in ('7631653','76376316531653','16531653','76316531653')
ROLLBACK TRAN

BEGIN TRAN 
    UPDATE tblShippingPromo -- 35
    SET ixPromoId = '763'
    WHERE ixPromoId in ('763763')
ROLLBACK TRAN

BEGIN TRAN 
    UPDATE tblShippingPromo -- 5
    SET ixPromoId = '1161'
    WHERE ixPromoId in ('11611161')
ROLLBACK TRAN

BEGIN TRAN 
    UPDATE tblShippingPromo -- 5
    SET ixPromoId = '1529'
    WHERE ixPromoId in ('15291529')
ROLLBACK TRAN



SELECT * FROM tblShippingPromo
where ixPromoId in ('7631653','16531653','763763','76376316531653','11611161','15291529','156157','76316531653','359157','393157','431157')
order by ixPromoId, ixOrder

