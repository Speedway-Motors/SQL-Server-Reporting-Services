-- Procs containing a sepcified string

-- MUST BE RUN ON EACH DB   

USE [SMI Reporting]
  SELECT SPECIFIC_CATALOG, SPECIFIC_NAME, CREATED, LAST_ALTERED--ROUTINE_NAME, ROUTINE_DEFINITION
    FROM INFORMATION_SCHEMA.ROUTINES 
    WHERE (ROUTINE_DEFINITION LIKE '%Log_ProcedureCall%' 
           OR ROUTINE_DEFINITION like '%Log_ProcedureCall%')
        AND ROUTINE_TYPE='PROCEDURE'
        
        
     
        
