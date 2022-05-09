-- Profile Trace Log Tables


SELECT * FROM [SMITemp].dbo.ProfileTrace_Ascrook_DW1 -- 3702        291
WHERE StartTime >= '07/11/2017'
AND TextData like '%Deadlock%'
ORDER BY RowNumber desc

/*
DEADLOCK ERRORS BETWEEN 03:30 AND 04:30 ON:

DATE        REFRESH
=======     =======
7/2/17      UNKNOWN
7/5/17      WORKED
7/7/17      FAILED
7/8/17      UNKNOWN
7/10/17     FAILED
*/




SELECT * FROM [SMITemp].dbo.ProfileTrace_Asrcook_DW1 -- 3702        266
WHERE StartTime >= '07/06/2017'
--AND TextData like '%Deadlock%'
ORDER BY RowNumber desc


SELECT * FROM [SMITemp].dbo.ProfileTrace_Deadlocks_DW1 -- KILL
WHERE StartTime >= '07/06/2017'
ORDER BY RowNumber desc

DROP TABLE [SMITemp].dbo.ProfileTrace_Deadlocks_DW1

-- AMANDA
SELECT * FROM ProfileTrace_AmandaLittle_AFCO_DWSTAGING1 -- KILL
-- WHERE StartTime >= '07/06/2017'
ORDER BY RowNumber desc

