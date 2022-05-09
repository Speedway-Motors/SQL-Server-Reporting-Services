-- Price changes for PRS SKUs
-- RETURNS SKUs in tblSKU and latest PRS catalog who's tblSKU.mPriceLevel1 value is different than yesterdays
SELECT YD.ixSKU 'SKU'
    , ISNULL(S.sWebDescription,S.sDescription) 'SKUDescription' 
    , YD.INVPriceLevel1 'YesterDayINVPriceLevel1'
    , YD.WEBPriceLevel1 'YesterDayWEBPriceLevel1'
    , S.mPriceLevel1 'CurrentINVPriceLevel'
    , CD.mPriceLevel1 'CurrentWEBPriceLevel1'
    , VS.mCost 'PVCost'
    , S.mAverageCost 'AvgCost'
    , S.mLatestCost 'LatestCost'
    -- COST APPLIED = IF VS.mCost > 0 THEN VS.mCost ELSE GREATER OF Avg Cost or Latest Cost
    , (CASE WHEN VS.mCost > 0 THEN VS.mCost 
          ELSE (CASE WHEN S.mAverageCost > S.mLatestCost THEN S.mAverageCost
                ELSE S.mLatestCost
                END)
          END
     ) 'CostApplied'
    , PRS.mPriceLevel1 'CurrentPRSPriceLevel1'
    , PRS.mPriceLevel3 'CurrentPRSPriceLevel3'      -- replace this and the next two with CurrentPRSPriceLevel3
    , ((PRS.mPriceLevel3-CAST((CASE WHEN ISNULL(VS.mCost,0) = 0 THEN (CASE WHEN S.mAverageCost > S.mLatestCost
                                           THEN S.mAverageCost
                                           ELSE S.mLatestCost
                                           END
                                           )
    ELSE VS.mCost
    END) AS smallmoney)
    )/PRS.mPriceLevel3
    ) 'PL3GPpercent'   
    /* PSEUDO LOGIC FOR SUGGESTED Price Levels 3,4,5
       WHEN GM% > 10% THEN Current Price + Inventory Price Change
           ELSE (CostApplied/.9) <-- GM 10%
       UNLESS above formula results > SKU PriceLevel1 (If it is, then just suggest PriceLevel1)
       -- if they ask for additional logic checks to be applied
       -- tell them NO
       -- ...and slap them
       -- ...HARD
    */
    , (CASE WHEN (CASE WHEN (((PRS.mPriceLevel3+(S.mPriceLevel1-YD.INVPriceLevel1)) - (CASE WHEN VS.mCost > 0 THEN VS.mCost 
                                                                            ELSE (CASE WHEN S.mAverageCost > S.mLatestCost THEN S.mAverageCost 
                                                                                  ELSE S.mLatestCost 
                                                                                  END
                                                                                  )
                                                                           END
                                                                           ))/(PRS.mPriceLevel3 + (S.mPriceLevel1-YD.INVPriceLevel1))) >.1 
            THEN (PRS.mPriceLevel3 + (S.mPriceLevel1-YD.INVPriceLevel1))
        ELSE (CASE WHEN VS.mCost > 0 THEN VS.mCost 
            ELSE (CASE WHEN S.mAverageCost > S.mLatestCost THEN S.mAverageCost
                ELSE S.mLatestCost
                END)
          END
     )/.9
     END) > S.mPriceLevel1 THEN S.mPriceLevel1
       ELSE 
           (CASE WHEN (((PRS.mPriceLevel3+(S.mPriceLevel1-YD.INVPriceLevel1)) - (CASE WHEN VS.mCost > 0 THEN VS.mCost 
                                                                                ELSE (CASE WHEN S.mAverageCost > S.mLatestCost THEN S.mAverageCost 
                                                                                      ELSE S.mLatestCost 
                                                                                      END
                                                                                      )
                                                                               END
                                                                               ))/(PRS.mPriceLevel3 + (S.mPriceLevel1-YD.INVPriceLevel1))) >.1 
                THEN (PRS.mPriceLevel3 + (S.mPriceLevel1-YD.INVPriceLevel1))
            ELSE (CASE WHEN VS.mCost > 0 THEN VS.mCost 
                ELSE (CASE WHEN S.mAverageCost > S.mLatestCost THEN S.mAverageCost
                    ELSE S.mLatestCost
                    END)
              END
         )/.9
         END)
       END) 'SuggestedPRSPL3'
