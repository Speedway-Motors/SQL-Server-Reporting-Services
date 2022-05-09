
SELECT ISNULL(CP.Category, PP.Category) AS Category
     , ISNULL(CP.CurrentPeriodNetRevenue,0) AS CurrentPeriodNetRevenue
     , ISNULL(PP.PreviousPeriodNetRevenue,0) AS PreviousPeriodNetRevenue
     , ISNULL(CP.CurrentPeriodNetRevenue,0) - ISNULL(PP.PreviousPeriodNetRevenue,0) AS NetRevenueDifference 

FROM (SELECT DISTINCT dbo.fnMajorPGC(SUBSTRING(ixPGC,1,1)) AS Category 
      FROM tblPGC 
	 ) AS PGC 

FULL OUTER JOIN (SELECT ISNULL(CPSALES.Category, CPRETURNS.Category)  AS Category
					  , ISNULL(CPSALES.Merch, 0) AS CurrentPeriodSales
					  , ISNULL(CPRETURNS.Returns, 0) AS CurrentPeriodReturns
					  , ISNULL(CPSALES.Merch,0) - ISNULL(CPRETURNS.Returns,0) AS CurrentPeriodNetRevenue

				 FROM (SELECT DISTINCT dbo.fnMajorPGC(SUBSTRING(ixPGC,1,1)) AS Category 
					   FROM tblPGC 
					  ) AS PGC 

				 FULL OUTER JOIN (SELECT DISTINCT dbo.fnMajorPGC(SUBSTRING(ixPGC,1,1)) AS Category
								       , ISNULL(SUM(OL.mExtendedPrice),0) AS Merch
								  FROM tblOrderLine OL 
				                  LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
								  WHERE OL.dtShippedDate BETWEEN '01/01/2012' AND '05/16/2012'
								    AND OL.flgLineStatus = 'Shipped' 
								  GROUP BY dbo.fnMajorPGC(SUBSTRING(ixPGC,1,1))
								 ) AS CPSALES ON CPSALES.Category = PGC.Category
	 
				 FULL OUTER JOIN(SELECT DISTINCT dbo.fnMajorPGC(SUBSTRING(ixPGC,1,1))  AS Category
									  , ISNULL(SUM(CMD.mExtendedPrice),0) AS Returns
								 FROM tblCreditMemoDetail CMD  
								 JOIN tblSKU S ON S.ixSKU = CMD.ixSKU 
								 JOIN tblCreditMemoMaster CMM ON CMM.ixCreditMemo = CMD.ixCreditMemo  
								 WHERE CMM.dtCreateDate BETWEEN '01/01/12' AND '05/16/12'
								   AND CMM.flgCanceled = '0' 
								 GROUP BY  dbo.fnMajorPGC(SUBSTRING(ixPGC,1,1))
								) AS CPRETURNS ON CPRETURNS.Category = PGC.Category
				 
				 GROUP BY ISNULL(CPSALES.Category, CPRETURNS.Category) 			  
						, ISNULL(CPRETURNS.Returns, 0) 
						, ISNULL(CPSALES.Merch, 0) 
						, ISNULL(CPSALES.Merch,0) - ISNULL(CPRETURNS.Returns,0) 	 
			    ) AS CP ON CP.Category = PGC.Category -- CP = Current Period 

FULL OUTER JOIN (SELECT ISNULL(PPSALES.Category, PPRETURNS.Category)  AS Category
					  , ISNULL(PPSALES.Merch, 0) AS PreviousPeriodSales
					  , ISNULL(PPRETURNS.Returns, 0) AS PreviousPeriodReturns
					  , ISNULL(PPSALES.Merch,0) - ISNULL(PPRETURNS.Returns,0) AS PreviousPeriodNetRevenue

				 FROM (SELECT DISTINCT dbo.fnMajorPGC(SUBSTRING(ixPGC,1,1)) AS Category 
					   FROM tblPGC 
					  ) AS PGC 

				 FULL OUTER JOIN (SELECT DISTINCT dbo.fnMajorPGC(SUBSTRING(ixPGC,1,1)) AS Category
								       , ISNULL(SUM(OL.mExtendedPrice),0) AS Merch
								  FROM tblOrderLine OL 
				                  LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
								  WHERE OL.dtShippedDate BETWEEN '01/01/2011' AND '05/16/2011'
								    AND OL.flgLineStatus = 'Shipped' 
								  GROUP BY dbo.fnMajorPGC(SUBSTRING(ixPGC,1,1))
								 ) AS PPSALES ON PPSALES.Category = PGC.Category
	 
				 FULL OUTER JOIN(SELECT DISTINCT dbo.fnMajorPGC(SUBSTRING(ixPGC,1,1))  AS Category
									  , ISNULL(SUM(CMD.mExtendedPrice),0) AS Returns
								 FROM tblCreditMemoDetail CMD  
								 JOIN tblSKU S ON S.ixSKU = CMD.ixSKU 
								 JOIN tblCreditMemoMaster CMM ON CMM.ixCreditMemo = CMD.ixCreditMemo  
								 WHERE CMM.dtCreateDate BETWEEN '01/01/11' AND '05/16/11'
								   AND CMM.flgCanceled = '0' 
								 GROUP BY  dbo.fnMajorPGC(SUBSTRING(ixPGC,1,1))
								) AS PPRETURNS ON PPRETURNS.Category = PGC.Category
				 
				 GROUP BY ISNULL(PPSALES.Category, PPRETURNS.Category) 			  
						, ISNULL(PPRETURNS.Returns, 0) 
						, ISNULL(PPSALES.Merch, 0) 
						, ISNULL(PPSALES.Merch,0) - ISNULL(PPRETURNS.Returns,0) 	 
			    ) AS PP ON PP.Category = PGC.Category -- PP = Previous Period 	
			    		    
WHERE ISNULL(CP.Category, PP.Category) IS NOT NULL	

GROUP BY ISNULL(CP.Category, PP.Category) 
       , ISNULL(CP.CurrentPeriodNetRevenue,0) 
       , ISNULL(PP.PreviousPeriodNetRevenue,0)
       , ISNULL(CP.CurrentPeriodNetRevenue,0) - ISNULL(PP.PreviousPeriodNetRevenue,0) 	
       
       