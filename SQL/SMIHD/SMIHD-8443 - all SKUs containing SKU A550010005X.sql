-- SMIHD-8443 - all SKUs containing SKU A550010005X

-- 1st Tier SKUs
SELECT ixFinishedSKU -- SKU is a direct sub-components of 401 Finished SKUs (AKA 2nd tier SKUs) 
FROM tblBOMTemplateDetail
WHERE flgDeletedFromSOP = 0
    and ixSKU = 'A550010005X'
--ORDER BY ixFinishedSKU    

UNION 

-- 2nd Tier SKUs 
-- are subcomponents of 1,279 Finished SKUs (3rd tier SKUs)
SELECT ixFinishedSKU  
FROM tblBOMTemplateDetail
WHERE flgDeletedFromSOP = 0
        and ixSKU IN (SELECT ixFinishedSKU -- SKU is a sub-components of 401 Finished Parts (AKA 2nd tier SKUs) 
                      FROM tblBOMTemplateDetail
                      WHERE flgDeletedFromSOP = 0
                        and ixSKU = 'A550010005X')
UNION

-- Tier 3 SKUs
-- are subcomponents of 66 Finished SKUs (3rd tier SKUs)
SELECT ixFinishedSKU
FROM tblBOMTemplateDetail
WHERE flgDeletedFromSOP = 0
                and ixSKU IN (  SELECT ixFinishedSKU  
                                FROM tblBOMTemplateDetail
                                WHERE flgDeletedFromSOP = 0
                                        and ixSKU IN (SELECT ixFinishedSKU -- SKU is a sub-components of 401 Finished Parts (AKA 2nd tier SKUs) 
                                                      FROM tblBOMTemplateDetail
                                                      WHERE flgDeletedFromSOP = 0
                                                        and ixSKU = 'A550010005X')
                            )                                                                       


UNION

-- Tier 4 SKUs
-- are subcomponents of 4 Finished SKUs
SELECT ixFinishedSKU
FROM tblBOMTemplateDetail
WHERE flgDeletedFromSOP = 0
                and ixSKU IN (SELECT ixFinishedSKU
                              FROM tblBOMTemplateDetail
                              WHERE flgDeletedFromSOP = 0
                                              and ixSKU IN (SELECT ixFinishedSKU  
                                                            FROM tblBOMTemplateDetail
                                                            WHERE flgDeletedFromSOP = 0
                                                                      and ixSKU IN (SELECT ixFinishedSKU -- SKU is a sub-components of 401 Finished Parts (AKA 2nd tier SKUs) 
                                                                                    FROM tblBOMTemplateDetail
                                                                                    WHERE flgDeletedFromSOP = 0
                                                                                      and ixSKU = 'A550010005X'
                                                                                     )
                                                              ) 
                              )


UNION

-- Tier 5 SKUs
-- are subcomponents of  Finished SKUs 
SELECT ixFinishedSKU
FROM tblBOMTemplateDetail
WHERE flgDeletedFromSOP = 0
                  and ixSKU IN (SELECT ixFinishedSKU
                                FROM tblBOMTemplateDetail
                                WHERE flgDeletedFromSOP = 0
                                                and ixSKU IN (SELECT ixFinishedSKU
                                                              FROM tblBOMTemplateDetail
                                                              WHERE flgDeletedFromSOP = 0
                                                                              and ixSKU IN (SELECT ixFinishedSKU  
                                                                                            FROM tblBOMTemplateDetail
                                                                                            WHERE flgDeletedFromSOP = 0
                                                                                                      and ixSKU IN (SELECT ixFinishedSKU -- SKU is a sub-components of 401 Finished Parts (AKA 2nd tier SKUs) 
                                                                                                                    FROM tblBOMTemplateDetail
                                                                                                                    WHERE flgDeletedFromSOP = 0
                                                                                                                     -- and ixSKU = 'A550010005X'
                                                                                                                      )
                                                                                              ) 
                                                              )
                                )  -- Tier 5     8,331        



                  
