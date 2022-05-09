-- SMIHD-16434 - Loyalty Builders 1&2 time buyers

-- Marketing > Retargetting Customer Groups.rdl

/*
From the Loyalty Builders table,

Fields to include are:
CUSTOMER_ID_
Customer Email address --  - (we do not get email address back from LB), 
TOTALORDERS
TOTALREVENUE
AVGORDERVALUE
BRAND_ORDERED
PRODUCT_CATEGORY
LOYALTY_GROUP

ZERO_TO_THREE_ORDER_CNT
ZERO_TO_THREE_ORDER_REV
ZERO_TO_SIX_ORDER_CNT
ZERO_TO_SIX_ORDER_REV
ZERO_TO_NINE_ORDER_CNT
ZERO_TO_NINE_ORDER_REV
ZERO_TO_TWELVE_ORDER_CNT
ZERO_TO_TWELVE_ORDER_REV

RISK_SCORE
LIKELY_BUYER_SCORE
EXPECTED_VALUE
PRIMARYMARKET

where Loyalty_Group = 1&2xBuyers only.

The table has been updated for this month already. We will want to run this each month so if you would like to set this up as an on-demand report where I could select 
the Loyalty Group to pull that would be great. The addition of the email address tied to the customer number may make this harder/not do-able.
*/

select sLoyaltyGroupRaw, FORMAT(count(LBC.ixWeakSopCustomerNumber),'###,###') CustCnt
from  [tng].[tblloyaltybuilder_customer] LBC
    left join tblCustomer C on LBC.ixWeakSopCustomerNumber = C.ixCustomer
WHERE C.sEmailAddress is NOT NULL
group by sLoyaltyGroupRaw
order by count(LBC.ixWeakSopCustomerNumber) desc

/* Retargeting Customer Groups
    ver 20.5.1
*/
DECLARE @LoyaltyGroup varchar(25)
SELECT @LoyaltyGroup = 'Loyalists' -- 1&2xBuyers, Loyalists, Nurturers, Underperformers, Winbacks, Faders

SELECT top 100 -- 
    --count(*) -- 995,645
    LBC.ixWeakSopCustomerNumber 'Customer', 
    C.sEmailAddress 'Email',
    LBC.iTotalOrders 'TotalOrders', 
    LBC.dTotalRevenue 'TotalRev',
    LBC.dAverageOrderValue 'AOV', 
    LBC.sBrandOrderedRaw 'BrandOrdered',    
    LBC.sProductCategoryRaw 'ProductCat', 
    LBC.sLoyaltyGroupRaw 'LoyaltyGroup', 
    LBC.iZeroToThreeOrderCount 'OrderCount0-3', 
    LBC.dZeroToThreeOrderRevenue 'OrderRev0-3', 
    LBC.iZeroToSixOrderCount 'OrderCount0-6', 
    LBC.dZeroToSixOrderRevenue'OrderRev0-6', 
    LBC.iZeroToNineOrderCount 'OrderCount0-9',  
    LBC.dZeroToNineOrderRevenue'OrderRev0-9', 
    LBC.iZeroToTwelveOrderCount 'OrderCount0-12', 
    LBC.dZeroToTwelveOrderRevenue'OrderRev0-12', 
    LBC.dRiskScore 'RiskScore', 
    LBC.dLikelyBuyerScore 'LikelyBuyerScore', 
    LBC.dExpectedValue 'ExpectedValue', 
    LBC.sPrimaryMarket 'PrimaryMarket'
    --, dtCreateUtc, dtLastUpdateUtc, sCreateUser, sUpdateUser, ixLoyaltyBuilder
FROM [tng].[tblloyaltybuilder_customer] LBC
    left join tblCustomer C on C.ixCustomer = LBC.ixWeakSopCustomerNumber
WHERE sLoyaltyGroupRaw in (@LoyaltyGroup) --'1&2xBuyers' -- 685,024
    and C.sEmailAddress is NOT NULL -- 127,629
ORDER BY LBC.dTotalRevenue -- desc


