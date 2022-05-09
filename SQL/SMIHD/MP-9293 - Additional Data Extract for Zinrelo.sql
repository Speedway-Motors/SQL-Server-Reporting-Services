-- MP-9293 - Additional Data Extract for Zinrelo
-- previous case SMIHD-21344
/*
    Customer_ID	
    Sale_Date	
    Order_Subtotal	
    Order_ID	
Discount	
    Shipping_Charges	
    Taxes	
    Order_Total
*/

-- ORDER DATA
SELECT -- 2,025,156 @30sec
	O.ixCustomer 'Customer_ID',   
    FORMAT(O.dtOrderDate,'yyyy-MM-dd') 'Sale_Date',
    O.mMerchandise 'Order_Subtotal',
    O.ixOrder 'Order_ID',
    O.mShipping 'Shipping_Charges',
    O.mTax 'Taxes',
    (O.mMerchandise+O.mShipping+O.mTax) 'Order_Total'
INTO #SALES -- DROP TABLE #SALES
FROM tblOrder O
	left join tblCustomer C on O.ixCustomer = C.ixCustomer
WHERE C.sCustomerType = 'Retail'
 	and O.dtOrderDate between '07/01/2017' and '06/30/2021' -- LAST 4 years
	and O.sOrderType='Retail'	
	and O.sOrderStatus = 'Shipped'
	and O.sShipToCountry = 'US'
	and O.ixOrder not like '%-%'
    and O.ixBusinessUnit NOT IN (101,102,103,104,105,108,109) -- Inter-company sale, Intra-company sale, Employee, Pro Racer,Mr Roadster, Garage Sale, Marketplaces
    and O.sSourceCodeGiven NOT IN ('AMAZON','AMAZONPRIME','EBAY', 'EBAYGS')
    and O.mMerchandise > 1


-- RETURNS DATA
    SELECT CMM.ixCustomer 'Customer_ID', -- 150,094
        FORMAT(CMM.dtCreateDate,'yyyy-MM-dd') 'Sale_Date',
        CMM.mMerchandise*-1 'Order_Subtotal',
        CMM.ixCreditMemo 'Order_ID',
        CMM.mShipping 'Shipping_Charges',
        CMM.mTax 'Taxes',
        ((CMM.mMerchandise*-1)+CMM.mShipping+CMM.mTax)  'Order_Total'

    INTO #RETURNS -- DROP TABLE #RETURNS
    FROM tblCreditMemoMaster CMM
        left join tblOrder O on CMM.ixOrder = O.ixOrder
        left join tblCustomer C on C.ixCustomer = CMM.ixCustomer
    WHERE CMM.flgCanceled = 0
        and sCustomerType = 'Retail'
        and CMM.dtCreateDate between '07/01/2017' and '06/30/2021' -- LAST 4 years -- MAKE SURE THE DATE IN THE QUERY ABOVE IS THE SAME!
        and O.sOrderType='Retail'	
	    and O.sOrderStatus = 'Shipped'
	    and O.sShipToCountry='US'
        and O.ixOrder not like '%-%'
        and O.ixBusinessUnit NOT IN (101,102,103,104,105,108,109) -- Inter-company sale, Intra-company sale, Employee, Pro Racer,Mr Roadster, Garage Sale, Marketplaces
        and O.sSourceCodeGiven NOT IN ('AMAZON','AMAZONPRIME','EBAY', 'EBAYGS')
        and O.mMerchandise > 1
        and CMM.mMerchandise <> 0
        and CMM.ixCustomer in (SELECT Customer_ID FROM #SALES)-- excluding customers that had no orders in the same date range

SELECT * 
into #COMBINED -- drop table #COMBINED
FROM  #TEMP

INSERT INTO #COMBINED
SELECT * FROM  #TEMPReturns

-- CREATE FILES
SELECT * FROM #SALES 
--where ORDER_ID like 'C%'
ORDER BY Sale_Date, Order_ID

SELECT * FROM #RETURNS 
--where ORDER_ID like 'C%'
ORDER BY Sale_Date, Order_ID

SELECT TOP 100 * FROM #SALES ORDER BY NEWID()

SELECT TOP 100 * FROM #RETURNS ORDER BY NEWID()


select mMerchandise,	mShipping,	mTax,	mCredits
from tblOrder
where ixOrder = '7322543'

select * from tblOrderLine 
where ixOrder in (SELECT OrderID from #Combined) -- '2653468','3177523','3160306','3271015','3805901','415933','1196269','2117679','415933','1796382')
and flgLineStatus = 'Dropshipped'
and mExtendedPrice <> mExtendedSystemPrice

select distinct flgLineStatus
from tblOrderLine 
where dtOrderDate >= '01/01/2021'


/*
mMerchandise	mShipping	mTax	mCredits
32147.50	    450.00	0.00	0.00
*/

/*
  select * from tblBusinessUnit
                                               
select SUM(OrderTotal) from   #TEMP        --  $493,607,209.59
select SUM(OrderTotal) from   #TEMPReturns -- -$ 28,105,177.57 -- 5.96% returns
                                               ===============
                                               $465,502,032.02 TOTAL
select SUM(OrderTotal) from #COMBINED   --     $465,502,032.02v


select count(1) from #TEMP         -- 2,428,418
select count(1) from #TEMPReturns  --   179,869
                                     ==========
                                      2,608,287 TOTAL RECORDS
Select count(1) from #COMBINED --     2,608,287v



select top 3 * from #TEMP
select top 3 * from #TEMPReturns 

select * from #COMBINED
order by OrderID desc

select max(LEN(OrderID))
from #COMBINED






*/

SELECT -- 2,025,152 @30sec
--	O.ixCustomer                        as 'Customer_ID',   
  --  FORMAT(O.dtOrderDate,'yyyy-MM-dd') 'Sale_Date',
	--convert(varchar,O.dtOrderDate,101)  as 'PurchaseDate',
 --   O.ixOrder as 'OrderID',
 SUM(O.mMerchandise) 'OrderTotal',
 SUM(OL.mExtendedPrice) 'OLExtPrice',
 SUM(OL.mExtendedSystemPrice), 'OLExtSysPrice'
    --NULL 'OriginalOrderID'
   -- O.sSourceCodeGiven 'SCGiven'
--INTO #TEMP -- DROP TABLE #TEMP
FROM tblOrder O
	left join tblCustomer C on O.ixCustomer = C.ixCustomer
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
WHERE C.sCustomerType = 'Retail'
 	and O.dtOrderDate between '07/01/2017' and '06/30/2021' -- LAST 4 years
	and O.sOrderType='Retail'	
	and O.sOrderStatus = 'Shipped'
	and O.sShipToCountry = 'US'
	and O.ixOrder not like '%-%'
    and O.ixBusinessUnit NOT IN (101,102,103,104,105,108,109) -- Inter-company sale, Intra-company sale, Employee, Pro Racer,Mr Roadster, Garage Sale, Marketplaces
    and O.sSourceCodeGiven NOT IN ('AMAZON','AMAZONPRIME','EBAY', 'EBAYGS')
    and O.mMerchandise > 1
    and OL.flgLineStatus in ('Shipped','Dropshipped')

410,500,676.34 Merch

2415673346.56	
410,499,898.484	
413,075,252.223


