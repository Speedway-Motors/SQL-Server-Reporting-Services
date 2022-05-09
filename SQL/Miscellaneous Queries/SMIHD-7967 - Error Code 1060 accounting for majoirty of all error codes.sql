-- SMIHD-7967 - Error Code 1060 accounting for majoirty of all error codes

SELECT ELM.ixErrorCode, EC.sDescription, EC.ixErrorType, COUNT(ELM.ixErrorCode) 'ErrorCount'
FROM tblErrorLogMaster ELM
    left join tblErrorCode EC on ELM.ixErrorCode = EC.ixErrorCode
WHERE dtDate >= '01/01/2017' -- between '05/23/2017' and '06/22/2017'
    and ELM.ixErrorCode <> '1184'
GROUP BY ELM.ixErrorCode, EC.sDescription, EC.ixErrorType
ORDER BY count(ELM.ixErrorCode) DESC



select sError, COUNT(*) 'ErrorQty'
from tblErrorLogMaster ELM
where dtDate >= '01/01/2017'
and ELM.ixErrorCode = 1060
group by sError
order by COUNT(*) desc