SELECT count(*) FROM tblGiftCardMaster -- 34,081 @1-4-12    
                                       -- 34,102 @1-7-12 10:00AM
                                       -- 39,731 @1-15-14
SELECT distinct ixGiftCard FROM tblGiftCardMaster        -- 34,100

SELECT count(*) FROM tblGiftCardDetail  -- 34102
                                        -- 29,742 @1-15-14

SELECT * FROM tblGiftCardMaster
WHERE mAmountIssued < mAmountOutstanding -- 0

SELECT * FROM tblGiftCardMaster
WHERE mAmountIssued < mAmountOutstanding -- 0

-- GC's with more than one row in GCM
SELECT ixGiftCard, count(*)
FROM tblGiftCardMaster
GROUP BY ixGiftCard
HAVING count(*) > 1

SELECT * FROM tblGiftCardMaster WHERE ixGiftCard = '8294100000147072'



     
       
-- GC's WHERE the Purchase Amount - the total redeedmed amount != the Amount Outstanding
SELECT GCM.ixGiftCard,
       GCM.mAmountIssued,
       GCM.mAmountOutstanding,
       sum(isnull(GCD.mAmountRedeemed,0)) TotRedeemAmount
FROM  tblGiftCardMaster GCM
  left join tblGiftCardDetail GCD on GCM.ixGiftCard = GCD.ixGiftCard
GROUP BY GCM.ixGiftCard,
       GCM.mAmountIssued,
       GCM.mAmountOutstanding 
HAVING GCM.mAmountIssued - sum(isnull(GCD.mAmountRedeemed,0)) <> GCM.mAmountOutstanding               
/* only two still having issues
ixGiftCard	        mAmountIssued	mAmountOutstanding	TotRedeemAmount
1	                75.00	        75.00	            100.00
8294100000147072	50.00	        50.00	            25.58
*/        
      


-- GCM - counts by order status
SELECT O.sOrderStatus, count(O.ixOrder) OrderCount
FROM tblOrder O
WHERE ixOrder in (SELECT ixOrder FROM tblGiftCardMaster)
GROUP BY O.sOrderStatus
-- Shipped	29897

-- GCD - counts by order status
SELECT O.sOrderStatus, count(distinct GCD.ixGiftCard) OrderCount
FROM tblGiftCardDetail GCD
    join tblOrder O on GCD.ixOrderRedeemed = O.ixOrder
where O.dtOrderDate > = '01/01/2011'    
GROUP BY O.sOrderStatus       
/*
sOrderStatus	OrderCount
Cancelled	    142
Open	        17
Shipped	        7877
*/






-- GC's WHERE the Purchase Amount - the total redeedmed amount > mAmountIssued
SELECT GCM.ixGiftCard,
       GCM.mAmountIssued,
       GCM.mAmountOutstanding,
       sum(isnull(GCD.mAmountRedeemed,0)) TotRedeemAmount
FROM  tblGiftCardMaster GCM
  left join tblGiftCardDetail GCD on GCM.ixGiftCard = GCD.ixGiftCard
GROUP BY GCM.ixGiftCard,
       GCM.mAmountIssued,
       GCM.mAmountOutstanding 
HAVING sum(isnull(GCD.mAmountRedeemed,0)) > GCM.mAmountIssued      


8192100000122579	50.00	81.00	81.00
1	75.00	340.00	100.00
8292100000168351	25.00	30.00	30.00
9899412143674264	100.00	300.00	300.00
8192100000125770	15.00	20.99	20.99 



SELECT ixGiftCard, count(*)
FROM tblGiftCardDetail
group by ixGiftCard
HAVING count(*) > 6



select * from tblGiftCardDetail
where ixGiftCard = '8144100197228522'


SELECT min(ixShipDate) FROM tblGiftCardMaster -- 13086

SELECT * FROM tblDate WHERE ixDate = 13086


SELECT top 5
       GCM.ixGiftCard,
       GCM.mAmountIssued,
       --GCM.mAmountOutstanding,
       sum(isnull(GCD.mAmountRedeemed,0)) TotRedeemAmount,
       count(GCD.ixId) UsageCount
FROM  tblGiftCardMaster GCM
  left join tblGiftCardDetail GCD on GCM.ixGiftCard = GCD.ixGiftCard
WHERE GCM.ixShipDate > 15707 --	01/01/2011
GROUP BY CM.ixGiftCard,
       GCM.mAmountIssued,
       GCM.mAmountOutstanding 
HAVING mAmountIssued > 100
--count(GCD.ixId) >= 5
order by newid()
--
ixGiftCard	        mAmountIssued	TotRedeemAmount	UsageCount
9550894393705263	75.00	        75.00	        1
9900854403684538	70.00	        70.00	        1
8396100000179709	10.00	        10.00	        1
8294100000149891	50.00	        50.00	        1
8292100000142103	50.00	        50.00	        1

8294100000172341	124.97	        124.97	        2
8294100000184723	299.99	        299.99	        2
8290100000183638	100.00	        100.00	        2
9058934203686585	100.00	        100.00	        3
8398100000143180	4744.83	        3086.30	        5

8394100000139058	1293.75	        239.21	        1
8294100000161958	200.00	        200.00	        2
8290100000163678	291.94	        275.59	        1
8294100000130438	150.00	        150.00	        1
8290100000179979	209.98	        209.98	        1



