-- error codes past 30 days
select ELM.ixErrorCode 'ErrorCode'
    , EC.sDescription
    ,COUNT(*) QTY
from tblErrorLogMaster ELM
    left join tblErrorCode EC on ELM.ixErrorCode = EC.ixErrorCode
where ELM.dtDate >= DATEADD(dd,-30, getdate()) -- 30 days ago
  and EC.sDescription like 'Failure to update%'
group by ELM.ixErrorCode, EC.sDescription
--having COUNT(*) > 100
order by COUNT(*) desc



-- Sample of Error messages for dif Error Codes
    select TOP 1 ixErrorID, FORMAT(dtDate,'yyyy.MM.dd')'Date', ixErrorCode, sError
    From tblErrorLogMaster ELM
    where ELM.dtDate >= '01/01/2019' and ELM.ixErrorCode = 1141
UNION
    select TOP 1 ixErrorID, FORMAT(dtDate,'yyyy.MM.dd')'Date', ixErrorCode, sError
    From tblErrorLogMaster ELM
    where ELM.dtDate >= '01/01/2019' and ELM.ixErrorCode = 1142
UNION
    select TOP 1 ixErrorID, FORMAT(dtDate,'yyyy.MM.dd')'Date', ixErrorCode, sError
    From tblErrorLogMaster ELM
    where ELM.dtDate >= '01/01/2019' and ELM.ixErrorCode = 1143
UNION
    select TOP 1 ixErrorID, FORMAT(dtDate,'yyyy.MM.dd')'Date', ixErrorCode, sError
    From tblErrorLogMaster ELM
    where ELM.dtDate >= '01/01/2019' and ELM.ixErrorCode = 1145
UNION
    select TOP 1 ixErrorID, FORMAT(dtDate,'yyyy.MM.dd')'Date', ixErrorCode, sError
    From tblErrorLogMaster ELM
    where ELM.dtDate >= '01/01/2019' and ELM.ixErrorCode = 1146
UNION
    select TOP 1 ixErrorID, FORMAT(dtDate,'yyyy.MM.dd')'Date', ixErrorCode, sError
    From tblErrorLogMaster ELM
    where ELM.dtDate >= '01/01/2019' and ELM.ixErrorCode = 1147
UNION
    select TOP 1 ixErrorID, FORMAT(dtDate,'yyyy.MM.dd')'Date', ixErrorCode, sError
    From tblErrorLogMaster ELM
    where ELM.dtDate >= '01/01/2019' and ELM.ixErrorCode = 1149
UNION
    select TOP 1 ixErrorID, FORMAT(dtDate,'yyyy.MM.dd')'Date', ixErrorCode, sError
    From tblErrorLogMaster ELM
    where ELM.dtDate >= '01/01/2019' and ELM.ixErrorCode = 1155
UNION
    select TOP 1 ixErrorID, FORMAT(dtDate,'yyyy.MM.dd')'Date', ixErrorCode, sError
    From tblErrorLogMaster ELM
    where ELM.dtDate >= '01/01/2019' and ELM.ixErrorCode = 1160
UNION
    select TOP 1 ixErrorID, FORMAT(dtDate,'yyyy.MM.dd')'Date', ixErrorCode, sError
    From tblErrorLogMaster ELM
    where ELM.dtDate >= '01/01/2019' and ELM.ixErrorCode = 1163
UNION
    select TOP 1 ixErrorID, FORMAT(dtDate,'yyyy.MM.dd')'Date', ixErrorCode, sError
    From tblErrorLogMaster ELM
    where ELM.dtDate >= '01/01/2019' and ELM.ixErrorCode = 1174
UNION
    select TOP 1 ixErrorID, FORMAT(dtDate,'yyyy.MM.dd')'Date', ixErrorCode, sError
    From tblErrorLogMaster ELM
    where ELM.dtDate >= '01/01/2019' and ELM.ixErrorCode = 1174
UNION
    select TOP 1 ixErrorID, FORMAT(dtDate,'yyyy.MM.dd')'Date', ixErrorCode, sError
    From tblErrorLogMaster ELM
    where ELM.dtDate >= '01/01/2019' and ELM.ixErrorCode = 1226





select -- to get the most recent occurence for each error code
    --FORMAT(dtDate,'yyyy.MM.dd')'Date', 
    ELM.ixErrorCode, ELM.ixErrorID --EC.sDescription--, ELM.sError
into #RawErrorData
From tblErrorLogMaster ELM
    left join tblErrorCode EC on ELM.ixErrorCode = EC.ixErrorCode
where EC.ixErrorType = 'SQLDB'
    and  ELM.dtDate >= '01/01/2019'  -- 666,356

select max(ixErrorID)
from #RawErrorData RD

DROP table #RawErrorData
     