-- 16,352 SKUs go at least 5 Tiers deep

-- Tier 6 SKUs
SELECT ixFinishedSKU
FROM tblBOMTemplateDetail
WHERE flgDeletedFromSOP = 0
                  and ixSKU IN (SELECT ixFinishedSKU
                                FROM tblBOMTemplateDetail
                                WHERE flgDeletedFromSOP = 0
                                                  and ixSKU IN (SELECT ixFinishedSKU
                                                                FROM tblBOMTemplateDetail
                                                                WHERE flgDeletedFromSOP = 0
                                                                                and ixSKU IN (SELECT ixFinishedSKU
                                                                                              FROM tblBOMTemplateDetail
                                                                                              WHERE flgDeletedFromSOP = 0
                                                                                                              and ixSKU IN (SELECT ixFinishedSKU  
                                                                                                                            FROM tblBOMTemplateDetail
                                                                                                                            WHERE flgDeletedFromSOP = 0
                                                                                                                                      and ixSKU IN (SELECT ixFinishedSKU -- SKU is a sub-components of 401 Finished Parts (AKA 2nd tier SKUs) 
                                                                                                                                                    FROM tblBOMTemplateDetail
                                                                                                                                                    WHERE flgDeletedFromSOP = 0
                                                                                                                                                     -- and ixSKU = 'A550010005X'
                                                                                                                                                      )
                                                                                                                              ) 
                                                                                              )
                                                                )  -- Tier 5     8,331               
                                ) -- Tier 6    7,498
                  
    

-- Tier 7 SKUs
SELECT ixFinishedSKU
into [AFCOTemp].dbo.PJC_BOMComponents_With7orMoreTiers
FROM tblBOMTemplateDetail
WHERE flgDeletedFromSOP = 0
                  and ixSKU IN (SELECT ixFinishedSKU
                                FROM tblBOMTemplateDetail
                                WHERE flgDeletedFromSOP = 0
                                                  and ixSKU IN (SELECT ixFinishedSKU
                                                                FROM tblBOMTemplateDetail
                                                                WHERE flgDeletedFromSOP = 0
                                                                                  and ixSKU IN (SELECT ixFinishedSKU
                                                                                                FROM tblBOMTemplateDetail
                                                                                                WHERE flgDeletedFromSOP = 0
                                                                                                                and ixSKU IN (SELECT ixFinishedSKU
                                                                                                                              FROM tblBOMTemplateDetail
                                                                                                                              WHERE flgDeletedFromSOP = 0
                                                                                                                                              and ixSKU IN (SELECT ixFinishedSKU  
                                                                                                                                                            FROM tblBOMTemplateDetail
                                                                                                                                                            WHERE flgDeletedFromSOP = 0
                                                                                                                                                                      and ixSKU IN (SELECT ixFinishedSKU -- SKU is a sub-components of 401 Finished Parts (AKA 2nd tier SKUs) 
                                                                                                                                                                                    FROM tblBOMTemplateDetail
                                                                                                                                                                                    WHERE flgDeletedFromSOP = 0
                                                                                                                                                                                     -- and ixSKU = 'A550010005X'
                                                                                                                                                                                      )
                                                                                                                                                              ) 
                                                                                                                              )
                                                                                                )  -- Tier 5     8,331               
                                                                ) -- Tier 6    7,498
                                 ) -- Tier 7    4,493

-- DROP table [AFCOTemp].dbo.PJC_BOMComponents_With7orMoreTiers                  
-- DROP table [AFCOTemp].dbo.PJC_BOMComponents_With8orMoreTiers
-- DROP table [AFCOTemp].dbo.PJC_BOMComponents_With9orMoreTiers
-- DROP table [AFCOTemp].dbo.PJC_BOMComponents_With10orMoreTiers
-- DROP table [AFCOTemp].dbo.PJC_BOMComponents_With11orMoreTiers

