-- SMIHD-11566 SKUs for 360 Photo Process

-- SELECT @@SPID as 'Current SPID' -- 136
SELECT S.ixSKU, -- 8,488 after PV <> '0009' (GS)   8,497 after GS Market filter        8,731 after UP filter              9,190 after Salable filter         16k last draft sent to Wyatt
        S.sBaseIndex 'SKU Base',
        SL.sPickingBin 'PickingBin',
        (CASE
            WHEN SL.sPickingBin like '3A%' or SL.sPickingBin like '3B%' or SL.sPickingBin like '3C%' THEN '3ABC'
            WHEN SL.sPickingBin like '3D%' or SL.sPickingBin like '3E%' or SL.sPickingBin like '3F%' THEN '3DEF'
            WHEN SL.sPickingBin like '4A%' or SL.sPickingBin like '4B%' or SL.sPickingBin like '4C%' THEN '4ABC'
            WHEN SL.sPickingBin like '4D%' or SL.sPickingBin like '4E%' or SL.sPickingBin like '4F%' THEN '4Def'
            WHEN SL.sPickingBin like '5A%' or SL.sPickingBin like '5B%' or SL.sPickingBin like '5C%' THEN '5ABC'
            WHEN SL.sPickingBin like '5D%' or SL.sPickingBin like '5E%' or SL.sPickingBin like '5F%' THEN '5DEF'
            WHEN SL.sPickingBin = '999' THEN '999' -- FACTORY SHIPPED? will be excluded from report
            WHEN SL.sPickingBin = '9999' THEN '9999'  -- DISCONTINUED will be excluded from report
            WHEN SL.sPickingBin like 'A%' THEN 'A'
            WHEN SL.sPickingBin like 'B%' AND SL.sPickingBin <> 'BOM' THEN 'B'
            WHEN SL.sPickingBin = 'IVAN' THEN 'IVAN'
            WHEN SL.sPickingBin like 'R%' THEN 'R'
            WHEN SL.sPickingBin like 'SHOCK%' THEN 'SHOCK'
            WHEN SL.sPickingBin like 'SHOP%' THEN 'SHOP'
            WHEN SL.sPickingBin like 'V%' THEN 'V'
            WHEN SL.sPickingBin like 'X%' THEN 'X'
            WHEN SL.sPickingBin like 'Y%' THEN 'Y'
            WHEN SL.sPickingBin like 'Z%' THEN 'Z'
         ELSE SL.sPickingBin 
       END) 'PickZone',
       ISNULL(TC.ThumbnailCount,0) 'ImageCount', -- It's really a count of thumbnails so that an image that is saved at multiple sizes is counted multiple times
       B.sBrandDescription 'BrandName',
       ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription',
       S.sSEMACategory 'Category',
       S.sSEMASubCategory 'SubCategory',
       S.sSEMAPart 'Part Type',
       S.mPriceLevel1,
-- (S.mPriceLevel1 - S.mLatestCost) 'Unit Margin',
       ISNULL(SALES.QtySold12Mo,0) 'Velocity12Mo',
       (ISNULL(SALES.Sales12Mo,0)-ISNULL(SALES.CoGS12Mo,0)) 'GM12Mo', -- Estimated Profit 12-Month	
       S.iHeight 'ShippingHeight',
       S.iWidth 'ShippingWidth',
       S.iLength 'ShippingLength',
       S.dWeight 'Weight(Actual)',
       (-- Component of an active Kit?
         CASE WHEN S.ixSKU in (select distinct K.ixSKU 
                               from tblKit K-- 32,254
                                    left join tblSKU S on K.ixKitSKU = S.ixSKU
                               where S.ixSKU is NOT NULL
                                    and S.flgDeletedFromSOP = 0 -- 32,254
                                    and S.flgActive = 1)THEN 'Y'
         ELSE 'N'
         END
        ) 'ComponentOfActiveKit'
