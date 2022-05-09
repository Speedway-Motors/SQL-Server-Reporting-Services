-- Prop65 pushing batches

-- TOTAL COUNT BY FLAG
SELECT flgProp65 ,FORMAT(count(ixSKU),'##,##0') 'SKUCnt', FORMAT(getdate(),'yyyy-MM-dd HH:mm') 'AsOf'
FROM tblSKU
WHERE flgDeletedFromSOP = 0
  --  and flgActive = 1
GROUP BY flgProp65
ORDER BY flgProp65
    /*
    SPEEDWAY
    flg
    Prop65	SKU Cnt	As Of
    =====   ======= ================
    NULL	  6,950	2018-09-14 14:28
    0	    109,817
    1	    163,714
    2	    143,042

    NULL	 11,295	2018-09-06 13:19
    0	     95,990
    1	    149,899
    2	     23,494

    NULL	 23,600	2018-08-31 15:04
    0	    106,547
    1	    150,334
    2	    141,925

    NULL	 98,146	2018-08-23 09:23
    0	     93,023
    1	     90,692
    2	    140,073

    NULL	114,576	2018-08-15 16:56
    0	     80,155
    1	     87,333
    2	    139,612

    NULL	225,389	2018-07-16 09:37
    0	     48,137	
    1	     37,874	
    2	     99,580	

    NULL	351,581	2018-07-02 20:26
    0	     24,600	
    1	     33,937	


    AFCO
    flg
    Prop65	SKUCnt	AsOf
    =====   ======  ================
    NULL	 37,470	2018-09-14 14:26
    0	        670
    1	     30,205
    2	          2

    NULL	37,462	2018-08-29 16:35
    0	       670	
    1	    30,207	

    NULL	46,757	2018-08-28 11:56
    0	       193  -- should be about 853 after update
    1	    21,389

    NULL	 56,979	2018-08-27 13:06
    0	        193	
    1	     11,155	

    NULL	68,264	2018-08-24 13:24
    0	         8  
    1	        51  
*/

SELECT ixSKU, flgProp65, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
FROM tblSKU
WHERE flgProp65 is NOT NULL
ORDER BY dtDateLastSOPUpdate, ixTimeLastSOPUpdate



-- remaining unflagged SKUs - counts by LU date
SELECT FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LU-DATE    ',
    FORMAT(count(*),'#,###') 'SKUs'
   -- ixSKU, dtDateLastSOPUpdate
FROM tblSKU
WHERE flgDeletedFromSOP = 0
    and flgProp65 is NULL
GROUP BY dtDateLastSOPUpdate
ORDER by FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd')
    /*
            SMI
    LU-DATE	    SKUs
    ==========  ======
    2018.09.12	5,863
    2018.09.13	  309
    2018.09.14	  778
    
            AFCO
    LU-DATE	    SKUs
    ==========  ======
    2018.09.01	22,235
    2018.09.02	 7,903
    2018.09.03	    93
    2018.09.05	 5,239
    2018.09.06	 1,931
    */

select top 2382 
    ixSKU, dtDateLastSOPUpdate  from tblSKU
where flgDeletedFromSOP = 0
--    and dtCreateDate > '07/01/2018'
    and flgProp65 is NULL
and dtDateLastSOPUpdate < '09/12/2018'
order by dtDateLastSOPUpdate, ixTimeLastSOPUpdate



