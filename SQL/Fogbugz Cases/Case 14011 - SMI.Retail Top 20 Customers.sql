
SELECT DISTINCT TOP 20 ISNULL(CP.Customer, PP.Customer) AS Customer 
     , ISNULL(CP.CustomerName, PP.CustomerName) AS CustomerName      
     , ISNULL(CP.CreateDate, PP.CreateDate) AS CreateDate 
     , ISNULL(CP.NetRev,0) AS CPNetRev
     , ISNULL(CP.NetCost,0) AS CPNetCost --Visibility = hidden on the the report 
     , ISNULL(CP.GP,0) AS CPGP
     -- add in percentage calculation on the report for margin 
     , ISNULL(PP.NetRev,0) AS PPNetRev
     , ISNULL(PP.NetCost,0) AS PPNetCost --Visibility = hidden on the the report 
     , ISNULL(PP.GP,0) AS PPGP
     -- add in percentage calculation on the report for margin 
     -- add in difference calculation between CP and PP on the report 

FROM (SELECT DISTINCT CPSALES.Customer AS Customer 
		   , CPSALES.CreateDate AS CreateDate 
		   , ISNULL(CPSALES.FirstName, '') + ' ' + CPSALES.LastName AS CustomerName
		   , ISNULL(CPSALES.Merch,0) - ISNULL (CPRTNS.Merch,0) AS NetRev
		   , ISNULL(CPSALES.Cost,0) - ISNULL (CPRTNS.Cost,0) AS NetCost
		   , (ISNULL(CPSALES.Merch,0) - ISNULL (CPRTNS.Merch,0)) - (ISNULL(CPSALES.Cost,0) - ISNULL (CPRTNS.Cost,0)) AS GP 
	  --Current Period Sales Figures 
	  FROM (SELECT DISTINCT O.ixCustomer AS Customer 
	 			 , C.dtAccountCreateDate AS CreateDate
				 , C.sCustomerFirstName AS FirstName
				 , C.sCustomerLastName AS LastName
				 , ISNULL(SUM(O.mMerchandise),0) AS Merch
				 , ISNULL(SUM(O.mMerchandiseCost),0) AS Cost
				 , ISNULL(SUM(O.mMerchandise),0) - ISNULL(SUM(O.mMerchandiseCost),0) AS GP
			FROM tblOrder O
			LEFT JOIN tblCustomer C ON C.ixCustomer = O.ixCustomer 
			WHERE O.dtShippedDate BETWEEN '01/01/2012' AND '05/24/12' 
			  AND O.sOrderStatus = 'Shipped' 
			  AND O.sOrderType IN ('Retail')
			  AND C.ixCustomerType <> '44' --Excludes employee accounts 
			  AND C.sCustomerType IN ('Retail') 
			  AND C.ixCustomerType IN ('1') 
			GROUP BY O.ixCustomer
				   , C.dtAccountCreateDate
				   , C.sCustomerFirstName
				   , C.sCustomerLastName       
           ) AS CPSALES
	  --Current Period Returns Figures 
	  LEFT JOIN (SELECT DISTINCT CMM.ixCustomer AS Customer 
	       			  , C.dtAccountCreateDate AS CreateDate
					  , C.sCustomerFirstName AS FirstName
					  , C.sCustomerLastName AS LastName
					  , ISNULL(SUM(CMM.mMerchandise),0) AS Merch
					  , ISNULL(SUM(CMM.mMerchandiseCost),0) AS Cost
					  , ISNULL(SUM(CMM.mMerchandise),0) - ISNULL(SUM(CMM.mMerchandiseCost),0) AS GP
				 FROM tblCreditMemoMaster CMM 
				 LEFT JOIN tblCustomer C ON C.ixCustomer = CMM.ixCustomer 
				 WHERE dtCreateDate BETWEEN '01/01/2012' AND '05/24/12' 
		   		   AND CMM.flgCanceled = '0'
		   		   AND C.ixCustomerType <> '44' --Excludes employee accounts 
		  		   AND C.sCustomerType IN ('Retail') 
		  		   AND C.ixCustomerType IN ('1') 
				 GROUP BY CMM.ixCustomer
		                , C.dtAccountCreateDate
					    , C.sCustomerFirstName      
						, C.sCustomerLastName      
			    ) AS CPRTNS ON CPRTNS.Customer = CPSALES.Customer 
	  --ORDER BY NetRev DESC   
     ) AS CP 

