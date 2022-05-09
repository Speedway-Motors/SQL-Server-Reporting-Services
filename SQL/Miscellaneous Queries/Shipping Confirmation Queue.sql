-- Shipping Confirmation Queue

-- run on dw.speedway2.com [TNGRawData]
select * from userInfo.tblorder_shipconfirm_queue WHERE dtAddedUtc < dateadd(d,-2,getdate())

