-- SMIHD-16279 - Longacre purchases by AFCO customers

/*
Can you pull a list AFCO customers that are buying the most Longacre product? Say the top 100 customers (if there are that many)

    Customer #                            LAP
    Customer First & Last name            LAP
    Longacre SKU #
    Speedway SKU # for the product
    SKU Description
    Total Units purchased in 2018, 2019
    Total $ purchased in 2018, 2019
    Per unit price to customer
    AFCO per unit cost
    CURRENT pricelevel1
    CURRENT mLatestCost


QUESTIONS:
exclude customer 10890 (INVENTORY USED BUT NOT SOLD)
flgActive = 1
*/

-- STARTING POOL of customers
-- had combined 2018 & 2019 sales of LA SKUs totalling $10,000+
SELECT O.ixCustomer, C.sCustomerFirstName, C.sCustomerLastName, SUM(OL.mExtendedPrice) 'LA_Sales'    -- 426
-- DROP TABLE [SMITemp].dbo.PJC_SMIHD_16279_LongacrePurchasers
--into [SMITemp].dbo.PJC_SMIHD_16279_LongacrePurchasers
FROM tblOrder O
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
    left join tblCustomer C on O.ixCustomer = C.ixCustomer
    left join tblSKU S on OL.ixSKU = S.ixSKU
WHERE O.dtInvoiceDate between '01/01/2018' and '12/31/2019'
    AND O.sOrderStatus = 'Shipped'
    AND OL.flgLineStatus in ('Shipped','Dropshipped')
    AND S.ixSKU like '52-%' 
    AND S.ixPGC like 'K%'
    AND O.ixCustomer NOT IN ('10511','11571','11572','11573','11574','12410','15242','26101','26103','27511','31173','34795','41138','43648','44776','48319','48398','48400','49948','50093','50239','51861','52097','53315','55108','55634','58769','63406','63900','65908','66504') -- SMI Accounts
    AND O.ixCustomer NOT IN ('10890')
    -- AND S.flgActive = 1
group by O.ixCustomer, C.sCustomerFirstName, C.sCustomerLastName
HAVING SUM(OL.mExtendedPrice) > 1000 -- $1,000+ for pool of customers per Ryan
order by SUM(OL.mExtendedPrice) desc

SELECT LAP.ixCustomer, LAP.sCustomerFirstName, LAP.sCustomerLastName
FROM [SMITemp].dbo.PJC_SMIHD_16279_LongacrePurchasers LAP






SELECT DISTINCT LAP.ixCustomer 'Customer', 
    LAP.sCustomerFirstName 'FirstName', 
    LAP.sCustomerLastName 'LastName',
    SP.ixSKU 'AFCO_SKU',
    VS.ixSKU 'SMI_SKU',
    SP.sDescription 'SKUDescription', 
    VS.ixVendor 'Vendor',
    SP.QtySold,
    SP.mUnitPrice 'UnitPrice', 
    SP.mCost 'UnitCost', 
    SP.Year, 
    SP.Sales,
    --ISNULL(SALES2018.sDescription, SALES2019.sDescription) 'SKUDescription',
    S.mPriceLevel1 'CurrentPriceLevel1',
    S.mAverageCost 'CurrentAvgCost',
    S.mLatestCost 'CurrentLatestCost'
-- INTO #ResultSet -- DROP TABLE #ResultSet
FROM [SMITemp].dbo.PJC_SMIHD_16279_LongacrePurchasers LAP  
    LEFT JOIN (-- SKU Purchases
                SELECT O.ixCustomer, OL.ixSKU, S.sDescription, OL.mUnitPrice, OL.mCost, 
                    (CASE WHEN O.dtInvoiceDate between '01/01/2018' and '12/31/2018' then 2018
                     ELSE 2019
                     END) as 'Year', 
                     SUM(OL.iQuantity) 'QtySold', --OL.mExtendedCost, OL.mExtendedPrice
                     (SUM(OL.iQuantity)*OL.mUnitPrice) 'Sales' --'QtySold
                FROM [SMITemp].dbo.PJC_SMIHD_16279_LongacrePurchasers LAP
                    left join tblOrder O on O.ixCustomer = LAP.ixCustomer
                    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
                    left join tblCustomer C on O.ixCustomer = C.ixCustomer
                    left join tblSKU S on OL.ixSKU = S.ixSKU
                WHERE O.dtInvoiceDate between '01/01/2018' and '12/31/2019'
                    AND O.sOrderStatus = 'Shipped'
                    AND OL.flgLineStatus in ('Shipped','Dropshipped')
                    AND S.ixSKU like '52-%' 
                    AND S.ixPGC like 'K%'
                   -- and S.ixSKU = '52-22552' -- TESTING ONLY    2018= 20 Qty Sold + 2019= 11 Qty Sold   -- 13 total records
                GROUP BY O.ixCustomer, OL.ixSKU, S.sDescription, OL.mUnitPrice, OL.mCost, 
                    (CASE WHEN O.dtInvoiceDate between '01/01/2018' and '12/31/2018' then 2018
                    ELSE 2019
                    END)
                ) SP on SP.ixCustomer = LAP.ixCustomer
    LEFT JOIN tblSKU S on S.ixSKU = SP.ixSKU
    LEFT JOIN [SMI Reporting].dbo.tblVendorSKU VS on VS.sVendorSKU = S.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS 
                                                    and VS.ixVendor in ('0475','0476','9475')
                                                    and VS.iOrdinality = 1
                                                    and VS.ixSKU NOT LIKE 'UP%'
