-- SMIHD-13086	- add sCreditCardLast4Digits field to tblOrder   


select * 
from tblOrder
where dtOrderDate >= '01/01/2019'
    and sMethodOfPayment in ('VISA','MASTERCARD','DISCOVER','AMEX')  -- 15,776 kicked off at 16:23.   ETA 17:28
    and sCreditCardLast4Digits is NULL
    and dtDateLastSOPUpdate < '02/26/19'  


select * 
from tblOrder
where dtOrderDate >= '01/01/2018' -- 15,004 AFCO            4,694 LEFT
and sMethodOfPayment in ('VISA','MASTERCARD','DISCOVER','AMEX') 
and sCreditCardLast4Digits is NULL


select ixOrder, ixCustomer, sMethodOfPayment, sCreditCardLast4Digits 
from tblOrder
where --dtOrderDate >= '01/01/2018' -- 15,004 AFCO            4,694 LEFT
--and sMethodOfPayment in ('VISA','MASTERCARD','DISCOVER','AMEX') 
 sCreditCardLast4Digits = '0000'



SELECT sCreditCardLast4Digits, count(distinct ixCustomer)
from tblOrder
--where sCreditCardLast4Digits in ('1006','2001','3281','3380','4135','5135','5654')
GROUP BY sCreditCardLast4Digits
HAVING  count(distinct ixCustomer) >= 40
ORDER BY sCreditCardLast4Digits



SELECT sCreditCardLast4Digits, count(distinct ixCustomer)
from tblOrder
GROUP BY sCreditCardLast4Digits
ORDER BY count(distinct ixCustomer) desc





