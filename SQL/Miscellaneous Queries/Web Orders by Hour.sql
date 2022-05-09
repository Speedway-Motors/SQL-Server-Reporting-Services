

-- Web Orders by Hour
select T.iHour, count(O.sWebOrderID) 'WebOrderCnt'
from tblOrder O
    left join tblTime T on O.ixOrderTime = T.ixTime
where dtOrderDate = '10/18/2019'
group by T.iHour 
order by T.iHour desc

select T.iHour, count(O.sWebOrderID) 'WebOrderCnt'
from tblOrder O
    left join tblTime T on O.ixOrderTime = T.ixTime
where dtOrderDate = '09/03/2019'
group by T.iHour 
order by T.iHour desc

-- hourly Avg of the previous 3 Thursdays - 
select T.iHour, count(O.sWebOrderID)/3 'WebOrderCnt'
from tblOrder O
    left join tblTime T on O.ixOrderTime = T.ixTime
where dtOrderDate in ('08/15/2019','08/08/2019', '08/01/2019')
group by T.iHour 
order by T.iHour desc


and sWebOrderID is NOT NULL
order by ixOrderTime

select ixOrder, dtOrderDate, sOrderStatus, iShipMethod
from tblOrder
where iShipMethod = 1
and ixOrderDate = 18926

select * from tblTime T

select * from tblOrder
where dtOrderDate = '08/22/2019'
and sShipToState = 'NE'
and iShipMethod = 1

select * from tblCustomer where sCustomerLastName = 'SHEIL'

select * from tblCounterOrderScans where ixOrder = '8926371'

select * from tblTime where ixTime = 53173 -- 14:46:13 

-- 2:17 


select * from tblCounterOrderScans where ixOrder in ('8787270','8791274','8709375','8726371','8731374','8741373','8745378','8756371','8757372','8768372','8771372','8776376','8777373','8795371','8797370','8708472','8723477','8724472','8724476','8734470','8741479','8702576','8748572','8754579','8769576','8787579','8798570','8701675','8707673','8718670','8727676','8736675','8747673','8753673','8764671','8772673','8773677','8783679','8733772','8783772','8787777','8700879','8706870','8717873','8721870','8733872','8756870','8758879','8767873','8774876','8779878','8779877','8779879','8787873','8789871','8789874','8792871','8794874','8798877','8798879','8703976','8706975','8708971','8709973','8728974','8796970','8810074','8812072','8818079','8823079','8832078','8836075','8841077','8847078','8851078','8852079','8854075','8861070','8885072','8887077','8891078','8803172','8821178','8822179','8837174','8880174','8882174','8887176','8890175','8802273','8810275','8811270','8842279','8856270','8865277','8872278','8876275','8809379')