WHERE SP.ixSKU is NOT NULL
ORDER BY LAP.ixCustomer, 'Year'

select AFCO_SKU, count(distinct Vendor)
from #ResultSet
group by AFCO_SKU
order by count(distinct Vendor) desc

select AFCO_SKU, count(distinct SMI_SKU)
from #ResultSet
group by AFCO_SKU
order by count(distinct SMI_SKU) desc

select 

select * from [SMI Reporting].dbo.tblVendor
where ixVendor in ('0001','0475','0476','1729','9475')

select * from [SMI Reporting].dbo.tblVendorSKU
where sVendorSKU = '52-46516'


select sum(Sales)
from #ResultSet                                         -- 10471557.54

select sum(LA_Sales)
FROM [SMITemp].dbo.PJC_SMIHD_16279_LongacrePurchasers

select * from [SMITemp].dbo.PJC_SMIHD_16279_LongacrePurchasers
order by LA_Sales desc


SELECT OL.*
FROM [SMITemp].dbo.PJC_SMIHD_16279_LongacrePurchasers LAP  
    LEFT JOIN tblOrder O on O.ixCustomer = LAP.ixCustomer
     left join tblOrderLine OL on O.ixOrder = OL.ixOrder
                    left join tblCustomer C on O.ixCustomer = C.ixCustomer
                    left join tblSKU S on OL.ixSKU = S.ixSKU
                WHERE O.dtInvoiceDate between '01/01/2018' and '12/31/2019'
                    AND O.sOrderStatus = 'Shipped'
                    AND OL.flgLineStatus in ('Shipped','Dropshipped')
                    AND S.ixSKU like '52-%' 
                    AND S.ixPGC like 'K%'
                    and S.ixSKU = '52-22552' 


SELECT LA_Sales
FROM [SMITemp].dbo.PJC_SMIHD_16279_LongacrePurchasers








/*** discarded attemp to do years in separate sub-queries
FROM [SMITemp].dbo.PJC_SMIHD_16279_LongacrePurchasers LAP
    LEFT JOIN (SELECT O.ixCustomer, OL.ixSKU, S.sDescription, OL.mUnitPrice, OL.mCost, 2018 as 'Year', SUM(OL.iQuantity) 'QtySold' --OL.mExtendedCost, OL.mExtendedPrice
                FROM [SMITemp].dbo.PJC_SMIHD_16279_LongacrePurchasers LAP
                    left join tblOrder O on O.ixCustomer = LAP.ixCustomer
                    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
                    left join tblCustomer C on O.ixCustomer = C.ixCustomer
                    left join tblSKU S on OL.ixSKU = S.ixSKU
                WHERE O.dtInvoiceDate between '01/01/2018' and '12/31/2018'
                    AND O.sOrderStatus = 'Shipped'
                    AND OL.flgLineStatus in ('Shipped','Dropshipped')
                    AND S.ixSKU like '52-%' 
                    AND S.ixPGC like 'K%'
                    and S.ixSKU = '52-22552' -- TESTING ONLY    20 TOT Qty Sold
        GROUP BY O.ixCustomer, OL.ixSKU, S.sDescription, OL.mUnitPrice, OL.mCost --, OL.iQuantity--, OL.mExtendedCost, OL.mExtendedPrice
        --Order by OL.ixSKU, O.ixCustomer, OL.mUnitPrice, OL.mCost
                ) SALES2018 ON LAP.ixCustomer = SALES2018.ixCustomer
    LEFT JOIN (SELECT O.ixCustomer, OL.ixSKU, S.sDescription, OL.mUnitPrice, OL.mCost, 2019 as 'Year', SUM(OL.iQuantity) 'QtySold' --OL.mExtendedCost, OL.mExtendedPrice
                FROM [SMITemp].dbo.PJC_SMIHD_16279_LongacrePurchasers LAP
                    left join tblOrder O on O.ixCustomer = LAP.ixCustomer
                    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
                    left join tblCustomer C on O.ixCustomer = C.ixCustomer
                    left join tblSKU S on OL.ixSKU = S.ixSKU
                WHERE O.dtInvoiceDate between '01/01/2019' and '12/31/2019'
                    AND O.sOrderStatus = 'Shipped'
                    AND OL.flgLineStatus in ('Shipped','Dropshipped')
                    AND S.ixSKU like '52-%' 
                    AND S.ixPGC like 'K%'
                    and S.ixSKU = '52-22552'-- TESTING ONLY      11 TOT Qty Sold
        GROUP BY O.ixCustomer, OL.ixSKU, S.sDescription, OL.mUnitPrice, OL.mCost --, OL.iQuantity--, OL.mExtendedCost, OL.mExtendedPrice
       -- Order by OL.ixSKU, O.ixCustomer, OL.mUnitPrice, OL.mCost
                ) SALES2019 ON LAP.ixCustomer = SALES2018.ixCustomer
WHERE ISNULL(SALES2018.ixSKU, SALES2019.ixSKU) IS NOT NULL
*/




