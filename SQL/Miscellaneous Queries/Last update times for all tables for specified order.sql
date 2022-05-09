-- Last update times for all tables for specified order

/* all [SMI Reporting] tables that contain field ixOrder as of 10/20/2015

    tblCounterOrderScans	
    tblCreditMemoMaster	
    tblDropship	
    tblGiftCardDetail	<--ixOrderRedeemed     
    tblGiftCardMaster	
    tblOrder	
    tblOrderFreeShippingEligible	
    tblOrderLine	
    tblOrderPromoCodeXref	
    tblOrderRouting	
    tblOrderTiming	
    tblPackage	
    
    TABLES that do not have SOP update fields:
    tblOrderTNT	         
    tblShippingPromo	 
    tblSKUPromo	         
*/

/*  CASE    ixOrder     DB
SMIHD-2524  6842131     SMI
SMIHD-2554  762198-2    AFCO
*/

/*************************************************
    TABLES THAT COMMONLY HAVE ORDER DATA
**************************************************/

SELECT 'tblOrder' as TableName, X.ixOrder, sOrderStatus, CONVERT(VARCHAR(10), X.dtDateLastSOPUpdate, 101) 'dtSOPUpdate', T.chTime 'SOPUpdateTime'
FROM tblOrder X left join tblTime  T on T.ixTime = X.ixTimeLastSOPUpdate
WHERE ixOrder = '762198-2'
/*                                                  SOPUpdate
TableName	ixOrder	    sOrderStatus    dtSOPUpdate	Time
tblOrder	6842131	                    10/13/2015	11:57:57  
tblOrder	762198-2	Shipped	        10/21/2015	08:57:10   
*/

SELECT 'tblOrderLine' as TableName, X.ixOrder, CONVERT(VARCHAR(10), X.dtDateLastSOPUpdate, 101) 'dtSOPUpdate', T.chTime 'SOPUpdateTime', X.ixSKU
FROM tblOrderLine X left join tblTime  T on T.ixTime = X.ixTimeLastSOPUpdate
WHERE ixOrder = '762198-2'
/*                                      SOPUpdate
TableName	    ixOrder	    dtSOPUpdate	Time	    ixSKU
tblOrderLine	6842131	    10/20/2015	08:32:54  	999
tblOrderLine	6842131	    10/20/2015	08:32:54  	COMINVOICE
tblOrderLine	6842131	    10/20/2015	08:32:54  	HELP
tblOrderLine	6842131	    10/20/2015	08:32:54  	READNOTE

tblOrderLine	762198-2	10/21/2015	08:57:10  	6620012
*/

SELECT 'tblPackage' as TableName, X.ixOrder, CONVERT(VARCHAR(10), X.dtDateLastSOPUpdate, 101) 'dtSOPUpdate', T.chTime 'SOPUpdateTime'
FROM tblPackage X left join tblTime  T on T.ixTime = X.ixTimeLastSOPUpdate
WHERE ixOrder = '762198-2'
/*                                  SOPUpdate
TableName	ixOrder	    dtSOPUpdate	Time
tblPackage	6842131	    10/13/2015	13:28:30  
tblPackage	6842131	    10/13/2015	15:37:00  
tblPackage	6842131	    10/13/2015	15:37:01 

tblPackage	762198-2	10/08/2015	19:10:42   
*/

SELECT 'tblOrderTiming' as TableName, X.ixOrder, CONVERT(VARCHAR(10), X.dtDateLastSOPUpdate, 101) 'dtSOPUpdate', T.chTime 'SOPUpdateTime'
FROM tblOrderTiming X left join tblTime  T on T.ixTime = X.ixTimeLastSOPUpdate
WHERE ixOrder = '762198-2'
/* 
TableName	    ixOrder	dtSOPUpdate	SOPUpdateTime
tblOrderTiming	NO DATA
*/


SELECT 'tblOrderPromoCodeXref' as TableName, X.ixOrder, CONVERT(VARCHAR(10), X.dtDateLastSOPUpdate, 101) 'dtSOPUpdate', T.chTime 'SOPUpdateTime'
FROM tblOrderPromoCodeXref X left join tblTime  T on T.ixTime = X.ixTimeLastSOPUpdate
WHERE ixOrder = '762198-2'
/* 
TableName	            ixOrder	dtSOPUpdate	SOPUpdateTime
tblOrderPromoCodeXref   NO DATA  
*/

