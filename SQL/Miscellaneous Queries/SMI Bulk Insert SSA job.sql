-- SMI Bulk Insert SSA job

/*

/************   tblGiftCardMaster & tblGiftCardDetail      *************/   -- 30 SECONDS
    delete from tblGiftCardMaster
    go
    delete from tblGiftCardDetail
    go
    bulk insert tblGiftCardMaster
        from 'e:\DataWarehouse\SMI\tblGiftCardMaster.txt'
        with
        (
            MAXERRORS = 5,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n'
        )
    go
    bulk insert tblGiftCardDetail
        from 'e:\DataWarehouse\SMI\tblGiftCardDetail.txt'
        with
        (
            MAXERRORS = 5,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n'
        )
    go





/************   tblShippingPromo & tblSKUPromo     *************/   -- 40 SECONDS
    delete from tblShippingPromo
    go
    bulk insert tblShippingPromo
        from 'e:\DataWarehouse\SMI\tblShippingPromo.txt'
        with
        (
            MAXERRORS = 5,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n'
        )
    go
    delete from tblSKUPromo
    go
    bulk insert tblSKUPromo
        from 'e:\DataWarehouse\SMI\tblSKUPromo.txt'
        with
        (
            MAXERRORS = 5,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n'
        )
    go








/************   tblFIFODetail     *************/   -- 40 SECONDS
    bulk insert tblFIFODetail   -- 11-17 minutes
        from 'e:\DataWarehouse\SMI\tblFIFODetail.txt'
        with
        (
            MAXERRORS = 5,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n'
        )
    go








--truncate table tblCatalogMaster
/************   tblCatalogMaster & tblCatalogDetail     *************/   -- 3 mins for the deletes + 2 mins for the insert
delete from tblCatalogDetail
go
delete from tblCatalogMaster
go

bulk insert tblCatalogMaster
    from 'e:\DataWarehouse\SMI\tblCatalogMaster.txt'   -- 
    with
    (
        MAXERRORS = 5,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    )
go

bulk insert tblCatalogDetail
    from 'e:\DataWarehouse\SMI\tblCatalogDetail.txt'
    with
    (
        MAXERRORS = 5,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    )
go


*/



-- select count(*) from tblCatalogDetail -- 6,343,849