-- Index Fragmentation
SELECT	
	 ss.[Name] [Schema], 
	 OBJECT_NAME(ddips.OBJECT_ID) [Table_name], 
	 ISNULL(si.[Name],'') [Index_name],
	 si.Index_id,
	 si.[Type_desc],
	 ISNULL(ddips.avg_fragmentation_in_percent,0) [Ext_fragmentation], 
	 ddips.page_count [Pages],
	 si.Fill_factor,
	 ISNULL(ddips.avg_page_space_used_in_percent,0) [Page_fullness_pct]
FROM [sys].dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') ddips /*DETAILED offers more, but burns the CPU more*/
	 JOIN [sys].indexes si ON ddips.index_id = si.index_id AND ddips.OBJECT_ID = si.OBJECT_ID
	 JOIN [sys].tables st ON ddips.OBJECT_ID = st.OBJECT_ID
	 JOIN [sys].schemas ss ON st.SCHEMA_ID = ss.SCHEMA_ID
WHERE ddips.index_level = 0 
    AND si.index_id > 0 
    AND st.[Type] = N'U' /* leaf level, non-heaps, user defined */
    AND ISNULL(ddips.avg_fragmentation_in_percent,0) > 20   -- indexes to REBUILD
   -- AND ISNULL(ddips.avg_fragmentation_in_percent,0) BETWEEN 10 AND 30 -- indexes to REORGINIZE
    AND ddips.page_count > 300 -- 300 OR MORE PAGES
/*
    Fragmentation is less than 10% – no de-fragmentation is required. 
    Fragmentation is between 10-30% – index REORGINIZATION suggested
    Fragmentation is higher than 30% – index REBUILD suggested
*/
    AND OBJECT_NAME(ddips.OBJECT_ID) LIKE 'tbl%'
    AND OBJECT_NAME(ddips.OBJECT_ID) NOT LIKE '%Aws%'
    AND OBJECT_NAME(ddips.OBJECT_ID)
      NOT IN ('tblDatabaseSchemaLog','tblengine_subfamily','tblskuvariant_transmission_family_xref','tblskuvariant_vehicle_base','tblskuvariant_vehicle_base','tblvehicle_base','tblvehicle_make','tblvehicle_make','tblvehicle_model')
GROUP BY	ss.[Name], ddips.OBJECT_ID, si.[Name], si.index_id, si.type_desc, avg_fragmentation_in_percent, ddips.page_count, 
			avg_page_space_used_in_percent,si.fill_factor
ORDER BY OBJECT_NAME(ddips.OBJECT_ID)
    --ddips.page_count DESC;



    USE [SMI Reporting]
GO

ALTER INDEX IX_tblVendorSKU_ixSKU_ixVendor 
ON [dbo].tblVendorSKU REBUILD PARTITION = ALL WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, RESUMABLE = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

