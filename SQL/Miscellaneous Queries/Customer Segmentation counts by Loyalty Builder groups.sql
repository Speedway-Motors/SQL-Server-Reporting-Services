-- Customer Segmentation counts by Loyalty Builder groups
select distinct sLoyaltyGroupRaw 'LoyaltyGroup', count(1)
from  [tng].[tblloyaltybuilder_customer] LBC
group by sLoyaltyGroupRaw
order by sLoyaltyGroupRaw