/* BATCH TABLES
SELECT * FROM Prop65_RET_20180905_mixedflags_2732rows
SELECT * FROM Prop65_RET_20180904_mixedflags

SELECT * FROM Prop65_ALB_20180830_flg0_389rows
SELECT * FROM Prop65_ALB_20180830_flg1_5098rows
SELECT * FROM Prop65_ALB_20180830_flg2_31rows

SELECT * FROM Prop65_ALB_20180829_flg2_2200rows
SELECT * FROM Prop65_ALB_20180829_flg0_5946rows
SELECT * FROM Prop65_ALB_20180829_flg1_26634rows

SELECT * FROM Prop65_ALB_20180829_flg1_30308rowsAFCO
SELECT * FROM Prop65_ALB_20180829_flg0_673rowsAFCO 

SELECT * FROM Prop65_ALB_20180823_flg0_18989rows 
SELECT * FROM Prop65_ALB_20180823_flg1_27033rows 
SELECT * FROM Prop65_ALB_20180823_flg2_465rows 
SELECT * FROM Prop65_ALB_20180713_flg2_139609rows
SELECT * FROM Prop65_ALB_complete_flg0_78398rows
SELECT * FROM Prop65_ALB_20180710_flg1_33611rows
SELECT * FROM Prop65_ALB_20180730_ones_19004rows
SELECT * FROM Prop65_ALB_20180713_mixedflg_111727rows
SELECT * FROM Prop65_ALB_20180712_mixedflg_11428rows
SELECT * FROM Prop65_ALB_20180629_flg1_34741rows_InitialBatch
SELECT * FROM Prop65_ALB_20180702_mixedflg_71549rows_2ndBatch
SELECT * FROM Prop65_ALB_20180712_mixedflg_11428rows
*/

/*******************************************************************/
/************************    flgProp65=0    ************************/
    -- check for SKUs formatted as scientific notation
    SELECT * FROM [SMITemp].dbo.Prop65_RET_20180905_mixedflags_2732rows
    WHERE ixSKU like '%+%'

    -- INVALID SKUS
    SELECT * FROM [SMITemp].dbo.Prop65_RET_20180905_mixedflags_2732rows P65
        left join tblSKU S ON S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS  = P65.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
    WHERE S.ixSKU is NULL -- 40 NON MATCHES

    -- Count vs Distinct Count
    SELECT FORMAT(COUNT(ixSKU),'##,##0')  GrossCnt, FORMAT(count(distinct ixSKU),'##,##0') DistCnt
    FROM [SMITemp].dbo.Prop65_RET_20180905_mixedflags_2732rows P65
    /*  Gross   Dist
        Cnt	    Cnt
        2,732	2,732
    */

        -- DUPE SKUS
        SELECT ixSKU, count(*) 'SKUcnt' from [SMITemp].dbo.Prop65_RET_20180905_mixedflags_2732rows
        group by ixSKU
        HAVING   count(*) > 1
        order by ixSKU

          
    -- ALREADY FLAGGED
    SELECT FORMAT(COUNT( P65.ixSKU),'##,##0')  GrossCnt, FORMAT(count(distinct  P65.ixSKU),'##,##0') DistCnt
    FROM [SMITemp].dbo.Prop65_RET_20180905_mixedflags_2732rows P65
        left join tblSKU S on P65.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = S.ixSKU  COLLATE SQL_Latin1_General_CP1_CI_AS
    WHERE S.flgProp65 IS NOT NULL
    /*  Gross   Dist
        Cnt	    Cnt
        7,769	7,769 
    */

    -- SKUs THAT STILL NEED TO BE PUSHED
    SELECT distinct P65.ixSKU
    FROM [SMITemp].dbo.Prop65_RET_20180905_mixedflags_2732rows P65
        left join tblSKU S on P65.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS 
    WHERE (S.flgProp65 IS NULL OR S.flgProp65 <> 0)
        and P65.ixSKU NOT LIKE '%+%'
    ORDER BY P65.ixSKU --  deleted from SOP



    -- RICHARDS that didn't update
    SELECT distinct P65.ixSKU, dtDateLastSOPUpdate, T.chTime 'LastSOPUpdateTime'
    FROM [SMITemp].dbo.Prop65_RET_20180905_mixedflags_2732rows P65
        left join tblSKU S on P65.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS 
        left join tblTime T on T.ixTime = S.ixTimeLastSOPUpdate
    WHERE S.flgProp65 IS NULL --OR S.flgProp65 <> 0)
        and P65.ixSKU NOT LIKE '%+%'
        and (S.dtDateLastSOPUpdate is NULL or S.dtDateLastSOPUpdate < '09/04/2018')
    ORDER BY dtDateLastSOPUpdate, T.chTime, P65.ixSKU --  deleted from SOP

