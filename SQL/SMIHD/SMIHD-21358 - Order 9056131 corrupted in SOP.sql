-- SMIHD-21358 - Order 9056131 corrupted in SOP  


SELECT -- 2,428,418
    ixOrder, O.ixCustomer, BU.sBusinessUnit, 
    FORMAT(dtOrderDate,'MM-dd-yyyy') 'OrderDate', 
    FORMAT(dtShippedDate,'MM-dd-yyyy') 'ShippedDate',  
    FORMAT(dtInvoiceDate, 'MM-dd-yyyy') 'InvoiceDate', 
    FORMAT(O.dtDateLastSOPUpdate,'MM-dd-yyyy') 'SOPLastUpdate', 
    O.mMerchandise 'Merch', sOrderStatus
FROM tblOrder O
	left join tblCustomer C on O.ixCustomer = C.ixCustomer
    left join tblBusinessUnit BU on O.ixBusinessUnit = BU.ixBusinessUnit
WHERE --C.sCustomerType = 'Retail'
 	O.dtOrderDate between '01/01/2017' and '04/30/2021' -- LAST 5 years
	--and O.sOrderType='Retail'	
	and O.sOrderStatus = 'Shipped'
	--and O.sShipToCountry = 'US'
	--and O.ixOrder not like '%-%'
    --and O.ixBusinessUnit NOT IN (101,102,103,104,105,108,109) -- Inter-company sale, Intra-company sale, Employee, Pro Racer,Mr Roadster, Garage Sale, Marketplaces
    --and O.sSourceCodeGiven NOT IN ('AMAZON','AMAZONPRIME','EBAY', 'EBAYGS')
   -- and O.mMerchandise > 1
    and O.ixInvoiceDate is NULL
    and O.ixOrder = '9056131'
order by O.ixOrderDate desc



select * from tblOrder where ixOrder = '9056131'

select * from tblOrderLine where ixOrder = '9056131' -- data in tblOrderLine was cleared when attempting to refeed the order