--INTO #TEMP360PhotoData
-- DROP TABLE #TEMP360PhotoData
FROM tblSKU S
    left join tblSKULocation SL on S.ixSKU = SL.ixSKU and SL.ixLocation = 99
    left join tblBrand B on S.ixBrand = B.ixBrand
    left join (-- count of thumbnails by BASE SKU
                SELECT b.ixSOPSKUBase
                     , COUNT(*) 'ThumbnailCount'
                FROM [DW.SPEEDWAY2.COM].TngRawData.tngLive.tblskubase b    -- 
                    left JOIN [DW.SPEEDWAY2.COM].TngRawData.tngLive.tblskubaseimage AS bi ON b.ixSKUBase = bi.ixSKUBase -- [DW.SPEEDWAY2.COM].
                WHERE bi.sImageSize = 'T' -- Thumb image
                GROUP BY b.ixSOPSKUBase
               ) TC on TC.ixSOPSKUBase COLLATE SQL_Latin1_General_CP1_CI_AS = S.sBaseIndex
    LEFT JOIN (-- 12 Mo SALES & Quantity Sold
                SELECT OL.ixSKU
                    ,SUM(OL.iQuantity) AS 'QtySold12Mo', SUM(OL.mExtendedPrice) 'Sales12Mo', SUM(OL.mExtendedCost) 'CoGS12Mo'
                FROM tblOrderLine OL 
                    join tblDate D on D.dtDate = OL.dtOrderDate 
                WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
                    and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
                GROUP BY OL.ixSKU
                ) SALES on SALES.ixSKU = S.ixSKU  
    LEFT JOIN (-- SALEABLE SKUs
               SELECT DISTINCT t.ixSOPSKU AS 'ixSOPSKU', t1.ixSOPSKUBase 'SOPSKUBase', t.ixSKUBase 'SKUBase'  -- 168,191 SKUs
               FROM [DW.SPEEDWAY2.COM].TngRawData.tngLive.tblskuvariant t
                  INNER JOIN [DW.SPEEDWAY2.COM].TngRawData.tngLive.tblskubase t1 ON t.ixSKUBase = t1.ixSKUBase
                  INNER JOIN [DW.SPEEDWAY2.COM].TngRawData.tngLive.tblproductpageskubase t2 ON t1.ixSKUBase = t2.ixSKUBase
                  INNER JOIN [DW.SPEEDWAY2.COM].TngRawData.tngLive.tblproductpage t3 ON t2.ixProductPage = t3.ixProductPage
                WHERE t.ixSOPSKU is NOT NULL
                    AND t.flgPublish = 1
                    AND t1.flgWebPublish = 1
                    AND t3.flgActive = 1
                    AND(t.iTotalQAV > 0 
                        OR t.flgBackorderable = 1)
               ) SS ON S.ixSKU = SS.ixSOPSKU COLLATE SQL_Latin1_General_CP1_CI_AS
    LEFT JOIN (-- GS Market 
                SELECT DISTINCT ixSkuBase 
                FROM [DW.SPEEDWAY2.COM].TngRawData.tngLive.tblskubase_effectivemarket 
                WHERE ixMarket = 222) GSM on SS.SKUBase = GSM.ixSkuBase
    LEFT JOIN tblVendorSKU VS on VS.ixSKU = S.ixSKU and VS.iOrdinality = 1
