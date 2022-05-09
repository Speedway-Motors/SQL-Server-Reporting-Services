-- verify tng and SMIReporting have the same Guaranteed Delivery dates
SELECT a.OrderNumber, a.tngGuaranteedDeliveryDate, O.dtGuaranteedDelivery SMIRepGrntdDelivery, O.sOrderStatus, O.sOrderChannel, O.dtOrderDate, O.dtDateLastSOPUpdate 
from openquery([TNGREADREPLICA], 
        'SELECT o.ixSopOrderNumber AS OrderNumber, 
            ogs.dtExpectedDeliveryDate AS tngGuaranteedDeliveryDate, 
            o.dtOrderDate as OrderDate 
        FROM userInfo.tblorder_guaranteedshipping ogs 
            INNER JOIN userInfo.tblorder o ON ogs.ixOrder = o.ixOrder 
            INNER JOIN userInfo.tblorder_status os ON o.ixOrderStatus = os.ixOrderStatus
        WHERE flgGuaranteedShipping = 1
           -- AND os.sOrderStatus in (''Open'') -- Only need to check the status of the order (is good enough)
           -- AND ogs.dtExpectedDeliveryDate <= DATE(NOW())
            AND ogs.dtExpectedDeliveryDate > DATE_ADD(DATE(NOW()), INTERVAL -7 DAY) -- For performance use a cutoff
        ORDER BY ogs.dtExpectedDeliveryDate ASC, o.ixOrder
        ;
        '
        ) a
join tblOrder O on a.OrderNumber COLLATE SQL_Latin1_General_CP1_CI_AS = O.ixOrder COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE O.dtGuaranteedDelivery is NULL
/*     OR 
    (a.tngGuaranteedDeliveryDate <> O.dtGuaranteedDelivery)
*/    
ORDER BY O.dtDateLastSOPUpdate  -- a.tngGuaranteedDeliveryDate, O.dtGuaranteedDelivery


-- originally 318 SMIReporting orders had no grntd delivery date but tng did
-- after refeeding all of them 


select ixDate, COUNT(*) from tblSnapshotSKU
where ixDate >= 17712
group by ixDate
order by ixDate 
/*
267421
312671
312566
312463
312463
312463
*/




userInfo.tblorder_guaranteedshipping.dtExpectedDeliveryDate 

