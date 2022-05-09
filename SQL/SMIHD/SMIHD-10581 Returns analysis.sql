-- SMIHD-10581 Returns analysis
/*
SELECT TOP 10 * FROM tblCreditMemoMaster
SELECT TOP 10 * FROM tblCreditMemoDetail
*/

-- MASTER QUERY
DECLARE @StartDate datetime,        @EndDate datetime
SELECT  @StartDate = '02/01/18',    @EndDate = '04/30/18'  

SELECT CMD.ixSKU, S.sBaseIndex
    , ISNULL(S.sWebDescription, sDescription) SKUDescription, S.sSEMACategory, S.sSEMASubCategory, S.sSEMAPart
    , count(distinct CMD.ixCreditMemo) CMCnt
    , SALES.OrderCnt
    , SUM(CMD.iQuantityCredited) QtyCredited 
    , SALES.QtySold
    , SUM(CMD.mExtendedPrice) MerchReturns
    , SALES.Sales MerchSales
FROM tblCreditMemoMaster CMM
    join tblCreditMemoDetail CMD on CMM.ixCreditMemo=CMD.ixCreditMemo  --75,208 unique SKU sold last 12 months... of rthose 20,894 had returns
    join tblSKU S ON S.ixSKU = CMD.ixSKU
    LEFT JOIN (-- Sales & Qty Sold
		    SELECT OL.ixSKU
			    ,SUM(OL.iQuantity) AS 'QtySold', SUM(OL.mExtendedPrice) 'Sales', SUM(OL.mExtendedCost) 'CoGS', COUNT(Distinct OL.ixOrder) OrderCnt
		    FROM tblOrderLine OL 
			    join tblDate D on D.dtDate = OL.dtOrderDate 
		    WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
			    and D.dtDate between DATEADD(dd,-60,@StartDate)  and @EndDate -- pulls additional 60 days of order history per BKR
		    GROUP BY OL.ixSKU
		    ) SALES on SALES.ixSKU = S.ixSKU 
where CMM.flgCanceled = 0                                           
    and CMM.dtCreateDate between @StartDate and @EndDate --'04/15/2017' and '04/14/2018'
    and S.flgActive = 1
GROUP BY CMD.ixSKU, S.sBaseIndex, ISNULL(S.sWebDescription, sDescription), SALES.OrderCnt, S.sSEMACategory, S.sSEMASubCategory, S.sSEMAPart, SALES.QtySold, SALES.Sales
HAVING SUM(CMD.iQuantityCredited) > 0
  -- and SALES.QtySold > 1
ORDER BY CMD.ixSKU -- count(CMD.ixSKU) DESC 


/******    TESTING PULLING THE ADDITIONAL 60 DAYS OF ORDER HISTORY ******/
    /*
    DECLARE @StartDate datetime,        @EndDate datetime
    SELECT  @StartDate = '01/01/18',    @EndDate = '04/30/18'  

    SELECT @StartDate 'CMStartDate', @EndDate 'CMEndDate', DATEADD(dd,-60,@StartDate) 'OrderStartDate'

    --                              ADJOrder
    --    CMStartDate	CMEndDate	StartDate
    --      2018-01-01  2018-04-30  2017-11-02

*/








/***********    SEMA Category level     ***********/
DECLARE @StartDate datetime,        @EndDate datetime
SELECT  @StartDate = '04/16/16',    @EndDate = '04/15/18'  

SELECT S.sSEMACategory
    , count(distinct CMD.ixCreditMemo) CMCnt
    , SALES.OrderCnt
    , SUM(CMD.iQuantityCredited) QtyCredited 
    , SALES.QtySold
    , SUM(CMD.mExtendedPrice) MerchReturns
    , SALES.Sales MerchSales
FROM tblCreditMemoMaster CMM
    join tblCreditMemoDetail CMD on CMM.ixCreditMemo=CMD.ixCreditMemo  --75,208 unique SKU sold last 12 months... of rthose 20,894 had returns
    join tblSKU S ON S.ixSKU = CMD.ixSKU
    LEFT JOIN (-- Sales & Qty Sold
		    SELECT S.sSEMACategory
			    ,SUM(OL.iQuantity) AS 'QtySold', SUM(OL.mExtendedPrice) 'Sales', SUM(OL.mExtendedCost) 'CoGS', COUNT(Distinct OL.ixOrder) OrderCnt
		    FROM tblOrderLine OL 
			    join tblDate D on D.dtDate = OL.dtOrderDate 
                join tblSKU S ON S.ixSKU = OL.ixSKU
		    WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
			    and D.dtDate between @StartDate and @EndDate 
		    GROUP BY S.sSEMACategory
		    ) SALES on SALES.sSEMACategory = S.sSEMACategory 
