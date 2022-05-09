SELECT ISNULL(CP.Market, PP.Market) AS Market 
     , ISNULL(CP.Description, PP.Description) AS Description 
     , ISNULL(CP.NetRev,0) AS CPNetRev
     , ISNULL(PP.NetRev,0) AS PPNetRev
   --  , (ISNULL(CP.NetRev,0) - ISNULL(PP.NetRev,0))/(ISNULL(PP.NetRev,0)) AS PercentChange

FROM (SELECT ISNULL(CPSALES.Market, CPRETURNS.Market) AS Market 
		   , ISNULL(CPSALES.Description, CPRETURNS.Description) AS Description 
           , ISNULL(CPSALES.Merch,0) - ISNULL(CPRETURNS.Returns,0) AS NetRev
			-- Current Period Sales Figures 
	  FROM (SELECT DISTINCT PGC.ixMarket AS Market
                 , M.sDescription AS Description
                 , ISNULL(SUM(OL.mExtendedPrice),0) AS Merch
	        FROM tblPGC PGC
			JOIN tblMarket M ON M.ixMarket = PGC.ixMarket
			JOIN tblSKU S ON S.ixPGC = PGC.ixPGC 
			JOIN tblOrderLine OL ON OL.ixSKU = S.ixSKU
			WHERE OL.dtShippedDate BETWEEN '01/01/12' AND  '05/20/12'
			GROUP BY PGC.ixMarket
                   , M.sDescription
	       ) AS CPSALES
	                   --Current Period Returns Figures 
	  FULL OUTER JOIN (SELECT DISTINCT PGC.ixMarket AS Market
					        , M.sDescription AS Description
							, ISNULL(SUM(CMD.mExtendedPrice),0) AS Returns
					   FROM tblPGC PGC 
					   JOIN tblMarket M ON M.ixMarket = PGC.ixMarket
					   JOIN tblSKU S ON S.ixPGC = PGC.ixPGC 
					   JOIN tblCreditMemoDetail CMD ON CMD.ixSKU = S.ixSKU 
					   JOIN tblCreditMemoMaster CMM ON CMM.ixCreditMemo = CMD.ixCreditMemo 
					   WHERE CMM.dtCreateDate BETWEEN '01/01/12' AND '05/20/12'
						 AND CMM.flgCanceled = '0'
					   GROUP BY PGC.ixMarket
                              , M.sDescription
					  ) AS CPRETURNS ON CPRETURNS.Market = CPSALES.Market 			  
      ) AS CP -- CP = Current Period 
      
FULL OUTER JOIN (SELECT ISNULL(PPSALES.Market, PPRETURNS.Market) AS Market 
		              , ISNULL(PPSALES.Description, PPRETURNS.Description) AS Description 
					  , ISNULL(PPSALES.Merch,0) - ISNULL(PPRETURNS.Returns,0) AS NetRev
					   -- Previous Period Sales Figures 
				 FROM (SELECT DISTINCT PGC.ixMarket AS Market
							, M.sDescription AS Description
							, ISNULL(SUM(OL.mExtendedPrice),0) AS Merch
					   FROM tblPGC PGC
					   JOIN tblMarket M ON M.ixMarket = PGC.ixMarket
					   JOIN tblSKU S ON S.ixPGC = PGC.ixPGC 
					   JOIN tblOrderLine OL ON OL.ixSKU = S.ixSKU
					   WHERE OL.dtShippedDate BETWEEN '01/01/11' AND '05/20/11' 
					   GROUP BY PGC.ixMarket
							  , M.sDescription
					  ) AS PPSALES
	                   --Previous Period Returns Figures 
				 FULL OUTER JOIN (SELECT DISTINCT PGC.ixMarket AS Market
									   , M.sDescription AS Description
									   , ISNULL(SUM(CMD.mExtendedPrice),0) AS Returns
								  FROM tblPGC PGC 
								  JOIN tblMarket M ON M.ixMarket = PGC.ixMarket
								  JOIN tblSKU S ON S.ixPGC = PGC.ixPGC 
								  JOIN tblCreditMemoDetail CMD ON CMD.ixSKU = S.ixSKU 
								  JOIN tblCreditMemoMaster CMM ON CMM.ixCreditMemo = CMD.ixCreditMemo 
								  WHERE CMM.dtCreateDate BETWEEN '01/01/11' AND '05/20/11' 
									AND CMM.flgCanceled = '0' 
							      GROUP BY PGC.ixMarket
										 , M.sDescription
								 ) AS PPRETURNS ON PPRETURNS.Market = PPSALES.Market 
				 ) AS PP ON PP.Market = CP.Market -- PP = Previous Period   					      
GROUP BY ISNULL(CP.Market, PP.Market) 
       , ISNULL(CP.Description, PP.Description)			
       , ISNULL(CP.NetRev,0) 
       , ISNULL(PP.NetRev,0) 
     --  , (ISNULL(CP.NetRev,0) - ISNULL(PP.NetRev,0))/(ISNULL(PP.NetRev,0)) 	 