/*
    , (CASE WHEN (((PRS.mPriceLevel3+(S.mPriceLevel1-YD.INVPriceLevel1)) - (CASE WHEN VS.mCost > 0 THEN VS.mCost 
                                                                            ELSE (CASE WHEN S.mAverageCost > S.mLatestCost THEN S.mAverageCost 
                                                                                  ELSE S.mLatestCost 
                                                                                  END
                                                                                  )
                                                                           END
                                                                           ))/(PRS.mPriceLevel3 + (S.mPriceLevel1-YD.INVPriceLevel1))) >.1 
            THEN (PRS.mPriceLevel3 + (S.mPriceLevel1-YD.INVPriceLevel1))
        ELSE (CASE WHEN VS.mCost > 0 THEN VS.mCost 
            ELSE (CASE WHEN S.mAverageCost > S.mLatestCost THEN S.mAverageCost
                ELSE S.mLatestCost
                END)
          END
     )/.9
     END) 'SuggestedPRSPL3'
*/
    , PRS.mPriceLevel4 'CurrentPRSPriceLevel4'   
    , ((PRS.mPriceLevel4-CAST((CASE WHEN ISNULL(VS.mCost,0) = 0 THEN (CASE WHEN S.mAverageCost > S.mLatestCost
                                           THEN S.mAverageCost
                                           ELSE S.mLatestCost
                                           END
                                           )
    ELSE VS.mCost
    END) AS smallmoney)
    )/PRS.mPriceLevel4
    ) 'PL4GPpercent'
    , (CASE WHEN (CASE WHEN (((PRS.mPriceLevel4+(S.mPriceLevel1-YD.INVPriceLevel1)) - (CASE WHEN VS.mCost > 0 THEN VS.mCost 
                                                                            ELSE (CASE WHEN S.mAverageCost > S.mLatestCost THEN S.mAverageCost 
                                                                                  ELSE S.mLatestCost 
                                                                                  END
                                                                                  )
                                                                           END
                                                                           ))/(PRS.mPriceLevel4 + (S.mPriceLevel1-YD.INVPriceLevel1))) >.1 
            THEN (PRS.mPriceLevel4 + (S.mPriceLevel1-YD.INVPriceLevel1))
        ELSE (CASE WHEN VS.mCost > 0 THEN VS.mCost 
            ELSE (CASE WHEN S.mAverageCost > S.mLatestCost THEN S.mAverageCost
                ELSE S.mLatestCost
                END)
          END
     )/.9
     END) > S.mPriceLevel1 THEN S.mPriceLevel1
       ELSE 
           (CASE WHEN (((PRS.mPriceLevel4+(S.mPriceLevel1-YD.INVPriceLevel1)) - (CASE WHEN VS.mCost > 0 THEN VS.mCost 
                                                                                ELSE (CASE WHEN S.mAverageCost > S.mLatestCost THEN S.mAverageCost 
                                                                                      ELSE S.mLatestCost 
                                                                                      END
                                                                                      )
                                                                               END
                                                                               ))/(PRS.mPriceLevel4 + (S.mPriceLevel1-YD.INVPriceLevel1))) >.1 
                THEN (PRS.mPriceLevel4 + (S.mPriceLevel1-YD.INVPriceLevel1))
            ELSE (CASE WHEN VS.mCost > 0 THEN VS.mCost 
                ELSE (CASE WHEN S.mAverageCost > S.mLatestCost THEN S.mAverageCost
                    ELSE S.mLatestCost
                    END)
              END
         )/.9
         END)
       END) 'SuggestedPRSPL4'
    , PRS.mPriceLevel5 'CurrentPRSPriceLevel5'  
    , ((PRS.mPriceLevel5-CAST((CASE WHEN ISNULL(VS.mCost,0) = 0 THEN (CASE WHEN S.mAverageCost > S.mLatestCost
                                           THEN S.mAverageCost
                                           ELSE S.mLatestCost
                                           END
                                           )
    ELSE VS.mCost
    END) AS smallmoney)
    )/PRS.mPriceLevel5
    ) 'PL5GPpercent'    
    , (CASE WHEN (CASE WHEN (((PRS.mPriceLevel5+(S.mPriceLevel1-YD.INVPriceLevel1)) - (CASE WHEN VS.mCost > 0 THEN VS.mCost 
                                                                            ELSE (CASE WHEN S.mAverageCost > S.mLatestCost THEN S.mAverageCost 
                                                                                  ELSE S.mLatestCost 
                                                                                  END
                                                                                  )
                                                                           END
                                                                           ))/(PRS.mPriceLevel5 + (S.mPriceLevel1-YD.INVPriceLevel1))) >.1 
            THEN (PRS.mPriceLevel5 + (S.mPriceLevel1-YD.INVPriceLevel1))
        ELSE (CASE WHEN VS.mCost > 0 THEN VS.mCost 
            ELSE (CASE WHEN S.mAverageCost > S.mLatestCost THEN S.mAverageCost
                ELSE S.mLatestCost
                END)
          END
     )/.9
     END) > S.mPriceLevel1 THEN S.mPriceLevel1
       ELSE 
           (CASE WHEN (((PRS.mPriceLevel5+(S.mPriceLevel1-YD.INVPriceLevel1)) - (CASE WHEN VS.mCost > 0 THEN VS.mCost 
                                                                                ELSE (CASE WHEN S.mAverageCost > S.mLatestCost THEN S.mAverageCost 
                                                                                      ELSE S.mLatestCost 
                                                                                      END
                                                                                      )
                                                                               END
                                                                               ))/(PRS.mPriceLevel5 + (S.mPriceLevel1-YD.INVPriceLevel1))) >.1 
                THEN (PRS.mPriceLevel5 + (S.mPriceLevel1-YD.INVPriceLevel1))
            ELSE (CASE WHEN VS.mCost > 0 THEN VS.mCost 
                ELSE (CASE WHEN S.mAverageCost > S.mLatestCost THEN S.mAverageCost
                    ELSE S.mLatestCost
                    END)
              END
         )/.9
         END)
       END) 'SuggestedPRSPL5'  
        
   -- CALCULATED COST = VS.mCost unless it's 0.  If 0, then use the greater of S.mAverageCost or S.mLatestCost
   ,CAST((CASE WHEN ISNULL(VS.mCost,0) = 0 THEN (CASE WHEN S.mAverageCost > S.mLatestCost
                                           THEN S.mAverageCost
                                           ELSE S.mLatestCost
                                           END
                                           )
    ELSE VS.mCost
    END) AS smallmoney) AS 'CalculatedCost'
    ,VS.ixVendor 'PVNum'
    ,V.sName 'PVName'    
