SELECT (CASE WHEN O.sMatchbackSourceCode IN ('317SSRN', '312SSRN', '314SSRN', '305SSRN') THEN 'NSRA SW Nationals'
             WHEN O.sMatchbackSourceCode IN ('317WSRN', '312WSRN', '314WSRN', '305WSRN') THEN 'NSRA W Nationals'
             WHEN O.sMatchbackSourceCode IN ('317SRNS', '312SRNS', '314SRNS', '305SRNS') THEN 'NSRA S Nationals'  
             WHEN O.sMatchbackSourceCode IN ('318GG33', '312GG33', '314GG33', '305GG33', '310GG33') THEN 'GG Nashville Nationals'
             WHEN O.sMatchbackSourceCode IN ('318NSRA', '312NSRA', '314NSRA', '305NSRA', '310NSRA') THEN 'NSRA MidAmer Nationals'                         
             WHEN O.sMatchbackSourceCode IN ('318GG34', '314GG34', '312GG34', '305GG34') THEN 'GG CO Nationals'
             WHEN O.sMatchbackSourceCode IN ('318B50', '314B50', '312B50', '305B50') THEN 'Back to 50s'     
             WHEN O.sMatchbackSourceCode IN ('318RSRN', '314RSRN', '312RSRN', '305RSRN') THEN 'NSRA Rocky Mtns'
             WHEN O.sMatchbackSourceCode IN ('318GG35', '314GG35', '312GG35', '305GG35') THEN 'GG Des Moines'  
             WHEN O.sMatchbackSourceCode IN ('318GG36', '314GG36', '312GG36', '305GG36') THEN 'GG Columbus'
             WHEN O.sMatchbackSourceCode IN ('318SN', '314SN', '312SN', '305SN') THEN 'Syracuse Nationals'                         
             WHEN O.sMatchbackSourceCode IN ('318CCSN', '314CCSN', '312CCSN', '305CCSN') THEN 'Car Craft'
             WHEN O.sMatchbackSourceCode IN ('319SRN', '316SRN', '312SRN', '305SRN') THEN 'NSRA Nationals' 
             ELSE 'Other'
        END) AS ShowGroup
        , O.ixCustomer 
       --, COUNT(CASE WHEN O.ixOrder LIKE '%-%' THEN 0 ELSE 1 
       --        END) AS CustCnt
       , (CASE WHEN O.dtShippedDate = (SELECT dbo.CustFirstOrderShippedDate (O.ixCustomer)) THEN 'NEW'
	           ELSE 'OLD'
	      END) AS CustomerStatus                                    
FROM tblOrder O 
WHERE sOrderChannel <> 'INTERNAL'
  and sOrderType <> 'Internal'
  and mMerchandise > 0
  and sOrderStatus IN ('Shipped', 'Dropshipped') 
  and sMatchbackSourceCode IN ('317SSRN', '312SSRN', '314SSRN', '305SSRN', '317WSRN', '312WSRN', '314WSRN', '305WSRN'
                                 , '317SRNS', '312SRNS', '314SRNS', '305SRNS', '318GG33', '312GG33', '314GG33', '305GG33', '310GG33'
                               , '318NSRA', '312NSRA', '314NSRA', '305NSRA', '310NSRA', '318GG34', '314GG34', '312GG34', '305GG34'
                                  , '318B50', '314B50', '312B50', '305B50', '318RSRN', '314RSRN', '312RSRN', '305RSRN'
                                , '318GG35', '314GG35', '312GG35', '305GG35', '318GG36', '314GG36', '312GG36', '305GG36'
                                  , '318SN', '314SN', '312SN', '305SN', '318CCSN', '314CCSN', '312CCSN', '305CCSN'
                                     , '319SRN', '316SRN', '312SRN', '305SRN')
ORDER BY ShowGroup	      
