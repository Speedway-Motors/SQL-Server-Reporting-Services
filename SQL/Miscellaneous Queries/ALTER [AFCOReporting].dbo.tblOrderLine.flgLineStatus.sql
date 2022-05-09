-- ALTER [AFCOReporting].dbo.tblOrderLine.flgLineStatus

USE [AFCOReporting];
SET XACT_ABORT on
BEGIN tran

--DROP INDEXES 
 DROP INDEX _dta_index_tblOrderLine_7_1077578877__K1_K9_K3_6_13 ON dbo.tblOrderLine 
 DROP INDEX _dta_index_tblOrderLine_7_1077578877__K14_K1_8_9_11_13 ON dbo.tblOrderLine 
 DROP INDEX _dta_index_tblOrderLine_7_1077578877__K2_K9_K10_K11_K1_K3 ON dbo.tblOrderLine 
 DROP INDEX _dta_index_tblOrderLine_7_1077578877__K3_K1_K2_K9_K10 ON dbo.tblOrderLine 
 DROP INDEX _dta_index_tblOrderLine_7_21575115__K1_2_3_4_5_6_7_8_9 ON dbo.tblOrderLine 
 DROP INDEX _dta_index_tblOrderLine_7_21575115__K9_1_3_6_7 ON dbo.tblOrderLine 
 DROP INDEX _dta_index_tblOrderLine_c_7_1077578877__K11_K9 ON dbo.tblOrderLine 


--ALTER FIELD
ALTER TABLE dbo.tblOrderLine
ALTER COLUMN flgLineStatus VARCHAR(15)

--RECREATE INDEXES
 CREATE NONCLUSTERED INDEX _dta_index_tblOrderLine_7_1077578877__K1_K9_K3_6_13 ON dbo.tblOrderLine (  ixOrder ASC  , flgLineStatus ASC  , ixSKU ASC  )   INCLUDE ( iQuantity , mExtendedCost )  WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 
 CREATE NONCLUSTERED INDEX _dta_index_tblOrderLine_7_1077578877__K14_K1_8_9_11_13 ON dbo.tblOrderLine (  flgKitComponent ASC  , ixOrder ASC  )   INCLUDE ( mExtendedPrice , flgLineStatus , dtShippedDate , mExtendedCost )  WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 
 CREATE NONCLUSTERED INDEX _dta_index_tblOrderLine_7_1077578877__K2_K9_K10_K11_K1_K3 ON dbo.tblOrderLine (  ixCustomer ASC  , flgLineStatus ASC  , dtOrderDate ASC  , dtShippedDate ASC  , ixOrder ASC  , ixSKU ASC  )   WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 
 CREATE NONCLUSTERED INDEX _dta_index_tblOrderLine_7_1077578877__K3_K1_K2_K9_K10 ON dbo.tblOrderLine (  ixSKU ASC  , ixOrder ASC  , ixCustomer ASC  , flgLineStatus ASC  , dtOrderDate ASC  )   WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 
 CREATE NONCLUSTERED INDEX _dta_index_tblOrderLine_7_21575115__K1_2_3_4_5_6_7_8_9 ON dbo.tblOrderLine (  ixOrder ASC  )   INCLUDE ( ixCustomer , ixSKU , ixShippedDate , ixOrderDate , iQuantity , mUnitPrice , mExtendedPrice , flgLineStatus )  WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 
 CREATE NONCLUSTERED INDEX _dta_index_tblOrderLine_7_21575115__K9_1_3_6_7 ON dbo.tblOrderLine (  flgLineStatus ASC  )   INCLUDE ( ixOrder , ixSKU , iQuantity , mUnitPrice )  WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 
 CREATE CLUSTERED INDEX _dta_index_tblOrderLine_c_7_1077578877__K11_K9 ON dbo.tblOrderLine (  dtShippedDate ASC  , flgLineStatus ASC  )   WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 


COMMIT TRAN

