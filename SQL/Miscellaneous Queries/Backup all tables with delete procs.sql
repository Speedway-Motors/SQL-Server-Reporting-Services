-- Backup all tables with delete procs

-- USE Redgate SQL Search to locatle all procs that contain 'DELETE'

-- size of tables to be backed up
SELECT sTableName, SUM(MB) 'TotalMB' -- 3.5 GB
    -- * 
from tblTableSizeLog
where dtDate = '06/10/2019'
  and sTableName in ('tblBinSku','tblBOMTemplateDetail','tblBOMTemplateMaster', 'tblBOMTransferDetail','tblBOMTransferMaster', 
                    'tblBrand', 'tblBusinessUnit', 'tblCard', 'tblCardUser', 'tblCatalogDetail', 
                    'tblCatalogMaster','tblCounterOrderScans','tblCreditMemoDetail', 'tblCreditMemoMaster', 'tblCustomerType',
                    'tblDate', 'tblDoorEvent', 'tblJob', 'tblJobClock', 'tblKit', 
                    'tblMailingOptIn', 'tblOrderPromoCodeXref','tblPODetail','tblPOMaster',
                    'tblPromoCodeMaster','tblSKU','tblSKULocation','tblSKUPromo','tblSourceCode',
                    'tblTimeClockDetail','tblVendor','tblVendorSKU'  )
  --and MB > 1
GROUP BY sTableName                      
order by SUM(MB) DESC                


-- 62 seconds total for these tables
    SELECT * into [SMIArchive].dbo.BU_tblBinSku_20210923 -- 1661885         @21 sec for these 10
    from [SMI Reporting].dbo.tblBinSku

    SELECT * into [SMIArchive].dbo.BU_tblBOMTemplateDetail_20210923 -- 79858
    from [SMI Reporting].dbo.tblBOMTemplateDetail

    SELECT * into [SMIArchive].dbo.BU_tblBOMTemplateMaster_20210923 -- 13247
    from [SMI Reporting].dbo.tblBOMTemplateMaster

    SELECT * into [SMIArchive].dbo.BU_tblBOMTransferDetail_20210923 -- 409914
    from [SMI Reporting].dbo.tblBOMTransferDetail

    SELECT * into [SMIArchive].dbo.BU_tblBOMTransferMaster_20210923 -- 77333
    from [SMI Reporting].dbo.tblBOMTransferMaster

    SELECT * into [SMIArchive].dbo.BU_tblBrand_20210923 -- 709
    from [SMI Reporting].dbo.tblBrand

    SELECT * into [SMIArchive].dbo.BU_tblBusinessUnit_20210923 -- 12
    from [SMI Reporting].dbo.tblBusinessUnit

    SELECT * into [SMIArchive].dbo.BU_tblCard_20210923 -- 1628
    from [SMI Reporting].dbo.tblCard

    SELECT * into [SMIArchive].dbo.BU_tblCardUser_20210923 -- 1688
    from [SMI Reporting].dbo.tblCardUser

    SELECT * into [SMIArchive].dbo.BU_tblCatalogDetail_20210923 -- 10958719
    from [SMI Reporting].dbo.tblCatalogDetail



    SELECT * into [SMIArchive].dbo.BU_tblCatalogMaster_20210923 -- 513           @10 sec for these 10
    from [SMI Reporting].dbo.tblCatalogMaster
    
    SELECT * into [SMIArchive].dbo.BU_tblCounterOrderScans_20210923 -- 221492            
    from [SMI Reporting].dbo.tblCounterOrderScans

    SELECT * into [SMIArchive].dbo.BU_tblCreditMemoDetail_20210923 -- 763954
    from [SMI Reporting].dbo.tblCreditMemoDetail

    SELECT * into [SMIArchive].dbo.BU_tblCreditMemoMaster_20210923 -- 608884
    from [SMI Reporting].dbo.tblCreditMemoMaster

    SELECT * into [SMIArchive].dbo.BU_tblCustomerType_20210923 -- 48
    from [SMI Reporting].dbo.tblCustomerType

    SELECT * into [SMIArchive].dbo.BU_tblDate_20210923 -- 15354
    from [SMI Reporting].dbo.tblDate
    
    SELECT * into [SMIArchive].dbo.BU_tblDoorEvent_20210923 -- 59310
    from [SMI Reporting].dbo.tblDoorEvent

    SELECT * into [SMIArchive].dbo.BU_tblJob_20210923 -- 366
    from [SMI Reporting].dbo.tblJob
        
    SELECT * into [SMIArchive].dbo.BU_tblJobClock_20210923 -- 2151131
    from [SMI Reporting].dbo.tblJobClock

    SELECT * Into [SMIArchive].dbo.BU_tblKit_20210923 -- 81244
    from [SMI Reporting].dbo.tblKit



    SELECT * into [SMIArchive].dbo.BU_tblMailingOptIn_20210923 -- 13623413              @19 sec for these 10
    from [SMI Reporting].dbo.tblMailingOptIn
    
    SELECT * into [SMIArchive].dbo.BU_tblOrderPromoCodeXref_20210923 -- 164786          
    from [SMI Reporting].dbo.tblOrderPromoCodeXref

    SELECT * into [SMIArchive].dbo.BU_tblPODetail_20210923 -- 1108867
    from [SMI Reporting].dbo.tblPODetail

    SELECT * into [SMIArchive].dbo.BU_tblPOMaster_20210923 -- 141988
    from [SMI Reporting].dbo.tblPOMaster

    SELECT * into [SMIArchive].dbo.BU_tblPromoCodeMaster_20210923 -- 2434
    from [SMI Reporting].dbo.tblPromoCodeMaster
    
    SELECT * into [SMIArchive].dbo.BU_tblSKU_20210923 -- 449211
    from [SMI Reporting].dbo.tblSKU

    SELECT * into [SMIArchive].dbo.BU_tblSKULocation_20210923 -- 1581747
    from [SMI Reporting].dbo.tblSKULocation

    SELECT * into [SMIArchive].dbo.BU_tblSKUPromo_20210923 -- 297752
    from [SMI Reporting].dbo.tblSKUPromo

    SELECT * into [SMIArchive].dbo.BU_tblSourceCode_20210923 -- 11638
    from [SMI Reporting].dbo.tblSourceCode

    SELECT * into [SMIArchive].dbo.BU_tblTimeClockDetail_20210923 -- 578845
    from [SMI Reporting].dbo.tblTimeClockDetail



    SELECT * into [SMIArchive].dbo.BU_tblVendor_20210923 -- 1895
    from [SMI Reporting].dbo.tblVendor
    
    SELECT * into [SMIArchive].dbo.BU_tblVendorSKU_20210923 -- 531831
    from [SMI Reporting].dbo.tblVendorSKU



