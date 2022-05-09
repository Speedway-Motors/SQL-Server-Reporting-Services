-- SMIHD-15477 - Send Returns Data to Loyalty Builders

/*
SMI - Transactions 01012009 to 10312019.txt

custid	itemid	    txdate	            quantity	amount	            order_channel
409605	582528	    2019-04-09 00:00:00	5	        -14.949999999999999	PHONE
3130318	69821504	2019-04-09 00:00:00	1	        -19.989999999999998	PHONE
*/


select top 10 * from vwLBSampleTransactions
select top 10 * from tblCreditMemoDetail
select top 10 * from tblCreditMemoMaster
select top 10 * from tblOrder





SELECT CMM.ixCustomer 'custid', 
    CMD.ixSKU 'itemid',
    convert(varchar,CMM.dtCreateDate,101)  as 'txdate',
    (CMD.iQuantityCredited*-1) 'quantity',
    (CMD.mExtendedPrice*-1) 'amount',
    O.sOrderChannel 'order_channel'
INTO #TEMP
from tblCreditMemoDetail CMD
    left join tblCreditMemoMaster CMM on CMD.ixCreditMemo = CMM.ixCreditMemo
    left join tblOrder O on CMM.ixOrder = O.ixOrder
    left join tblCustomer C on C.ixCustomer = CMM.ixCustomer
--    left join tblOrderLine OL on OL.ixOrder = O.ixOrder
--    left join tblSKU SKU on SKU.ixSKU = CMD.ixSKU
--	left join tblSKULocation SL on SKU.ixSKU = SL.ixSKU and SL.ixLocation=99
WHERE CMM.flgCanceled = 0
    and sCustomerType = 'Retail'
    and CMM.dtCreateDate between '01/01/2009' and '10/31/2019'
    and O.sOrderType='Retail'	
	and O.sOrderStatus = 'Shipped'
	and O.sShipToCountry='US'
    and O.ixOrder not like '%-%'
--	and OL.flgLineStatus IN ('Shipped','Dropshipped') -- SMIHD-3538	
--	and OL.flgKitComponent = 0
---	and SKU.flgIntangible=0
--	and OL.mExtendedPrice > 0
--	and OL.ixSKU not like 'HELP%'   
--	and SKU.sDescription not like '%CATALOG%' 
--	and SL.sPickingBin not like '%!%'

DROP TABLE #TEMP

SELECT FORMAT(SUM(amount),'###,###.###') 'amount'
FROM #TEMP

SELECT FORMAT(SUM(quantity),'###,###') 'amount'
FROM #TEMP

        SELECT COUNT(*) FROM #TEMP
/***  2009 to present
 837,817,341 SALES          17,338,809
 -41,858,014 CREDITS          -598,013
***/

SELECT TOP 10000 *
FROM #TEMP
order by newid()

