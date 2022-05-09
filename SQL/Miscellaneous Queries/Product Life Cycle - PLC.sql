-- PRODUCT LIFE CYCLE - PLC

SELECT * from tblProductLifeCycle

DELETE FROM tblProductLifeCycle
where ixProductLifeCycleCode in (3,5)


SELECT * 
into [SMIArchive].dbo.BU_tblProductLifeCycle_20200221
from tblProductLifeCycle


SELECT PLC.ixProductLifeCycleCode 'ixPLC', PLC.sProductLifeCycleCode 'sPLC', 
    FORMAT(COUNT(S.ixSKU),'###,###') 'SKUCnt', 
    FORMAT(GETDATE(),'MM/dd/yyyy')  'AsOf'
FROM  tblProductLifeCycle PLC
    left join tblSKU S on PLC.ixProductLifeCycleCode = S.ixProductLifeCycleCode
WHERE flgDeletedFromSOP = 0 -- You'll always want this condition you look at SKU data
GROUP BY PLC.ixProductLifeCycleCode,PLC.sProductLifeCycleCode
ORDER BY PLC.ixProductLifeCycleCode,PLC.sProductLifeCycleCode
/*
ix  s
PLC	PLC     SKUCnt	AsOf
=== ===     ======  ==========
1	R&D	    11,671	04/22/2020
2	INTRO	113	    
4	MATURE	173,532	
6	EOL	    287,203	

      

GROWTH & DECLINE were deleted 2-21-2020
*/

-- SKUs with no PLC
select format(COUNT(S.ixSKU),'###,###') 
from tblSKU S 
where flgDeletedFromSOP = 0 -- 465,481 TOTAL SKUs
    and ixProductLifeCycleCode is NULL -- 137,400


-- discontinued SKUs not flagged as EOL
SELECT ixSKU, ixProductLifeCycleCode, dtDateLastSOPUpdate, dtDiscontinuedDate
FROM tblSKU
WHERE dtDiscontinuedDate < getdate()
    and (ixProductLifeCycleCode is NULL
        or
        ixProductLifeCycleCode <> 6)
order by ixProductLifeCycleCode




/******** MANUALLY FLAGGING discontinued SKUs as EOL (6)  ***********/

    select *
    from tblSKU
    where dtDiscontinuedDate <= '04/09/2020'
    and ixProductLifeCycleCode <> 6

    BEGIN TRAN
        UPDATE tblSKU
        set ixProductLifeCycleCode = 6
        where dtDiscontinuedDate < getdate()
        and ixProductLifeCycleCode is NULL
    ROLLBACK TRAN


-- All discontinued SKUs
select COUNT(distinct ixSKU) from tblSKU
where dtDiscontinuedDate < getdate()
    and flgDeletedFromSOP = 0 -- 230,895

select ixSKU, ixProductLifeCycleCode, dtDateLastSOPUpdate --DCOUNT(distinct ixSKU) 
from tblSKU
    where (ixSKU LIKE 'UP%'
    or ixSKU LIKE 'AUP%'
    or ixSKU LIKE 'NS%')
    and (ixProductLifeCycleCode is NULL
         or ixProductLifeCycleCode <> 6)

-- FLAGGING UP AUP & NS SKUs
BEGIN TRAN
    UPDATE tblSKU
    set ixProductLifeCycleCode = 6
    where (ixSKU LIKE 'UP%'
    or ixSKU LIKE 'AUP%'
    or ixSKU LIKE 'NS%')
    and (ixProductLifeCycleCode is NULL
         or ixProductLifeCycleCode <> 6)
ROLLBACK TRAN






-- MANUAL updates from files provided by Connie
select count(*) from [SMITemp].dbo.PJC_PLC_Intro_SKUs -- 12,032

BEGIN TRAN
    update S
    set ixProductLifeCycleCode = 2
    from tblSKU S
         join [SMITemp].dbo.PJC_PLC_Intro_SKUs B on S.ixSKU = B.ixSKU
ROLLBACK TRAN


select count(*) from [SMITemp].dbo.PJC_PLC_RandD_SKUs -- 36,026


BEGIN TRAN
    update S
    set ixProductLifeCycleCode = 1
    from tblSKU S
     join [SMITemp].dbo.PJC_PLC_RandD_SKUs B on S.ixSKU = B.ixSKU
ROLLBACK TRAN