WHERE S.flgDeletedFromSOP = 0
    AND S.flgActive = 1
    and SL.sPickingBin NOT IN ('999','9999','EMI','!!!!!','~','`','!NA','SC01A1') -- Dropship, Discontinued and other invalid pick bins
    AND S.dWeight <= 70 -- 70lbs or less
    AND S.iLength <= 26 -- all dimenstions need be <=26 
    AND S.iWidth <= 26
    AND S.iHeight <= 26
    AND S.ixBrand in ('10087','10225','10956','10207','10494','10402','10240','11032','11182','10192','10189','10101','10297','10928','10831','10187','10922','10190','10191','11311','10763','10683','10046','10165','10185','10564','10781') -- House Brands list provided by Wyatt
    AND S.sSEMAPart NOT IN ('A/C Fittings','Accelerator Pump O-Rings','Air Bleeds','Air Cleaner Gaskets and Seals','Air Cleaner Spacers','Air Cleaners','Air Filter Elements','Air Hose Fittings','Air Suspension Air Line Fittings','AN Bulkhead Fittings','AN Bulkhead Nuts','AN Fitting Couplers','AN Fitting O-Rings','AN Fitting Reducers','AN Fitting Washers','AN Flare Caps','AN Flare Plugs','AN Hose End Sockets','AN Hose Ends','AN Hoses','AN Inline Pressure Port Fittings','AN Pressure Test Fittings','AN to Inverted Flare Fittings','AN to O-Ring Port Fittings','AN to SAE Quick Disconnect Fittings','AN to Straight Thread Fittings','AN to Tube Adapter Fittings','AN Weld Bung Fittings','AN Y-Fitting Manifolds','Arm Restraints','Auto Trans Gaskets','Auto Trans Oil Pan Bolts','Auto Trans Overhaul Kits','Banjo Fittings','Banjo Screw and Fittings','Banjo Washers','Banners','Barstools','Battery Cables','Beadlock Ring Bolts','Beadlock Rings','Body Gaskets and Seals','Body Hardware Tech Trays','Bolt Kits','Bolts','Brake Bleed Screws','Brake Caliper Bolts','Brake Hoses','Brake Line Hardware','Brake Line Hose End Fittings','Brake Line Quick Disconnect Fittings','Bumper Bolts','Butt Connectors','Button-Down Shirts','Camshaft Bearings','Camshaft Bushings','Camshaft Followers','Camshaft Seals','Car Covers','Carburetor Adapter Plates','Carburetor Base Gaskets','Carburetor Fuel Inlet Fittings','Carburetor Heat Shield Gaskets','Carburetor Main Jets','Carburetor Spacers','Carburetor Studs','Carburetor Throttle Plates','Carburetor Tuning Kits','Carburetor Vacuum Lines','Carpets','Catalogs','Chassis Gussets','Chassis Tabs','Chest Protectors','Choke Cables','Clevis','Clevis Pins','Clocks','Clutch Gaskets and Seals','Clutch Hydraulic Hose Fittings','Clutch Push Rods','Clutch Release Bearing Bolts','Coats and Jackets','Complete Bodies','Complete Kit Cars','Compression Fittings','Connecting Rod Bearings','Connecting Rod Bolts','Cool Suits','Coolant Bleeder Screws','Coolant Hose Fittings','Coolant Overflow Caps','Coolant Sensor Seals and Fittings','Coolant Water Outlet Gaskets','Cotter Pins','Courtesy Cover/Mats','Coveralls','Crankshaft Main Bearings','Crankshaft Pull Bolts','Crankshaft Seals','Creepers','Crew Gloves','Cylinder Head Bolts','Cylinder Head Dowel Pins','Cylinder Head Gaskets','Distributor Bolt Wrenches','Distributor Bolts','Distributor Gaskets and Seals','Dowel Pins','Drawing Books','Drive Shafts','E-Clips/Snap Rings','Emblem Gaskets and Seals','Embroidered Patches','Engine Conversion Gaskets','Engine Decals','Engine Gasket Sets','Engine Top End Kits','Enthusiast Books','Exhaust Collector Gaskets','Exhaust Valves','Exterior Door Handle Gaskets','Exterior Mirror Gaskets','Fastener Assortments','Fire Resistant Socks','Fire Resistant Underwear','First-Aid Kits','Fitting Crimp Collars','Flame Arrestors','Flex Guards','Flex Line Clips','Flexplate Mounting Bolts','Float Bowl Gaskets','Flywheel Bolts','Foam Inserts','Fuel Bladders','Fuel Cell Foams','Fuel Injection Nozzle O-Rings','Fuel Injection Throttle Body Gaskets','Fuel Line AN Fittings','Fuel Line Clamps','Fuel Line Clips','Fuel Pump Gaskets and Seals','Fuel Pump Push Rods','Fuel Sending Unit Gaskets and Seals','Fuel Storage Cans','Fuel Tank Gaskets and Seals','Fuses','Garage Signs','Gear Bags','Gear Drives','General Maintenance Hardware Tech Trays','Grease Fittings','Grease Zerk Fittings','Grommets','Hardware Assortment and Merchandisers','Harmonic Balancer Bolts','Hats and Caps','Head Lamp Retainers','Head Socks','Header Gaskets','Heater Fittings','Heim Joint Rod End Mounting Brackets','Heim Joint Rod End Reducers','Heim Joint Rod End Seals','Heim Joint Rod End Spacers','Heim Joints and Rod Ends','Helmet Bags','Helmet Graphics','Helmet Restraint Straps','Hog Rings','Hoodies and Sweatshirts','Hose Clamps','Hose Connector Assortment and Merchandisers','Hose Covers','Ignition Coil Lead Wires','Instructional DVDs','Intake Manifold Bolts','Intake Manifold Gaskets','Intake Valves','Inverted Flare Fittings','Jacobs Ladder Straps','Jacobs Ladders','Jam Nuts','Lapel Pins','Latex/Nitrile Gloves','Leg Restraints','Lock Washers','Magnetic Cable Fasteners','Magneto Gaskets and Seals','Main Bearing Gaskets and Seals','Manual Trans Gaskets','Manual Trans O-Rings','Master Cylinder Pushrods','Mechanical Fuel Injection Pills','Mechanical Fuel Injector Lines','Mechanics Wires','Metal Seal Ring/Washers','Metering Block Gaskets','Mock-Up Cylinder Heads','Mock-Up Engine Blocks','Mock-Up Transmissions','Mouse Pads','Multi Purpose Caps','Multi Purpose Knobs','Multi Purpose O-Rings','Multi Purpose Retainers','Multi Purpose Shelves','Multi Purpose Springs','Multi Purpose Threaded Plugs','Neck Braces','Necklaces','Nitrous Oxide Jets','Nitrous Oxide Manifold Fittings','Nuts','Nylon Air Hoses','O-Ring Tech Trays','Oil Dipstick Tube Seals','Oil Filter Gaskets and Seals','Oil Pan Bolts','Oil Pan Gaskets','Oil Pump Gaskets and Seals','Owners Manuals','Panel Trim Retainer Assortments','Parachutes','Pedal Cars','Peg Boards','Pigtails','Pipe Fitting Plugs','Pipe Fitting Reducers','Pipe Fittings','Pipe to AN Fittings','Pipe to Compression Fittings','Pipe to Hose Barb Fittings','Pipe to Inverted Flare Fittings','Pipe Weld Bung Fittings','Plug Buttons','Plumbing Tubing','Polo Shirts','Posters','Power Steering Pressure Fittings','Pull Bar Bolts','Pushrod Guide Plates','Pushrods','Quarter Turn Fastener Tools','Quarter-Turn Fastener Spring Plates','Quarter-Turn Fastener Springs','Quarter-Turn Fasteners','Quick Change Gears','Racing Gloves','Racing Harness Shoulder Pads','Racing Harnesses','Racing Shoes','Racing Suit Cleaners','Racing Suits','Radiator Caps','Radiator Thermostat Gaskets and Seals','Ratchets','Razor Blades','Repair Manuals','Retaining Clip Tech Trays','Retaining Rings','Rivets','Rocker Arm Balls','Rocker Arm Nuts','Rocker Arm Studs','Roll Bar Paddings','Roll Cage Kits','Roll Cage Tubing','Rotating Assemblies','Screws','Seats','Shock Bumpers','Shoes','Socket Adapters','Socket Sets','Sockets','Spark Plug Boot Protectors','Spark Plug Boot Pullers','Spark Plug Boots and Terminals','Spark Plug Sockets','Spark Plug Washers','Spark Plug Wires','Spark Plugs','Speed Nuts','Stud Removal Tools','Studs','Supercharger Gaskets and Seals','Sway Bar Bushings','Sway Bar End Links','Swedged Tubes','T-Shirts','Tail Light Gaskets and Seals','Tape Measures','Technical Books','Tee Fittings','Teflon Tape','Terminal Assortments','Thermal Sleeves','Thermometers','Threaded U-Bolts','Timing Cover Bolts','Timing Cover Gaskets','Timing Tapes','Torx Keys','Trim Removal Tools','Tube Fittings','Utility Knives','Vacuum Caps','Vacuum Line Fittings','Vacuum Lines','Valve Cover Gaskets and Seals','Valve Guide Seals','Washers','Water Pump Bolts','Water Pump Gaskets','Water Pump Pulley Bolts','Wheel Spacers','Windshield Wiper Gaskets and Seals','Wingnuts','Wiper Blades','Wire Brushes','Wire Holders','Work Gloves','Zip Ties')
    AND ISNULL(TC.ThumbnailCount,0) < 6
    AND S.ixSKU NOT LIKE 'UP%'
    AND SS.ixSOPSKU is NOT NULL -- SKU is Salable according to SS sub-query
    AND GSM.ixSkuBase IS NULL -- NOT IN GS Market
    AND VS.ixVendor <> '0009'