/*******************************************************************/
/************************    flgProp65=1    ************************/
    -- check for SKUs formatted as scientific notation
    SELECT * FROM [SMITemp].dbo.Prop65_ALB_20180830_flg1_5098rows
    WHERE ixSKU like '%+%'

    -- INVALID SKUS
    SELECT * FROM [SMITemp].dbo.Prop65_ALB_20180830_flg1_5098rows P65
        left join tblSKU S ON S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS  = P65.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
    WHERE S.ixSKU is NULL

    -- Count vs Distinct Count
    SELECT FORMAT(COUNT(ixSKU),'##,##0')  GrossCnt, FORMAT(count(distinct ixSKU),'##,##0') DistCnt
    FROM [SMITemp].dbo.Prop65_ALB_20180830_flg1_5098rows P65
    /*  Gross   Dist
        Cnt	    Cnt
        5,098	5,081
    */

    -- DUPE SKUS
    SELECT ixSKU, count(*) 'SKUcnt' from [SMITemp].dbo.Prop65_ALB_20180830_flg1_5098rows
    group by ixSKU
    HAVING   count(*) > 1
    order by ixSKU

          
    -- ALREADY FLAGGED
    SELECT FORMAT(COUNT( P65.ixSKU),'##,##0')  GrossCnt, FORMAT(count(distinct  P65.ixSKU),'##,##0') DistCnt
    FROM [SMITemp].dbo.Prop65_ALB_20180830_flg1_5098rows P65
        left join tblSKU S on P65.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = S.ixSKU  COLLATE SQL_Latin1_General_CP1_CI_AS
    WHERE S.flgProp65 IS NOT NULL
    /*  Gross   Dist
        Cnt	    Cnt
        6	6   -- about 6,000 still need to be refed
    */

    -- SKUs THAT STILL NEED TO BE PUSHED
    SELECT distinct P65.ixSKU
    FROM [SMITemp].dbo.Prop65_ALB_20180830_flg1_5098rows P65
        left join tblSKU S on P65.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS 
    WHERE (S.flgProp65 IS NULL OR S.flgProp65 <> 1)
        and P65.ixSKU NOT LIKE '%+%'
    ORDER BY P65.ixSKU -- 41 deleted from SOP



/*******************************************************************/
/************************    flgProp65=2    ************************/
    -- check for SKUs formatted as scientific notation
    SELECT * FROM [SMITemp].dbo.Prop65_ALB_20180830_flg2_31rows
    WHERE ixSKU like '%+%'

    -- INVALID SKUS
    SELECT * FROM [SMITemp].dbo.Prop65_ALB_20180830_flg2_31rows P65
        left join tblSKU S ON S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS  = P65.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
    WHERE S.ixSKU is NULL

    -- Count vs Distinct Count
    SELECT FORMAT(COUNT(ixSKU),'##,##0')  GrossCnt, FORMAT(count(distinct ixSKU),'##,##0') DistCnt
    FROM [SMITemp].dbo.Prop65_ALB_20180830_flg2_31rows P65
    /*  Gross   Dist
        Cnt	    Cnt
        57	    57
    */

    -- DUPE SKUS
    SELECT ixSKU, count(*) 'SKUcnt' from [SMITemp].dbo.Prop65_ALB_20180830_flg2_31rows
    group by ixSKU
    HAVING   count(*) > 1
    order by ixSKU

          
    -- ALREADY FLAGGED
    SELECT FORMAT(COUNT( P65.ixSKU),'##,##0')  GrossCnt, FORMAT(count(distinct  P65.ixSKU),'##,##0') DistCnt
    FROM [SMITemp].dbo.Prop65_ALB_20180830_flg2_31rows P65
        left join tblSKU S on P65.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = S.ixSKU  COLLATE SQL_Latin1_General_CP1_CI_AS
    WHERE S.flgProp65 IS NOT NULL
    /*  Gross   Dist
        Cnt	    Cnt
        56	    56   -- 
    */

    -- SKUs THAT STILL NEED TO BE PUSHED
    SELECT distinct P65.ixSKU
    FROM [SMITemp].dbo.Prop65_ALB_20180830_flg2_31rows P65
        left join tblSKU S on P65.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS 
    WHERE (S.flgProp65 IS NULL OR S.flgProp65 <> 2)
        and P65.ixSKU NOT LIKE '%+%'
    ORDER BY P65.ixSKU -- 41 deleted from SOP