GO
/* SELECT FORMAT(COUNT(*),'###,###') 'Records' FROM         tblOrder 6m         tblOrderLine 24m    tblSKUTransaction 33m    
                                                            tblFIFODetail 180m  tblSnapshotSKU 379m

tblSnapshotSKU	IX_tblSnapshotSKU_ixSKU_ixDate	99.0
tblSnapshotSKU	PK_tblSnapshotSKU	99.2


REBUILT 1-7-18
tblBinSku	IX_tblBinSku_ixSKU_Include	27.7	9014
tblBinSku	IX_tblBinSku_ixSKU_sPickingBin_Include	23.5	8766
tblBinSku	IX_tblBinSku_ixSKU_sPickingBin_ixLocation	23.3	8762
tblCardUser	PK__tblCardUser__07C12930
tblCounterOrderScans	PK_tblCounterOrderTiming	60.1
tblCreditMemoDetail	IX_tblCreditMemoDetail_ixSKU_ixCreditMemo_Include
tblCustomer	IX_tblCustomer_flgDeletedFromSOP_sCustomerType_sMailToZip_sMailingStatus_sMailToCountry_ixCustomer_ixSourceCode_Include
tblCustomerProject	IX_tblCustomerProject_ixWeakCustomer	98.3
tblDoorEvent	IX_tblDoorEvent_iEventTimeDate_Include
tblDoorEvent	pkScanID	94.4
tblDoorEvent	PK__tblDoorEvent__160F4887
tblOrder	IX_tblOrder_ixCustomer_mMerchandise_sOrderType_sOrderStatus_sOrderChannel	54032	26.8
tblOrder	IX_tblOrder_sOrderStatus_sOrderChannel_ixCustomer_ixOrder	39330	25.0
tblOrder	IX_tblOrder_sOrderType_sOrderChannel_mMerchandise_sOrderStatus_dtShippedDate_Include	60216	21.7
tblSKULocation	IX_tblSKULocation_IQAV	43.4
tblSKULocation	IX_tblSKULocation_ixSKU_Include	32.3
tblStockOut	PK_tblStockOut	97.5
tblVelocity60	PK_tblVelocity60	85.9

REBUILT 1-4-18
    tblBin	IX_tblBin_ixBin_ixLocation_Include
    tblBin	PK_tblBin
    tblBinSku	IX_tblBinSku_ixSKU_Include
    tblBinSku	IX_tblBinSku_ixSKU_sPickingBin_Include
    tblBinSku	IX_tblBinSku_ixSKU_sPickingBin_ixLocation
    tblBinSku	PK_tblBinSkuNEW
    tblBOMSequence	PK_tblBOMSequence
    tblBOMTemplateDetail	PK_tblBOMTemplateDetail	97.254004576659
    tblBOMTemplateMaster	PK_tblBOMTemplateMaster
    tblBOMTransferDetail	IX_tblBOMTransferDetail_ixTransferNumber_ixSKU_Include
    tblBOMTransferDetail	PK_tblBOMTransferDetail
    tblBOMTransferMaster	IX_tblBOMTransferMaster_ixTransferNumber
    tblBOMTransferMaster	PK_tblBOMTransferMaster
    tblBrand	PK__tblBrand__117F9D94
    tblCardUser	PK__tblCardUser__07C12930
    tblCatalogDetail	PK_tblCatalogDetail
    tblCatalogMaster	PK__tblCatalogMaster__70DDC3D8
    tblCatalogRequest	PK_tblCatalogRequest
    tblCatalogSKULog	PK_tblCatalogSKULog
    tblCounterOrderScans	IX_tblCounterOrderScans_ixOrder_ixIP_Include
    tblCounterOrderScans	PK_tblCounterOrderTiming
    tblCreditMemoDetail	IX_tblCreditMemoDetail_ixCreditMemo_ixSKU_Include
    tblCreditMemoDetail	IX_tblCreditMemoDetail_ixSKU_ixCreditMemo_Include
    tblCreditMemoDetail	PK_tblCreditMemoDetail
    tblCreditMemoMaster	IX_tblCreditMemoMaster_flgCancelled_dtCreateDate_ixCreditMemo
    tblCreditMemoMaster	IX_tblCreditMemoMaster_ixCreditMemo_flgCanceled_dtCreateDate
    tblCreditMemoMaster	PK_tblCreditMemoMaster
    tblCustomer	IX_tblCustomer_flgDeletedFromSOP_sCustomerType_sMailToZip_sMailingStatus_sMailToCountry_ixCustomer_ixSourceCode_Include
    tblCustomer	IX_tblCustomer_ixCustomer
    tblCustomer	IX_tblCustomer_ixCustomer_Include
    tblCustomer	IX_tblCustomer_sEmailAddress_Include
    tblCustomer	PK__tblCustomer__7C8480AE
    tblCustomerOffer	PK__tblCustomerOffer__37A5467C
    tblCustomerProject	IX_tblCustomerProject_ixWeakCustomer
    tblDatabaseSchemaLog	PK_tblDatabaseSchemaLog_ScsDatabaseSchemaLogID
    tblDate	IX_tblDate_ixDate_dtDate
    tblDate	PK__tblDate__25869641
    tblDoorEvent	pkScanID
    tblDoorEvent	PK__tblDoorEvent__160F4887
    tblDropship	IX_tblDropship_ixSpecialOrder_ixSKU
    tblDropship	PK__tblDropship__1A14E395
    tblDropshipSKUPerformance	PK_tblDropshipSKUPerformance
    tblEmployee	IX_tblEmployee_ixEmployee_Include
    tblEmployee	IX_tblEmployee_ixEmployee_sFirstname_Include
    tblEmployee	PK_tblEmployee
    tblErrorCode	PK_tblErrorCode	50
    tblErrorLogMaster	PK_tblErrorLogMaster
    tblFIFODetail	PK_tblFIFODetail	98m -- 15mins
    tblGoodHTC	PK_tblGoodHTC	98.8
    tblInventoryForecast	PK_tblInventoryForecast	90.0
    tblInventoryReceipt	PK__tblInventoryRece__48CFD27E	99.1
    tblIPAddress	PK_tblIPAddress	50
    tblJob	PK__tblJob__4F7CD00D	33.3
    tblJobClock	IX_tblJobClock_ixDate_dtDate_ixEmployee_sJob	74.5
    tblJobClock	IX_tblJobClock_ixDate_iStartTime_ixEmployee	58.0
    tblJobClock	IX_tblJobClock_ixDate_sJob_ixEmployee_dtDate	73.4
    tblJobClock	IX_tblJobClock_ixDate_sJob_ixEmployee_dtDate_Include	72.8
    tblJobClock	PK__tblJobClock__52593CB8	77.2
    tblKit	PK_tblKit	93.75
    tblLocalTaxCode	PK_tblLocalTaxCode	95.5
    tblMailingOptIn	IX_tblMailingOptIn_ixMarket_sOptInStatus	59.2
    tblMailingOptIn	PK_tblMailingOptIn	98.5
    tblMergedCustomers	PK_tblMergedCustomers	98.4
    tblOrder	IX_tblOrder_dtOrderDate
    tblOrder	IX_tblOrder_dtOrderDate_sOrderStatus_ixCustomerType_sOrderType_ixOrder_ixCustomer_Include	85.5
    tblOrder	IX_tblOrder_dtShippedDate_ixPrimaryShipLocation_sOrderStatus_Include	48.8
    tblOrder	IX_tblOrder_iShipMethod_sShipToZip_Include	52.2
    tblOrder	IX_tblOrder_ixCustomer_mMerchandise_sOrderType_sOrderStatus_sOrderChannel	91.5
    tblOrder	IX_tblOrder_ixOrderDate_ixCustomer_sOrderChannel_sOrderStatus_sOrderType_Include	98.6
    tblOrder	IX_tblOrder_ixOrder_iShipMethod_dtOrderDate_sOrderStatus_sShipToCountry_sShipToZip	99.2
    tblOrder	IX_tblOrder_ixOrder_ixOrderDate	99.0
    tblOrder	IX_tblOrder_ixOrder_ixOrderDate	99.0
    tblOrder	IX_tblOrder_ixOrder_sOrderChannel_dtOrderDate	99.1
    tblOrder	IX_tblOrder_sOrderStatus_dtOrderDate_iShipMethod_ixOrderDate_ixOrder_ixOrderTime_Include	98.5
    tblOrder	IX_tblOrder_sOrderStatus_Include	98.9
    tblOrder	IX_tblOrder_sOrderStatus_ixOrder_ixCustomer_Include	89.6
    tblOrder	IX_tblOrder_sOrderStatus_mMerchandise_dtOrderDate_Include	54.9
    tblOrder	IX_tblOrder_sOrderStatus_mMerchandise_Include	68.3
    tblOrder	IX_tblOrder_sOrderStatus_sOrderChannel_ixCustomer_ixOrder	99.0
    tblOrder	IX_tblOrder_sOrderStatus_sOrderType_mMerchandise_Include	48.1
    tblOrder	IX_tblOrder_sOrderType_sOrderChannel_mMerchandise_sOrderStatus_dtShippedDate_Include	72.9
    tblOrder	IX_tblOrder_sOrderType_sOrderStatus_mMerchandise_sOrderChannel_ixCustomer_sShipToCountry_sSourceCodeGiven_MoreFields_Include	91.2
    tblOrder	IX_tblOrder_sOrderType_sOrderStatus_mMerchandise_sOrderChannel_ixCustomer_sShipToCountry_sSourceCodeGiven_MoreFields_Include	91.21
    tblOrder	PK_tblOrder	93.89
    tblOrderLine	IX_tblOrderLine_flgKitComponent_dtOrderDate_ixCustomer_flgLineStatus_dtShippedDate_ixOrder_ixSKU_Include	69.6
    tblOrderLine	IX_tblOrderLine_flgKitComponent_flgLineStatus_dtOrderDate_Include
    tblOrderLine	IX_tblOrderLine_flgKitComponent_ixSKU_ixOrder_Include	74.5
    tblOrderLine	IX_tblOrderLine_flgLineStatus_dtShippedDate	77.4
    tblOrderLine	IX_tblOrderLine_flgLineStatus_mExtendedPrice_Include	49.0    @2:06
    tblOrderLine	IX_tblOrderLine_ixOrder_flgLineStatus_dtOrderDate_ixSKU_Include	69.4
    tblOrderLine	IX_tblOrderLine_ixOrder_flgLineStatus_dtShippedDate_ixSKU_dtOrderDate	70.7
    tblOrderLine	IX_tblOrderLine_ixOrder_flgLineStatus_ixSKU_Include	72.4
    tblOrderLine	IX_tblOrderLine_ixOrder_flgLineStatus_ixSKU_Include	72.46
    tblOrderLine	IX_tblOrderLine_ixOrder_ixSKU_Include	72.5
    tblOrderLine	IX_tblOrderLine_ixSKU_flgLineStatus_dtShippedDate_ixOrder_Include	55.6
    tblOrderLine	IX_tblOrderLine_ixSKU_flgLineStatus_flgKitComponent_dtOrderDate_Include
    tblOrderLine	IX_tblOrderLine_ixSKu_Include	81.1 @2.25
    tblOrderLine	IX_tblOrderLine_ixSKU_ixOrder_ixCustomer_flgLineStatus_dtOrderDate	78.2
    tblOrderLine	PK_tblOrderLine_1	77.8
    tblOrderPromoCodeXref	pk_tblOrderPromoCodeXref	97.8
    tblOrderRouting	IX_tblOrderRouting_ixOrder	99.2
    tblOrderRouting	PK_tblOrderRouting	99.1
    tblOrderTiming	PK_tblOrderTiming	92.4
    tblPackage	IX_tblPackage_ixPacker_flgMetals_Included	46.02
    tblPackage	IX_tblPackage_sTrackingNumber_ixOrder	48.14
    tblPackage	PK__tblPackage__628FA481	57.63
    tblPGC	PK__tblPGC__6754599E	66.6
    tblPODetail	IX_tblPODetail_ixPO_iQuantityPosted_iQuantity_ixSKU	39.1
    tblPODetail	IX_tblPODetail_ixPO_ixSKU_ixExpectedDeliveryDate_Include	46.3
    tblPODetail	IX_tblPODetail_ixSKU	96.6
    tblPODetail	PK_tblPODetail	52.1
    tblPOMaster	IX_tblPOMaster_flgIssued_flgOpen_ixPO	79.3
    tblPOMaster	PK__tblPOMaster__10566F31	86.5
    tblProductLine	PK_tblProductLine	93.0
    tblPromoCodeMaster	pk_tblPromoCodeMaster
    tblReceiver	PK__tblReceiver__1F98B2C1	68.5
    tblReceivingWorksheet	PK__tblReceivingWork__31EC6D26
    tblSKU	IX_tblSKU_flgActive_flgDeletedFromSOP_Include	76.8
    tblSKU	IX_tblSKU_flgDeletedFromSOP	78.3
    tblSKU	IX_tblSKU_flgDeletedFromSOP_Included	60.7
    tblSKU	IX_tblSKU_flgDeletedFromSOP_ixSKU_dtCreateDate	78.3
    tblSKU	IX_tblSKU_flgIntangible_ixSKU	78.8
    tblSKU	IX_tblSKU_ixPGC_flgIntangible_ixSKU	83.3
    tblSKU	IX_tblSKU_ixSKU	98.3
    tblSKU	IX_tblSKU_IXSKU_flgDeletedFromSOP_sOriginalSource_sDescription_mPriceLevel1_mLatestCost_Include	94.3
    tblSKU	PK_tblSKU	78.7
    tblSKULocation	IX_tblSKULocation_IQAV	72.7
    tblSKULocation	IX_tblSKULocation_ixLocation_Include
    tblSKULocation	IX_tblSKULocation_ixSKU_Include	53.7
    tblSKULocation	PK__tblSKULocation__0D7A0286	93.5
    tblSKUTransaction	IX_tblSKUTransaction_ixSKU_Include	98.230931855276
    tblSKUTransaction	PK_tblSKUTransaction
    tblSOPFeedLog	PK_tblSOPFeedLog	40.8
    tblSourceCode	IX_tblSourceCode_ixCatalog_ixSourceCode	75.6
    tblSourceCode	IX_tblSourceCode_ixSourceCode_Include	63.0
    tblSourceCode	PK__tblSourceCode__2DE6D218	98.4
    tblStockOut	PK_tblStockOut	95.0
    tblTableSizeLog	PK_tblTableSizeLog	98.6
    tblTimeClock	IX_tblTimeClock_ixDate_ixEmployee	34.9
    tblTimeClock	PK_tblTimeClock
    tblTimeClockDetail	PK_tblTimeClockDetail	70.6
    tblVelocity60	PK_tblVelocity60	99.0291262135922
    tblVendor	IX_tblVendor_ixVendor_Include	93.3333333333333
    tblVendor	PK__tblVendor__3D5E1FD2	97.8494623655914
    tblVendorSKU	IX_tblVendorSKU_iOrdinality_ixSKU_ixVendor_sVendorSKU	82.3842985219288
    tblVendorSKU	IX_tblVendorSKU_iOrdinality_ixVendor_Include	88.7736424649176
    tblVendorSKU	IX_tblVendorSKU_ixSKU_iOrdinality	83.5996382273138
    tblVendorSKU	IX_tblVendorSKU_ixVendor_Include	89.4534995206136
    tblVendorSKU	IX_tblVendorSKU_ixVendor_iOrdinality_ixSKU_Include	89.3634165995165
    tblVendorSKU	IX_tblVendorSKU_sVendorSKU_ixSKU_iOrdinality_ixVendor	92.5560538116592
    tblVendorSKU	PK_tblVendorSKU	82.8302626421011



REORGANIZED
    tblSnapshotSKU	IX_tblSnapshotSKU_ixDate_ixSKU	98.9678118252573

/*************************************************************************
 ******************         AFCO         *********************************
 *************************************************************************/
