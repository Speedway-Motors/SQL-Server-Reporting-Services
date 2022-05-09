-- SMIHD-19516 Inventory Valuation Analysis for CCC

-- 1) PREP TABLE
-- dates to be evaluated
select ixDate, ixSKU, iFIFOQuantity, mFIFOCost -- 1,561,927  for 6 dates
into #ValueationDates -- DROP TABLE #ValueationDates
from tblFIFODetail
where ixDate in (18598,18628,18638,18963,18993,19003) -- (18628,18993,19331) 

    -- add more dates
    INSERT INTO #ValueationDates
    select ixDate, ixSKU, iFIFOQuantity, mFIFOCost 
    from tblFIFODetail
    where ixDate in () 

-- 2) SKUs to EXCLUDE
select ixSKU, ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription', flgIntangible 
into #SKUsToRemove -- DROP TABLE #SKUsToRemove
from tblSKU S 
where flgDeletedFromSOP = 0
    AND (upper(sDescription) LIKE '%LABOR%' -- 1,043
         OR
         flgIntangible = 1)                 --   114

select * from #SKUsToRemove -- 1,157
where ixSKU in ('20100001','55550','90000001','91000001','91600013','91600014','91600015','91600016','91600017','91600018','916108','91645','91650','91655','91660','91670','94060','94560','94600-ASSEMBLE','94600-BEND','94600-COPE','94600-CUT','94600-GRIND','94600-LATHE','94600-SETUP','94600-WELD','94601','94604','94605') -- 29 SKUs

select ixSKU, ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription', flgIntangible 
into #VickisSKUsToRemove -- DROP TABLE ##VickisSKUsToRemove
from tblSKU S 
where flgDeletedFromSOP = 0
and ixSKU in ('20100001','55550','90000001','91000001','91600013','91600014','91600015','91600016','91600017','91600018','916108','91645','91650','91655','91660','91670','94060','94560','94600-ASSEMBLE','94600-BEND','94600-COPE','94600-CUT','94600-GRIND','94600-LATHE','94600-SETUP','94600-WELD','94601','94604','94605') -- 29 SKUs