where CMM.flgCanceled = 0                                           
    and CMM.dtCreateDate between @StartDate and @EndDate --'04/15/2017' and '04/14/2018'
    and S.flgActive = 1
GROUP BY S.sSEMACategory, SALES.QtySold, SALES.Sales    , SALES.OrderCnt
HAVING SALES.QtySold > 1
    and SUM(CMD.iQuantityCredited) > 1
ORDER BY count(CMD.ixSKU) DESC 

/***********    SEMA Category + SubCategory level   ***********/
DECLARE @StartDate datetime,        @EndDate datetime
SELECT  @StartDate = '04/16/16',    @EndDate = '04/15/18'  

SELECT S.sSEMACategory, S.sSEMASubCategory
    , count(distinct CMD.ixCreditMemo) CMCnt
    , SALES.OrderCnt
    , SUM(CMD.iQuantityCredited) QtyCredited 
    , SALES.QtySold
    , SUM(CMD.mExtendedPrice) MerchReturns
    , SALES.Sales MerchSales
FROM tblCreditMemoMaster CMM
    join tblCreditMemoDetail CMD on CMM.ixCreditMemo=CMD.ixCreditMemo  --75,208 unique SKU sold last 12 months... of rthose 20,894 had returns
    join tblSKU S ON S.ixSKU = CMD.ixSKU
    LEFT JOIN (-- Sales & Qty Sold
		    SELECT S.sSEMACategory, S.sSEMASubCategory
			    ,SUM(OL.iQuantity) AS 'QtySold', SUM(OL.mExtendedPrice) 'Sales', SUM(OL.mExtendedCost) 'CoGS', COUNT(Distinct OL.ixOrder) OrderCnt
		    FROM tblOrderLine OL 
			    join tblDate D on D.dtDate = OL.dtOrderDate 
                join tblSKU S ON S.ixSKU = OL.ixSKU
		    WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
			    and D.dtDate between @StartDate and @EndDate 
		    GROUP BY S.sSEMACategory, S.sSEMASubCategory
		    ) SALES on SALES.sSEMACategory = S.sSEMACategory 
                    and SALES.sSEMASubCategory = S.sSEMASubCategory
where CMM.flgCanceled = 0                                           
    and CMM.dtCreateDate between @StartDate and @EndDate --'04/15/2017' and '04/14/2018'
    and S.flgActive = 1
GROUP BY S.sSEMACategory, S.sSEMASubCategory, SALES.QtySold, SALES.Sales    , SALES.OrderCnt
HAVING SALES.QtySold > 1
    and SUM(CMD.iQuantityCredited) > 1
ORDER BY count(CMD.ixSKU) DESC 






/****** additional analysis quiries for BKR  ********/


    -- Avg # of days between Order Shipped and CM being generated
        select O.dtShippedDate, CMM.dtCreateDate, O.ixOrder, CMM.ixCreditMemo, CMM.mMerchandise,
        DATEDIFF (d,O.dtShippedDate, CMM.dtCreateDate) DaysApart
        from tblOrder O
        join tblCreditMemoMaster CMM on O.ixOrder = CMM.ixOrder
        where dtShippedDate between '01/01/2017' and '12/31/2017'
              and CMM.flgCanceled = '0'
              and CMM.mMerchandise > 0
              and CMM.ixCreditMemo NOT like 'F%' -- exclude Freestanding CMs per CCC
              and O.sOrderType <> 'Internal'    -- exclude per CCC 
              and CMM.ixCreditMemo in (SELECT distinct ixCreditMemo from tblCreditMemoDetail)
         and DATEDIFF (d,O.dtShippedDate, CMM.dtCreateDate) > 60
        Order by  DaysApart desc       

        -- AVG # OF days between order shipped vs CM created -- 31

        select COUNT(DISTINCT CMM.ixCreditMemo) 'CMCount', AVG(DATEDIFF (d,O.dtShippedDate, CMM.dtCreateDate)) DaysApart
        from tblOrder O
        join tblCreditMemoMaster CMM on O.ixOrder = CMM.ixOrder
        where dtShippedDate between '01/01/2017' and '12/31/2017'
              and CMM.flgCanceled = '0'
              and CMM.mMerchandise > 0
              and CMM.ixCreditMemo NOT like 'F%' -- exclude Freestanding CMs per CCC
              and O.sOrderType <> 'Internal'    -- exclude per CCC 
              and CMM.ixCreditMemo in (SELECT distinct ixCreditMemo from tblCreditMemoDetail)
        -- and DATEDIFF (d,O.dtShippedDate, CMM.dtCreateDate) > 60
        Order by  DaysApart desc      


CMM.sReasonCode count YTD -- include codes with NO CMMs

SELECT *
from tblCreditMemoReasonCode