SELECT 'tblOrderRouting' as TableName, X.ixOrder, CONVERT(VARCHAR(10), X.dtDateLastSOPUpdate, 101) 'dtSOPUpdate', T.chTime 'SOPUpdateTime'
FROM tblOrderRouting X left join tblTime  T on T.ixTime = X.ixTimeLastSOPUpdate
WHERE ixOrder = '762198-2'
/*                                      SOPUpdate
TableName	    ixOrder	    dtSOPUpdate	Time
tblOrderRouting	NO DATA

tblOrderRouting	762198-2	09/23/2015	10:55:32  
*/



/*************************************************
    TABLES LESS COMMONLY USED FOR ORDERS
**************************************************/

SELECT 'tblCounterOrderScans' as TableName, X.ixOrder, CONVERT(VARCHAR(10), X.dtDateLastSOPUpdate, 101) 'dtSOPUpdate', T.chTime 'SOPUpdateTime'
FROM tblCounterOrderScans X left join tblTime  T on T.ixTime = X.ixTimeLastSOPUpdate
where ixOrder = '762198-2'
/* 
TableName	ixOrder	dtSOPUpdate	SOPUpdateTime
tblCounterOrderScans      NO DATA    
*/


SELECT 'tblCreditMemoMaster' as TableName, X.ixOrder, CONVERT(VARCHAR(10), X.dtDateLastSOPUpdate, 101) 'dtSOPUpdate', T.chTime 'SOPUpdateTime'
FROM tblCreditMemoMaster X left join tblTime  T on T.ixTime = X.ixTimeLastSOPUpdate
where ixOrder = '762198-2'
/* 
TableName	ixOrder	dtSOPUpdate	SOPUpdateTime
tblGiftCardMaster      NO DATA    
*/


SELECT 'tblDropship' as TableName, X.ixOrder, CONVERT(VARCHAR(10), X.dtDateLastSOPUpdate, 101) 'dtSOPUpdate', T.chTime 'SOPUpdateTime'
FROM tblDropship X left join tblTime  T on T.ixTime = X.ixTimeLastSOPUpdate
where ixOrder = '762198-2'
/* 
TableName	ixOrder	dtSOPUpdate	SOPUpdateTime
tblDropship NO DATA    
*/


SELECT 'tblGiftCardDetail' as TableName, X.ixOrderRedeemed, CONVERT(VARCHAR(10), X.dtDateLastSOPUpdate, 101) 'dtSOPUpdate', T.chTime 'SOPUpdateTime'
FROM tblGiftCardDetail X left join tblTime  T on T.ixTime = X.ixTimeLastSOPUpdate
where ixOrderRedeemed = '762198-2'
/* 
TableName	        ixOrderRedeemed dtSOPUpdate	SOPUpdateTime
tblGiftCardDetail   NO DATA    
*/


SELECT 'tblGiftCardMaster' as TableName, X.ixOrder, CONVERT(VARCHAR(10), X.dtDateLastSOPUpdate, 101) 'dtSOPUpdate', T.chTime 'SOPUpdateTime'
FROM tblGiftCardMaster X left join tblTime  T on T.ixTime = X.ixTimeLastSOPUpdate
where ixOrder = '762198-2'
/* 
TableName	ixOrder	dtSOPUpdate	SOPUpdateTime
tblGiftCardMaster      NO DATA    
*/


SELECT 'tblOrderFreeShippingEligible' as TableName, X.ixOrder, CONVERT(VARCHAR(10), X.dtDateLastSOPUpdate, 101) 'dtSOPUpdate', T.chTime 'SOPUpdateTime'
FROM tblOrderFreeShippingEligible X left join tblTime  T on T.ixTime = X.ixTimeLastSOPUpdate
WHERE ixOrder = '762198-2'
/* 
TableName	                    ixOrder	dtSOPUpdate	SOPUpdateTime
tblOrderFreeShippingEligible    NO DATA 
*/





-- TABLES WITHOUTH SOP update fields
SELECT * FROM tblOrderTNT
WHERE ixOrder = '762198-2'

SELECT * FROM tblShippingPromo
WHERE ixOrder = '762198-2'

SELECT * FROM tblSKUPromo
WHERE ixOrder = '762198-2'

