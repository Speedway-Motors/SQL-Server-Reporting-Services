-- ALTER [SMI Reporting].dbo.tblOrderLine.flgLineStatus

USE [SMI Reporting];
SET XACT_ABORT on
BEGIN tran

--DROP INDEXES 
 DROP  INDEX IX_tblOrderLine_flgKitComponent_dtOrderDate_ixCustomer_flgLineStatus_dtShippedDate_ixOrder_ixSKU_Include ON dbo.tblOrderLine 
 DROP  INDEX IX_tblOrderLine_flgLineStatus_dtOrderDate_flgKitComponent_ixOrder_ixSKU_Include ON dbo.tblOrderLine 
 DROP  INDEX IX_tblOrderLine_flgLineStatus_dtShippedDate ON dbo.tblOrderLine 
 DROP  INDEX IX_tblOrderLine_ixOrder_flgLineStatus_dtOrderDate_ixSKU_Include ON dbo.tblOrderLine 
 DROP  INDEX IX_tblOrderLine_ixOrder_flgLineStatus_dtShippedDate_ixSKU_dtOrderDate ON dbo.tblOrderLine 
 DROP  INDEX IX_tblOrderLine_ixOrder_flgLineStatus_ixSKU_Include ON dbo.tblOrderLine 
 DROP  INDEX IX_tblOrderLine_ixOrder_ixSKU_Include ON dbo.tblOrderLine 


--ALTER FIELD
ALTER TABLE dbo.tblOrderLine
ALTER COLUMN flgLineStatus VARCHAR(15)

--RECREATE INDEXES
 CREATE NONCLUSTERED INDEX IX_tblOrderLine_flgKitComponent_dtOrderDate_ixCustomer_flgLineStatus_dtShippedDate_ixOrder_ixSKU_Include ON dbo.tblOrderLine (  flgKitComponent ASC  , dtOrderDate ASC  , ixCustomer ASC  , flgLineStatus ASC  , dtShippedDate ASC  , ixOrder ASC  , ixSKU ASC  )   INCLUDE ( iQuantity , mExtendedPrice , mExtendedCost )  WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 
 CREATE NONCLUSTERED INDEX IX_tblOrderLine_flgLineStatus_dtOrderDate_flgKitComponent_ixOrder_ixSKU_Include ON dbo.tblOrderLine (  flgLineStatus ASC  , dtOrderDate ASC  , flgKitComponent ASC  , ixOrder ASC  , ixSKU ASC  )   INCLUDE ( iQuantity , mUnitPrice , mCost )  WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 
 CREATE CLUSTERED INDEX IX_tblOrderLine_flgLineStatus_dtShippedDate ON dbo.tblOrderLine (  flgLineStatus ASC  , dtShippedDate ASC  )   WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 
 CREATE NONCLUSTERED INDEX IX_tblOrderLine_ixOrder_flgLineStatus_dtOrderDate_ixSKU_Include ON dbo.tblOrderLine (  ixOrder ASC  , flgLineStatus ASC  , dtOrderDate ASC  , ixSKU ASC  )   INCLUDE ( iQuantity )  WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 
 CREATE NONCLUSTERED INDEX IX_tblOrderLine_ixOrder_flgLineStatus_dtShippedDate_ixSKU_dtOrderDate ON dbo.tblOrderLine (  ixOrder ASC  , flgLineStatus ASC  , dtShippedDate ASC  , ixSKU ASC  , dtOrderDate ASC  )   WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 
 CREATE NONCLUSTERED INDEX IX_tblOrderLine_ixOrder_flgLineStatus_ixSKU_Include ON dbo.tblOrderLine (  ixOrder ASC  , flgLineStatus ASC  , ixSKU ASC  )   INCLUDE ( iQuantity , mExtendedCost )  WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 
 CREATE NONCLUSTERED INDEX IX_tblOrderLine_ixOrder_ixSKU_Include ON dbo.tblOrderLine (  ixOrder ASC  , ixSKU ASC  )   INCLUDE ( iQuantity , mExtendedPrice )  WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 
 CREATE NONCLUSTERED INDEX IX_tblOrderLine_ixSKU_flgLineStatus_flgKitComponent_dtOrderDate_Include ON dbo.tblOrderLine (  ixSKU ASC  , flgLineStatus ASC  , flgKitComponent ASC  , dtOrderDate ASC  )   INCLUDE ( mCost , iOrdinality , iKitOrdinality )  WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 
 CREATE NONCLUSTERED INDEX IX_tblOrderLine_ixSKu_Include ON dbo.tblOrderLine (  ixSKU ASC  )   INCLUDE ( mExtendedPrice )  WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 
 CREATE NONCLUSTERED INDEX IX_tblOrderLine_ixSKU_ixOrder_ixCustomer_flgLineStatus_dtOrderDate ON dbo.tblOrderLine (  ixSKU ASC  , ixOrder ASC  , ixCustomer ASC  , flgLineStatus ASC  , dtOrderDate ASC  )   WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) ON [PRIMARY ] 






COMMIT TRAN

