-- SMIHD-19992 - Error on FIFO reports - 1-28-21
/*FIFO Layer Costs.rdl
    ver 21.12.1

DECLARE @Date date, 	 @Location int
SELECT  @Date = '01/01/2020',   @Location = 99
*/
select
	(CASE WHEN PGC.ixMarket IS NULL THEN 'Unassigned' ELSE PGC.ixMarket END) as 'Market',
	PGC.ixPGC as 'PGC',
	FD.ixSKU as 'SKU',
	SKU.sDescription as 'SKU Desc',
	FD.iFIFOQuantity 'FIFO Qty',
	FD.mFIFOCost as 'FIFO Unit Cost',
	--sum(FD.iFIFOQuantity*FD.mFIFOCost) as 'Extended Cost'
    sum(cast (FD.iFIFOQuantity as money)) * cast(FD.mFIFOCost as money) as 'Extended Cost'
     
from
	tblFIFODetail FD
	left join tblSKU SKU on FD.ixSKU collate SQL_Latin1_General_CP1_CS_AS = SKU.ixSKU collate SQL_Latin1_General_CP1_CS_AS
	left join tblPGC PGC on SKU.ixPGC = PGC.ixPGC
	left join tblDate D on FD.ixDate = D.ixDate
where
	D.dtDate = @Date
	and FD.ixLocation = @Location
group by
	(CASE WHEN PGC.ixMarket IS NULL THEN 'Unassigned' ELSE PGC.ixMarket END) ,
	PGC.ixPGC,
	FD.ixSKU,
	SKU.sDescription,
	FD.iFIFOQuantity,
	FD.mFIFOCost
	

/*
ix
Loc	sDescription
20	FBA
30	Eagle
31	Trackside Support Services
46	CSI
68	Lincoln
99	Boonville
*/
