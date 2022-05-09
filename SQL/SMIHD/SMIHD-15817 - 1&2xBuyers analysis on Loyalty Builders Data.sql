-- SMIHD-15817 - 1&2xBuyers analysis on Loyalty Builders Data

-- FIRST GROUP = 41,583  unique email addresses
select-- count(distinct C.sEmailAddress) 
    distinct C.sEmailAddress
from [userInfo].tblloyaltybuilder_customer LBC -- 966,683
    left join [DW].dbo.tblCustomer C on LBC.ixWeakSopCustomerNumber = C.ixCustomer
where sLoyaltyGroupRaw = '1&2xBuyers'   -- 655,584
    and ixWeakSopCustomerNumber in (SELECT ixCustomer
                       from [DW].dbo.tblOrder O
                       WHERE O.sOrderStatus = 'Shipped'
                            and O.dtShippedDate between '11/20/2018' and '11/19/2019'
                            and O.sOrderType <> 'Internal'   -- normally filtered
                            and O.mMerchandise > 0 -- > 1 if looking at non-US orders
                      ) -- 206,144
    and dAverageOrderValue >= 150  -- 57,111
    and C.sEmailAddress is NOT NULL -- 41,990
order by C.sEmailAddress



-- SECOND GROUP = 40,802 unique email addresses
select-- count(distinct C.sEmailAddress) 
    distinct C.sEmailAddress
from [userInfo].tblloyaltybuilder_customer LBC -- 966,683
    left join [DW].dbo.tblCustomer C on LBC.ixWeakSopCustomerNumber = C.ixCustomer
where sLoyaltyGroupRaw = '1&2xBuyers'   -- 655,584
    and ixWeakSopCustomerNumber NOT in (SELECT ixCustomer
                       from [DW].dbo.tblOrder O
                       WHERE O.sOrderStatus = 'Shipped'
                            and O.dtShippedDate between '11/20/2018' and '11/19/2019'
                            and O.sOrderType <> 'Internal'   -- normally filtered
                            and O.mMerchandise > 0 -- > 1 if looking at non-US orders
                      ) -- 206,144
    and ixWeakSopCustomerNumber in (SELECT ixCustomer
                       from [DW].dbo.tblOrder O
                       WHERE O.sOrderStatus = 'Shipped'
                            and O.dtShippedDate between '7/20/2017' and '11/19/2018'
                            and O.sOrderType <> 'Internal'   -- normally filtered
                            and O.mMerchandise > 0 -- > 1 if looking at non-US orders
                      ) -- 206,144
    and dAverageOrderValue >= 150  -- 57,111
    and C.sEmailAddress is NOT NULL -- 41,990
order by C.sEmailAddress




SELECT TOP 10 * FROM  [userInfo].tblloyaltybuilder_customer

 - Customer is a 1&2x Buyer (In the Loyalty_Group field, 1&2xBuyers)
 - Customer has purchased within the past 12 months
 - Customers AOV (in the AVGORDERVALUE field) was >= to $150

dAverageOrderValue
197.97

1117230


sLoyaltyGroupRaw
Winbacks