-- SMIHD-14686 - change logic on which backorders to display on Backorders Ready to Release report

 SELECT FORMAT(count(*),'###,###') 'BOcnt' FROM tblOrder where sOrderStatus = 'Backordered'  -- 2,604
                                                                                             -- 2,345 have 1 or more order lines with QAV
                                                                                             -- 664 on current report
-- ALL backorders
SELECT FORMAT(O.dtOrderDate,'yyyy.MM.dd') 'OrderDate', O.ixOrder 'Order', 
    O.ixCustomer 'Customer', O.mMerchandise 'Merch', O.sOrderTaker 'OrderTaker'
    --, O.sOrderType
 FROM tblOrder O
    left join tblDate D on O.ixOrderDate = D.ixDate
 where sOrderStatus = 'Backordered'  -- 2,624
   -- and O.dtOrderDate < '01/01/2018' -- '08/05/2018'
 order by dtOrderDate


 SELECT D.iYear, FORMAT(count(O.ixOrder),'###,###') 'OrderCnt'
 FROM tblOrder O
 left join tblDate D on O.ixOrderDate = D.ixDate
 where sOrderStatus = 'Backordered'  -- 2,624
 group by D.iYear
 order by D.iYear
 /*         BO
    Year	Cnt
    2015	1
    2016	9
    2017	78
    2018	469
    2019	2,065
*/
 -- LOAD TEMP TABLE
 SELECT FORMAT(O.dtOrderDate,'yyyy.MM.dd') 'OrderDate', O.ixOrder, 
    O.ixCustomer 'Customer', O.mMerchandise 'Merch', O.sOrderTaker 'OrderTaker',
    OL.ixSKU, ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription', S.mPriceLevel1,
    S.sSEMACategory 'Category',
    S.sSEMASubCategory 'SubCategory',
    V.ixVendor 'VendorNum',
    V.sName 'VendorName',
    -- OL.flgLineStatus, S.flgIntangible, 
    OL.iQuantity,
    SL.iQAV
    --, O.sOrderType
 into #BackOrderedSKUsWithNoQAV -- 2,923
 FROM tblOrder O
    left join tblDate D on O.ixOrderDate = D.ixDate
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
    left join tblSKU S on S.ixSKU = OL.ixSKU
    left join tblSKULocation SL on SL.ixSKU = S.ixSKU and SL.ixLocation = 99
    left join tblVendorSKU VS on S.ixSKU = VS.ixSKU and VS.iOrdinality = 1
    left join tblVendor V on VS.ixVendor = V.ixVendor
 WHERE sOrderStatus = 'Backordered'  -- 2,624
   -- and O.dtOrderDate < '01/01/2018' --
    and S.flgIntangible = 0
    and SL.iQAV < 1
 --order by SL.iQAV desc  --O.dtOrderDate

 -- DROP table #BackOrderedSKUsWithNoQAV
 -- select count(*) from #BackOrderedSKUsWithNoQAV

 -- SKU ROLLUP
 SELECT ixSKU, SKUDescription, mPriceLevel1 'PLvl1', 
    Category ,
    SubCategory,
    VendorNum 'PV',
    VendorName 'PrimaryVendor',
    SUM(iQuantity) 'QtyOnBackorder', 
    count(distinct Customer) 'CustomersWaiting',
    count(distinct ixOrder) 'OrdersWaiting'
 FROM #BackOrderedSKUsWithNoQAV
 GROUP BY ixSKU, SKUDescription, mPriceLevel1,
  Category,
  SubCategory,
  VendorNum,
  VendorName
 ORDER BY count(distinct Customer) DESC, 
          count(distinct ixOrder) DESC, 
          (SUM(iQuantity)*mPriceLevel1) DESC

-- Summary by Category
SELECT Category, COUNT(distinct ixSKU) 'UniqueSKUsOnBO'
 FROM #BackOrderedSKUsWithNoQAV
 GROUP BY Category
 ORDER BY COUNT(distinct ixSKU) DESC

 -- Summary by PV
SELECT VendorNum,
  VendorName, COUNT(distinct ixSKU) 'UniqueSKUsOnBO'
 FROM #BackOrderedSKUsWithNoQAV
 GROUP BY VendorNum,
  VendorName
 ORDER BY COUNT(distinct ixSKU) DESC





