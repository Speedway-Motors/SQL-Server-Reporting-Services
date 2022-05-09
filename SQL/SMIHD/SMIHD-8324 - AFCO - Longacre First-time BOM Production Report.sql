-- SMIHD-8324 - AFCO - Longacre First-time BOM Production Report


SELECT * -- ixFinishedSKU
FROM tblBOMTransferMaster
where ixFinishedSKU = '52-1101113'
and ixCreateDate >= 18030 -- '05/12/2017

SELECT ST.ixDate, ST.ixSKU,	ST.iQty, ST.sTransactionInfo, ST.sTransactionType, ST.sBin
FROM tblSKUTransaction ST
where ixSKU LIKE '52-%'
--AND ixSKU = '52-1101113'
    AND ixDate >= 18030
    and sTransactionType = 'BOM'
    AND sBin = 'RBOM'
order by ixSKU, ixDate
                
                
SELECT * -- ixFinishedSKU
FROM tblBOMTransferMaster
where ixFinishedSKU = '52-1601470'
and ixCreateDate >= 18030 -- '05/12/2017


/* need to use this query to get a list of SKUs and their MIN(ixDate) to use in a sub-query
   then run this query and SUM the QTY by the SKU and that MIN(ixDate)
*/   
SELECT ST.ixDate, ST.ixSKU,	ST.iQty, ST.sTransactionInfo, ST.sTransactionType, ST.sBin
	--ixTime, sUser, sToBin,	sCID,	, sLocation,	sToLocation
FROM tblSKUTransaction ST
    -- join tblDate D on ST.ixDate = D.ixDate
WHERE ixSKU LIKE '52-%'
    and ixDate >= 18030 -- 05/12/2017
    -- and D.dtDate between @StartDate and @EndDate
    and sTransactionType = 'BOM'
    and sBin = 'CBOM' -- what about'RBOM' ?
    and sTransactionInfo NOT LIKE '%DISASSEM%' -- excludes reverse BOMs
    --AND ixSKU = '52-1101113'    
ORDER BY ixSKU, ixDate

