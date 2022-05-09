-- Web Order Reject Reason Summary

select 
        (CASE WHEN sRejectReason like 'Shipping charge difference%' then 'SH charge difference'
             WHEN sRejectReason like 'Backorder status for SKU%' then 'SKU Backordered'
             WHEN sRejectReason like 'Item price different for SKU%' then 'Item Price difference'
             WHEN sRejectReason like 'This order may be a duplicate%' then 'Possible dupe order'
             WHEN sRejectReason like 'No Billto customer%' then 'Billto cust address or name field missing'
             WHEN sRejectReason like 'AFCO dropship for SKU%' then 'AFCO dropship'
             WHEN sRejectReason like 'WEIGHT%EXCEEDS MAX (9)' then 'WEIGHT EXCEEDS MAX (9)'
             WHEN sRejectReason like 'Shipping method not valid for ORMD SKU%' then 'Ship method not valid for ORMD SKU'
        else sRejectReason
        end) sRejectReason,
        count(ixWebOrderRejectReason) 'Reject Reasons',
        count(distinct ixOrder) 'Distinct Orders'
from dbo.tblWebOrderRejectReason
WHERE dtOrderDate >= '04/21/2019'
group by (CASE WHEN sRejectReason like 'Shipping charge difference%' then 'SH charge difference'
             WHEN sRejectReason like 'Backorder status for SKU%' then 'SKU Backordered'
             WHEN sRejectReason like 'Item price different for SKU%' then 'Item Price difference'
             WHEN sRejectReason like 'This order may be a duplicate%' then 'Possible dupe order'
             WHEN sRejectReason like 'No Billto customer%' then 'Billto cust address or name field missing'
             WHEN sRejectReason like 'AFCO dropship for SKU%' then 'AFCO dropship'
             WHEN sRejectReason like 'WEIGHT%EXCEEDS MAX (9)' then 'WEIGHT EXCEEDS MAX (9)'
             WHEN sRejectReason like 'Shipping method not valid for ORMD SKU%' then 'Ship method not valid for ORMD SKU'
        else sRejectReason
        end) 
order by sRejectReason