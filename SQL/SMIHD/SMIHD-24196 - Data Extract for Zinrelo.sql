-- SMIHD-24196 - Data Extract for Zinrelo

-- ORDER DATA
SELECT -- 1,703,367 @2:21		
	O.ixCustomer                        as 'CustomerID',   
	-- convert(varchar,O.dtOrderDate,101)  as 'PurchaseDate',
    O.dtOrderDate 'PurchaseDate',
    O.ixOrder as 'OrderID',
    O.mMerchandise 'OrderTotal',
    NULL 'OriginalOrderID'
   -- O.sSourceCodeGiven 'SCGiven'
INTO #TEMP -- DROP TABLE #TEMP
FROM tblOrder O
	left join tblCustomer C on O.ixCustomer = C.ixCustomer
WHERE C.sCustomerType = 'Retail'
 	and O.dtOrderDate between '03/01/2019' and '02/28/2022' -- LAST 3 years
	and O.sOrderType='Retail'	
	and O.sOrderStatus = 'Shipped'
	and O.sShipToCountry = 'US'
	and O.ixOrder not like '%-%'
    and O.ixBusinessUnit NOT IN (101,102,103,104,105,108,109) -- Inter-company sale, Intra-company sale, Employee, Pro Racer,Mr Roadster, Garage Sale, Marketplaces
    and O.sSourceCodeGiven NOT IN ('AMAZON','AMAZONPRIME','EBAY', 'EBAYGS')
    and O.mMerchandise > 1


-- RETURNS DATA
    SELECT CMM.ixCustomer 'CustomerID', -- 129,523
        -- convert(varchar,CMM.dtCreateDate,101)  as 'PurchaseDate',
        CMM.dtCreateDate as 'PurchaseDate',
        CMM.ixCreditMemo 'OrderID',
        CMM.mMerchandise*-1 'OrderTotal',
        CMM.ixOrder 'OriginalOrderID'
    INTO #TEMPReturns -- DROP TABLE #TEMPReturns
    FROM tblCreditMemoMaster CMM
        left join tblOrder O on CMM.ixOrder = O.ixOrder
        left join tblCustomer C on C.ixCustomer = CMM.ixCustomer
    WHERE CMM.flgCanceled = 0
        and sCustomerType = 'Retail'
        and CMM.dtCreateDate between '03/01/2019' and '02/28/2022' -- LAST 3 years -- MAKE SURE THE DATE IN THE QUERY ABOVE IS THE SAME!
        and O.sOrderType='Retail'	
	    and O.sOrderStatus = 'Shipped'
	    and O.sShipToCountry='US'
        and O.ixOrder not like '%-%'
        and O.ixBusinessUnit NOT IN (101,102,103,104,105,108,109) -- Inter-company sale, Intra-company sale, Employee, Pro Racer,Mr Roadster, Garage Sale, Marketplaces
        and O.sSourceCodeGiven NOT IN ('AMAZON','AMAZONPRIME','EBAY', 'EBAYGS')
        and O.mMerchandise > 1
        and CMM.mMerchandise <> 0
        and CMM.ixCustomer in (SELECT CustomerID FROM #TEMP)-- excluding customers that had no orders in the same date range

SELECT TOP 10 * FROM #COMBINED

select OriginalOrderID, count(*)
from #COMBINED
group by OriginalOrderID
having count(*) > 4
order by count(*) desc



SELECT * -- 1,703,367
into #COMBINED -- drop table #COMBINED
FROM  #TEMP

INSERT INTO #COMBINED -- 129,523
SELECT * FROM  #TEMPReturns

SELECT COUNT(*) -- 1,832,890
FROM #COMBINED

select top 100 *
from #COMBINED
order by newid()

SELECT * FROM #COMBINED -- Output to File to create the extract file
OrderExtractForZinrelo20220304



SELECT CustomerID, count(distinct OrderID) 'OrderCnt'
into #OrderCount -- DROP TABLE #OrderCount
from #COMBINED
GROUP BY CustomerID

SELECT *
FROM #OrderCount
WHERE OrderCnt = 1


SELECT
(
 (SELECT MAX(OrderTotal) FROM
   (SELECT TOP  219581 OrderTotal 
    FROM #COMBINED C
        left join #OrderCount OC on C.CustomerID = OC.CustomerID 
    where OC.OrderCnt = 1
    ORDER BY OrderTotal) AS BottomHalf)
 +
 (SELECT MIN(OrderTotal) FROM
   (SELECT TOP 219581 OrderTotal 
    FROM #COMBINED C
        left join #OrderCount OC on C.CustomerID = OC.CustomerID
   where OC.OrderCnt = 1
    ORDER BY OrderTotal DESC) AS TopHalf)
) / 2 AS Median -- 111.45 -- 108.935

SELECT COUNT(*)
FROM #OrderCount OC 
WHERE   OC.OrderCnt = 1 -- 439162  -- 219,581=HALF


 
where PurchaseDate between '05/01/2020' and '04/30/2021' 
        and OC.OrderCnt = 1

SELECT OrderTotal, PurchaseDate 
FROM #COMBINED 
where PurchaseDate > '04/15/2021' -- is NOT NULL -- between '05/01/2020' and '04/30/2021' 




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