GROUP BY  S.ixSKU, --SUBSTRING(SL.sPickingBin,1,7)
    ISNULL(S.sWebDescription, S.sDescription),
      S.sBaseIndex ,
      SL.sPickingBin,
      ISNULL(TC.ThumbnailCount,0),
      B.sBrandDescription,
       B.sBrandDescription ,
       ISNULL(S.sWebDescription, S.sDescription),
       S.sSEMACategory,
       S.sSEMASubCategory,
       S.sSEMAPart,
      (S.mPriceLevel1 - S.mLatestCost),
       ISNULL(SALES.QtySold12Mo,0),
       (ISNULL(SALES.Sales12Mo,0)-ISNULL(SALES.CoGS12Mo,0)),
       S.iHeight,
       S.iWidth,
       S.iLength,
       S.dWeight,
            S.mPriceLevel1,
            S.mAverageCost,
            S.mLatestCost,
        (CASE
            WHEN SL.sPickingBin like '3A%' or SL.sPickingBin like '3B%' or SL.sPickingBin like '3C%' THEN '3ABC'
            WHEN SL.sPickingBin like '3D%' or SL.sPickingBin like '3E%' or SL.sPickingBin like '3F%' THEN '3DEF'
            WHEN SL.sPickingBin like '4A%' or SL.sPickingBin like '4B%' or SL.sPickingBin like '4C%' THEN '4ABC'
            WHEN SL.sPickingBin like '4D%' or SL.sPickingBin like '4E%' or SL.sPickingBin like '4F%' THEN '4DEF'
            WHEN SL.sPickingBin like '5A%' or SL.sPickingBin like '5B%' or SL.sPickingBin like '5C%' THEN '5ABC'
            WHEN SL.sPickingBin like '5D%' or SL.sPickingBin like '5E%' or SL.sPickingBin like '5F%' THEN '5DEF'
            WHEN SL.sPickingBin = '999' THEN '999' -- FACTORY SHIPPED? will be excluded from report
            WHEN SL.sPickingBin = '9999' THEN '9999'  -- DISCONTINUED will be excluded from report
            WHEN SL.sPickingBin like 'A%' THEN 'A'
            WHEN SL.sPickingBin like 'B%' AND SL.sPickingBin <> 'BOM' THEN 'B'
            WHEN SL.sPickingBin = 'IVAN' THEN 'IVAN'
            WHEN SL.sPickingBin like 'R%' THEN 'R'
            WHEN SL.sPickingBin like 'SHOCK%' THEN 'SHOCK'
            WHEN SL.sPickingBin like 'SHOP%' THEN 'SHOP'
            WHEN SL.sPickingBin like 'V%' THEN 'V'
            WHEN SL.sPickingBin like 'X%' THEN 'X'
            WHEN SL.sPickingBin like 'Y%' THEN 'Y'
            WHEN SL.sPickingBin like 'Z%' THEN 'Z'
         ELSE SL.sPickingBin
       END),
        S.flgIsKit