FROM tblSnapshotWEBPriceLevel1 YD
    join tblCatalogDetail CD on YD.ixSKU = CD.ixSKU and CD.ixCatalog = (SELECT dbo.[GetCurrentWebCatalog] ())
    join tblCatalogDetail PRS on PRS.ixSKU = YD.ixSKU and PRS.ixCatalog = 'PRS.19' --@Catalog --
    left join tblSKU S on YD.ixSKU = S.ixSKU
    left join tblVendorSKU VS on S.ixSKU = VS.ixSKU and VS.iOrdinality = 1
    left join tblVendor V on V.ixVendor = VS.ixVendor       
WHERE YD.INVPriceLevel1 <> S.mPriceLevel1 --  YD.INVPriceLevel1 <> S.mPriceLevel1         ONLY USE = for TESTING





















-- Price changes for PRS SKUs
-- RETURNS SKUs in tblSKU and latest PRS catalog who's tblSKU.mPriceLevel1 value is different than yesterdays
SELECT YD.ixSKU 'SKU'
    , ISNULL(S.sWebDescription,S.sDescription) 'SKUDescription' 
    , YD.INVPriceLevel1 'YesterDayINVPriceLevel1'
    , YD.WEBPriceLevel1 'YesterDayWEBPriceLevel1'
    , S.mPriceLevel1 'CurrentINVPriceLevel'
    , CD.mPriceLevel1 'CurrentWEBPriceLevel1'
    , VS.mCost 'PVCost'
    , S.mAverageCost 'AvgCost'
    , S.mLatestCost 'LatestCost'
    -- COST APPLIED = IF VS.mCost > 0 THEN VS.mCost ELSE GREATER OF Avg Cost or Latest Cost
    , (CASE WHEN VS.mCost > 0 THEN VS.mCost 
          ELSE (CASE WHEN S.mAverageCost > S.mLatestCost THEN S.mAverageCost
                ELSE S.mLatestCost
                END)
          END
     ) 'CostApplied'
    , PRS.mPriceLevel1 'CurrentPRSPriceLevel1'
    , PRS.mPriceLevel3 'CurrentPRSPriceLevel3'      -- replace this and the next two with CurrentPRSPriceLevel3
    , ((PRS.mPriceLevel3-CAST((CASE WHEN ISNULL(VS.mCost,0) = 0 THEN (CASE WHEN S.mAverageCost > S.mLatestCost
                                           THEN S.mAverageCost
                                           ELSE S.mLatestCost
                                           END
                                           )
    ELSE VS.mCost
    END) AS smallmoney)
    )/PRS.mPriceLevel3
    ) 'PL3GPpercent'
    /*
    WHEN (Current Price + Inventory Price Change - CostApplied)/(Current Price + Inventory Price Change) >.1 
        THEN (Current Price + Inventory Price Change)
    ELSE (CostApplied/.9)                                                   */