FULL OUTER JOIN (SELECT DISTINCT PPSALES.Customer AS Customer 
					  , PPSALES.CreateDate AS CreateDate 
					  , ISNULL(PPSALES.FirstName, '') + ' ' + PPSALES.LastName AS CustomerName
					  , ISNULL(PPSALES.Merch,0) - ISNULL (PPRTNS.Merch,0) AS NetRev
					  , ISNULL(PPSALES.Cost,0) - ISNULL (PPRTNS.Cost,0) AS NetCost
					  , (ISNULL(PPSALES.Merch,0) - ISNULL (PPRTNS.Merch,0)) - (ISNULL(PPSALES.Cost,0) - ISNULL (PPRTNS.Cost,0)) AS GP 
				 --Previous Period Sales Figures 
				 FROM (SELECT DISTINCT O.ixCustomer AS Customer 
	 						, C.dtAccountCreateDate AS CreateDate
							, C.sCustomerFirstName AS FirstName
							, C.sCustomerLastName AS LastName
							, ISNULL(SUM(O.mMerchandise),0) AS Merch
							, ISNULL(SUM(O.mMerchandiseCost),0) AS Cost
							, ISNULL(SUM(O.mMerchandise),0) - ISNULL(SUM(O.mMerchandiseCost),0) AS GP
					   FROM tblOrder O
					   LEFT JOIN tblCustomer C ON C.ixCustomer = O.ixCustomer 
					   WHERE O.dtShippedDate BETWEEN '01/01/2011' AND '05/24/11' 
						 AND O.sOrderStatus = 'Shipped' 
						 AND O.sOrderType IN ('Retail')
						 AND C.ixCustomerType <> '44' --Excludes employee accounts 
						 AND C.sCustomerType IN ('Retail') 
						 AND C.ixCustomerType IN ('1') 
					   GROUP BY O.ixCustomer
							  , C.dtAccountCreateDate
							  , C.sCustomerFirstName
							  , C.sCustomerLastName       
                       ) AS PPSALES
				 --Previous Period Returns Figures 
				 LEFT JOIN (SELECT DISTINCT CMM.ixCustomer AS Customer 
	       					  	 , C.dtAccountCreateDate AS CreateDate
								 , C.sCustomerFirstName AS FirstName
								 , C.sCustomerLastName AS LastName
								 , ISNULL(SUM(CMM.mMerchandise),0) AS Merch
								 , ISNULL(SUM(CMM.mMerchandiseCost),0) AS Cost
								 , ISNULL(SUM(CMM.mMerchandise),0) - ISNULL(SUM(CMM.mMerchandiseCost),0) AS GP
							FROM tblCreditMemoMaster CMM 
							LEFT JOIN tblCustomer C ON C.ixCustomer = CMM.ixCustomer 
							WHERE dtCreateDate BETWEEN '01/01/2011' AND '05/24/11' 
		   					  AND CMM.flgCanceled = '0'
		   					  AND C.ixCustomerType <> '44' --Excludes employee accounts 
		  					  AND C.sCustomerType IN ('Retail') 
		  					  AND C.ixCustomerType IN ('1') 
							GROUP BY CMM.ixCustomer
								   , C.dtAccountCreateDate
								   , C.sCustomerFirstName      
								   , C.sCustomerLastName      
						    ) AS PPRTNS ON PPRTNS.Customer = PPSALES.Customer 
				 --ORDER BY NetRev DESC   
				) AS PP ON PP.Customer = CP.Customer

ORDER BY CPNetRev DESC     