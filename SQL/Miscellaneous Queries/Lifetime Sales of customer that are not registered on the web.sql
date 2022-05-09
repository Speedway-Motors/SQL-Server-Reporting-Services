-- Lifetime Sales of customer that are not registered on the web
-- RUN ON dw.speedway2.com
userInfo.tblwebuser.ixUserProfile

if that is null, no registration at all

if it has a value, it could either be a website login, or a facebook login

SELECT COUNT(*) FROM tng.tblwebuser

SELECT COUNT(distinct ixSOPCustomer) 
FROM tng.tblwebuser         -- 1,879,047
where ixUserProfile is NULL -- 1,689,082

-- Lifetime Sales of customer that are not registered on the web
SELECT O.ixCustomer, C.sCustomerFirstName, C.sCustomerLastName,  
    FORMAT(SUM(O.mMerchandise),'$###,###') LifetimeSales -- orders 2006 - present
FROM tblOrder O
    left join tblCustomer C on O.ixCustomer = C.ixCustomer
    left join tng.tblwebuser WU on CAST(C.ixCustomer AS varchar(15)) = WU.ixSOPCustomer
WHERE O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.mMerchandise > 0
    and WU.ixUserProfile is NULL
GROUP BY O.ixCustomer, C.sCustomerFirstName, C.sCustomerLastName
ORDER BY SUM(O.mMerchandise) desc

-- 2 year Sales of customer that are not registered on the web
SELECT O.ixCustomer, C.sCustomerFirstName, C.sCustomerLastName,  
    FORMAT(SUM(O.mMerchandise),'$###,###') LifetimeSales -- orders 2006 - present
FROM tblOrder O
    left join tblCustomer C on O.ixCustomer = C.ixCustomer
    left join tng.tblwebuser WU on CAST(C.ixCustomer AS varchar(15)) = WU.ixSOPCustomer
WHERE O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.mMerchandise > 0
    and O.dtShippedDate >= '06/07/2017'
    and WU.ixUserProfile is NULL
GROUP BY O.ixCustomer, C.sCustomerFirstName, C.sCustomerLastName
ORDER BY SUM(O.mMerchandise) desc

select O.ixCustomer, C.sCustomerFirstName, C.sCustomerLastName,  -- 1.1m out of 1.3m
    FORMAT(SUM(O.mMerchandise),'$###,###') Sales
FROM tblOrder O
    left join tblCustomer C on O.ixCustomer = C.ixCustomer
where O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.mMerchandise > 0
GROUP BY O.ixCustomer, C.sCustomerFirstName, C.sCustomerLastName
ORDER BY SUM(O.mMerchandise) desc