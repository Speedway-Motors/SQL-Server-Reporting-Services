-- SMIHD-4414 - refeed sHandlingCode data for all SKUs once final codes are reassigned in SOP

-- NEED TO KNOW WHEN PSG FIXES THE CODES SO THAT SKUS can be refed!

SELECT COUNT(*) -- 57,539
from tblSKU
where flgDeletedFromSOP = 0
and sHandlingCode is NOT NULL
     and sHandlingCode NOT IN ('SA','SN','TR')

SELECT sHandlingCode, COUNT(*)
from tblSKU
where flgDeletedFromSOP = 0
GROUP BY sHandlingCode
ORDER BY sHandlingCode

-- SKUs to refeed once their handling codes are fixed in SOP
SELECT ixSKU, dtDateLastSOPUpdate
from tblSKU
where flgDeletedFromSOP = 0
and sHandlingCode in ('2A','2N','2S','3A','3N','DA','DN','DW','OA','ON','OS')
ORDER BY dtDateLastSOPUpdate

SELECT ixSKU, dtDateLastSOPUpdate -- 57,539
from tblSKU
where flgDeletedFromSOP = 0
and sHandlingCode is NOT NULL
     and sHandlingCode NOT IN ('SA','SN','TR')
ORDER BY dtDateLastSOPUpdate     

