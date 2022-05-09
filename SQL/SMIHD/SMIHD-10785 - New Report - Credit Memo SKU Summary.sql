-- SMIHD-10785 - New Report - Credit Memo SKU Summary

/* Credit Memo SKU Summary.rdl
    ver 18.18.1

DECLARE @StartDate datetime,        @EndDate datetime
SELECT  @StartDate = '02/01/18',    @EndDate = '04/30/18'  
*/
SELECT CMD.ixSKU 'SKU'
    , S.sBaseIndex 'BaseIndex'
    , ISNULL(S.sWebDescription, sDescription) 'SKUDescription'
    , S.sSEMACategory 'SEMACategory', S.sSEMASubCategory 'SEMASubCategory', S.sSEMAPart 'SEMAPart'
    , count(distinct CMD.ixCreditMemo) 'CreditMemoCount'
    , SALES.OrderCnt 'OrderCount'
    , SUM(CMD.iQuantityCredited) 'QtyCredited' 
    , SALES.QtySold
    , SUM(CMD.mExtendedPrice) 'MerchReturns'
    , SALES.Sales 'MerchSales'
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
WHERE CMM.flgCanceled = 0                                           
    and CMM.dtCreateDate between @StartDate and @EndDate --'04/15/2017' and '04/14/2018'
    and S.flgActive = 1
GROUP BY CMD.ixSKU, S.sBaseIndex, ISNULL(S.sWebDescription, sDescription), SALES.OrderCnt, S.sSEMACategory, S.sSEMASubCategory, S.sSEMAPart, SALES.QtySold, SALES.Sales
HAVING SUM(CMD.iQuantityCredited) > 0
  -- and SALES.QtySold > 1
ORDER BY CMD.ixSKU -- count(CMD.ixSKU) DESC 