-- have to use temp table at this point, otherwise:    Msg 8623, Level 16, State 1, Line 3          The query processor ran out of internal resources and could not produce a query plan. 
-- This is a rare event and only expected for extremely complex queries or queries that reference a very large number of tables or partitions. Please simplify the query. If you believe you have received this message in error, contact Customer Support Services for more information.                                               
SELECT TD.ixFinishedSKU -- 5907
into [AFCOTemp].dbo.PJC_BOMComponents_With8orMoreTiers
FROM tblBOMTemplateDetail TD 
    join [AFCOTemp].dbo.PJC_BOMComponents_With7orMoreTiers T on T.ixFinishedSKU = TD.ixSKU
WHERE TD.flgDeletedFromSOP = 0

SELECT TD.ixFinishedSKU -- 8026
into [AFCOTemp].dbo.PJC_BOMComponents_With9orMoreTiers
FROM tblBOMTemplateDetail TD 
    join [AFCOTemp].dbo.PJC_BOMComponents_With8orMoreTiers T on TD.ixSKU = T.ixFinishedSKU 
WHERE TD.flgDeletedFromSOP = 0

SELECT TD.ixFinishedSKU -- 10857
into [AFCOTemp].dbo.PJC_BOMComponents_With10orMoreTiers
FROM tblBOMTemplateDetail TD 
    join [AFCOTemp].dbo.PJC_BOMComponents_With9orMoreTiers T on TD.ixSKU = T.ixFinishedSKU 
WHERE TD.flgDeletedFromSOP = 0


SELECT TD.ixFinishedSKU -- 16256
into [AFCOTemp].dbo.PJC_BOMComponents_With11orMoreTiers
FROM tblBOMTemplateDetail TD 
    join [AFCOTemp].dbo.PJC_BOMComponents_With10orMoreTiers T on TD.ixSKU = T.ixFinishedSKU 
WHERE TD.flgDeletedFromSOP = 0

SELECT TD.ixFinishedSKU -- 16256
into [AFCOTemp].dbo.PJC_BOMComponents_With12orMoreTiers
FROM tblBOMTemplateDetail TD 
    join [AFCOTemp].dbo.PJC_BOMComponents_With11orMoreTiers T on TD.ixSKU = T.ixFinishedSKU 
WHERE TD.flgDeletedFromSOP = 0
-- TEST ABOVE BY TRYING AT THE FIRST LEVEL AND WORKING YOUR WAY UP TO SEE IF NUMBERS MATCH


                  
SELECT COUNT(*) FROM [AFCOTemp].dbo.PJC_BOMComponents_With7orMoreTiers -- 4,498      
SELECT COUNT(*) FROM [AFCOTemp].dbo.PJC_BOMComponents_With8orMoreTiers -- 4,498               
SELECT COUNT(*) FROM [AFCOTemp].dbo.PJC_BOMComponents_With9orMoreTiers -- 4,498   
SELECT COUNT(*) FROM [AFCOTemp].dbo.PJC_BOMComponents_With10orMoreTiers -- 4,498   
                  
                  
                  
                                    
                                    
                                    
-- count of templates each SKU is used in
SELECT ixSKU, COUNT(distinct ixFinishedSKU) 'FinishedBOMs'
FROM tblBOMTemplateDetail
WHERE flgDeletedFromSOP = 0
    -- and ixSKU = 'SKU#HERE'
GROUP BY ixSKU
ORDER BY COUNT(distinct ixFinishedSKU) desc -- will show SKUs used in most templates first




SELECT TD.ixSKU, S.sDescription, count(TD.ixFinishedSKU) -- SKU is a direct sub-components of 401 Finished SKUs (AKA 2nd tier SKUs) 
FROM tblBOMTemplateDetail TD
    join tblSKU S on TD.ixSKU = S.ixSKU
WHERE TD.flgDeletedFromSOP = 0
    and S.flgIntangible = 0
    and S.sDescription NOT LIKE '%LABOR%'
group by TD.ixSKU, S.sDescription
having count(TD.ixFinishedSKU) > 3000

SELECT * from tblSKU where ixSKU = 'A901040009X'




