-- AFCO Bulk Insert SSA job

use [AFCOReporting]

GO
-- *****   tblFIFODetail   **********
    bulk insert tblFIFODetail
        from 'e:\DataWarehouse\AFCO\tblFIFODetail.txt'
        with
        (   MAXERRORS = 5,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n'
        )
GO

-- ******   Catalog Master & Detail  **********
    DELETE from tblCatalogDetail
    GO
    DELETE from tblCatalogMaster
    GO

    bulk insert tblCatalogMaster
        from 'e:\DataWarehouse\AFCO\tblCatalogMaster.txt'
        with
        (   MAXERRORS = 5,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n'
        )
    GO

    bulk insert tblCatalogDetail
        from 'e:\DataWarehouse\AFCO\tblCatalogDetail.txt'
        with
        (   MAXERRORS = 5,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n'
        )
GO 

select count(*) from tblCatalogDetail
select count(*) from tblCatalogMaster