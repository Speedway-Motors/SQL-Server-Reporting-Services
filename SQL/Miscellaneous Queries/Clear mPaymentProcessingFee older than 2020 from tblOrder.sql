-- Clear mPaymentProcessingFee older than 2020 from tblOrder

SELECT FORMAT(count(*),'###,###') 'RecCnt' -- 8.9m orders!    
from tblOrder
where ixShippedDate >= 19360 -- 1/1/2021
    and mPaymentProcessingFee > 0

-- NEED TO UPDATE STORED PROC TO NOT POPULATE PRIOR TO 2020 AND START CLEARING!
-- 9m orders would take AWS 45 hours to update!
-- since that's not the only feed, it's more like double that.  90 hours or 4 DAYS!!!



SET ROWCOUNT 50000

BEGIN TRAN                  -- 445K     
                            -- 9 batches    1 to go
    UPDATE tblOrder
    SET mPaymentProcessingFee = 0
    where ixShippedDate < 19360
        and mPaymentProcessingFee > 0

ROLLBACK TRAN 


SELECT FORMAT(count(*),'###,###') 'RecCnt' -- 8.9m orders!    
from tblOrder
where ixShippedDate >= 19360 -- 1/1/2021
    and mPaymentProcessingFee > 0