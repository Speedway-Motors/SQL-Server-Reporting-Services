-- SMIHD-7588 Muscle Car SKUs
/*
DECLARE @Market int

SELECT @Market = 1903
*/
SELECT TNG.*
    , S.sSEMAPart 'PartType'
    , S.ixBrand
    , B.sBrandDescription 'Brand'
    , SALES.Sales12Mo
    , SALES.QtySold12Mo   
FROM openquery([TNGREADREPLICA], '	
        SELECT DISTINCT 
          b.ixSKUBase
       -- , s.ixSKUVariant          
        , s.sSKUVariantName
        , s.ixSOPSKU
        , m.sMarketName 
       -- , m.ixMarket
       -- Informational

        , MAX(CASE WHEN bum.ixMarket = m.ixMarket then 1 ELSE 0 END ) as flgUniversal
        , MAX(CASE WHEN ma.ixMarket = m.ixMarket then 1 ELSE 0 END ) as flgApplication
        , MAX(CASE WHEN rmx.ixMarket = m.ixMarket then 1 ELSE 0 END ) as flgRaceType
        , MAX(CASE WHEN vmx.ixMarket = m.ixMarket then 1 ELSE 0 END ) as flgvehicleBase
FROM tblskubase b
    INNER JOIN tblskuvariant s on b.ixSKUBase = s.ixSKUBase
    LEFT JOIN tblskubase_universal_market bum ON bum.ixSkuBase = b.ixSKUBase
    LEFT JOIN tblskuvariant_application_xref sax ON s.ixSKUVariant = sax.ixSKUVariant
    LEFT JOIN tblmarket_application ma ON sax.ixApplication = ma.ixApplication
    LEFT JOIN tblskuvariant_racetype_xref srx ON s.ixSKUVariant = srx.ixSkuVariant
    LEFT JOIN tblracetype_market_xref rmx ON srx.ixRaceType = rmx.ixRaceType
    LEFT JOIN 
    ( SELECT DISTINCT svb.ixSkuVariant, vmx.ixMarket 
      FROM  tblskuvariant_vehicle_base svb 
        inner JOIN tblvehicle_base_market_xref vmx ON svb.ixVehicleBase = vmx.ixVehicleBase
        INNER JOIN tblskuvariant s on svb.ixSkuVariant = s.ixSKUVariant
        INNER JOIN tblskubase b ON s.ixSKUBase = b.ixSKUBase 
    ) as vmx on s.ixSKUVariant = vmx.ixSkuVariant
    LEFT JOIN tblmarket m on bum.ixMarket = m.ixMarket
                        OR ma.ixMarket = m.ixMarket
                        OR rmx.ixMarket = m.ixMarket
                        OR vmx.ixMarket = m.ixMarket
WHERE m.ixMarket in (2,1775,1903) -- <id of Muscle car from tblmarket>  (1,2,3,4,222,225,741,857,949,1775,1877,1900,1901,1902,1903)   -- 3,258 for Marine market
GROUP BY b.ixSKUBase, s.ixSKUVariant, s.ixSOPSKU, m.ixMarket	
   ') TNG
   LEFT JOIN tblSKU S on TNG.ixSOPSKU COLLATE SQL_Latin1_General_CP1_CS_AS = S.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS
   LEFT JOIN tblBrand B on B.ixBrand = S.ixBrand
   LEFT JOIN (-- 12 Mo QTY SOLD
                SELECT OL.ixSKU
                    , SUM(OL.iQuantity) AS 'QtySold12Mo'
                    , SUM(OL.mExtendedPrice) 'Sales12Mo'
                    , SUM(OL.mExtendedCost) 'CoGS12Mo'
                FROM tblOrderLine OL 
                    join tblDate D on D.dtDate = OL.dtOrderDate 
                WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
                    and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
                GROUP BY OL.ixSKU
              ) SALES on SALES.ixSKU = S.ixSKU     




/* FROM RON 
"This is what you have to work into that query."
*/

SELECT   * 
FROM tblmarket m  
    LEFT JOIN tblsupermarket_market AS sm 
    LEFT JOIN tblsupermarket AS s ON sm.ixSupermarket = s.ixSuperMarket
                            ON m.ixMarket = sm.ixMarket 
                                AND  (m.ixMarket = 857
                                         AND s.ixSuperMarket = 3 -- Truck market is in two super markets, give the detault supermarket only
                                      OR  m.ixMarket <> 857
                                        )
ORDER BY m.ixMarket              


-- Markets
SELECT * 
FROM openquery([TNGREADREPLICA], '
                           select * from tblmarket
                             ') TNG
/*
ixMarket	sMarketName	flgVisible
1	        Offroad	0
2	        Oval Track	1
3	        Pedal Car	1
4	        Sport Compact	1
222	        Garage Sale	1
225	        Street Rod	1
741	        Open Wheel	1
857	        Classic Truck	1
949	        Muscle Car	1
1775	    Drag Racing	1
1877	    T-Bucket	1
1900	    Modern Truck	1
1901	    Modern Muscle	1
1902	    Marine	1
1903	    Demolition Derby	1
*/

1	        Offroad
1900	    Modern Truck
1775	    Drag Racing
1903	    Demolition Derby

/* FROM WYATT:
    "Racing" is a supermarket, which is a collection of 
    Oval Track and Drag Racing and Demolition Derby markets.  
    I believe it's "Racing" not "Race" in the db

select ixMarket, sMarketName
from tngLive.tblmarket -- on [dw.speedway2.com]
where ixMarket in (2,1775,1903)
order by ixMarket
/*
ixMarket	sMarketName
2	        Oval Track
1775	    Drag Racing
1903	    Demolition Derby
*/
*/

SELECT DISTINCT (CASE WHEN M.sMarketName IS NULL THEN 'Unassigned'
                      ELSE M.sMarketName
                  END) AS sMarketName
     , SV.ixSOPSKU
     , SV.sSKUVariantName
FROM tblskubase SB 
JOIN tblskuvariant SV ON SV.ixSKUBase = SB.ixSKUBase 
LEFT JOIN tblskubasemarket SBM ON SBM.ixSKUBase = SB.ixSKUBase
LEFT JOIN tblmarket M ON M.ixMarket = SBM.ixMarket
WHERE ((CASE WHEN M.sMarketName IS NULL THEN 'Unassigned'
                      ELSE M.sMarketName
                  END) = ?)      
  AND (
        (flgBackorderable = 1) 
          OR (flgBackorderable = 0 AND iTotalQAV > 0)
       )
  AND flgPublish = 1 
  
  
  SELECT * FROM [SMITemp].dbo.PJC_MC_SKUs_perTNG -- 51,274
  where 
     flgUniversal = 1                          -- 27,463
     and flgvehicleBase = 1                          -- 23,884     
     
      
      
SELECT * FROM tblEmployee where ixEmployee = 'LMC1'      

select * from tblTime where ixTime = '22503'

select * from tblVendor where ixVendor in ('0003','0008','0118','0018','5537','5566')

