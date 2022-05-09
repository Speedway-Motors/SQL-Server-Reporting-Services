-- Case 7093 - Phone Order Timing Analysis
/*
 join tblOrderTiming & tblOrder on ixOrder, and display the columns from tblOrderTiming + user name.

@ ixEmployee, 
date range
order type
method of payment

(12:17 PM) pjcrews: multiple selects for ixEmployee & MoP ?
(12:17 PM) pjcrews: ie give them a drop-down for both so they can select one, multiple or all?
*/
select top 10 * from tblOrder
SELECT MAX(ixOrder) from tblOrderTiming

select top 10 * from tblOrderTiming
/*
ixOrder	iMailingAddress	iOrderSummary	iLineItems	iBillingAddress	iMethodOfPayment	iMethodOfShipping	iShippingAddress
3228247	0	            3	            72	        11	            23	                7	                13
4295508	0	            25	            9	        0	            99              	11	                69
4301905	0	            4	            28	        NULL        	0	                1	                4
4302902	0	            3	            89	        9	            91              	1	                0
4306900	5	            8	            61	        NULL        	2	                8	                454
4314701	0	            10	            135     	11	            28              	13	                40
4315603	0	            12	            627     	6	            28              	NULL            	27
4318500	72	            8	            115	        15	            33              	9	                55
4320900	0	            31	            49	        20	            33              	8	                82
4322902	4	            64	            135	        48	            36              	10	                135
*/

DECLARE 
@StartDate DateTime 
'02/11/2011' as @StartDate



SELECT 
    E.ixEmployee               OrderTakerInit, 
    E.sFirstname + ' ' + E.sLastname OrderTakerName,
    isNull(O.sMethodOfPayment, 'NULL'),
    count(distinct O.ixOrder)  OrderCount,
    Avg(OT.iLineItems)         AvgMailingAdd,
    Avg(OT.iMethodOfPayment)   MethodOfPayment,
    Avg(OT.iBillingAddress)    BillingAddress,
    Avg(OT.iShippingAddress)   ShippingAddress,
    Avg(OT.iMethodOfShipping)  MethodOfShipping,
    Avg(OT.iOrderSummary)      OrderSummary,
    Avg(OT.iMailingAddress)    MailingAddress
FROM
    tblOrder O
    join tblOrderTiming OT  on O.ixOrder = OT.ixOrder
    join tblEmployee E      on E.ixEmployee = O.sOrderTaker
WHERE 
        O.dtOrderDate > '02/01/2011'
    and O.dtOrderDate <= '02/08/2011'
    and O.sOrderType = 'Retail' --in (@OrderType)
    --and O.iMethodOfPayment in (@MoP)
    and E.ixEmployee = 'RRZ' --in (@Employee)
GROUP BY
    E.ixEmployee, 
    E.sFirstname + ' ' + E.sLastname,
isNull(O.sMethodOfPayment, 'NULL')




select distinct sOrderType
from tblOrder


select * tblDepartment


select * from tblEmployee where flgCurrentEmployee = 1




select * from tblOrder
where sMethodOfPaymnent is Null