/*
SELECT ixSKU, flgProp65, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
FROM tblSKU
WHERE flgDeletedFromSOP = 0
    and flgProp65 is NULL
    and dtDateLastSOPUpdate < '08/26/2018'
ORDER BY dtDateLastSOPUpdate, ixTimeLastSOPUpdate  -- 343


SELECT * FROM tblTime where ixTime in (43040)
/*
43040	11:57:20  
*/


SELECT count(S.ixSKU) SKUCnt
FROM tblSKU S
    left join tblSKULocation SL on S.ixSKU = SL.ixSKU and SL.ixLocation = 99
WHERE S.flgDeletedFromSOP = 0
    and S.flgProp65 is NULL  -- 35,676
    and S.flgActive = 0-- 466
    and SL.iQOS > 0 -- 455
    --and (S.ixSKU like 'UP%' or S.ixSKU like 'AUP%') -- 46
    -- and GS.ixSKU is NOT NULL
*/


    -- CCC's 12 month rev breakdown for SKUs with no Prop65 flag
SELECT S.flgProp65,
    FORMAT(sum(OL.mExtendedPrice),'$###,###') as '12Mo Rev',
    FORMAT(count(distinct S.ixSKU),'###,###') 'SKUcnt'-- Only counts SKUs with Sales
FROM tblOrderLine OL   
    left join tblSKU S on OL.ixSKU=S.ixSKU  
    left join tblBOMTemplateMaster BM on BM.ixFinishedSKU = S.ixSKU
WHERE OL.dtOrderDate >= DATEADD(yy, -1, getdate()) 
    and OL.flgLineStatus in ('Shipped','Dropshipped')
    and S.flgDeletedFromSOP = 0     -- $28,128,627
    --and BM.ixFinishedSKU is NOT NULL -- $8,780,224
GROUP BY S.flgProp65  
ORDER BY S.flgProp65  
    /*
    CLEANED UP VERSION


    flg
    Prop65	12Mo Rev	SKUcnt    AS OF 
    ======  =========== ======  ========
    NULL	$18,755,459	10,482  09/04/18 10am
    0	    $45,076,737	24,173
    1	    $65,676,300	33,948
    2	    $ 2,823,411	8,825


    NULL	$28,284,806 08/30/18
    1	    $55,698,353
    2	     $2,999,375
    0	    $44,807,595

    NULL	$34,041,795 08/23/18
    0	    $44,930,469
    1	    $50,134,387
    2	    $2,761,319


    NULL	$59,608,197 08/21/18
    0	    $40,391,110
    1	    $29,596,695
    2	    $ 2,612,766

    */

SELECT S.ixSKU, 
    SUM(SL.iQAV) 'QAV',
    FORMAT(sum(OL.mExtendedPrice),'$###,###') as '12Mo Rev'
FROM tblOrderLine OL   
    left join tblSKU S on OL.ixSKU=S.ixSKU  
    left join tblSKULocation SL on SL.ixSKU = S.ixSKU and SL.ixLocation = 99
WHERE OL.dtOrderDate >= DATEADD(yy, -1, getdate()) 
    and OL.flgLineStatus in ('Shipped','Dropshipped')
    and S.flgDeletedFromSOP = 0
    and S.flgProp65 is NULL
