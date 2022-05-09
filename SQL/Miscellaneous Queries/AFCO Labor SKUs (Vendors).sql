-- AFCO'S Labor SKUs (Vendors)
-- These vendors supposedly only contain LABOR SKUs
SELECT * FROM tblVendor where ixVendor in ('5033','5061','5098','5372','6613','6615','6638','6362')
/*
    5033	INDUSTRIAL ANODIZING CO
    5061	CRADDOCK FINISHING CO
    5098	H & M METAL PROCESSING CO
    5372	LIVERMORE IND PLATING
    6362	INDY METAL FINISHING
    6613	DIXIE INDUSTRIAL FINISHING
    6615	NORCO METAL FINISHINGS INC
    6638	EMI QUALITY PLATING SERVICE
*/

select S.*, SL.iQAV -- 1196
from tblSKU S
    join tblVendorSKU VS on S.ixSKU = VS.ixSKU
    join tblSKULocation SL on S.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS = SL.ixSKU  COLLATE SQL_Latin1_General_CP1_CS_AS and SL.ixLocation = '99' 
where VS.ixVendor in ('5033','5061','5098','5372','6613','6615','6638','6362')
and S.flgDeletedFromSOP = 0