/* REMOVE OLD BACKUP TABLES
DROP TABLE [SMIArchive].dbo.BU_tblBinSku_20201231
DROP TABLE [SMIArchive].dbo.BU_tblBOMTemplateDetail_20201231
DROP TABLE [SMIArchive].dbo.BU_tblBOMTemplateMaster_20201231
DROP TABLE [SMIArchive].dbo.BU_tblBOMTransferDetail_20201231
DROP TABLE [SMIArchive].dbo.BU_tblBOMTransferMaster_20201231
DROP TABLE [SMIArchive].dbo.BU_tblBrand_20201231
DROP TABLE [SMIArchive].dbo.BU_tblBusinessUnit_20201231
DROP TABLE [SMIArchive].dbo.BU_tblCardUser_20201231
DROP TABLE [SMIArchive].dbo.BU_tblCard_20201231
DROP TABLE [SMIArchive].dbo.BU_tblCatalogDetail_20201231

DROP TABLE [SMIArchive].dbo.BU_tblCatalogMaster_20201231
DROP TABLE [SMIArchive].dbo.BU_tblCounterOrderScans_20201231
DROP TABLE [SMIArchive].dbo.BU_tblCreditMemoDetail_20201231
DROP TABLE [SMIArchive].dbo.BU_tblCreditMemoMaster_20201231
DROP TABLE [SMIArchive].dbo.BU_tblCustomer_20201231
DROP TABLE [SMIArchive].dbo.BU_tblCustomerType_20201231
DROP TABLE [SMIArchive].dbo.BU_tblDate_20201231
DROP TABLE [SMIArchive].dbo.BU_tblDoorEvent_20201231
DROP TABLE [SMIArchive].dbo.BU_tblJob_20201231
DROP TABLE [SMIArchive].dbo.BU_tblJobClock_20201231
DROP TABLE [SMIArchive].dbo.BU_tblKit_20201231

DROP TABLE [SMIArchive].dbo.BU_tblMailingOptIn_20201231
DROP TABLE [SMIArchive].dbo.BU_tblOrderPromoCodeXref_20201231
DROP TABLE [SMIArchive].dbo.BU_tblPODetail_20201231
DROP TABLE [SMIArchive].dbo.BU_tblPOMaster_20201231
DROP TABLE [SMIArchive].dbo.BU_tblPromoCodeMaster_20201231
DROP TABLE [SMIArchive].dbo.BU_tblSKU_20201231
DROP TABLE [SMIArchive].dbo.BU_tblSKULocation_20201231
DROP TABLE [SMIArchive].dbo.BU_tblSKUPromo_20201231
DROP TABLE [SMIArchive].dbo.BU_tblSourceCode_20201231
DROP TABLE [SMIArchive].dbo.BU_tblTimeClockDetail_20201231

DROP TABLE [SMIArchive].dbo.BU_tblVendorSKU_20201231
DROP TABLE [SMIArchive].dbo.BU_tblVendor_20201231
*/



SELECT * 
from tblTableSizeLog
where dtDate > '06/06/2019'
  and sTableName in ('tblBusinessUnit')
order by dtDate desc 
