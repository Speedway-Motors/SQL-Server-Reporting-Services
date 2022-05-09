

SELECT SUM(mMerchandise) AS TotSales
    -- , SUM(mMerchandiseCost) AS TotCost
     , SUM(mMerchandise) - SUM(mMerchandiseCost) AS GP
FROM tblOrder
WHERE ixCustomer = '26103' 
  and dtOrderDate BETWEEN '06/30/12' AND '07/27/12' 
  and sOrderStatus = 'Shipped' 

SELECT SUM(mMerchandise) AS ReturnSales 
     --, SUM(mMerchandiseCost) AS ReturnCost
     , SUM(mMerchandise) - SUM(mMerchandiseCost) AS ReturnGP
FROM tblCreditMemoMaster 
WHERE ixCustomer = '26103'
  and dtCreateDate BETWEEN '06/30/12' AND '07/27/12' 
  and flgCanceled = '0'
  
  


SELECT Sales.TotSales - Rtns.ReturnSales AS Sales 
     , Sales.GP - Rtns.ReturnGP AS GP 
FROM (SELECT DISTINCT ixCustomer AS Customer 
           , SUM(mMerchandise) AS TotSales
          -- , SUM(mMerchandiseCost) AS TotCost
           , SUM(mMerchandise) - SUM(mMerchandiseCost) AS GP
	  FROM tblOrder
	  WHERE ixCustomer = '26103' 
		and dtOrderDate BETWEEN '06/30/12' AND '07/27/12' 
		and sOrderStatus = 'Shipped' 
	  GROUP BY ixCustomer 
	  ) AS Sales 
LEFT JOIN (SELECT DISTINCT ixCustomer AS Customer 
                , SUM(mMerchandise) AS ReturnSales 
                --, SUM(mMerchandiseCost) AS ReturnCost
			    , SUM(mMerchandise) - SUM(mMerchandiseCost) AS ReturnGP
		   FROM tblCreditMemoMaster 
		   WHERE ixCustomer = '26103'
			 and dtCreateDate BETWEEN '06/30/12' AND '07/27/12' 
			 and flgCanceled = '0' 
		   GROUP BY ixCustomer      
		   ) AS Rtns ON Rtns.Customer = Sales.Customer 