select top 10 * from tblSKUTransaction

ixDate	ixTime	sUser	iSeq	sTransactionType	ixSKU	iQty	mAverageCost	sLocation	sToLocation	sWarehouse	sToWarehouse	sBin	sToBin	sCID	sToCID	sGID	sToGID	ixReceiver	ixJob

15185	29542	CEL	1283	R	10621-1200	10	35.22	99	NULL	MAIN	NULL	RCV	NULL	801399	NULL	17777	NULL	64502	NULL



select 
   D.dtDate, 
   ST.ixSKU, 
   SKU.sDescription, 
   SKU.mAverageCost,
   ST.iQty,
   (SKU.mAverageCost * ST.iQty) ExtendedCost,
   ST.sBin 'From Bin',
   ST.sToBin 'To Bin'
from tblSKUTransaction ST
   join tblDate D on ST.ixDate = D.ixDate
   join tblSKU SKU on ST.ixSKU = SKU.ixSKU
where ST.ixDate >= 15858 -- 06/01/2011
  and ST.sBin in ('LOST','LOSTNC')
  and ST.sToBin NOT in ('LOST','LOSTNC')
  and ST.sToBin is NOT NULL
  and ST.sTransactionType = 'T'


select top 10 * from tblSKU


