-- SMIHD-19819 - Completed BOMs by Date
/*  */
DECLARE @StartDate datetime,        @EndDate datetime,      @SKU varchar(30)
SELECT  @StartDate = '01/01/20',    @EndDate = '12/31/20',  @SKU = '52-53026'
/*
PckBin
OS Bin	
LastRcvd	
*/
SELECT D.dtDate, ST.ixSKU, S.ixPGC, ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription',
    ST.iQty 'AdjQty',
    ST.mAverageCost 'UnitCost',
    (ST.iQty * ST.mAverageCost) 'TotalCost',
    ST.sUser 'By',
    ST.sTransactionInfo 'Reason',
    SL.sPickingBin 'PickBin',
    --OS Bin	
    --LastRcvd
    ST.sLocation
FROM tblSKUTransaction ST
    left join tblDate D on ST.ixDate = D.ixDate
    left join tblSKU S on S.ixSKU = ST.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
    left join tblSKULocation SL on S.ixSKU = SL.ixSKU  COLLATE SQL_Latin1_General_CP1_CI_AS and SL.ixLocation = 99
WHERE ST.ixSKU in (@SKU) -- '52-904127WR' 52-53006' 'A550100101X' '2173-5'
    and sTransactionType = 'BOM'
    and D.dtDate between @StartDate and @EndDate -- ixDate between 18994 and 19359 -- all 2020



/*
            Sheet   Query
SKU         Qty     Results
==========  =====   =======
52-53006    2,224   2,224
52-52009	  415     415
52-53026	   24      24
52-904127WR	 -500    -500
*/

/*
SELECT * FROM tblSKULocation
where ixSKU = '52-904127WR'
*/