select top 10 *
from tblOrderRouting
/*
ixOrder	
sDropRecord	
    ixCommitmentDate	
    ixCommitmentTime	
    ixCommitmentPrimaryTrailer	
    ixCommitmentSecondaryTrailer	
    iCommitmentBestTNT	
    ixCommitmentDeliveryDate	
ixAvailablePrintDate	
ixAvailablePrintTime	
ixAvailablePrintPrimaryTrailer	
ixAvailablePrintSecondaryTrailer	
iAvailablePrintBestTNT	
ixAvailablePrintDeliveryDate	
    ixPrintDate	
    ixPrintTime	
    ixPrintPrimaryTrailer	
    ixPrintSecondaryTrailer	
    iPrintBestTNT	
    ixPrintDeliveryDate	
ixVerifyDate	
ixVerifyTime	
ixVerifyPrimaryTrailer	
ixVerifySecondaryTrailer	
iVerifyBestTNT	
ixVerifyDeliveryDate
*/
select ixOrder, ixCOmmitmentDate, ixCOmmitmentTime,  ixCommitmentPrimaryTrailer TNT@OrderTime, ixPrintPrimaryTrailer TNT@PrintTime, ixVerifyPrimaryTrailer TNT@VerifyTime, TNTShipped
from tblOrderRouting
where ixCommitmentPrimaryTrailer <> ixPrintPrimaryTrailer
        or ixPrintPrimaryTrailer <> ixVerifyPrimaryTrailer
        or ixVerifyPrimaryTrailer <> TNTShipped


