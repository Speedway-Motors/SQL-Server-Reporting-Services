-- SMIHD-14364 - Buyer info for FB analysis
-- Pull 6 mo buyers/>=$200 customers 6/30/19/>=$200 customers 6/30/19

/*
select * from sys.synonyms
where name like '%loyaltybuilder%'

tblloyaltybuilder_customer

select top 10 * from tng.tblloyaltybuilder_customer

ixWeakSopCustomerNumber
1117230
*/

-- Output for Excel file    
SELECT  O.ixCustomer,       -- 52,269 should be final output
    C.sCustomerFirstName,
    C.sCustomerLastName,
    C.sMailToCity,
    C.sMailToState,
    C.sMailToZip,
    C.sDayPhone,
    C.sCellPhone,
    C.sNightPhone,
    C.sEmailAddress, 
    LB.sLoyaltyGroupRaw 'LoyaltyGroup'
    , MAX(O.dtOrderDate) 'MostRecentOrder' 
    , COUNT(O.ixOrder) 'QualifyingOrders'
    , SUM(mMerchandise) 'QualifiedSales' 
    , SUM(mMerchandiseCost) 'MerchCost'
FROM dbo.tblOrder O
    LEFT JOIN dbo.tblCustomer C on O.ixCustomer = C.ixCustomer
    LEFT JOIN tng.tblloyaltybuilder_customer LB on C.ixCustomer = LB.ixWeakSopCustomerNumber
WHERE O.dtOrderDate >= DATEADD(mm, -6, getdate())  -- 6 months ago
     and O.sOrderType <> 'Internal'
    and O.mMerchandise >= 200
    and O.sOrderStatus in ('Backordered','Open','Shipped') 
    and C.sEmailAddress is NOT NULL
    and sMailToCountry is NULL -- US customers
    and C.flgDeletedFromSOP = 0
GROUP BY O.ixCustomer,  
    C.sCustomerFirstName,
    C.sCustomerLastName,
    C.sMailToCity,
    C.sMailToState,
    C.sMailToZip,
    C.sCellPhone,
    C.sDayPhone,
    C.sNightPhone,
    C.sEmailAddress
    , LB.sLoyaltyGroupRaw
--HAVING count(O.ixOrder)
ORDER BY LB.sLoyaltyGroupRaw --count(O.ixOrder) desc
-- Phone, First Name, Last Name, Zip, City, State, Country
