-- update tblWork_TransferTruckHistory with data from the "Bin Inventory" report
-- query taken from Bin Inventory.rdl

DECLARE @sTruckName nvarchar(50) = 'AZIT-169', -- from file header/name 
        @ixLocation int = 85, -- 85 for AZ or 25 for WV
        @sTransferBin varchar(10) = 'AZIT9', -- from file header, xxIT then last digit of truck number
        @dtTruckReportDate date = '2021-12-29' -- date provided in the truck document

SELECT -- ixWorkTransferTruckHistory --  ask Ron how to insert next value for PK
    @sTruckName 'sTruckName',
    SL.ixSKU 'ixSKU', 
    ISNULL(S.sWebDescription, S.sDescription) 'sSkuDescription',
    iSKUQuantity 'iQty', 
    SL.iQAV 'iLocationQav',
    BS.ixLocation 'ixLocation', 
    @sTransferBin 'sTransferBin',
    SL.sPickingBin 'sPickingBin',
    SL.iPickingBinMin 'iPickingBinMin',
    SL.iPickingBinMax 'iPickingBinMax',
    SL.iCartonQuantity 'iPickingBinRestockUnit',
    @dtTruckReportDate 'dtTruckReportDate'
INTO #Load_tblWork_TransferTruckHistory
FROM tblBinSku BS
        LEFT JOIN tblSKU S ON S.ixSKU = BS.ixSKU
        LEFT JOIN tblSKULocation SL ON SL.ixSKU = BS.ixSKU 
                                     AND SL.ixLocation = @ixLocation 
WHERE ixBin =@sTransferBin
    and BS.ixLocation = @ixLocation
    and BS.iSKUQuantity > 0
ORDER BY S.ixSKU

-- SELECT * FROM #Load_tblWork_TransferTruckHistory
-- select top 10 * from tblWork_TransferTruckHistory 
-- SELECT * FROM tblWork_TransferTruckHistory WHERE sTruckName = 'AZIT-169'

select top 10 * from tblWork_TransferTruckHistory 
where sTruckName like 'AZIT-16%'