GROUP BY S.ixSKU
ORDER BY SUM(SL.iQAV) DESC



SELECT --S.ixSKU, 
    VS.ixVendor, V.sName, 
    --SUM(SL.iQAV) 'QAV',
    count(distinct S.ixSKU) 'SKUs',
    FORMAT(sum(OL.mExtendedPrice),'$###,###') as '12Mo Rev'
FROM tblOrderLine OL   
    left join tblSKU S on OL.ixSKU=S.ixSKU  
    left join tblSKULocation SL on SL.ixSKU = S.ixSKU and SL.ixLocation = 99
    left join tblVendorSKU VS on VS.ixSKU = S.ixSKU and VS.iOrdinality = 1
    left join tblVendor V on VS.ixVendor = V.ixVendor
WHERE OL.dtOrderDate >= DATEADD(yy, -1, getdate()) 
    and OL.flgLineStatus in ('Shipped','Dropshipped')
    and S.flgDeletedFromSOP = 0
    and S.flgProp65 is NULL
GROUP BY VS.ixVendor, V.sName
ORDER BY sum(OL.mExtendedPrice) DESC

-- refeed unflagged SKUs in order of longest length first -- most likely to have been screwed up with scientific notation
select ixSKU,len(ixSKU), dtDateLastSOPUpdate
from tblSKU
where flgDeletedFromSOP = 0
    and flgProp65 is NULL
    and len(ixSKU) between 2 and 8
    and ISNUMERIC(ixSKU) = 1
order by -- len(ixSKU) desc,
 dtDateLastSOPUpdate





SELECT VS.ixVendor, V.sName,
    FORMAT(sum(OL.mExtendedPrice),'$###,###') as '12Mo Rev',
    COUNT(distinct S.ixSKU) 'Unflagged SKUs'
FROM tblOrderLine OL   
    left join tblSKU S on OL.ixSKU=S.ixSKU  
    left join tblBOMTemplateMaster BM on BM.ixFinishedSKU = S.ixSKU
    left join tblVendorSKU VS on VS.ixSKU = S.ixSKU and VS.iOrdinality = 1
    left join tblVendor V on V.ixVendor = VS.ixVendor
WHERE OL.dtOrderDate >= DATEADD(yy, -1, getdate()) 
    and OL.flgLineStatus in ('Shipped','Dropshipped')
    and S.flgDeletedFromSOP = 0     -- $28,128,627
    and flgProp65 is NULL

    --and BM.ixFinishedSKU is NOT NULL -- $8,780,224
GROUP BY VS.ixVendor, V.sName
order by sum(OL.mExtendedPrice) desc


SELECT COUNT(*)
FROM tblVendorSKU 
where ixVendor = '0802' and iOrdinality = 1

select S.ixSKU, SL.iQAV, S.sSEMACategory
from tblSKU S
    left join tblSKULocation SL on SL.ixSKU = S.ixSKU and SL.ixLocation = 99
    left join tblCatalogDetail CD on CD.ixSKU = S.ixSKU and CD.ixCatalog = 'WEB.18'
where S.flgDeletedFromSOP = 0
    and S.flgProp65 is NULL
    and SL.iQAV > 0
    and CD.ixSKU is NOT NULL
    and S.mPriceLevel1 > 0
    and S.flgIntangible = 0
    and S.flgActive = 1
order by S.sSEMACategory

select count(*) from tblCatalogDetail where ixCatalog = 'WEB.18' -- 305,259

select count(*) from tblSKU where flgDeletedFromSOP = 0 
and flgActive = 1


