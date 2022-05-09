-- SMIHD-2855 - Add BOM Creator field to SMI Reporting feeds for tblBOMTransferMaster

-- Scripts to add field to tables

-- run on DWSTAGING ONLY!!!!
BEGIN TRAN
    ALTER TABLE [SMI Reporting].dbo.tblBOMTransferMaster
         ADD ixCreator varchar(10) NULL 
ROLLBACK TRAN

BEGIN TRAN
    ALTER TABLE [AFCOReporting].dbo.tblBOMTransferMaster
         ADD ixCreator varchar(10) NULL 
ROLLBACK TRAN


/* TESTING

-- SMI
    SELECT TOP 10 * FROM [SMI Reporting].dbo.tblBOMTransferMaster 
    
    select * from [SMI Reporting].dbo.tblBOMTransferMaster 
    where dtDateLastSOPUpdate = '04/11/2016'

    select * from [SMI Reporting].dbo.tblBOMTransferMaster 
    WHERE ixTransferNumber in ('60987-1','61191-1','61637-1','61856-1','62907-1','63001-1','63252-1','63372-1','63444-1','63451-1','63676-1','63782-1','63834-1','63890-1','63894-1','63904-1','63971-1','64081-1','64207-1','64295-1','64399-1','64426-1','64465-1','64468-1','64766-1','64857-1','64947-1','65028-1','65035-1','65224-1','65387-1','65388-1','65394-1','65395-1','65397-1','65403-1','65404-1','65405-1','65406-1','65409-1','65410-1','65411-1','65415-1','65416-1','65417-1','65419-1','65421-1','65423-1','65424-1','65426-1','65427-1','65428-1','65429-1','65430-1','65434-1','65438-1','65440-1')
    order by dtDateLastSOPUpdate 

    SELECT ixCreator, count(*) 'Qty'
    FROM [SMI Reporting].dbo.tblBOMTransferMaster 
    GROUP BY ixCreator
    ORDER BY count(*) Desc
    /*
    ixCreator	Qty
    NULL	64470
    KDL	41
    NFT	12
    LJP	3
    MAK1	1
    ABS	1
    AHH	1
    JAP	1
    IDA	1
    */

    SELECT * FROM [SMI Reporting].dbo.tblBOMTransferMaster  where ixCreator is NOT NULL
    
    SELECT TOP 6000 * FROM [SMI Reporting].dbo.tblBOMTransferMaster  where ixCreator is NULL order BY NEWID()
    
    SELECT count(*) from [SMI Reporting].dbo.tblBOMTransferMaster where ixCreator is NOT NULL

-- AFCO
    SELECT TOP 10 * FROM [AFCOReporting].dbo.tblBOMTransferMaster 
    
    select * from [AFCOReporting].dbo.tblBOMTransferMaster 
    where dtDateLastSOPUpdate = '04/11/2016'

    select * from [AFCOReporting].dbo.tblBOMTransferMaster 
    WHERE ixTransferNumber in ('180158-1','180930-1','182823-1','182911-1','182912-1','183170-1','183908-1','184511-1','184815-1','184853-1','185228-1','185862-1','186100-1','186503-1','186527-1','186600-1','186601-1','187029-1','187077-1','187400-1','187951-1','188004-1','188110-1','188111-1','188112-1','188113-1','189158-1','189383-1','189649-1','190589-1','190730-1','190814-1','190815-1','190969-1','191120-1','191571-1','191599-1','191600-1','191941-1','191975-1','191978-1','192164-1','192478-1','192479-1','192735-1','192957-1','192958-1','193073-1','193429-1','193430-1','193470-1','193650-1','193896-1','193906-1','193928-1','194056-1','194058-1','194139-1','194140-1','194141-1','194281-1','194282-1','194343-1','194400-1','194401-1','194402-1','194487-1','194488-1','194493-1','194543-1','194544-1','194545-1','194546-1','194547-1','194548-1','194672-1','194673-1','194707-1','194736-1','194737-1','194749-1','194766-1','194775-1','194800-1','194810-1','194831-1','194850-1','194860-1','194875-1','194876-1','194910-1','194918-1','194922-1','194928-1','194929-1','194931-1','194932-1','194933-1','194934-1','194935-1','194937-1','194938-1','194939-1','194940-1','194941-1','194942-1','194943-1','194944-1','194945-1','194946-1','194947-1','194948-1','194949-1','194950-1','194956-1','194957-1','194958-1','194959-1','194960-1','194961-1','194976-1','194990-1','195030-1','195031-1','195032-1','195034-1')
    order by dtDateLastSOPUpdate 

    SELECT ixCreator, count(*) 'Qty'
    FROM [AFCOReporting].dbo.tblBOMTransferMaster 
    GROUP BY ixCreator
    ORDER BY count(*) Desc
    /*
    ixCreator	Qty
    NULL	152718
    5SRN	78
    SDR	19
    JCT	18
    5RJM	17
    LMC1	6
    5AAW	3
    NMF	1
    5CKS	1
    KMB	1
    */
    
    SELECT * FROM [AFCOReporting].dbo.tblBOMTransferMaster  where ixCreator is NOT NULL

    SELECT count(*) from [AFCOReporting].dbo.tblBOMTransferMaster 


select dtDateLastSOPUpdate, count(*)
from [AFCOReporting].dbo.tblBOMTransferMaster 
where dtDateLastSOPUpdate >= '04/11/2016'
group by dtDateLastSOPUpdate
order by group by dtDateLastSOPUpdate


*/