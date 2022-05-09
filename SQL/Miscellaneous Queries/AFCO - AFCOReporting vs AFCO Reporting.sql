select getdate() TimeRan 

-- Order count
select count(*) NS_OrderCount 
from [AFCOReporting].dbo.tblOrder                               
where dtOrderDate between '01/01/10' and '08/31/10' -- 18,316      2010-09-15 12:24:20.050         

select count(*) S_OrderCount 
from [AFCO Reporting].dbo.tblOrder                              
where dtOrderDate between '01/01/10' and '08/31/10' -- 18,316      2010-09-15 12:24:20.050          

-- OrderLine count
select count(*) NS_OrderLineCount 
from [AFCOReporting].dbo.tblOrderLine
where tblOrderLine.flgLineStatus = 'Shipped' 
and tblOrderLine.dtShippedDate between '01/01/10' and '08/31/10'    -- 73400    2010-09-15 12:24
and flgKitComponent = 0

select count(*) S_OrderLineCount 
from [AFCO Reporting].dbo.tblOrderLine
where tblOrderLine.flgLineStatus = 'Shipped'
and tblOrderLine.dtShippedDate between '01/01/10' and '08/31/10'    -- 73397    2010-09-15 12:24
/*******************************************/

select
	sum(tblOrderLine.iQuantity) as 'NS_QTY Sold',               --   394,680  2010-09-15 12:28
	sum(tblOrderLine.mExtendedPrice) as 'NS_Ext Price',         -- 9,496,764.482
	sum(tblOrderLine.mExtendedCost) as 'NS_Ext Cost'            -- 5,715,260.641
from [AFCOReporting].dbo.tblOrderLine
where 
	tblOrderLine.flgLineStatus = 'Shipped'	
and	tblOrderLine.dtShippedDate between '01/01/10' and '08/31/10'
 and flgKitComponent = 0

select
	sum(tblOrderLine.iQuantity) as 'Quantity Sold',             --   394,680        2010-09-15 12:31
	sum(tblOrderLine.mExtendedPrice) as 'Extended Price',       -- 9,496,764.482  
	sum(tblOrderLine.mExtendedCost) as 'Extended Cost'          -- 5,449,727.136  
from [AFCO Reporting].dbo.tblOrderLine
where 
	tblOrderLine.flgLineStatus = 'Shipped'	and
	tblOrderLine.dtShippedDate between '01/01/10' and '08/31/10'



select top 10 NOSPACE.ixOrder, NOSPACE.ixSKU, NOSPACE.mExtendedCost NOSPACE_cost, AFCOSPACE.mExtendedPrice AFCOSPACE_cost
from [AFCOReporting].dbo.tblOrderLine NS
    join [AFCO Reporting].dbo.tblOrderLine S on S.ixOrder = NS.ixOrder and S.iOridinality = NS.iOrdinality and S.mExtendedCost <> NS.mExtendedCost
where NS.flgLineStatus = 'Shipped'
and NS.dtShippedDate between '01/01/10' and '08/31/10'  

-- costs not matching
SELECT
    S.ixOrder, 
    S.mMerchandiseCost SCost, 
    NS.mMerchandiseCost NSCost
FROM
(
Select ixOrder, mMerchandiseCost
 from [AFCO Reporting].dbo.tblOrder
where dtOrderDate between '01/01/10' and '08/31/10'
) S -- [AFCO Reporting]

JOIN (
    Select ixOrder, mMerchandiseCost
     from [AFCOReporting].dbo.tblOrder
    where dtOrderDate between '01/01/10' and '08/31/10'
    ) NS on S.ixOrder = NS.ixOrder and ((S.mMerchandiseCost <> NS.mMerchandiseCost) or (NS.mMerchandiseCost is null or S.mMerchandiseCost is null))
    -- [AFCOReporting]