--                  Current Price +     Inventory Price Change           - CostApplied
    , (CASE WHEN (((PRS.mPriceLevel3+(S.mPriceLevel1-YD.INVPriceLevel1)) - (CASE WHEN VS.mCost > 0 THEN VS.mCost 
                                                                            ELSE (CASE WHEN S.mAverageCost > S.mLatestCost THEN S.mAverageCost 
                                                                                  ELSE S.mLatestCost 
                                                                                  END
                                                                                  )
                                                                           END
                                                                           ))/(PRS.mPriceLevel3 + (S.mPriceLevel1-YD.INVPriceLevel1))) >.1 
            THEN (PRS.mPriceLevel3 + (S.mPriceLevel1-YD.INVPriceLevel1))
        ELSE (CASE WHEN VS.mCost > 0 THEN VS.mCost 
            ELSE (CASE WHEN S.mAverageCost > S.mLatestCost THEN S.mAverageCost
                ELSE S.mLatestCost
                END)
          END
     )/.9
     END) 'SuggestedPRSPL3'
    , PRS.mPriceLevel4 'CurrentPRSPriceLevel4'   
    , ((PRS.mPriceLevel4-CAST((CASE WHEN ISNULL(VS.mCost,0) = 0 THEN (CASE WHEN S.mAverageCost > S.mLatestCost
                                           THEN S.mAverageCost
                                           ELSE S.mLatestCost
                                           END
                                           )
    ELSE VS.mCost
    END) AS smallmoney)
    )/PRS.mPriceLevel4
    ) 'PL4GPpercent'
    , (CASE WHEN (((PRS.mPriceLevel4+(S.mPriceLevel1-YD.INVPriceLevel1)) - (CASE WHEN VS.mCost > 0 THEN VS.mCost 
                                                                            ELSE (CASE WHEN S.mAverageCost > S.mLatestCost THEN S.mAverageCost 
                                                                                  ELSE S.mLatestCost 
                                                                                  END
                                                                                  )
                                                                           END
                                                                           ))/(PRS.mPriceLevel4 + (S.mPriceLevel1-YD.INVPriceLevel1))) >.1 
            THEN (PRS.mPriceLevel4 + (S.mPriceLevel1-YD.INVPriceLevel1))
        ELSE (CASE WHEN VS.mCost > 0 THEN VS.mCost 
            ELSE (CASE WHEN S.mAverageCost > S.mLatestCost THEN S.mAverageCost
                ELSE S.mLatestCost
                END)
          END
     )/.9
     END) 'SuggestedPRSPL4'
    , PRS.mPriceLevel5 'CurrentPRSPriceLevel5'  
    , ((PRS.mPriceLevel5-CAST((CASE WHEN ISNULL(VS.mCost,0) = 0 THEN (CASE WHEN S.mAverageCost > S.mLatestCost
                                           THEN S.mAverageCost
                                           ELSE S.mLatestCost
                                           END
                                           )
    ELSE VS.mCost
    END) AS smallmoney)
    )/PRS.mPriceLevel5
    ) 'PL5GPpercent'    
    , (CASE WHEN (((PRS.mPriceLevel5+(S.mPriceLevel1-YD.INVPriceLevel1)) - (CASE WHEN VS.mCost > 0 THEN VS.mCost 
                                                                            ELSE (CASE WHEN S.mAverageCost > S.mLatestCost THEN S.mAverageCost 
                                                                                  ELSE S.mLatestCost 
                                                                                  END
                                                                                  )
                                                                           END
                                                                           ))/(PRS.mPriceLevel5 + (S.mPriceLevel1-YD.INVPriceLevel1))) >.1 
            THEN (PRS.mPriceLevel5 + (S.mPriceLevel1-YD.INVPriceLevel1))
        ELSE (CASE WHEN VS.mCost > 0 THEN VS.mCost 
            ELSE (CASE WHEN S.mAverageCost > S.mLatestCost THEN S.mAverageCost
                ELSE S.mLatestCost
                END)
          END
     )/.9
     END) 'SuggestedPRSPL5'     
        
   -- CALCULATED COST = VS.mCost unless it's 0.  If 0, then use the greater of S.mAverageCost or S.mLatestCost
   ,CAST((CASE WHEN ISNULL(VS.mCost,0) = 0 THEN (CASE WHEN S.mAverageCost > S.mLatestCost
                                           THEN S.mAverageCost
                                           ELSE S.mLatestCost
                                           END
                                           )
    ELSE VS.mCost
    END) AS smallmoney) AS 'CalculatedCost'
    ,VS.ixVendor 'PVNum'
    ,V.sName 'PVName'    
