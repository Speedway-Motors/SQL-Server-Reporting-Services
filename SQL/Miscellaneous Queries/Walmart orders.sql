-- Walmart orders
select ixOrder, dtOrderDate
    , mMerchandise, mMerchandiseCost
    , (mMerchandise-mMerchandiseCost) 'GM'
    , sOrderStatus, sOrderChannel
from tblOrder O
where sOrderChannel = 'WALMART'
ORDER BY dtOrderDate desc
