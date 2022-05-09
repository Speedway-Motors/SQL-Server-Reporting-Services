-- Orders with Eagle SC INTERNAL-EMI

SELECT * FROM tblSourceCode
where ixSourceCode = 'INTERNAL-EMI'

select ixOrder
    ,ixCustomer
    ,sOrderType
    ,sSourceCodeGiven
    ,mMerchandise
    ,mMerchandiseCost
    ,mTax
    ,sOrderTaker
    ,CONVERT(VARCHAR(10), dtShippedDate, 101)  'ShippedDate'
   -- ,sOrderStatus
   -- ,dtOrderDate
 from tblOrder
where sOrderStatus = 'Shipped'
and (sSourceCodeGiven = 'INTERNAL-EMI'
    OR
    sMatchbackSourceCode = 'INTERNAL-EMI')
ORDER BY dtShippedDate    
    
    
ixOrder	ixCustomer	sOrderType	sSourceCodeGiven	mMerchandise	mMerchandiseCost	mTax	sOrderTaker	dtShippedDate	sOrderStatus	dtOrderDate
6005812	2218745	Retail	INTERNAL-EMI	48.98	48.98	3.43	MAL2	2015-04-15 00:00:00.000	Shipped	2015-04-14 00:00:00.000    
    
select distinct sOrderType from tblOrder


select * from tblEmployee where ixEmployee = 'JJM'