-- SMIHD-22089 - Product Content Quality Field

-- 4/27-22 SOP & DW counts were off.  Got a list from Connie and refed the SKUs.  
--    After the updates and flagging some SKUs that had been deleted from SOP, counts matched 100%.
SELECT sProductContentQuality, FORMAT(COUNT(*),'###,###') 'SKUS'
FROM tblSKU
where flgDeletedFromSOP = 0
group by sProductContentQuality
/*														AFTER
sProductContentQuality	SKUS			SOP		DELTA	CLEAN-UP
NULL					211,768
A						1,091			1,116	25		1,116
B						545				550		 5		550
C						984				987		 3		987
*/


SELECT count(*), count(distinct(ixSKU)) 'UniqueCnt'
FROM [SMITemp].dbo.PJC_SMHD22809_ProductQualityValues -- 2653	2653


SELECT SOP.*, S.sProductContentQuality
FROM [SMITemp].dbo.PJC_SMHD22809_ProductQualityValues SOP
	LEFT JOIN tblSKU S on SOP.ixSKU = S.ixSKU
WHERE S.sProductContentQuality is NULL
--	or SOP.sProductContentQuality <> S.sProductContentQuality
ORDER BY SOP.sProductContentQuality, S.sProductContentQuality

-- SKUs with values in DW but NOT in SOP
SELECT ixSKU, sProductContentQuality, dtDateLastSOPUpdate, ixTimeLastSOPUpdate, flgDeletedFromSOP
FROM tblSKU
where flgDeletedFromSOP = 0
and sProductContentQuality is NOT NULL
and ixSKU NOT IN (SELECT ixSKU
					FROM [SMITemp].dbo.PJC_SMHD22809_ProductQualityValues SOP)




-- SELLABLE SKUs with QAV and Price > 0 
SELECT sProductContentQuality, count(S.ixSKU) 'SKUs'
FROM tblSKU S
	    left join (-- SALEABLE SKUs
                SELECT DISTINCT t.ixSOPSKU AS 'ixSOPSKU', t1.ixSOPSKUBase 'SOPSKUBase', t.ixSKUBase 'SKUBase'  -- 148,970 SKUs @40 seconds
                FROM tng.tblskuvariant t  -- IF RUNNING DIRECTLY ON DW REMOVE ->  
                    INNER JOIN tng.tblskubase t1 ON t.ixSKUBase = t1.ixSKUBase
                    INNER JOIN tng.tblproductpageskubase t2 ON t1.ixSKUBase = t2.ixSKUBase
                --     INNER JOIN tng.tblproductpage t3 ON t2.ixProductPage = t3.ixProductPage
                WHERE t.ixSOPSKU is NOT NULL
                    AND t.flgPublish = 1
                    AND t1.flgWebPublish = 1
                    -- AND t3.flgActive = 1   replaced with t1.flgWebActive = 1 check per SMIHD-17893
                    AND t1.flgWebActive = 1  
                    AND(t.iTotalQAV > 0 
                        OR t.flgBackorderable = 1)
               ) SS ON S.ixSKU = SS.ixSOPSKU --COLLATE SQL_Latin1_General_CP1_CI_AS
	left join tblSKULocation SL on S.ixSKU = SL.ixSKU 
									and SL.ixLocation = 99
where flgDeletedFromSOP = 0
	and S.dtCreateDate >= '01/01/2022'
	and S.mPriceLevel1 > 0
	and SS.ixSOPSKU is NOT NULL
	and SL.iQAV > 0
	--and sProductContentQuality is NOT NULL
GROUP BY sProductContentQuality
order by sProductContentQuality
/*

tblSKU.sProductContentQuality

SKUs created YTD that are:
web active 
have a price > 0 
and QAV >0 at LNK

sProduct
Content
Quality	SKUs
=======	=====
NULL	325
A		164
B		130
C		25
*/


-- WHO is creating the SKUs without a sProductContentQuality value
SELECT S.ixCreator, count(S.ixSKU) 'SKUs'
FROM tblSKU S
	    left join (-- SALEABLE SKUs
                SELECT DISTINCT t.ixSOPSKU AS 'ixSOPSKU', t1.ixSOPSKUBase 'SOPSKUBase', t.ixSKUBase 'SKUBase'  -- 148,970 SKUs @40 seconds
                FROM tng.tblskuvariant t  -- IF RUNNING DIRECTLY ON DW REMOVE ->  
                    INNER JOIN tng.tblskubase t1 ON t.ixSKUBase = t1.ixSKUBase
                    INNER JOIN tng.tblproductpageskubase t2 ON t1.ixSKUBase = t2.ixSKUBase
                --     INNER JOIN tng.tblproductpage t3 ON t2.ixProductPage = t3.ixProductPage
                WHERE t.ixSOPSKU is NOT NULL
                    AND t.flgPublish = 1
                    AND t1.flgWebPublish = 1
                    -- AND t3.flgActive = 1   replaced with t1.flgWebActive = 1 check per SMIHD-17893
                    AND t1.flgWebActive = 1  
                    AND(t.iTotalQAV > 0 
                        OR t.flgBackorderable = 1)
               ) SS ON S.ixSKU = SS.ixSOPSKU --COLLATE SQL_Latin1_General_CP1_CI_AS
	left join tblSKULocation SL on S.ixSKU = SL.ixSKU 
									and SL.ixLocation = 99
where flgDeletedFromSOP = 0
	and S.dtCreateDate >= '01/01/2022'
	and S.mPriceLevel1 > 0
	and SS.ixSOPSKU is NOT NULL
	and SL.iQAV > 0
	and sProductContentQuality is NULL
GROUP BY ixCreator
order by ixCreator

