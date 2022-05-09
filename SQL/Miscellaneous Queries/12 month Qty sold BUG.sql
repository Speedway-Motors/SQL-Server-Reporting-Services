/***** AFCO 
    for ixSKU 9850-6020  -- 80179
    12 Month QTY Sold 
    =================
    303 per AFCO/Purchasing "Weekly Fill Rates Analysis" report
    303 per tblSnapAdjustedMonthlySKUSales  -- select * from tblSnapAdjustedMonthlySKUSales where ixSKU = '9850-6020' AND iYearMonth Between '2011-01-15' and '2011-12-15' order by iYearMonth desc
    303 per SOP
    304 per OL
      1 RETURNED per Credit Memo Tables
    303 per vwAdjustedMonthlySKUSales       -- select top 13 * from vwAdjustedMonthlySKUSales where ixSKU = '9850-6020' order by iYearMonth desc
*****/

-- OL SALES
select sum(OL.iQuantity) GrossQtySold
from tblOrderLine OL
    join tblOrder O on OL.ixOrder = O.ixOrder
where OL.ixSKU =  '9850-6020'
and OL.flgLineStatus = 'Shipped'
and O.dtOrderDate between '01/01/2011' and '12/31/2011'

-- Credit Memo RETURNS
select CMD.*
from tblCreditMemoDetail CMD
    join tblCreditMemoMaster CMM on CMM.ixCreditMemo = CMD.ixCreditMemo
where CMD.ixSKU =  '9850-6020'
    and CMM.dtCreateDate between '01/01/2011' and '12/31/2011'
    and CMM.flgCanceled = 0


SELECT * FROM tblSnapAdjustedMonthlySKUSales 
WHERE ixSKU =  '9850-6020'
ORDER BY iYearMonth Desc
/*
iYearMonth	AdjustedQTYSold
2011-12-15 	30
2011-11-15 	34
2011-10-15 	10
2011-09-15 	43
2011-08-15 	109
2011-07-15 	67
2011-06-15 	67
2011-05-15 	114
2011-04-15 	26
2011-03-15 	223
2011-02-15 	31
2011-01-15 	36
*/


TABLE COLUMNS AND VIEW COLUMNS ARE NOT THE SAME ORDER!!!!!!!!!!!!!!!!!!!!!!!!!1
-- AFCO
iYearMonth, ixSKU, AdjustedSales, AdjustedQTYSold, AdjustedGP, AdjustedCost, AVGInvCost -- tblSnapAdjustedMonthlySKUSales
iYearMonth, ixSKU, AdjustedSales, AdjustedQTYSold, AdjustedGP, AdjustedCost, AVGInvCost -- vwAdjustedMonthlySKUSales

-- SMI
iYearMonth, ixSKU, AdjustedSales, AdjustedQTYSold, AdjustedGP, AVGInvCost, BOMQuantity, AvgBOMUnitCost
iYearMonth, ixSKU, AdjustedSales, AdjustedQTYSold, AdjustedGP, AVGInvCost, BOMQuantity, AvgBOMUnitCost

SELECT * FROM vwAdjustedMonthlySKUSales 
WHERE ixSKU =  '9850-6020'
ORDER BY iYearMonth Desc
/*
iYearMonth	AdjustedQTYSold
2011-12-15 	6
2011-11-15 	7
2011-10-15 	2
2011-09-15 	8
2011-08-15 	21
2011-07-15 	13
2011-06-15 	14
2011-05-15 	22
2011-04-15 	5
2011-03-15 	43
2011-02-15 	6
2011-01-15 	7
*?