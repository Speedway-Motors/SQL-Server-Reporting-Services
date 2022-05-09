-- AFCO OLD VERSION SALES
select
	tblSKU.ixPGC as 'PGC',
	tblSKU.ixSKU as'SKU',
	sum(tblOrderLine.iQuantity) as 'Quantity Sold',
	sum(tblOrderLine.mExtendedPrice) as 'Extended Price',
	sum(tblOrderLine.mExtendedCost) as 'Extended Cost'
from
	tblOrderLine
	right join tblSKU on tblOrderLine.ixSKU = tblSKU.ixSKU
where 
	tblOrderLine.flgLineStatus = 'Shipped'
	and	tblOrderLine.dtShippedDate >= '01/01/10'
    and	tblOrderLine.dtShippedDate < '09/01/10'
    and flgKitComponent = 0
group by
	tblSKU.ixPGC,
	tblSKU.ixSKU
order by
	sum(tblOrderLine.iQuantity)
/*
Quantity    Extended        Extended
  Sold	     Price	          Cost
 374,130    $9,415,468      $5,636,384   -- SALES from above query       
  15,358 	  $554,716 	      $244,926   -- RETURNS from below query
 =======    ==========      ==========
 358,772    $8,860,752      $5,391,458   -- ADJUST SALES for 01/01/10 to 09/01/10
 
 380,315 	$8,785,887 	    $5,353,678   -- New numbers

*/


-- AFCO OLD VERSION RETURNS
select
	tblCreditMemoDetail.ixSKU as 'SKU',
	sum(tblCreditMemoDetail.iQuantityReturned) as 'Qty Returned',
	sum(tblCreditMemoDetail.iQuantityCredited) as 'Qty Credited',
	sum(tblCreditMemoDetail.mUnitPrice * tblCreditMemoDetail.iQuantityReturned) as 'Merch Returned Revenue',
	sum(tblCreditMemoDetail.mUnitCost * tblCreditMemoDetail.iQuantityReturned) as 'Merch Returned Cost'
from
	tblCreditMemoDetail
	left join tblCreditMemoMaster on tblCreditMemoDetail.ixCreditMemo = tblCreditMemoMaster.ixCreditMemo
where
	tblCreditMemoMaster.dtCreateDate >= '01/01/10'
 and tblCreditMemoMaster.dtCreateDate < '09/01/10'
group by
	tblCreditMemoDetail.ixSKU



















-- FULL OUTER JOIN
SELECT *
FROM 
(select OL.ixSKU,
                            --D.iYearMonth,
                            SUM(OL.iQuantity) QTYSold,
                            SUM(OL.iQuantity*CAST(OL.mUnitPrice as Money)) Sales,
                            SUM(OL.mExtendedCost) Cost,
                            SUM((OL.mUnitPrice-OL.mCost)* CAST(OL.iQuantity as Money)) GP
                     from tblOrder O 
                        join tblOrderLine OL on OL.ixOrder = O.ixOrder 
                                and OL.flgLineStatus = 'Shipped' 
                                and OL.dtOrderDate >= DATEADD(yy, DATEDIFF(yy,0,'09/01/10'), 0)   -- first of the year for '09/01/10'
                                and OL.dtOrderDate < DATEADD(mm, DATEDIFF(mm,0,'09/01/10'), 0) -- first of the month for '09/01/10'
                                and flgKitComponent = 0
                        left join tblDate D on D.dtDate = OL.dtOrderDate 
                        left join tblSKU S on S.ixSKU = OL.ixSKU 
                     -- per Laurie, INCLUDE internal orders
                     group by OL.ixSKU
                    ) NEW
FULL OUTER JOIN (
                select
	                tblSKU.ixPGC as 'PGC',
	                tblSKU.ixSKU as'SKU',
	                sum(tblOrderLine.iQuantity) as 'Quantity Sold',
	                sum(tblOrderLine.mExtendedPrice) as 'Extended Price',
	                sum(tblOrderLine.mExtendedCost) as 'Extended Cost'
                from
	                tblOrderLine
	                right join tblSKU on tblOrderLine.ixSKU = tblSKU.ixSKU
                where 
	                tblOrderLine.flgLineStatus = 'Shipped'
	                and	tblOrderLine.dtShippedDate >= '01/01/10'
                    and	tblOrderLine.dtShippedDate < '09/01/10'
                    and flgKitComponent = 0
                group by
	                tblSKU.ixPGC,
	                tblSKU.ixSKU
                ) OLD on OLD.SKU = NEW.ixSKU
                WHERE NEW.ixSKU is null
                    OR OLD.SKU is null