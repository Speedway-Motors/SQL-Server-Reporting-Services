-- Loyalty Builder groups on DW
SELECT top 10 * from [tng].[tblloyaltybuilder_customer]
ORDER BY dtCreateUtc desc

SELECT FORMAT(count(*),'###,###') CustCount -- 883,626
FROM [tng].[tblloyaltybuilder_customer]

SELECT sLoyaltyGroupRaw, FORMAT(count(*),'###,###') CustCount
FROM [tng].[tblloyaltybuilder_customer]
GROUP BY sLoyaltyGroupRaw
ORDER BY count(*) DESC

/*
CustCount	sLoyaltyGroupRaw
=========   ================
588,359	    1&2xBuyers
100,949 	Loyalists
 65,555	    Underperformers
 56,877	    Nurturers
 39,209	    Winbacks
 32,677	    Faders

 */
