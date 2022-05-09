-- tblSnapshotSKUArchive - Inventory Valuation for 1st of each year
select ixDate, SUM(mFIFOExtendedCost)
FROM tblSnapshotSKUArchive
WHERE ixDate = 18994 -- 01/01/2013
GROUP BY ixDate
/*
Date	tot Cost
=====   ==========
1/1/19  49,410,057
1/1/18  46,771,729
1/1/17  48,885,694
1/1/16  43,765,120
1/1/15  42,835,288
1/1/14	41,584,727
1/1/13	37,393,364
1/1/12  31,655,047
1/1/11  27,002,521
1/1/10  25,126,962

*/
select distinct ixDate
from tblSnapshotSKUArchive
where ixDate <= 14977

18994	01/01/2020
18629	01/01/2019
18264	01/01/2018
17899	01/01/2017
17533	01/01/2016
17168	01/01/2015 <-- only have Jan 1st for 2010-2015
16803	01/01/2014
16438	01/01/2013
16072	01/01/2012
15707	01/01/2011
15342	01/01/2010

SELECT DISTINCT ixDate 
from tblSnapshotSKUArchive
where ixDate <= 17168 -- 01/01/2015


/*************************************************
    PROBLEM ixDate = 17168  
 ************************************************/
    select FORMAT(COUNT(*),'###,###') RecCount from tblSnapshotSKUArchive where ixDate = 17168  -- 96,337   PROBLEM ixDate
    
    /*  1. ONLY IF THE DATA IS BAD... clear the data for the problem day

        DELETE from tblSnapshotSKUArchive -- 7,691
        where ixDate = 16877
    */

    select FORMAT(COUNT(*),'###,###') RecCount from tblSnapshotSKUArchive where ixDate = 17169  -- 219,229  PREVIOUS GOOD ixDate
    
    -- 2. insert the previous days data into the table adding 1 to the ixDate
    -- DROP TABLE [SMITemp].dbo.PJC_Missing_Snapshot_SKUs
    -- TRUNCATE TABLE [SMITemp].dbo.PJC_Missing_Snapshot_SKUs    

    --insert into [SMITemp].dbo.PJC_Missing_Snapshot_SKUs --  
    SELECT ixSKU, 
        iFIFOQuantity, mFIFOExtendedCost, mAverageCost, 
        (ixDate-1) as ixDate, -- converting it to the date that missing SKUs so it can be directly inserted into tblSnapshotSKU
        mLastCost, ixPGC, ixPrimaryVendor, dtDateLastSOPUpdate, ixTimeLastSOPUpdate, mPriceLevel1
    --into [SMITemp].dbo.PJC_Missing_Snapshot_SKUs -- 326331 -- roughly 6 mins
    FROM  tblSnapshotSKUArchive GOOD
    WHERE GOOD.ixDate = 17169
        AND ixSKU NOT IN (-- The Date w/missing SKUs
                          SELECT ixSKU 
                          from tblSnapshotSKUArchive
                          WHERE ixDate = 17168)--Problem Date
                          
    SELECT FORMAT(COUNT(*),'###,###') RecCount FROM  [SMITemp].dbo.PJC_Missing_Snapshot_SKUs -- 122,892
    
    select top 10 * from  [SMITemp].dbo.PJC_Missing_Snapshot_SKUs  -- verify ixDate was altered to the date that is being "repaired" 
        


BEGIN TRAN    
    -- set rowcount 20000
    -- set rowcount 50000    -- 10K seems to be a good batch size               350k DONE
    SELECT GETDATE() AS 'insert START'   
    GO 
        INSERT INTO tblSnapshotSKUArchive
        select M.*
        from [SMITemp].dbo.PJC_Missing_Snapshot_SKUs M 
    GO

    DELETE FROM [SMITemp].dbo.PJC_Missing_Snapshot_SKUs 
    WHERE ixSKU in (select ixSKU from tblSnapshotSKUArchive
                    where ixDate = 17168)-- problem date
    GO
    SELECT GETDATE() AS 'delete END'    
    
ROLLBACK TRAN  