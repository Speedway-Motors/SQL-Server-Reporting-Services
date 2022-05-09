-- SMIHD-19724 - refeed 144k SKUs

SELECT * FROM [SMITemp].cbo.PJC_SMIHD19724_SMISKUsToRefeed

-- DROP TABLE [SMITemp].dbo.PJC_SMIHD19724_SMISKUsToRefeed  
SELECT count(ixSKU) FROM [SMITemp].dbo.PJC_SMIHD19724_SMISKUsToRefeed            -- 143,979 
SELECT count(distinct (ixSKU)) FROM [SMITemp].dbo.PJC_SMIHD19724_SMISKUsToRefeed -- 143,979

-- SELECT * into #StillNeedToFeed FROM [SMITemp].dbo.PJC_SMIHD19724_SMISKUsToRefeed 


-- BATCH
SELECT SNF.ixSKU, S.dtDateLastSOPUpdate
FROM #StillNeedToFeed SNF
    left join tblSKU S on SNF.ixSKU = S.ixSKU
--WHERE S.dtDateLastSOPUpdate >= '10/15/2020' -- 13,981
order by S.dtDateLastSOPUpdate desc--, SNF.ixSKU


SELECT S.ixSKU, S.flgActive, S.dtDateLastSOPUpdate
FROM tblSKU S
WHERE ixSKU in (SELECT SNF.ixSKU--, SKUM.iQAV, SKUM.iQOS
                FROM #StillNeedToFeed SNF
                    left join tblSKU S on SNF.ixSKU = S.ixSKU
               -- WHERE S.dtDateLastSOPUpdate >= '10/15/2020' -- 13,012
               )
and dtDateLastSOPUpdate < '12/29/2020'
              
/* AFTER BATCH completes and above query returns 0 

BEGIN TRAN

    DELETE FROM #StillNeedToFeed
    WHERE ixSKU in (SELECT SNF.ixSKU
                    FROM #StillNeedToFeed SNF
                        left join tblSKU S on SNF.ixSKU = S.ixSKU
                  --  WHERE S.dtDateLastSOPUpdate >= '10/15/2020' -- 13,095
                    )

ROLLBACK TRAN

*/

SELECT count(*) FROM #StillNeedToFeed 
/*                      -- est 5,200/hour
 139,480 @12/28 5pm 
  64,929 @12/29 3:45pm
  40,171 @12/29 8:20pm
  36,111 @12/30 1:50pm      ~7 hours left
  27,076 @12/30 3:30pm   
  13,981   
  */
/* UPDATE SPEEDS

Rec     Sec     Rec/Sec             -- FEEDS CUT OFF AT 04:35 and 20:58
======   =====   =======    
 4,212   2,878   1.46
11,745   7,763   1.51
 5,377   3,157   1.70
24,824  14,300   1.73       
 9,042   5,611   1.61   
13,095   8,789   1.49
13,981           -- ETA 8:43 pm

1.3 rec/sec = 5,200/hour    Est 30.8 hours total to refeed

*/

SELECT FORMAT(count(*),'###,###') FROM #StillNeedToFeed 
-- 139,480 12/28 5pm