ORDER BY 'PickZone', 
    (ISNULL(SALES.Sales12Mo,0)-ISNULL(SALES.CoGS12Mo,0)) desc -- GM12Mo



-- DROP #TEMP360PhotoData
/*
SELECT PickZone, 
    FORMAT(COUNT(DISTINCT [SKU Base]),'###,###') 'SKUBaseCount',
    FORMAT(SUM(GM12Mo),'$###,##0') 'GM12Mo'
FROM  #TEMP360PhotoData
GROUP BY PickZone
ORDER BY SUM(GM12Mo) DESC
*/
/*
Pick    SKUBase
Zone	Count
A	    5185
X	    2001
V	    1735
B	    948
5ABC	913
Z	    750
4ABC	576
4DEF	459
3ABC	451
5DEF	443
3DEF	316
BOM 	256
Y	    245
SHOCK	51
SHOP	26
R	    2
*/














-- SELECT * FROM tblVendor where ixVendor in ('0999','9999')


-- EXCLUDED COUNTS
/*
SELECT SL.sPickingBin, COUNT(SL.ixSKU) 'SKUCount'
/*
            WHEN SL.sPickingBin like '3A%' or SL.sPickingBin like '3B%' or SL.sPickingBin like '3C%' THEN '3ABC'
            WHEN SL.sPickingBin like '3D%' or SL.sPickingBin like '3E%' or SL.sPickingBin like '3F%' THEN '3DEF'
            WHEN SL.sPickingBin like '4A%' or SL.sPickingBin like '4B%' or SL.sPickingBin like '4C%' THEN '4ABC'
            WHEN SL.sPickingBin like '4D%' or SL.sPickingBin like '4E%' or SL.sPickingBin like '4F%' THEN '4DEF'
            WHEN SL.sPickingBin like '5A%' or SL.sPickingBin like '5B%' or SL.sPickingBin like '5C%' THEN '5ABC'
            WHEN SL.sPickingBin like '5D%' or SL.sPickingBin like '5E%' or SL.sPickingBin like '5F%' THEN '5DEF'
            WHEN SL.sPickingBin = '999' THEN '999'
            WHEN SL.sPickingBin = '9999' THEN '9999'
            WHEN SL.sPickingBin like 'A%' THEN 'A'
            WHEN SL.sPickingBin like 'B%' AND SL.sPickingBin <> 'BOM' THEN 'B'
            WHEN SL.sPickingBin = 'IVAN' THEN 'IVAN'
            WHEN SL.sPickingBin like 'R%' THEN 'R'
            WHEN SL.sPickingBin like 'SHOCK%' THEN 'SHOCK'
            WHEN SL.sPickingBin like 'SHOP%' THEN 'SHOP'
            WHEN SL.sPickingBin like 'V%' THEN 'V'
            WHEN SL.sPickingBin like 'V%' THEN 'V'
            WHEN SL.sPickingBin like 'X%' THEN 'X'
            WHEN SL.sPickingBin like 'Y%' THEN 'Y'
            WHEN SL.sPickingBin like 'Z%' THEN 'Z'
         ELSE 'Excluded Pick Bins' -- B.ixBin
       END) 'PickZone',
       COUNT(S.ixSKU) 'SKUCount'
-- S.ixSKU, SL.sPickingBin
-- SUBSTRING(SL.sPickingBin,1,7) 'PickingBin',
--SL.sPickingBin, 
*/
FROM tblSKU S
    left join tblSKULocation SL on S.ixSKU = SL.ixSKU and SL.ixLocation = 99
