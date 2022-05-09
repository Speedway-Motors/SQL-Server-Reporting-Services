-- SMIHD-5386 - CSI Inventory

SELECT COUNT(*) FROM tblBinSku

SELECT * FROM tblBin WHERE ixBin = 'CSIBSW'
SELECT * FROM tblBinSku WHERE ixBin = 'CSIBSW'

SELECT top 10 * FROM vwSKULocalLocation

SELECT * FROM tblSKULocation WHERE sPickingBin = 'CSIBSW'


/***************    TO POPULATE JEAN'S SPREADSHEET MOCKUP  *********/
    SELECT BS.ixSKU 'SKU', 
        -- 'n/a' as 'CID',     <-- CID is not in the AFCO Reporting DB
        SUM(iSKUQuantity) 'QOH',
        SKULL.iPickingBinMin 'Min', 
        SKULL.iPickingBinMax 'Max',
        SKULL.iCartonQuantity 'RestockUnit'  -- Al says the carton quantity is the same as the restock unit
    FROM tblBinSku BS
        left join (SELECT ixSKU, iPickingBinMin, iPickingBinMax, iCartonQuantity
                   FROM vwSKULocalLocation
                   ) SKULL on BS.ixSKU = SKULL.ixSKU
    WHERE BS.ixBin = 'CSIBSW'
    GROUP BY  BS.ixSKU, SKULL.iPickingBinMin, SKULL.iPickingBinMax, SKULL.iCartonQuantity 
    ORDER BYBS.ixSKU




-- verified there is only ONE picking bin per SKU
SELECT ixSKU, count(sPickingBin) FROM tblBinSku 
WHERE ixBin = 'CSIBSW'
GROUP BY ixSKU
ORDER BYcount(sPickingBin) desc

-- the data was recently refed
SELECT BS.ixSKU, SUM(iSKUQuantity), SKULL.iQOS, SKULL.iQAV, SKULL.iQC, SKULL.iQCB, SKULL.iQCBOM, SKULL.iQCXFER
, dtDateLastSOPUpdate
FROM tblBinSku BS
    full outer join (SELECT ixSKU, iQOS, iQAV, iQC, iQCB, iQCBOM, iQCXFER
               FROM vwSKULocalLocation 
               ) SKULL on BS.ixSKU = SKULL.ixSKU
WHERE ixBin = 'CSIBSW'
GROUP BY BS.ixSKU, SKULL.iQOS, SKULL.iQAV, SKULL.iQC, SKULL.iQCB, SKULL.iQCBOM, SKULL.iQCXFER ,dtDateLastSOPUpdate
    -- having SUM(iSKUQuantity) > = SKULL.iQOS
ORDER BYdtDateLastSOPUpdate-- SUM(iSKUQuantity) desc
    SKULL.iQAV



SELECT distinct sBinType FROM tblBin ORDER BYsBinType
/*
R
FBOM
PI
QA
XSTG
SL
DEF
LN
QANC
CBOM
P
RT
S
WIP
DEFNC
BVLST
IT
CONV
RC
*/
