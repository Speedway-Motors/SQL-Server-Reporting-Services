-- SMIHD-9648 - Mods for Shock Sales report

/*
TODO:

Hide PINK column
add the cost break out columns "SMILabor Cost" and "Ext Material Cost"
& Keep the combined cost field. HIDE "Ext Material Cost" FIELD FOR NOW BUT KEEP ON REPORT.

refer to "SHOP Sales.rdl"

 

Build a sub-report identical to the set-up of the MIDDLE sub-report on  "Engine Sales by PGC.rdl".  This one will only be for SKUs that belong to a NEW PGC that Kevin will provide after he creates it.
 

CREATE A SUB-TASK FOR CONNIE to split out the mSMITotalLaborCost field 
into SMIShockLabor & SMIShopLabor fields.


tblBOMTemplateMaster.mSMITotalLaborCost
tblBOMTemplateMaster.mSMIShockLabor

*/


-- Shock Sales (Shipped Orders)
/*
DECLARE @Start_Date datetime,        @End_Date datetime
SELECT  @Start_Date = '10/31/18',    @End_Date = '10/31/18'  
*/
SELECT
	SKU.ixPGC as 'SKU Product Group Code',
	PGC.sDescription as 'PGC Description',
	SKU.ixSKU as 'SKU', 
	SKU.sDescription as 'SKU Description',
	SKU.mPriceLevel1 as 'Retail',
	sum(OL.iQuantity) as 'Actual Units Sold',
	sum(OL.mExtendedPrice) as 'Sales',
	SUM(CASE when flgKitComponent = 1 then 0 -- don't count the CoGS if it's a kit component
	         ELSE OL.mExtendedCost
	    END) as 'Cost of Goods',
	sum(ISNULL(OL.mExtendedWeightedKitComponentPrice,0)) as 'EstKitCompSales',
    (SUM(isNULL(TM.mSMITotalMaterialCost,0))) + (SUM(isNULL(TM.mSMIShopLabor,0))) + (SUM(isNULL(TM.mSMIShockLabor,0))) as 'CombinedMatAndLaborCost',
    SUM(isNULL(TM.mSMITotalMaterialCost,0)) as 'ExtMaterialCost',
    SUM(isNULL(TM.mSMIShopLabor,0)) as 'ExtShopLabor',    
    SUM(isNULL(TM.mSMIShockLabor,0)) as 'ExtShockLabor'
FROM tblOrderLine OL
	right join vwSKULocalLocation SKU on OL.ixSKU = SKU.ixSKU
	right join tblPGC PGC on SKU.ixPGC = PGC.ixPGC
	left join tblOrder O on OL.ixOrder = O.ixOrder
    left join tblBOMTemplateMaster TM on TM.ixFinishedSKU = OL.ixSKU
WHERE OL.flgLineStatus in ('Shipped', 'Dropshipped')
	and (O.sOrderType <> 'Internal')
	and OL.dtShippedDate between @Start_Date and @End_Date
    --    and OL.flgKitComponent = 1 -- KIT COMPONENT CHECK
	and substring(SKU.ixPGC,1,1) in ('k') -- all the lower case values for the 1st char of ixPGC
GROUP BY 
	SKU.ixPGC,
	PGC.sDescription,
	SKU.ixSKU,
	SKU.sDescription,
	SKU.mPriceLevel1
ORDER BY SKU.ixPGC, SKU.ixSKU








-- SKUs in Shock PGC's (no orderline data)
SELECT
	SKU.ixPGC as 'SKU Product Group Code',
	PGC.sDescription as 'PGC Description',
	SKU.ixSKU as 'SKU', 
	SKU.sDescription as 'SKU Description',
	SKU.mPriceLevel1 as 'Retail',
    SKU.mAverageCost,
    SKU.mLatestCost,
    (isNULL(TM.mSMITotalMaterialCost,0)+isNULL(TM.mSMITotalLaborCost,0)) 'LaborAndMaterialCost',
    TM.mSMITotalMaterialCost,
    TM.mSMITotalLaborCost,
    TM.mSMIShopLabor,
    TM.mSMIShockLabor
FROM vwSKULocalLocation SKU
	right join tblPGC PGC on SKU.ixPGC = PGC.ixPGC
	--left join tblOrder O on OL.ixOrder = O.ixOrder
   left join tblBOMTemplateMaster TM on TM.ixFinishedSKU = SKU.ixSKU
WHERE substring(SKU.ixPGC,1,1) in ('k') -- all the lower case values for the 1st char of ixPGC
  and (isNULL(TM.mSMITotalMaterialCost,0)+isNULL(TM.mSMITotalLaborCost,0))  = 0
ORDER BY SKU.ixPGC, SKU.ixSKU

34,073 SKUs have a 'k' at the start of their PGC

kA
kB
kl
kK
kR
kS
