-- order in tblOrder but not tblHoldCodeAuditHistory
SELECT ixOrder, dtOrderDate, sOrderStatus, mPaymentProcessingFee, dtDateLastSOPUpdate, ixTimeLastSOPUpdate 
FROM tblOrder
where ixOrder = '11487819'
/*
ixOrder		dtOrderDate	sOrderStatus	mPaymentProcessingFee	dtDateLastSOPUpdate	ixTimeLastSOPUpdate
11487819	2022-04-06 	Open			0.00					2022-04-06 			44394
*/

-- SELECT top 10 * FROM tblHoldCodeAuditHistory

SELECT * 
FROM tblHoldCodeAuditHistory
WHERE ixOrder = '11487819'




-- Shipped order that was initially held but then shipped.  No payment processing fee assigned.  why?


SELECT ixOrder, dtOrderDate, dtShippedDate, sOrderStatus, mPaymentProcessingFee, dtDateLastSOPUpdate, ixTimeLastSOPUpdate 
FROM tblOrder
where ixOrder = '11488710'
/*
ixOrder	dtOrderDate	dtShippedDate	sOrderStatus	mPaymentProcessingFee	dtDateLastSOPUpdate	ixTimeLastSOPUpdate
11488710	2022-04-06 00:00:00.000	2022-04-06 00:00:00.000	Shipped	4.58	2022-04-07 00:00:00.000	1713
*/

select * from tblTime 
where ixTime = 1713 -- 00:28:33  

The order was taken and shipped 4/6, the order last refed at 12:28am on 4/7... 