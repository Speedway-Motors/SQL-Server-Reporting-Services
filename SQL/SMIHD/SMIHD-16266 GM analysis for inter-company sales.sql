-- SMIHD-16266 GM analysis for inter-company sales

-- AFCO Sales to SMI
SELECT FORMAT(sum(mMerchandise),'$###,###') 'Sales_AFCOtoSMI', 
    FORMAT(sum(mMerchandiseCost),'$###,###') 'Cogs_AFCOtoSMI',
    FORMAT((sum(mMerchandise)-sum(mMerchandiseCost)),'$###,###') 'GM_AFCOtoSMI'
FROM [AFCOReporting].dbo.tblOrder O
WHERE --ixInvoiceDate between 18629 and 18993 -- 1/1/19 to 12/31/19
ixInvoiceDate between  18264 and 18628 -- 1/1/18 to 12/31/18
--dtOrderDate between '01/01/2018' and '12/31/2018'
    and ixCustomer in (-- 32 SMI accounts
                       '10511','11571','11572','11573','11574','12410','15242','26101','26103','27511',
                       '31173','34795','41138','43648','44776','48319','48398','48400','49948',
                       '50093','50239','51861','52097','53315','55108','55634','58769',
                       '63406','63900','65908','66504','72975')
/*
Sales_AFCOtoSMI	Cogs_AFCOtoSMI	GM_AFCOtoSMI    GM%     YEAR
$2,527,573	        $1,435,864	$1,091,709      43.2%   2019
$5,082,687	    $3,350,572	    $1,732,115      34.1%   2018

aprox 1,800 orders
*/

-- AFCO Sales to SMI  by Customer Account
SELECT O.ixCustomer, sCustomerFirstName , sCustomerLastName,
    FORMAT(sum(mMerchandise),'$###,###') 'Sales_AFCOtoSMI', 
    FORMAT(sum(mMerchandiseCost),'$###,###') 'Cogs_AFCOtoSMI',
    FORMAT((sum(mMerchandise)-sum(mMerchandiseCost)),'$###,###') 'GM_AFCOtoSMI'
FROM [AFCOReporting].dbo.tblOrder O
    left join [AFCOReporting].dbo.tblCustomer C on O.ixCustomer = C.ixCustomer
WHERE --ixInvoiceDate between 18629 and 18993 -- 1/1/19 to 12/31/19
ixInvoiceDate between  18264 and 18628 -- 1/1/18 to 12/31/18
--dtOrderDate between '01/01/2018' and '12/31/2018'
    and O.ixCustomer in (-- 32 SMI accounts
                       '10511','11571','11572','11573','11574','12410','15242','26101','26103','27511',
                       '31173','34795','41138','43648','44776','48319','48398','48400','49948',
                       '50093','50239','51861','52097','53315','55108','55634','58769',
                       '63406','63900','65908','66504','72975')
group by O.ixCustomer, sCustomerFirstName, sCustomerLastName
order by sum(mMerchandise) desc


select ixOrder, dtOrderDate, dtShippedDate, ixShippedDate, ixInvoiceDate, dtInvoiceDate, sOrderStatus
FROM [AFCOReporting].dbo.tblOrder O
    left join [AFCOReporting].dbo.tblCustomer C on O.ixCustomer = C.ixCustomer
WHERE --ixInvoiceDate between 18629 and 18993 -- 1/1/19 to 12/31/19
    ixInvoiceDate between  18264 and 18628 -- 1/1/18 to 12/31/18
    and sOrderStatus = 'Shipped'
    and C.ixCustomer in (-- 32 SMI accounts
                       '10511','11571','11572','11573','11574','12410','15242','26101','26103','27511',
                       '31173','34795','41138','43648','44776','48319','48398','48400','49948',
                       '50093','50239','51861','52097','53315','55108','55634','58769',
                       '63406','63900','65908','66504','72975')

/*
Sales	    Cogs	    GM
$2,527,573	$1,435,864	$1,091,709 -- 43.2%
$5,350,470	$3,502,546	$1,847,923 -- 34.5%
*/



SELECT D.iYear, D.sMonth, D.iYearMonth,
       FORMAT(sum(mMerchandise),'$###,###') 'Sales_SMItoAFCO', 
       FORMAT(sum(mMerchandiseCost),'$###,###') 'Cogs_SMItoAFCO',
