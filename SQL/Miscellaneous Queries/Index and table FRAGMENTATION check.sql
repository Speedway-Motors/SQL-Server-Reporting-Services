-- check fragmentation
-- If you found any tables or indexes that are over 5% fragmented and take over a few thousand pages, this may be an issue
SELECT o.name AS TableName, i.name AS IndexName, ips.index_type_desc,  -- 113 indexes
 --ips.avg_fragmentation_in_percent,
 FORMAT(ips.avg_fragmentation_in_percent/100,'###%') 'AvgFragmnt%', 
 FORMAT(ips.page_count, '###,###') 'PageCount',  
 FORMAT(((ips.avg_fragmentation_in_percent/100)*ips.page_count),'###,###')  'FragPrcntXPageCount',
 ips.avg_page_space_used_in_percent
FROM sys.dm_db_index_physical_stats(
 DB_ID(), NULL, NULL, NULL, 'Sampled') ips
JOIN sys.objects o ON ips.object_id = o.object_id
JOIN sys.indexes i ON (ips.object_id = i.object_id) AND (ips.index_id = i.index_id)
WHERE (ips.alloc_unit_type_desc <> 'LOB_DATA') 
    AND (ips.alloc_unit_type_desc <> 'ROW_OVERFLOW_DATA')
    AND ips.page_count > 3000
    AND ips.avg_fragmentation_in_percent > 10
ORDER BY o.name, ips.page_count, i.name
/*
TableName                                                                                                                        IndexName                                                                                                                        index_type_desc                                              avg_fragmentation_in_percent           page_count avg_page_space_used_in_percent
-------------------------------------------------------------------------------------------------------------------------------- -------------------------------------------------------------------------------------------------------------------------------- ------------------------------------------------------------ ---------------------------- -------------------- ------------------------------
tblOrder                                                                                                                         _dta_index_tblOrder_7_1989582126__K21_K8_K2_K1                                                                                   NONCLUSTERED INDEX                                                       11.9665513264129                 6936               93.8360390412651
tblOrder                                                                                                                         _dta_index_tblOrder_7_1989582126__K2_K24_K21_K17                                                                                 NONCLUSTERED INDEX                                                       18.2150694952451                 8202               90.6409562638992
tblOrder                                                                                                                         _dta_index_tblOrder_7_1989582126__K2_K1_K17_K23_K25_K21_K8_K12_K7                                                                NONCLUSTERED INDEX                                                       12.0202981287663                12612               94.0635532493205
tblOrder                                                                                                                         _dta_index_tblOrder_7_1989582126__K11_K6_1_2_3_4_5_7_8_9_10_12_13_14_15_16_17_18_19_20_21_22_23_24_25_26_27_28_29_30_31          NONCLUSTERED INDEX                                                       5.61880034618201                30042               96.2423276501112
tblOrderLine                                                                                                                     _dta_index_tblOrderLine_7_1077578877__K3_8                                                                                       NONCLUSTERED INDEX                                                       10.4397216074238                37501               94.3380281690141
tblOrderLine                                                                                                                     IX_tblOrderLine_ixSKU_flgLineStatus_flgKitComponent_dtOrderDate                                                                  NONCLUSTERED INDEX                                                       10.9527182574818                45176               93.7914998764517
tblOrderLine     

*/

/*
SELECT 
  total_physical_memory_kb, available_physical_memory_kb, 
  total_page_file_kb, available_page_file_kb, 
  system_memory_state_desc
FROM sys.dm_os_sys_memory
*/


-- STILL NEED TO RUN
ALTER INDEX [IX_tblOrderLine_ixOrder_flgLineStatus_dtOrderDate_ixSKU_Include] ON [dbo].[tblOrderLine] REBUILD PARTITION = ALL WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, RESUMABLE = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

ALTER INDEX [IX_tblOrderLine_flgKitComponent_ixSKU_ixOrder_Include] ON [dbo].[tblOrderLine] REBUILD PARTITION = ALL WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, RESUMABLE = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

ALTER INDEX [IX_tblOrderLine_flgLineStatus_mExtendedPrice_Include] ON [dbo].[tblOrderLine] REBUILD PARTITION = ALL WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, RESUMABLE = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

ALTER INDEX [IX_tblOrderLine_ixSKU_flgLineStatus_dtShippedDate_ixOrder_Include] ON [dbo].[tblOrderLine] REBUILD PARTITION = ALL WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, RESUMABLE = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

ALTER INDEX [IX_tblOrderLine_flgKitComponent_flgLineStatus_dtOrderDate_Include] ON [dbo].[tblOrderLine] REBUILD PARTITION = ALL WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, RESUMABLE = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

ALTER INDEX [IX_tblOrderLine_dtOrderDate_Include] ON [dbo].[tblOrderLine] REBUILD PARTITION = ALL WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, RESUMABLE = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

ALTER INDEX [IX_tblOrderLine_flgKitComponent_ixOrderDate_flgLineStatus_include] ON [dbo].[tblOrderLine] REBUILD PARTITION = ALL WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, RESUMABLE = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

ALTER INDEX [IX_tblOrderLine_dtOrderDate2_Include] ON [dbo].[tblOrderLine] REBUILD PARTITION = ALL WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, RESUMABLE = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

ALTER INDEX [IX_tblOrderLine_flgKitComponent_mExtendedPrice_flgLineStatus] ON [dbo].[tblOrderLine] REBUILD PARTITION = ALL WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, RESUMABLE = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

ALTER INDEX [IX_tblOrderLine_ixShippedDate_flgLineStatus_Include_ixOrder_ixSKU_iQuantity_sTrackingNumber] ON [dbo].[tblOrderLine] REBUILD PARTITION = ALL WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, RESUMABLE = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

ALTER INDEX [IX_tblOrderLine_ixOrder_Include_ixSKU_dtOrderDate_iOrdinality] ON [dbo].[tblOrderLine] REBUILD PARTITION = ALL WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, RESUMABLE = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

ALTER INDEX [IX_tblOrderLine_ixOrder_sTrackingNumber_Include_ixSKU_iQuantity_iOrdinality] ON [dbo].[tblOrderLine] REBUILD PARTITION = ALL WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, RESUMABLE = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

ALTER INDEX [IX_tblOrderLine_flgLineStatus_Include_ixOrder_ixSKU_iQuantity_sTrackingNumber] ON [dbo].[tblOrderLine] REBUILD PARTITION = ALL WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, RESUMABLE = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
