

SELECT ISNULL(ISNULL(SALES.Market, RTNS.Market), M.ixMarket) AS Market 
     , ISNULL(ISNULL(SALES.Description, RTNS.Description), M.sDescription) AS Description
     , ISNULL(SALES.GrossRev,0) - ISNULL(RTNS.RtnRev,0) AS NetRevenue 
     , ISNULL(SALES.GrossCost,0) - ISNULL(RTNS.RtnCost,0) AS NetCost 
     , (ISNULL(SALES.GrossRev,0) - ISNULL(RTNS.RtnRev,0)) - (ISNULL(SALES.GrossCost,0) - ISNULL(RTNS.RtnCost,0)) AS GrossMargin 
FROM (SELECT M.ixMarket AS Market 
           , M.sDescription AS Description 
           , SUM(OL.mExtendedPrice) AS GrossRev 
           , SUM(OL.mExtendedCost) AS GrossCost
      FROM tblOrderLine OL
      JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
      JOIN tblPGC PGC ON PGC.ixPGC = S.ixPGC 
      JOIN tblMarket M ON M.ixMarket = PGC.ixMarket 
      WHERE OL.flgLineStatus = 'Shipped' 
        AND OL.dtShippedDate BETWEEN @SalesStart AND @SalesEnd --'01/01/12' AND '06/03/12'
        AND SUBSTRING(S.ixPGC,1,1) IN (@MajorCode) --('A')
      GROUP BY M.ixMarket 
             , M.sDescription 
     ) AS SALES 
FULL OUTER JOIN (SELECT M.ixMarket AS Market
                      , M.sDescription AS Description 
                      , SUM(mExtendedPrice) AS RtnRev
                      , SUM(mExtendedCost) AS RtnCost
                 FROM tblCreditMemoMaster CMM 
                 JOIN tblCreditMemoDetail CMD ON CMD.ixCreditMemo = CMM.ixCreditMemo 
                 JOIN tblSKU S ON S.ixSKU = CMD.ixSKU 
                 JOIN tblPGC PGC ON PGC.ixPGC = S.ixPGC 
                 JOIN tblMarket M ON M.ixMarket = PGC.ixMarket 
                 WHERE CMM.dtCreateDate BETWEEN @RtnsStart AND @RtnsEnd -- '01/01/12' AND '06/03/12'
                   AND CMM.flgCanceled = '0' 
				   AND SUBSTRING(S.ixPGC,1,1) IN (@MajorCode) -- ('A')
                 GROUP BY M.ixMarket
                        , M.sDescription 
                ) AS RTNS ON RTNS.Market = SALES.Market     
FULL OUTER JOIN tblMarket M ON M.ixMarket = ISNULL(SALES.Market, RTNS.Market)    
ORDER BY GrossMargin DESC            