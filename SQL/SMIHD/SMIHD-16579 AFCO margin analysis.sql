-- SMIHD-16579 AFCO margin analysis
-- AFCO SALES

-- ALL AFCO SKUs based on BRAND
SELECT S.ixSKU
INTO #AFCOSKUsBRAND -- 47,789 
-- DROP TABLE #AFCOSKUsBRAND
FROM tblSKU S
WHERE S.flgDeletedFromSOP = 0
and S.ixBrand in (10022, 10038, 10066, 10137, 11515)

/*
ixBrand	sBrandDescription
10022	Pro Shocks
10038	AFCO
10066	Dynatech
10137	Longacre
11515	DeWitts
*/

SELECT OL.ixSKU, S.sDescription,  --5,293    4,186 SKUs match back to AFCO SKUs
    SUM(OL.iQuantity) 'QtySold', 
    (SUM((OL.iQuantity)*OL.mUnitPrice)) 'ExtSales' ,
    (SUM((OL.iQuantity)*OL.mCost)) 'SMI_COGS', -- WILL SWITCH OUT AND USE AFCO COGS LATER
    (SUM((OL.iQuantity)*AFS.mAverageCost)) 'AFCO_COGS'
FROM tblOrder O
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
    left join tblSKU S on OL.ixSKU = S.ixSKU
    left join #AFCOSKUsBRAND on #AFCOSKUsBRAND.ixSKU = S.ixSKU
    left join tblVendorSKU VS on S.ixSKU = VS.ixSKU --and VS.iOrdinality = 1
    left join [AFCOReporting].dbo.tblSKU AFS on VS.sVendorSKU = AFS.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE O.dtInvoiceDate between '01/01/2019' and '12/31/2019'
    AND O.sOrderStatus = 'Shipped'
    AND OL.flgLineStatus in ('Shipped','Dropshipped')
    AND #AFCOSKUsBRAND.ixSKU is NOT NULL
    AND AFS.ixSKU IS NOT NULL
    AND AFS.flgDeletedFromSOP = 0
    AND OL.flgKitComponent = 1
GROUP BY OL.ixSKU, S.sDescription


/*              2019   
 USING PV                   USING BRAND             USING LIST OF BRANDS            MATCH BACK TO AFCO SKUS

 2,822 SKUs                 3,222 SKUs              5,293 SKUs                      4,186 SKUs

 $2,949,000 Sales           $2,880,000 Sales        $4,883,000 Sales	            $5,123,000 Sales  
  2,427,000 Cogs            $2,286,000 Cogs         $3,983,000 Cogs                 $3,694,000 SMI Cogs	                 +$500k Cogs for kit comp  12%
 ========== ======          ========== ======       ========== ======               $2,732,000 AFCO Cogs                 +$377k Cogs for kit comp  12%
 $  522,000 GM$             $  594,000 GM$          $  900,000 GM$                  ========== ======  
                                                                                    $1,429,000 GM$ @SMI Costs
                                                                                    $2,391,000 GM$ @AFCO Costs

                                                                                    $3,694,000 $2,732,000

[Yesterday 4:54 PM] Christopher C. Chance
    your SMI GM vs AFCO GM #s seem reasonable too.  ballpark, AFCO generated $1m GM selling to us in 2019
    which means the ballpark we were discussing this morning is probably a good ballpark too 
            - i.e. we're going to end up splitting the margin 50/50 and it's going to translate into $500k each
    plus the split of the margin on Speedway product sold to AFCO






 -- ALL AFCO SKUs using VENDOR
SELECT S.ixSKU
INTO #AFCOSKUs -- 17,663
FROM tblSKU S
    left join tblVendorSKU VS on S.ixSKU = VS.ixSKU and VS.iOrdinality = 1
WHERE VS.ixVendor in ('0055','0106','0108','0111','0126','0133','0134','0136','0311','0313','0475','0476','0578','0582','9106','9311')
    and S.flgDeletedFromSOP = 0


SELECT OL.ixSKU, S.sDescription,  -- 2,822
    SUM(OL.iQuantity) 'QtySold', 
    (SUM((OL.iQuantity)*OL.mUnitPrice)) 'ExtSales' ,
    (SUM((OL.iQuantity)*OL.mCost)) 'SMI_COGS' -- WILL SWITCH OUT AND USE AFCO COGS LATER
FROM tblOrder O
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
    left join tblSKU S on OL.ixSKU = S.ixSKU
    left join #AFCOSKUs on #AFCOSKUs.ixSKU = S.ixSKU
WHERE O.dtInvoiceDate between '01/01/2019' and '12/31/2019'
    AND O.sOrderStatus = 'Shipped'
    AND OL.flgLineStatus in ('Shipped','Dropshipped')
    AND #AFCOSKUs.ixSKU is NOT NULL
GROUP BY OL.ixSKU, S.sDescription


*/