FORMAT((sum(mMerchandise)-sum(mMerchandiseCost)),'$###,###') 'GM_SMItoAFCO'
FROM tblOrder O
    left join tblDate D on O.ixInvoiceDate = D.ixDate
WHERE 
--ixInvoiceDate between 18264 and 18993 -- 1/1/18 to 12/31/19
--ixInvoiceDate between 18629 and 18993 -- 1/1/19 to 12/31/19
--ixInvoiceDate between  18264 and 18628 -- 1/1/18 to 12/31/18
    and ixBusinessUnit = 101	--ICS	Inter-company sale	Sales from Speedway to a wholly owned subsidiary.  Sales occur at cost +15%
group by D.iYear, D.sMonth, D.iYearMonth
/*
Sales	    Cogs	    GM          GM%
$1,381,788	$1,230,782	$151,006    10.9    <-- 2019
$1,429,415	$1,261,868	$167,546    11.7    <-- 2018
*/!


-- RUN ON DW
-- SMI Sales to AFCO    by Vendor
-- RUN ON DW
SELECT V.ixVendor 'Vendor',
    V.sName 'VendorName',    
    V.flgOverseas,   
    FORMAT(sum(OL.mExtendedPrice),'$###,###') 'Sales_SMItoAFCO',
    FORMAT(sum(OL.mExtendedCost),'$###,###') 'Cogs_SMItoAFCO',
    FORMAT(sum(OL.mExtendedCost*SPR.dLandedCostMultiplier),'$###,###') 'Cogs_SMItoAFCO_Landed', -- uses Landed Cost
    FORMAT((sum(OL.mExtendedPrice)-sum(OL.mExtendedCost*SPR.dLandedCostMultiplier)),'$###,###') 'GM_SMItoAFCO'
FROM tblOrder O
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
    left join tblSkuProfitabilityRollup SPR on OL.ixSKU = SPR.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS
    left join tblVendorSKU VS on VS.ixSKU = SPR.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS and VS.iOrdinality = 1
    left join tblVendor V on VS.ixVendor = V.ixVendor
WHERE 
    O.ixInvoiceDate between 18629 and 18993 -- 1/1/19 to 12/31/19
    --O.ixInvoiceDate between  18264 and 18628 -- 1/1/18 to 12/31/18
    and O.ixBusinessUnit = 101
    and OL.flgLineStatus = 'Shipped'
GROUP BY V.ixVendor,
    V.sName,
    V.flgOverseas
ORDER BY sum(OL.mExtendedPrice) DESC

-- SMI Sales to AFCO    by month
-- RUN ON DW
SELECT D.iYear,
    D.sMonth,
    D.iMonth,
    --V.ixVendor 'Vendor',
    --V.sName 'VendorName',    
    --V.flgOverseas,   
    FORMAT(sum(OL.mExtendedPrice),'$###,###') 'Sales_SMItoAFCO',
    FORMAT(sum(OL.mExtendedCost),'$###,###') 'Cogs_SMItoAFCO',
    FORMAT(sum(OL.mExtendedCost*SPR.dLandedCostMultiplier),'$###,###') 'Cogs_SMItoAFCO_landed', -- uses Landed Cost
    FORMAT(sum(OL.mExtendedPrice)-sum(OL.mExtendedCost),'$###,###') 'GM_SMItoAFCO',
    FORMAT((sum(OL.mExtendedPrice)-sum(OL.mExtendedCost*SPR.dLandedCostMultiplier)),'$###,###') 'GM_SMItoAFCO_landed'
FROM tblOrder O
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
    left join tblSkuProfitabilityRollup SPR on OL.ixSKU = SPR.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS
    left join tblVendorSKU VS on VS.ixSKU = SPR.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS and VS.iOrdinality = 1
    left join tblVendor V on VS.ixVendor = V.ixVendor
    left join tblDate D on D.ixDate = O.ixInvoiceDate
WHERE 
    O.ixInvoiceDate between 18629 and 18993 -- 1/1/19 to 12/31/19
    --O.ixInvoiceDate between  18264 and 18628 -- 1/1/18 to 12/31/18
    and O.ixBusinessUnit = 101
    and OL.flgLineStatus = 'Shipped'
GROUP BY --V.ixVendor,
    --V.sName,
    --V.flgOverseas
    D.iYear,
    D.sMonth,
    D.iMonth
ORDER BY D.iYear, D.iMonth --sum(OL.mExtendedPrice) DESC