-- REBUILT 1-8-18
tblBinSku	IX_tblBinSku_ixBin_ixSKU_ixLocation	4077	94.6
tblBinSku	PK_tblBinSkuNEW	1564	43.6
tblBOMTemplateDetail	_dta_index_tblBOMTemplateDetail_c_11_2094630505__K1	3387	21.7
tblBOMTemplateMaster	PK_tblBOMTemplateMaster	795	98.7
tblBOMTransferDetail	IX_tblBOMTransferDetail_ixSKU	18518	27.5
tblBOMTransferDetail	IX_tblBOMTransferDetail_ixSKU	18518	27.5
tblBOMTransferDetail	_dta_index_tblBOMTransferDetail_c_11_155147598__K1	26285	20.8
tblBOMTransferDetail	_dta_index_tblBOMTransferDetail_c_11_155147598__K1	26285	20.8
tblBOMTransferMaster	IX_tblBOMTransferMaster_ixFinishedSKU_flgReverseBOM_dtCanceledDate_flgClosed	1853	87.5
tblCatalogDetail	PK_tblCatalogDetail	4350	98.7
tblCustomer	ix_tblCustomer_sCustomerFirstName_sCustomerLastName_iPriceLevel_ixCustomerType_ixAccountManager	418	99.0

tblFIFODetail	PK_tblFIFODetail	542122	24.8 @3:53
tblFIFODetail	PK_tblFIFODetail	542122	24.8 @3:53

