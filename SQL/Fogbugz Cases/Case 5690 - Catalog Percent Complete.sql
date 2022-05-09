select 
    ixCatalog                       'Catalog',
--    sDescription                    'Description',
--    sMarket                         'Market',
--    dbo.DisplayDate (dtStartDate)   'Start Date',
--    dbo.DisplayDate (dtEndDate)     'End Date',
--    iQuantityPrinted                'Qty Printed',
--    iPages                          'Pages',
    mPrintingCost                   'Printing Cost',
    mPreparationCost                'Prep Cost'
from tblCatalogMaster
where dtStartDate > dateadd(MM,-16,getdate()) -- 16 months ago
order by dtStartDate
/*
Catalog	Print Cost	Prep Cost
281	    0.00	    0.00
285	    127550.70	0.00
283	    0.00	    0.00
T287	0.00	    0.00
284	    0.00	    0.00
286	    0.00	    0.00
AFCO10	0.00	    0.00
T290	0.00	    0.00
AFAB10	0.00	    0.00
MRR10	0.00	    0.00
WEB.10	0.00	    0.00
GEN.10	0.00	    0.00
CTR.10	0.00	    0.00
287	    479922.00	0.00
T297	0.00	    0.00
T293	0.00	    0.00
297 	0.00	    0.00
PRS10	0.00	    0.00
290	    50015.00	20941.00
292	    482373.00	0.00
298	    0.00	    0.00
288	    194812.00	0.00
289 	93724.00	0.00
300 	0.00	    0.00
293 	746285.00	0.00
291 	9357.00	    11586.00
299 	0.00	    0.00
SHKRBD	0.00	    0.00
296 	0.00	    0.00
EMP.10	0.00	    0.00
294	    0.00    	0.00
IP	    1.00    	1.00
295	    0.00    	0.00
400	    10.00   	10.00
304	    0.00	    0.00
302	    150000.00	150000.00
301	    125000.00	0.00
306	    0.00	    0.00
311	    0.00	    0.00
303	    0.00	    0.00
308	    0.00	    0.00
310	    0.00	    0.00
325	    10.00   	10.00
314	    0.00	    0.00
311CB	0.00	    0.00
317	    0.00	    0.00
*/

SELECT
    vwSCP.*,
    SimSCP.ixSourceCode                     SimixSourceCode,    -- temp 
    SimSCP.ActOrdersToDate                  SimActOrdersToDate, -- temp
    SimSCP.ActBuyersToDate                  SimActBuyersToDate, -- temp
    SimSCP.SalesToDate                      SimSalesToDate,     -- temp
    vwSCP.SimSCRatio*SimSCP.ActOrdersToDate TargetOrderCount,
    vwSCP.SimSCRatio*SimSCP.ActBuyersToDate TargetCustCount,
    vwSCP.SimSCRatio*SimSCP.SalesToDate     TargetSales,
    (CASE WHEN SimSCP.QtyPrinted = 0 THEN 0 
     ELSE SimSCP.ActBuyersToDate/SimSCP.QtyPrinted 
     END
    ) SimResponseRate,
    (CASE WHEN SimSCP.QtyPrinted  = 0 THEN 0 
     ELSE SimSCP.SalesToDate/SimSCP.QtyPrinted 
     END
    ) SimSalesPerBook,
    SimSCP.GMPercent                        SimGMPercent
FROM    
 vwSCP
        left join vwSourceCodePerformance SimSCP    on SimSCP.ixSourceCode = vwSCP.ixMostSimilarSourceCode
WHERE vwSCP.ixCatalog = '302' -- 302 has costs
ORDER BY vwSCP.ixSourceCode

select * from tblCatalogMaster where ixCatalog = '302'


