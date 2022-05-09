--  Case 21296 - AFCO Vendor Inventory receipts by month for 2013

select distinct ixVendor, ixSKU 
FROM 
    (-- FLAT data... could make this a view or sub-query in order to SUM Sku Qty and ExtendedCost 
        -- to avoid showing the same SKUs multiple times for a vendor in the same month
    select D.dtDate -- 409 ROWS in IR for dec 2013
          ,D.sMonth
          ,V.ixVendor
          ,V.sName 'VendorName'
          ,IR.ixSKU
          ,IR.iQuantityReceived
          ,POD.mCost
          ,IR.iQuantityReceived * POD.mCost as 'Extended Cost'
    from tblInventoryReceipt IR
        left join tblPOMaster POM on IR.ixPO COLLATE SQL_Latin1_General_CP1_CS_AS = POM.ixPO COLLATE SQL_Latin1_General_CP1_CS_AS
        left join tblPODetail POD on IR.ixPO COLLATE SQL_Latin1_General_CP1_CS_AS = POD.ixPO COLLATE SQL_Latin1_General_CP1_CS_AS 
                        AND IR.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS = POD.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS 
        left join tblDate D on IR.ixCreateDate = D.ixDate
        left join tblVendor V on POM.ixVendor COLLATE SQL_Latin1_General_CP1_CS_AS = V.ixVendor COLLATE SQL_Latin1_General_CP1_CS_AS
    where ixCreateDate between 16772 and 16802 -- Just DEC 2013 for testing... query should only return 409 rows
    --order by D.sMonth, V.ixVendor, IR.ixSKU
    ) X