WHERE S.flgDeletedFromSOP = 0
AND SL.sPickingBin NOT LIKE '3A%' 
AND SL.sPickingBin NOT LIKE '3B%'
AND SL.sPickingBin NOT LIKE '3C%'
AND SL.sPickingBin NOT LIKE '3C%'
AND SL.sPickingBin NOT LIKE '3D%'
AND SL.sPickingBin NOT LIKE '3E%'
AND SL.sPickingBin NOT LIKE '4A%' 
AND SL.sPickingBin NOT LIKE '4B%'
AND SL.sPickingBin NOT LIKE '4C%'
AND SL.sPickingBin NOT LIKE '4C%'
AND SL.sPickingBin NOT LIKE '4D%'
AND SL.sPickingBin NOT LIKE '4E%'
AND SL.sPickingBin NOT LIKE '5A%' 
AND SL.sPickingBin NOT LIKE '5B%'
AND SL.sPickingBin NOT LIKE '5C%'
AND SL.sPickingBin NOT LIKE '5C%'
AND SL.sPickingBin NOT LIKE '5D%'
AND SL.sPickingBin NOT LIKE '5E%'
AND SL.sPickingBin NOT LIKE 'A%'
AND SL.sPickingBin NOT LIKE 'B%'
AND SL.sPickingBin <> 'IVAN'
AND SL.sPickingBin NOT LIKE 'R%'
AND SL.sPickingBin NOT LIKE 'SHOCK%'
AND SL.sPickingBin NOT LIKE 'SHOP%'
AND SL.sPickingBin NOT LIKE 'V%'
AND SL.sPickingBin NOT LIKE 'X%'
AND SL.sPickingBin NOT LIKE 'Y%'
AND SL.sPickingBin NOT LIKE 'Z%'
--AND SL.sPickingBin < 'SF03F'
GROUP BY S.ixSKU, SL.sPickingBin--SUBSTRING(SL.sPickingBin,1,7)
/*
(CASE
            WHEN SL.sPickingBin like '5A%' or SL.sPickingBin like '5B%' or SL.sPickingBin like '5C%' THEN '5ABC'
            WHEN SL.sPickingBin like '5D%' or SL.sPickingBin like '5E%' or SL.sPickingBin like '5F%' THEN '5DEF'
            WHEN SL.sPickingBin like '4A%' or SL.sPickingBin like '4B%' or SL.sPickingBin like '4C%' THEN '4ABC'
            WHEN SL.sPickingBin like '4D%' or SL.sPickingBin like '4E%' or SL.sPickingBin like '4F%' THEN '4DEF'
            WHEN SL.sPickingBin like '3A%' or SL.sPickingBin like '3B%' or SL.sPickingBin like '3C%' THEN '3ABC'
            WHEN SL.sPickingBin like '3D%' or SL.sPickingBin like '3E%' or SL.sPickingBin like '3F%' THEN '3DEF'
            WHEN SL.sPickingBin like 'A%' THEN 'A'
            WHEN SL.sPickingBin like 'B%' AND SL.sPickingBin <> 'BOM' THEN 'B'
            WHEN SL.sPickingBin = 'IVAN' THEN 'IVAN'
            WHEN SL.sPickingBin like 'R%' THEN 'R'
            WHEN SL.sPickingBin like 'SHOCK%' THEN 'SHOCK'
            WHEN SL.sPickingBin like 'SHOP%' THEN 'SHOP'
            WHEN SL.sPickingBin like 'V%' THEN 'V'
            WHEN SL.sPickingBin like 'V%' THEN 'V'
            WHEN SL.sPickingBin like 'X%' THEN 'X'
            WHEN SL.sPickingBin like 'Y%' THEN 'Y'
            WHEN SL.sPickingBin like 'Z%' THEN 'Z'
         ELSE 'Excluded Pick Bins' -- B.ixBin
       END)
*/
HAVING COUNT(*) > 1
ORDER BY SL.sPickingBin