select * from #VickisSKUsToRemove
where ixSKU NOT IN (select ixSKU from #SKUsToRemove) -- 10 SKUs weren't already exclusded




    -- REMOVE the invalid SKUs
    DELETE FROM #ValueationDates
    where ixSKU in (select ixSKU from #SKUsToRemove) -- 2,482 for 6 dates

        -- verify
        select * from #ValueationDates where ixSKU in (select ixSKU from #SKUsToRemove) -- 0

        -- results of the 10 SKUs in Vicki's list that weren't exclused in my list
        SELECT FORMAT(D.dtDate,'yyyy.MM.dd') 'InvDate' , 
            FORMAT(SUM(iFIFOQuantity * (CAST (mFIFOCost as Money))),'$###,###') 'InvValue'
        FROM #ValueationDates VD
            left join tblDate D on VD.ixDate = D.ixDate
            left join #VickisSKUsToRemove VL on VD.ixSKU = VL.ixSKU
        WHERE VL.ixSKU is NOT NULL
            -- VD.ixDate IN (18628,18993,19331) -- 2020-12-03
        group by D.dtDate
        order by D.dtDate


-- 3)RESULTS
SELECT FORMAT(D.dtDate,'yyyy.MM.dd') 'InvDate' , 
    FORMAT(SUM(iFIFOQuantity * (CAST (mFIFOCost as Money))),'$###,###') 'InvValue'
FROM #ValueationDates VD
    left join tblDate D on VD.ixDate = D.ixDate
--WHERE VD.ixDate IN (18628,18993,19331) -- 2020-12-03
group by D.dtDate
order by D.dtDate
/*
InvDate	    InvValue
2018.12.01	$48,342,714
2018.12.31	$49,967,476
2019.01.10	$50,787,790
2019.12.01	$48,553,726
2019.12.31	$49,869,168
2020.01.10	$50,671,791
*/



SELECT FORMAT(D.dtDate,'yyyy.MM.dd') 'InvDate' , 
    ixSKU,
    FORMAT(SUM(iFIFOQuantity * (CAST (mFIFOCost as Money))),'$###,###') 'InvValue'
FROM #ValueationDates VD
    left join tblDate D on VD.ixDate = D.ixDate
WHERE VD.ixDate IN (18628,18993,19331) -- 2020-12-03
AND ixSKU in ('ARSC','TECHELP-EIM','TECHELP-JOS','TECHELP-JTM','TECHELP-MKL','TECHELP-PWO','TECHELP-TJM')
group by D.dtDate, ixSKU
having SUM(iFIFOQuantity * (CAST (mFIFOCost as Money))) > 0
order by D.dtDate, ixSKU

select * from tblFIFODetail where ixDate = 19331
and ixSKU in ('ARSC','TECHELP-EIM','TECHELP-JOS','TECHELP-JTM','TECHELP-MKL','TECHELP-PWO','TECHELP-TJM')
and mFIFOCost > 0

select * from tblSKU where ixSKU = 'ARSC'

select ixDate, dtDate from tblDate
where dtDate in ('12/31/2018','12/31/2019','12/01/2018', '12/01/2019','1/10/19', '1/10/20')
/*
ixDate	dtDate
18628	2018-12-31 00:00:00.000
18993	2019-12-31 00:00:00.000
*/

select * from #SKUsToRemove
order by SKUDescription


select ixSKU, ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription', iLength, iWidth, iHeight, dWeight
from tblSKU S
where flgDeletedFromSOP = 0
and flgIntangible = 0



/******************* SCRATCH WORK to see which labor SKUs we're still evaluating as physical inventory with value

-- 2) SKUs to EXCLUDE
select ixSKU, ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription', flgIntangible  -- 1,138
into #SKUsToRemove -- DROP TABLE #SKUsToRemove
from tblSKU S 
where flgDeletedFromSOP = 0
    AND (upper(sDescription) LIKE '%LABOR%' -- 1,043
         OR
         flgIntangible = 1)                 --   114
    AND ixSKU NOT IN ('20100001','55550','90000001','91000001','91600013','91600014','91600015','91600016','91600017','91600018','916108','91645','91650','91655','91660','91670','94060','94560','94600-ASSEMBLE','94600-BEND','94600-COPE','94600-CUT','94600-GRIND','94600-LATHE','94600-SETUP','94600-WELD','94601','94604','94605') -- Vicki's 29 SKUs

select FD.ixDate, FD.ixSKU, iFIFOQuantity, mFIFOCost -- 1,561,927  for 6 dates
into #ValueationDates -- DROP TABLE #ValueationDates
from tblFIFODetail FD
    left join #SKUsToRemove SR on FD.ixSKU = SR.ixSKU
where ixDate in (18598,18628,18638,18963,18993,19003, 19337) -- (18628,18993,19331) 
    and SR.ixSKU is NOT NULL

-- 3)RESULTS
SELECT FORMAT(D.dtDate,'yyyy.MM.dd') 'InvDate' , 
    FORMAT(SUM(iFIFOQuantity * (CAST (mFIFOCost as Money))),'$###,###') 'InvValue'
FROM #ValueationDates VD
    left join tblDate D on VD.ixDate = D.ixDate
--WHERE VD.ixDate IN (18628,18993,19331) -- 2020-12-03
group by D.dtDate
order by D.dtDate

SELECT VD.ixDate, VD.ixSKU, 
    ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription',
    FORMAT(SUM(iFIFOQuantity * (CAST (mFIFOCost as Money))),'$###,###') 'InvValue' 
FROM #ValueationDates VD
    LEFT JOIN tblSKU S on VD.ixSKU = S.ixSKU
WHERE mFIFOCost > 0 
    and iFIFOQuantity > 0
GROUP BY VD.ixDate, VD.ixSKU, ISNULL(S.sWebDescription, S.sDescription)
ORDER BY VD.ixDate desc
-- we're paying taxes on inventory for 49 intangible SKUs


select ixDate, FD.ixSKU, -- iFIFOQuantity, mFIFOCost,  -- 1,561,927  for 6 dates
ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription',
FORMAT(SUM(iFIFOQuantity * (CAST (mFIFOCost as Money))),'$###,###') 'InvValue'
-- into #ValueationDates -- DROP TABLE #ValueationDates
from tblFIFODetail FD
    left join tblSKU S on FD.ixSKU = S.ixSKU
where ixDate = 19337
and FD.ixSKU in ('12100005','12100006','12100007','12100008','12100009','30431111.1','6273203.1.10.F','6273203.1.11.F','6273203.1.14.F','6273203.1.15.F','6273203.1.16.F','6273203.1.17.F','6273203.1.18.F','6273203.1.6.F','6273203.1.7.F','6273203.2.10.F','6273203.2.5.F','91035102.G1','91035102.L1','91035103.L1','91035104.G1','91035108','91048339-2','91084100.2-2.B','91335408.P','91600001','9161410','91618012-1.1B','91628905.3.B','91628910-6.B','91647904.P','91801654.P','92558931.1P','ARSC','ASB/SRXP','TECHELP-EIM','TECHELP-JOS','TECHELP-JTM','TECHELP-MKL','TECHELP-PWO','TECHELP-TJM','91035101.L1','91628903.3.B','92558931.2P','9708313.31S','HPSP-.38-.63.P','12100001','91000400.04.H','9161410')
group by ixDate, FD.ixSKU, ISNULL(S.sWebDescription, S.sDescription)
order by SUM(iFIFOQuantity * (CAST (mFIFOCost as Money))) desc

-- top 10 SKUs if we used FIFO data for 12-9-2020
/*      Inv
ixDate	Value	ixSKU	        SKUDescription
======  ======  =============   ===================================
19337	$8,894	91035108	    LABOR TO BEND AXLE BLANK
19337	$6,278	9161410	        Eagle Motorsports® Labor @ $1.00 EA
19337	$3,143	91600001	    SHOP LABOR - MINUTES
19337	$960	91035102.L1	    LABOR TO BEND
19337	$853	91000400.04.H	LABOR TO HEAT TREAT
19337	$525	12100008	    OUTSIDE LABOR
19337	$438	12100005	    OUTSIDE LABOR
19337	$336	91618012-1.1B	LABOR TO BEND X MEMBERS
19337	$306	91628905.3.B	LABOR TO BEND
19337	$195	12100006	    OUTSIDE LABOR
*/



********************************************************/