FROM tblSnapshotWEBPriceLevel1 YD
    join tblCatalogDetail CD on YD.ixSKU = CD.ixSKU and CD.ixCatalog = (SELECT dbo.[GetCurrentWebCatalog] ())
    join tblCatalogDetail PRS on PRS.ixSKU = YD.ixSKU and PRS.ixCatalog = 'PRS.19' --@Catalog --
    left join tblSKU S on YD.ixSKU = S.ixSKU
    left join tblVendorSKU VS on S.ixSKU = VS.ixSKU and VS.iOrdinality = 1
    left join tblVendor V on V.ixVendor = VS.ixVendor       
WHERE YD.INVPriceLevel1 <> S.mPriceLevel1 --  YD.INVPriceLevel1 <> S.mPriceLevel1         ONLY USE = for TESTING
--PRS.ixSKU = 'UP73411'
-- AND PRS.ixSKU NOT IN ('7154900-FRD','91000400.03','91000401.04','91000404.02','94540701.4','97052099')
--UP73411
-- and S.mLatestCost > S.mAverageCost 
-- AND VS.mCost = 0  -- 3,700 SKUs have 0 as the PV cost

-- YD.WEBPriceLevel1 <> CD.mPriceLevel1
--and S.ixSKU like '7%'

/****** SKU TO ALTER FOR TESTING!
SELECT * FROM tblSnapshotWEBPriceLevel1 WHERE ixSKU = 'UP73411'

-- ORIGINAL VALUES
ixSKU	WEBPriceLevel1	dtDateRecorded	        ixTimeRecorded	INVPriceLevel1
UP73411	299.99	        2019-07-23 00:00:00.000	17717	        299.99

UPDATE tblSnapshotWEBPriceLevel1
SET INVPriceLevel1 = 399.99
WHERE ixSKU = 'UP73411'


/*
=(Fields!CurrentPRSPriceLevel4.Value-Fields!CalculatedCost.Value)/Fields!CurrentPRSPriceLevel4.Value
'PL1-COGS/PL1
'PL4 GP%



SELECT dbo.[GetCurrentWebCatalog] () 


SELECT * FROM tblCatalogDetail
where ixCatalog = 'PRS.19'
and (mPriceLevel1 = 0
or mPriceLevel2 = 0
or mPriceLevel3 = 0
or mPriceLevel4 = 0
or mPriceLevel5 = 0
)
'97052099'
SELECT * FROM tblCatalogDetail
where ixCatalog = 'MRR.19'
and (mPriceLevel1 = 0
or mPriceLevel2 = 0
or mPriceLevel3 = 0
or mPriceLevel4 = 0
or mPriceLevel5 = 0
)

select *
-- DELETE
FROM tblCatalogDetail where ixSKU = '97052099' and ixCatalog = 'PRS.19'


*/

SELECT FORMAT(dtOrderDate,'yyyy.MM.dd') 'OrderDate', FORMAT(count(*),'###,###') 'OrderCount'
from tblOrder
where dtOrderDate > = '07/22/2019'
group by dtOrderDate

OrderDate	OrderCount as of 7-24-19 10:03
2019.07.22	3,048
2019.07.23	2,621
2019.07.24	446


*/