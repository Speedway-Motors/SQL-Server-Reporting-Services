-- Repair tblFIFODetail when daily job fails

select ixDate, COUNT(*) 
from tblFIFODetail FD
where ixDate >= 18014
group by ixDate
order by ixDate desc
/*
ixDate  Records
18020	249,007
18019	249,592
18018	249,566
18017   250,256  <-- missing data was copied from ixDate 18016 
18016	250,256
18015	250,286


AFCO
ixDate  Records
18025	45,064
18024	45,064
18022	44,864
18021	44,987
18016	44,533
18015	44,182
18014	44,607


select * from tblTime 

*/


/*************************************************
    PROBLEM ixDate = 17737  
 ************************************************/
    select COUNT(*) from tblFIFODetail where ixDate = 18017 -- 221,250  PROBLEM ixDate
    
    /*  1. ONLY IF THE DATA IS BAD... clear the data for the problem day

        DELETE from tblFIFODetail -- 7,691
        where ixDate = 16877
    */

    select COUNT(*) from tblFIFODetail where ixDate = 18016 -- 44,533 PREVIOUS good ixDate
    
    -- 2. insert the previous days data into the table adding 1 to the ixDate
    -- DROP TABLE [SMITemp].dbo.PJC_Missing_FIFODetail
    -- TRUNCATE TABLE [SMITemp].dbo.PJC_Missing_FIFODetail    

    --insert into [SMITemp].dbo.PJC_Missing_FIFODetail -- 94,038
    select *
    /*ixSKU, 
        iFIFOQuantity, 
        mFIFOExtendedCost, 
        mAverageCost, 
        (ixDate+1) as ixDate, -- converting it to the date that missing SKUs so it can be directly inserted into tblFIFODetail
        mLastCost, 
        ixPGC, 
        ixPrimaryVendor, 
        dtDateLastSOPUpdate, 
        ixTimeLastSOPUpdate
     */
    into [SMITemp].dbo.PJC_Missing_FIFODetail -- 49,999
    FROM  [SMI Reporting].dbo.tblFIFODetail GOOD
    WHERE GOOD.ixDate = 18016
        AND ixSKU NOT IN (-- The Date w/missing SKUs
                          SELECT ixSKU 
                          from tblFIFODetail
                          WHERE ixDate = 17765)--Problem Date
                          
    SELECT count(*) FROM  [SMITemp].dbo.PJC_Missing_FIFODetail -- verify ixDate was altered to the date that is being "repaired" 
    -- IMPORT table from DW1 to DWSTAGING!
select top 10 * from [SMITemp].dbo.PJC_Missing_FIFODetail


-- DROP TABLE [AFCOTemp].dbo.PJC_Missing_FIFODetail  
    select ixSKU, 
        (ixDate+1) as ixDate, -- converting it to the date that missing SKUs so it can be directly inserted into tblFIFODetail
        iOrdinality,
        iFIFOQuantity, 
        ixFIFODate,
        mFIFOCost,
        sFIFOSourceType,
        ixLocation
    INTO [AFCOTemp].dbo.PJC_Missing_FIFODetail -- 44,533  
    FROM  [AFCOReporting].dbo.tblFIFODetail GOOD
    WHERE GOOD.ixDate = 18022
-- changing the copied date to the date that's missing data
UPDATE [AFCOTemp].dbo.PJC_Missing_FIFODetail
set ixDate = 18020
where ixDate = 18019

SELECT TOP 10 * FROM [AFCOReporting].dbo.tblFIFODetail

-- do the following on DWSTAGING1 ONLY!
BEGIN TRAN    
    -- set rowcount 10000
    -- set rowcount 15000    -- 10K seems to be a good batch size
        INSERT INTO [LNK-DWSTAGING1].[AFCOReporting].dbo.tblFIFODetail
        select * 
        from [LNK-DWSTAGING1].[AFCOTemp].dbo.PJC_Missing_FIFODetail M 

ROLLBACK TRAN


select ixDate, COUNT(*)
from tblFIFODetail
where ixDate >= 18020
group by ixDate
order by ixDate








/*
DELETE FROM [SMITemp].dbo.PJC_Missing_FIFODetail 
WHERE ixSKU in (select ixSKU from [SMI Reporting].dbo.tblFIFODetail
                where ixDate = 17765)

    GO
    SELECT GETDATE() AS 'delete END'    
*/    
ROLLBACK TRAN        
/*  Avg     batch
    Mins    size
     .6      1K
    3.4      5K
    3.1     10K 
    4.0     20K
   10.0     51K 
            
*/                 
    SELECT COUNT(*) FROM [SMITemp].dbo.PJC_Missing_FIFODetail   -- 250K to go
    SELECT * FROM [SMITemp].dbo.PJC_Missing_FIFODetail   

    -- 3. verify
    select ixDate, COUNT(*) 'SKUCount'
    from tblFIFODetail 
    where ixDate in (17680,17681) -- 132079v  verify previous day qty is matched OR slightly exceeded if problem day had some initial data
    group by ixDate
    order by ixDate
    
    
    

