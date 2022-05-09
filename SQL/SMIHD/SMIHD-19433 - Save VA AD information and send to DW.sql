-- SMIHD-19433 - Save VA/AD information and send to DW

-- AUTH STATUS

-- last 3 months
Select ixAuthorizationStatus, FORMAT(count(*),'###,###') 'Orders'--, sOrderStatus
from tblOrder
where dtOrderDate >= '09/01/2020'
    and ixOrder not like 'P%'
    and ixOrder not like 'Q%'
    and sOrderStatus NOT IN ('Cancelled')
group by  ixAuthorizationStatus--, sOrderStatus
order by count(*) desc,ixAuthorizationStatus

select ixOrder from tblOrder
where dtOrderDate >= '8/01/2020'
and ixAuthorizationStatus in ('ER','H','HC','P-RET-OK','PLOK','HOLD-OK','OK*PSG','P-CAR2-H','2WH','HCL','OK*AUTHOLD','OK*FBA*PSG','P-CDM2-OK','P-DGP-H','P-JPR1-OK','P-RDV-OK','P-TJR-AD')
    and ixOrder not like 'P%'
    and ixOrder not like 'Q%'


    