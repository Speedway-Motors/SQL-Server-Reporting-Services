/* AFCO pricing fpr ICS Catalog

 As part of the Business Unit & GL project, we will use a couple of automated catalogs to handle pricing for AFCO.

The following comment is Jeff White’s instruction to Connie on how to select the appropriate cost. 
Jeff knows his stuff, so I suggest that moving forward, any time someone asks for cost, you use the logic below. 

 i.e.  the order of precedence is:  1) Average Cost, 2) Prime Vendor Cost, 3) Last/Latest Cost, 4) SKU Retail Price.

—-—-—-— 
Reply above this line. 
Jeff White (PSG) commented:
Connie While  

The AFCO catalog will be the ICS catalog as discussed with CCC .  SOURCE-CODE ICS will point to AFCO catalog. 
Retail price is level 1 , qty 1 
For cost,  use the following logic : 


If QTY > 0 THEN SKU.COST = AVG.COST 
ELSE IF PRIME.VENDOR.COST # 0 THEN   SKU.COST = PRIME.VENDOR.COST
ELSE IF LAST.COST # 0 THEN  SKU.COST = LAST.COST 
ELSE SKU.COST = INV<4,1> ; (LEVEL 1, QTY 1 PRICE)
END



if it falls all the way to LEVEL 1 pricing, that's safer.  I don't want to guess at a markup form level 1 pricing. 
someone will be screaming if they are paying > retail price and it will be dealt with then. 

*/

SELECT S.ixSKU, 
    S.mAverageCost,
    VS.mCost 'PVCost',
    S.mLatestCost,
    S.mPriceLevel1,
    (CASE WHEN SL.iQAV > 0 THEN S.mAverageCost    -- 1)should this Qty be Qty Available (iQAV) or Qty on Hand (iQOS)?    2)Should the only qty looked at be for the single AFDO location? (99 on the AFCO side)
         WHEN VS.mCost <> 0 THEN VS.mCost 
         WHEN S.mLatestCost <> 0 THEN S.mLatestCost
    ELSE S.mPriceLevel1
    END
    ) AS 'CalculatedSKUCost'
FROM [SMI Reporting].dbo.tblSKU S
    left join [AFCOReporting].dbo.tblSKULocation SL on S.ixSKU  COLLATE SQL_Latin1_General_CP1_CI_AS = SL.ixSKU and SL.ixLocation = 99 -- only AFCO's local location?
    left join tblVendorSKU VS on S.ixSKU  COLLATE SQL_Latin1_General_CP1_CI_AS = VS.ixSKU and VS.iOrdinality = 1
    left join [SMI Reporting].dbo.tblCatalogDetail CD on S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = CD.ixSKU
WHERE CD.ixCatalog = 'AFCO.19'
    and S.flgDeletedFromSOP = 0
    and S.flgActive = 1
    and S.flgIntangible = 0


214,717 SKUs
120,880 S.mAverageCost
    281 VS.mCost
        S.mLatestCost
 69,380 S.mPriceLevel1


select * from tblCatalogDetail
select * from [SMI Reporting].dbo.tblCatalogMaster
where ixCatalog like '%AFCO%'

select * from [AFCOReporting].dbo.tblCatalogMaster
where ixCatalog like '%AFCO%'


SELECT COUNT(*) FROM [SMI Reporting].dbo.tblCatalogDetail CD
where ixCatalog = 'AFCO.19'