select distinct TD.ixSKU    -- 660
from tblBOMTemplateDetail TD
    join tblBOMTemplateMaster TM on TD.ixFinishedSKU = TM.ixFinishedSKU
    join tblSKU S on TD.ixSKU = S.ixSKU
    join tblCatalogDetail CD on CD.ixSKU = S.ixSKU and CD.ixCatalog = 'WEB.18'
    join (-- SKU component is also a finished SKU
          select distinct TM.ixFinishedSKU 
          from tblBOMTemplateMaster TM
          where TM.flgDeletedFromSOP = 0
          ) FS on FS.ixFinishedSKU = S.ixSKU
where S.flgDeletedFromSOP = 0
    and TM.flgDeletedFromSOP = 0 




SELECT S.ixSKU, S.ixOriginalPart, OP.flgProp65
from tblSKU S
    join tblSKU OP on OP.ixSKU = S.ixOriginalPart
where S.flgDeletedFromSOP = 0
and S.flgProp65 is NULL
and S.ixOriginalPart is NOT NULL
-- and S.ixOriginalPart <> S.ixSKU
order by OP.flgProp65




select --COUNT(distinct ixFinishedSKU)
     distinct ixFinishedSKU, S.dtDateLastSOPUpdate
from tblBOMTemplateMaster TM
    left join tblSKU S on TM.ixFinishedSKU = S.ixSKU  -- 3,473
where S.flgDeletedFromSOP = 0   -- 12,531
    and S.flgProp65 is NULL     --  6,711
    -- and S.dtDateLastSOPUpdate < '08/30/2018'
   -- and S.flgProp65 in (0,1,2)--  5,743
ORDER BY S.dtDateLastSOPUpdate



/* 

23,618 SKUs do not have Prop65 flags as of 8/31/18 10:30AM

of those (each stat set overlaps):
    23,192 are active
    16,875 are in the WEB.18 catalog
    13,394 have quantity available
    10,472 have had sales in the past 12 months

                                    SKUs in Total 
    Unflagged       Active  SKUs    Catalog 12mo
    SKUs      -->   SKUs    w/QAV   WEB.18  Rev.    As of
    =========       ======  ======  ======= ======  ===============
    23,548          23,128  13,337  16,815  $18.7m  8/31/18 12:05pm
    23,618          23,192  13,394  16,875  $18.1m  8/31/18 10:30am

    
-- POPULATE TEMP TABLE
SELECT S.ixSKU, S.flgActive,
    ISNULL(SL.iQAV,0) iQAV
into #UnflaggedSKUs
from tblSKU S
    left join tblSKULocation SL on SL.ixSKU = S.ixSKU and SL.ixLocation = 99
where flgDeletedFromSOP = 0
    and flgProp65 is NULL

-- STATS FROM TEMP TABLE
SELECT FORMAT(count(*),'##,###') as UnflaggedSKUs from #UnflaggedSKUs -- 13,394
SELECT FORMAT(count(*),'##,###') as ActiveSKUs from #UnflaggedSKUs where flgActive = 1 -- 13,394
SELECT FORMAT(count(*),'##,###') as SKUsWithQAV from #UnflaggedSKUs where iQAV > 0 -- 13,394
SELECT FORMAT(count(T.ixSKU),'##,###') as SKUsInWeb18Cat from #UnflaggedSKUs T join tblCatalogDetail CD on T.ixSKU = CD.ixSKU and CD.ixCatalog = 'WEB.18'

DROP TABLE #UnflaggedSKUs


SELECT flgProp65, dtDateLastSOPUpdate, T.chTime
from tblSKU S
left join tblTime T on S.ixTimeLastSOPUpdate = T.ixTime
where ixSKU in ('630683-S','6302000-WHT-12','6302000-WHT-9','6302000-WHT-13','6302000-WHT-13.5','6302000-WHT-10.5','6302000-WHT-12.5','6302000-WHT-14','6302000-WHT-7','6302000-WHT-8.5','UP60723','UP76056','6302000-WHT-11','6302000-WHT-6','6302000-WHT-6.5','6302000-WHT-7.5','6302000-WHT-8')
group by flgProp65, T.chTime


select ixOriginalPart
from tblSKU
where ixOriginalPart is NOT NULL



