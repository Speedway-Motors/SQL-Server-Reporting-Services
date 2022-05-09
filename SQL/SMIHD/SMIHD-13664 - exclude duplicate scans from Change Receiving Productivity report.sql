-- SMIHD-13664 - exclude duplicate scans from Change Receiving Productivity report
/* Reciving Productivity.rdl
    ver 18.45.1

DECLARE @StartDate datetime,        @EndDate datetime,  @Employee varchar(5), @Everybody varchar(1)
SELECT  @StartDate = '04/17/19',    @EndDate = '04/17/19',  @Employee = 'AAI', @Everybody = 'N'
*/

SELECT
    JT.dtDate,
   JT.ixEmployee,
   E.sFirstname+' '+E.sLastname  EmpName,
    JT.sJob,
    JT.JobDescription,
    JT.sJobSort,
    (sum(JT.iTotDailyJobTime) /3600.00) JobTime,
    VW.LineItemsCount, 
    VW.RcvrsCount,
    VW.TotPieces,
    VW.RoutedPieces,
    VW.RecPieces,
    VW.Lbs, 
    VW.CIDsCount
FROM vwDailyTotJobTime JT
  join tblEmployee E on E.ixEmployee = JT.ixEmployee
  left join vwWarehouseReceivingProductivity VW on VW.ixDate = JT.ixDate 
                                                 and VW.sUser = JT.ixEmployee
                                                 and VW.ixJob COLLATE SQL_Latin1_General_CP1_CS_AS = JT.sJob COLLATE SQL_Latin1_General_CP1_CS_AS
WHERE JT.sJob like '81%'
    and JT.dtDate >= @StartDate --  '01/05/11' 
    and JT.dtDate < (@EndDate+1)
    and (JT.ixEmployee in (@Employee)  
            OR @Everybody = 'Y')
GROUP BY JT.dtDate,
JT.ixEmployee,
E.sFirstname+' '+E.sLastname,
JT.sJob,
JT.JobDescription,    
JT.sJobSort,
    VW.LineItemsCount, 
    VW.RcvrsCount,
    VW.TotPieces,
    VW.RoutedPieces,
    VW.RecPieces,
    VW.Lbs, 
    VW.CIDsCount
ORDER BY JT.dtDate,JT.ixEmployee,JT.sJobSort







-- SNIPET FROM vwWarehouseReceivingProductivity

    /**********************
    -- PACKAGING
    81-4 Autobagger
    81-5 Bench Pkg
    81-6 Floor Pkg
    81-8 PROP 65
    81-9 BOM Package
    ***********************/
select ST.sUser, ST.ixJob,ST.ixDate, 
    null, -- count(distinct ST.ixSKU) LineItemsCount, 
    null, 
    sum(ST.iQty)                TotPieces, 
    null RoutedPieces,
    null RecPieces,
    sum(SKU.dWeight*ST.iQty)    lbs, 
    null
from tblSKUTransaction ST
    join vwSKULocalLocation SKU on SKU.ixSKU = ST.ixSKU
where (ST.ixJob in ('81-4','81-5','81-6','81-8','81-9')
        OR ST.ixJob like '81-9%') -- not measuring anything for 81-8
    and ST.ixDate = 18735 -- 04/17/2019     >= 17168--	01/01/2015
    and ST.sUser = 'AAI'
    and ST.sTransactionType = 'T'
    --and ST.sGID is not null
    and ST.sToGID is not null
group by ST.ixJob,
    ST.sUser, 
    ST.ixDate


SELECT * FROM tblSKUTransaction
where sUser = 'AAI'
    and sTransactionType = 'T'
    and ixDate = 18735 
    and sToGID is not null
    and ixJob = '81-6'
order by sCID


SELECT s FROM tblSKUTransaction
where sUser = 'AAI'
    and sTransactionType = 'T'
    and ixDate = 18735 
    and sToGID is not null
    and ixJob = '81-6'
order by sCID


SELECT sUser, ixDate, ixSKU, sCID, sGID, count(iSeq) RecCount
into #DUPES
FROM tblSKUTransaction
where --sUser = 'AAI'
         sTransactionType = 'T'
    and ixDate >= 18629 
    and sToGID is not null
    and ixJob = '81-6'
GROUP BY sUser, ixDate, ixSKU, sCID, sGID
HAVING count(iSeq) > 1
order by sCID

SELECT D.*, ST.iSeq, ST.iQty
FROM #DUPES D
    LEFT JOIN tblSKUTransaction ST ON D.ixDate = ST.ixDate
                                    and D.sUser = ST.sUser
                                    and D.ixSKU = ST.ixSKU
                                    and D.sCID = ST.sCID
                                    and D.sGID = ST.sGID
--WHERE D.sUser = 'DVB'
ORDER BY ixDate, ixSKU, sCID, sUser, iSeq




SELECT * FROM tblDate where ixDate = 18671  -- 2-12-19
SELECT * FROM tblEmployee where ixEmployee = 'DVB'

SELECT * FROM tblSKUTransaction
where ixDate = 18698
and sGID = 200033
and sCID in (3181403,3181404,3181406,3181407)
ORDER BY ixSKU, iSeq