/*
ixCatalog	CatalogTitle	PageCount	dtStartDate	dtEndDate	TotCatCost	CostPerPage	CostPerBook	ixMostSimilarSourceCode	ixSourceCode	SourceDesc	QtyPrinted	TotPagesPrinted	ActOrdersToDate	ActBuyersToDate	SalesToDate	TotFulfilmentCost	COGSToDate	GMPercent	SimSCRatio	SimixSourceCode	SimActOrdersToDate	SimActBuyersToDate	SimSalesToDate	TargetOrderCount	TargetCustCount	TargetSales	SimResponseRate	SimSalesPerBook	SimGMPercent
303	2010 STRT GIFT	292	2010-11-15 00:00:00.000	2011-02-28 00:00:00.000	0.00	0.00	0.00	NULL	30316	BOTH12MM1	100	29200	1	1	599.99	59.99900	404.97	0.325	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
303	2010 STRT GIFT	292	2010-11-15 00:00:00.000	2011-02-28 00:00:00.000	0.00	0.00	0.00	NULL	30317	BOTH12MS1	100	29200	1	1	177.97	17.79700	126.573	0.2887	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
303	2010 STRT GIFT	292	2010-11-15 00:00:00.000	2011-02-28 00:00:00.000	0.00	0.00	0.00	NULL	30325	Hemmings Poly	132000	38544000	271	253	34259.66	3425.96600	18401.608	0.4628	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
*/


/*
-- Goal =   Total count of orders from SimSC (similar source code) * (Qty printed from SimSC / Qty printed for new SC)
--AND vwSCP.ixSourceCode IN ('28710','28712','28716','28720','28723','28728','28730','28740','28742','28748','28754','28762','28766')

select SC.ixSourceCode,
        SC.ixMostSimilarSourceCode,
        SC.ixCatalog
from tblSourceCode SC
    join tblCatalogMaster CM on CM.ixCatalog = SC.ixCatalog
where CM.dtStartDate >= '01/01/2010'
and CM.dtStartDate < '01/01/2011'
order by SC.ixCatalog, SC.ixMostSimilarSourceCode

select SC.ixSourceCode,
        SC.ixMostSimilarSourceCode,
        SC.ixCatalog
from tblSourceCode SC
    join tblCatalogMaster CM on CM.ixCatalog = SC.ixCatalog
where CM.ixCatalog = '303'
order by SC.ixCatalog, SC.ixMostSimilarSourceCode

select * from vwSourceCodePerformance where ixCatalog = '303'

ixSourceCode	OrderCount	CustCount	SalesCount
28710	        10600	    5766	    2268008.88
*/


/*
select * from vwSourceCodePerformance
where ixSourceCode in ('28710','28712','28716','28720','28723','28728','28730','28740','28742','28748','28754','28762','28766')

select * from vwSourceCodePerformance
where ixSourceCode in ('27310','27312','27316','27320','27323','27328','27330')



*/
update 

select iQuantityPrinted
from tblSourceCode
where iQuantityPrinted> 100000

select ixCatalog, ixSourceCode, iQuantityPrinted
from tblSourceCode
where iQuantityPrinted> 100000

select * from tblSourceCode
where ixSourceCode = 'PRS91'

update tblSourceCode
set iQuantityPrinted = 0
where ixSourceCode = 'PRS91'





select len(ixSourceCode) CHARS, count(*) QTY 
from tblSourceCode -- XX% of are ## char or less
--where dtStartDate > '01/01/2009'
group by len(ixSourceCode)
order by len(ixSourceCode) DESC




select * from vwSourceCodePerformance
where ixSourceCode = '26910'
order by sMatchBackSourceCode = '26910'
/*
ixCatalog	CatalogTitle	PageCount	dtStartDate	dtEndDate	TotCatCost	CostPerPage	CostPerBook	ixMostSimilarSourceCode	ixSourceCode	SourceDesc	QtyPrinted	TotPagesPrinted	ActOrdersToDate	ActBuyersToDate	SalesToDate	COGSToDate	GMPercent	SimSCRatio
269	2008 RACE GIFT	266	2008-10-27 00:00:00.000	2009-01-05 00:00:00.000	0.00	0.00	0.00	NULL	26910	RACE12MMult150	17542	4666172	75	67	21640.46	11909.386	0.4496	NULL

select * from tblOrder
where sSourceCodeGiven = '26910'
and sOrderStatus = 'Shipped'

sMatchbackSourceCode



select ixCatalog
from tblSourceCode
where ixCatalog not in
    (select distinct ixCatalog
    from tblSourceCode
    where ixMostSimilarSourceCode is null)




select * from tblSourceCode


select * from tblSourceCode 
where dtStartDate > '01/01/2009'
order by ixCatalog, ixSourceCode



update tblSourceCode
set ixMostSimilarSourceCode = 'TEST'
where ixCatalog = '291' and ixMostSimilarSourceCode is null