SELECT * FROM tblBrand where sBrandDescription in ('Bell','Bills Hot Rod Co','Blue Diamond Classics','DECO','Eagle Motorsports','Fenton','Finishline','G-Comp by Speedway','Henchcraft Racing Products','King Chrome','Mr Roadster','Offenhauser','Omega Helmet Shields','Omega Kustom Instruments','Rod Action','Safety Racing','Schnee Chassis','Speed Fast','Speedway Motors','Speedway Motors Racing Engines','Stallard Chassis','Swindell Series','Total Performance','Tru-Coil','Tru-Lite','Tru-Ram Manifolds','Yellow Jacket')
order by sBrandDescription

SELECT * FROM tblBrand where sBrandDescription LIKE '%G-Comp%'-- ('G-Comp by Speedway')
order by sBrandDescription

*/

SELECT COUNT(*) FROM #TEMP360PhotoData --                 8,485v

-- NONE OF THESE SHOULD BE IN THE RESULT SET
SELECT * FROM #TEMP360PhotoData
WHERE ixSKU IN ('350206', '91006366-2', '91140215') 
    OR Velocity12Mo is NULL
    OR GM12Mo is NULL
    OR ixSKU like 'UP%'

-- MAKE SURE the Active Componenet of Kit logic is working correctly
    SELECT * FROM #TEMP360PhotoData
    WHERE ixSKU IN ('91045002', '91602020', '91636100', '7205014')