tblInventoryReceipt	PK_tblInventoryReceipt	1527	43.0
tblOrder	IX_tblOrder_sOptimalShipOrigination_dtShippedDate	2785	20.3
tblOrder	IX_tblOrder_sOptimalShipOrigination_dtShippedDate	2785	20.3
tblOrder	IX_tblOrder_sOrderStatus_dtShippedDate_ixCustomer	2504	26.9
tblOrder	IX_tblOrder_sOrderStatus_dtShippedDate_ixCustomer	2504	26.9tblBOMTemplateDetail	_dta_index_tblBOMTemplateDetail_c_11_2094630505__K1	3387	21.7
tblOrder	_dta_index_tblOrder_7_1989582126__K21_K3	1746	30.0
tblOrder	_dta_index_tblOrder_c_7_1989582126__K1_K3	37907	98.2
tblOrderLine	_dta_index_tblOrderLine_7_1077578877__K2_K9_K10_K11_K1_K3	16583	51.8
tblOrderLine	_dta_index_tblOrderLine_7_1077578877__K3_K1_K2_K9_K10	17364	63.4
tblOrderLine	_dta_index_tblOrderLine_7_21575115__K9_1_3_6_7	14141	30.0
tblOrderRouting	PK_tblOrderRouting	2943	21.1
tblPackage	PK_tblPackage	9677	21.3
tblPODetail	IX_tblPODetail_ixSKU	520	94.6
tblSKU	IX_tblSKU_flgActive_flgDeletedFromSOP_ixPGC	307	57.6
tblSKU	IX_tblSKU_ixSKU	4764	90.2
tblSKUTransaction	IX_tblSKUTransaction_ixSKU	104889	31.8 @60 sec
tblSnapAdjustedMonthlySKUSales	PK_tblSnapAdjustedMonthlySKUSales	4301	99.2

tblSnapshotSKU	IX_tblSnapshotSKU_ixDate_ixSKU	361581	38.1 @3:12
tblSnapshotSKU	PK_tblSnapshotSKU	312494	61.2 @3:39
tblSnapshotSKU	_dta_index_tblSnapshotSKU_c_11_363148339__K5_K1	1051037	35.5    @9:33

tblTableSizeLog	PK_tblTableSizeLog	1298	28.4
tblVendorSKU	IX_tblVendorSKU_ixSKU_ixVendor	533	29.2
tblVendorSKU	PK_tblVendorSKU	1092	31.1


