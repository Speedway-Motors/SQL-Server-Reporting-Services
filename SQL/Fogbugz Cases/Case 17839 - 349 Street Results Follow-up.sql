SELECT REG.sShipToState
     , ixSourceCode
     , sDescription     
     , iQuantityPrinted
     , REG.Sales
     , REG.Cost
     , REG.Orders
 --    , (REG.Sales - REG.Cost)/REG.Sales
FROM tblSourceCode
LEFT JOIN (SELECT sMatchbackSourceCode
				, sShipToState
				, SUM(CASE WHEN ixOrder LIKE '%-%' THEN 0 
						   ELSE 1
					  END) AS Orders
				, SUM(mMerchandise) AS Sales 
				, SUM(mMerchandiseCost) AS Cost 
		   FROM tblOrder
		   WHERE sMatchbackSourceCode BETWEEN '34925' AND '34957'
		     AND sShipToState = 'GA' --IN ('CA', 'AZ', 'NM', 'TX', 'OK', 'LA', 'AR', 'MS', 'AL', 'FL', 'GA')
		     AND dtOrderDate BETWEEN '01/01/13' AND '03/26/13'
		   GROUP BY sMatchbackSourceCode
                  , sShipToState
          ) REG ON REG.sMatchbackSourceCode = tblSourceCode.ixSourceCode
WHERE ixCatalog = '349'
  AND ixSourceCode BETWEEN '34925' AND '34957'
ORDER BY sShipToState 
       , ixSourceCode  

SELECT SC.ixSourceCode
     , COUNT(DISTINCT CO.ixCustomerOffer) CustCount
FROM tblSourceCode SC
JOIN tblCustomerOffer CO on SC.ixSourceCode = CO.ixSourceCode
JOIN tblCustomer C on CO.ixCustomer = C.ixCustomer
WHERE SC.ixCatalog = '349'
and SC.ixSourceCode BETWEEN '34925' AND '34957'
and C.sMailToState = 'GA' --IN ('CA', 'AZ', 'NM', 'TX', 'OK', 'LA', 'AR', 'MS', 'AL', 'FL', 'GA')
GROUP BY SC.ixSourceCode
ORDER BY SC.ixSourceCode