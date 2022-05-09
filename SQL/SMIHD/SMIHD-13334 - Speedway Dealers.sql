-- SMIHD-13534 - Retail Customer List - 500 for New Checkout
-- copied from SMIHD-13334 - Speedway Dealers

/*
 In states of: Florida, Alabama, Mississippi, Louisiana, Texas, Ohio, Indiana, Illinois, Minnesota
• Have ordered within the past 180 days
• Have an email address listed and are not set to Do not Mail
• Have default billing and shipping addresses
Please include loyalty builder type, customer number, customer name, city/state, email address, last order date
*/


SELECT C.ixCustomer 'Customer',   -- 570
    C.sCustomerFirstName 'FirstName', C.sCustomerLastName 'LastName', 
    C.sMailToCOLine 'COLine', -- sometimes has the business name!?!
    C.sMailToCity 'City', C.sMailToState 'State', 
    C.sEmailAddress 'Email',
    C.sCustomerType 'CustType',
    -- loyalty builder type
    max(dtOrderDate)  'MostRecentOrderDate',
    LB.LoyaltyGroup
into #SMIHD13534RetailCustomers
FROM tblCustomer C
    LEFT JOIN tblOrder O on C.ixCustomer = O.ixCustomer
    LEFT JOIN [DW.SPEEDWAY2.COM].TngRawData.userInfo.tblwebuser WEB on O.ixCustomer = WEB.ixSopCustomer 
                                                                        and (WEB.ixSopCustomer <> 'old-1118269')
    LEFT JOIN [DW.SPEEDWAY2.COM].TngRawData.userInfo.tblwebuser_addressbook AB ON AB.ixWebUser = WEB.ixWebUser
    LEFT JOIN [SMITemp].dbo.SMIHD13534_LB_CustomerType LB ON LB.ixCustomer = C.ixCustomer
WHERE flgDeletedFromSOP = 0
    and C.sCustomerType = 'Retail' -- 1,743
    and C.sEmailAddress is NOT NULL -- 1,632
    and C.sMailToState in ('AL','FL','MS','LA','TX','OH','IN','IL','MN')
    and (C.sMailingStatus is NULL OR C.sMailingStatus = '0') -- 1,442
    and O.sOrderChannel = 'WEB'
  --  and WEB.flgCanEditShippingAddress = 0 -- can't edit their shipping address
    and LB.LoyaltyGroup is NOT NULL
    and AB.flgDefaultBillingAddress = 1
    and AB.flgDefaultShippingAddress = 1
GROUP BY C.ixCustomer, C.sCustomerFirstName, C.sCustomerLastName, 
    C.sMailToCOLine, -- sometimes has the business name!?!
    C.sMailToCity, C.sMailToState, 
    C.sEmailAddress,
    C.sCustomerType,
    LB.LoyaltyGroup
  --  ,WEB.flgCanEditShippingAddress
HAVING  max(dtOrderDate) > '10/06/2018'
ORDER BY max(dtOrderDate)

select * from #SMIHD13534RetailCustomers


SELECT LoyaltyGroup, COUNT(*) customers
FROM #SMIHD13534RetailCustomers
GROUP BY LoyaltyGroup
ORDER BY LoyaltyGroup

DROP TABLE #SMIHD13534RetailCustomers


/*
SELECT * FROM tblStates
where ixState in ('AL','FL','MS','LA','TX','OH','IN','IL','MN')



userInfo.tblwebuser 
Column: flgCanEditShippingAddress 

[DW.SPEEDWAY2.COM].TngRawData.userInfo.tblorder

[DW.SPEEDWAY2.COM].TngRawData.userInfo.tblwebuser.flgCanEditShippingAddress

select top 10 * from [DW.SPEEDWAY2.COM].TngRawData.userInfo.tblwebuser
order by ixSopCustomer desc




-- Loyalty Builder Customer Type data
-- DROP TABLE [SMITemp].dbo.SMIHD13534_LB_CustomerType

    SELECT * FROM [SMITemp].dbo.SMIHD13534_LB_CustomerType

    SELECT LoyaltyGroup, FORMAT(count(*),'###,###') CustCont
    from [SMITemp].dbo.SMIHD13534_LB_CustomerType
    group by LoyaltyGroup
    /*
    Cust
    CoUnt	LoyaltyGroup
    448,159	1_2xBuyers
     33,130	Faders
    122,211	Loyalists
     66,299	Nurturers
     68,587	Underperformers
     33,789	Winbacks
    */

SELECT COUNT(*) FROM [SMITemp].dbo.SMIHD13534_LB_CustomerType           -- 772,175
SELECT COUNT(ixCustomer) FROM [SMITemp].dbo.SMIHD13534_LB_CustomerType  -- 772,175


*/