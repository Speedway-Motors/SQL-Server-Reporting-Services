SELECT 
/*********** section 1 **********************/
      V.ixVendor
    , V.sName AS PrimaryVendor
    , VSKU.sVendorSKU AS PrimaryVendorSKU  -- Thier Part Number
    , SKU.ixSKU AS SKU -- Our Part Number
    , SKU.sDescription AS SKUDescription
    , RTRIM(SKU.sSEMACategory) AS sSEMACategory
    , RTRIM(SKU.sSEMASubCategory) AS sSEMASubCategory 
    , RTRIM(SKU.sSEMAPart) AS sSEMAPart
    , SKU.flgUnitOfMeasure AS SellUM
    , (CASE WHEN SKU.flgActive = 1 THEN 'Y'
            WHEN SKU.flgActive = 0 THEN 'N'
            ELSE ' '
      END) AS Active
    , SKU.dtDiscontinuedDate
    , SKU.dtCreateDate
    , SKU.ixCreator AS CreatedBy
    , SKU.mPriceLevel1 AS Retail --current price
    , VSKU.mCost AS PrimaryVendorCost
    , SKU.mLatestCost AS LastCost
    , SKU.mAverageCost AS AvgCost    
    , dbo.GetSKUinCatalogsLast12Months (SKU.ixSKU) AS Catalogs
/*********** section 2 YTD SUMMARY **********/
    , (CASE WHEN BOM.ixSKU IS NULL THEN BOM.ixSKU
            ELSE 'Y'
      END) AS 'BOM'
    , (BOMYTD.QTY) AS YTDBOMQty
    , TYDKit.KitCompQtyConsumed
    , TYDKit.KitCompCost
    , YR2Kit.KitCompQtyConsumed AS YR2KitCompQtyConsumed
    , YR2Kit.KitCompCost AS YR2KitCompCost
    , ISNULL(YTD.YTDSales,0) AS YTDSales
    , ISNULL(YTD.YTDNonKCSales,0) AS YTDNonKCSales -- New
    , ISNULL(YTD.YTDKCSales,0) AS YTDKCSales -- New          
    , ISNULL(YTD.YTDGP,0) AS YTDGP
    , ISNULL(YTD.YTDNonKCGP,0) AS YTDNonKCGP -- New
    , ISNULL(YTD.YTDKCGP,0) AS YTDKCGP -- New         
    , ISNULL(YTD.YTDQTYSold,0) AS YTDQTYSold
    , ISNULL(YTD.YTDNonKCQtySold,0) AS YTDNonKCQtySold -- New 
    , ISNULL(YTD.YTDKCQtySold,0) AS YTDKCQtySold -- New        
    , ISNULL(YTD.AVGInvCost,0) AS AVGInvCost
    , (BOMYR2.QTY) AS YR2BOMQty
    , ISNULL(YR2.YR2Sales,0) AS YR2Sales
    , ISNULL(YR2.YR2NonKCSales,0) AS YR2NonKCSales -- New 
    , ISNULL(YR2.YR2KCSales,0) AS YR2KCSales  -- New        
    , ISNULL(YR2.YR2GP,0) AS YR2GP
    , ISNULL(YR2.YR2NonKCGP,0) AS YR2NonKCGP -- New
    , ISNULL(YR2.YR2KCGP,0) AS YR2KCGP  -- New         
    , ISNULL(YR2.YR2QTYSold,0) AS YR2QTYSold
    , ISNULL(YR2.YR2NonKCQtySold,0) AS YR2NonKCQtySold -- New 
    , ISNULL(YR2.YR2KCQtySold,0) AS YR2KCQtySold -- New        
    , ISNULL(YR2.YR2AVGInvCost,0) AS YR2AVGInvCost
/*********** section 3 MONTHLY SUMMARIES ******/
    , Month01.Month01 AS FirstMonth
    , Month01.MonthSales AS Month01Sales
    , Month01.MonthNonKCSales AS Month01NonKCSales -- New
    , Month01.MonthKCSales AS Month01KCSales -- New         
    , Month01.MonthGP AS Month01GP
    , Month01.MonthNonKCGP  AS Month01NonKCGP  -- New 
    , Month01.MonthKCGP  AS Month01KCGP  -- New         
    , Month01.MonthQTYSold AS Month01QTYSold
    , Month01.MonthNonKCQtySold AS Month01NonKCQtySold -- New 
    , Month01.MonthKCQtySold AS Month01KCQtySold -- New     
    , Month02.Month02 AS Month02
    , Month02.MonthSales AS Month02Sales
    , Month02.MonthNonKCSales AS Month02NonKCSales -- New
    , Month02.MonthKCSales AS Month02KCSales -- New         
    , Month02.MonthGP AS Month02GP
    , Month02.MonthNonKCGP  AS Month02NonKCGP  -- New 
    , Month02.MonthKCGP  AS Month02KCGP  -- New         
    , Month02.MonthQTYSold AS Month02QTYSold
    , Month02.MonthNonKCQtySold AS Month02NonKCQtySold -- New 
    , Month02.MonthKCQtySold AS Month02KCQtySold -- New  
    , Month03.Month03 AS Month03
    , Month03.MonthSales AS Month03Sales
    , Month03.MonthNonKCSales AS Month03NonKCSales -- New
    , Month03.MonthKCSales AS Month03KCSales -- New         
    , Month03.MonthGP AS Month03GP
    , Month03.MonthNonKCGP  AS Month03NonKCGP  -- New 
    , Month03.MonthKCGP  AS Month03KCGP  -- New         
    , Month03.MonthQTYSold AS Month03QTYSold
    , Month03.MonthNonKCQtySold AS Month03NonKCQtySold -- New 
    , Month03.MonthKCQtySold AS Month03KCQtySold -- New  
    , Month04.Month04 AS Month04
    , Month04.MonthSales AS Month04Sales
    , Month04.MonthNonKCSales AS Month04NonKCSales -- New
    , Month04.MonthKCSales AS Month04KCSales -- New         
    , Month04.MonthGP AS Month04GP
    , Month04.MonthNonKCGP  AS Month04NonKCGP  -- New 
    , Month04.MonthKCGP  AS Month04KCGP  -- New         
    , Month04.MonthQTYSold AS Month04QTYSold
    , Month04.MonthNonKCQtySold AS Month04NonKCQtySold -- New 
    , Month04.MonthKCQtySold AS Month04KCQtySold -- New  
    , Month05.Month05 AS Month05
    , Month05.MonthSales AS Month05Sales
    , Month05.MonthNonKCSales AS Month05NonKCSales -- New
    , Month05.MonthKCSales AS Month05KCSales -- New         
    , Month05.MonthGP AS Month05GP
    , Month05.MonthNonKCGP  AS Month05NonKCGP  -- New 
    , Month05.MonthKCGP  AS Month05KCGP  -- New         
    , Month05.MonthQTYSold AS Month05QTYSold
    , Month05.MonthNonKCQtySold AS Month05NonKCQtySold -- New 
    , Month05.MonthKCQtySold AS Month05KCQtySold -- New  
    , Month06.Month06 AS Month06
    , Month06.MonthSales AS Month06Sales
    , Month06.MonthNonKCSales AS Month06NonKCSales -- New
    , Month06.MonthKCSales AS Month06KCSales -- New         
    , Month06.MonthGP AS Month06GP
    , Month06.MonthNonKCGP  AS Month06NonKCGP  -- New 
    , Month06.MonthKCGP  AS Month06KCGP  -- New         
    , Month06.MonthQTYSold AS Month06QTYSold
    , Month06.MonthNonKCQtySold AS Month06NonKCQtySold -- New 
    , Month06.MonthKCQtySold AS Month06KCQtySold -- New  
    , Month07.Month07 AS Month07
    , Month07.MonthSales AS Month07Sales
    , Month07.MonthNonKCSales AS Month07NonKCSales -- New
    , Month07.MonthKCSales AS Month07KCSales -- New         
    , Month07.MonthGP AS Month07GP
    , Month07.MonthNonKCGP  AS Month07NonKCGP  -- New 
    , Month07.MonthKCGP  AS Month07KCGP  -- New         
    , Month07.MonthQTYSold AS Month07QTYSold
    , Month07.MonthNonKCQtySold AS Month07NonKCQtySold -- New 
    , Month07.MonthKCQtySold AS Month07KCQtySold -- New  
    , Month08.Month08 AS Month08
    , Month08.MonthSales AS Month08Sales
    , Month08.MonthNonKCSales AS Month08NonKCSales -- New
    , Month08.MonthKCSales AS Month08KCSales -- New         
    , Month08.MonthGP AS Month08GP
    , Month08.MonthNonKCGP  AS Month08NonKCGP  -- New 
    , Month08.MonthKCGP  AS Month08KCGP  -- New         
    , Month08.MonthQTYSold AS Month08QTYSold
    , Month08.MonthNonKCQtySold AS Month08NonKCQtySold -- New 
    , Month08.MonthKCQtySold AS Month08KCQtySold -- New  
    , Month09.Month09 AS Month09
    , Month09.MonthSales AS Month09Sales
    , Month09.MonthNonKCSales AS Month09NonKCSales -- New
    , Month09.MonthKCSales AS Month09KCSales -- New         
    , Month09.MonthGP AS Month09GP
    , Month09.MonthNonKCGP  AS Month09NonKCGP  -- New 
    , Month09.MonthKCGP  AS Month09KCGP  -- New         
    , Month09.MonthQTYSold AS Month09QTYSold
    , Month09.MonthNonKCQtySold AS Month09NonKCQtySold -- New 
    , Month09.MonthKCQtySold AS Month09KCQtySold -- New  
    , Month10.Month10 AS Month10
    , Month10.MonthSales AS Month10Sales
    , Month10.MonthNonKCSales AS Month10NonKCSales -- New
    , Month10.MonthKCSales AS Month10KCSales -- New         
    , Month10.MonthGP AS Month10GP
    , Month10.MonthNonKCGP  AS Month10NonKCGP  -- New 
    , Month10.MonthKCGP  AS Month10KCGP  -- New         
    , Month10.MonthQTYSold AS Month10QTYSold
    , Month10.MonthNonKCQtySold AS Month10NonKCQtySold -- New 
    , Month10.MonthKCQtySold AS Month10KCQtySold -- New  
    , Month11.Month11 AS Month11
    , Month11.MonthSales AS Month11Sales
    , Month11.MonthNonKCSales AS Month11NonKCSales -- New
    , Month11.MonthKCSales AS Month11KCSales -- New         
    , Month11.MonthGP AS Month11GP
    , Month11.MonthNonKCGP  AS Month11NonKCGP  -- New 
    , Month11.MonthKCGP  AS Month11KCGP  -- New         
    , Month11.MonthQTYSold AS Month11QTYSold
    , Month11.MonthNonKCQtySold AS Month11NonKCQtySold -- New 
    , Month11.MonthKCQtySold AS Month11KCQtySold -- New     
    , Month12.Month12 AS Month12
    , Month12.MonthSales AS Month12Sales
    , Month12.MonthNonKCSales AS Month12NonKCSales -- New
    , Month12.MonthKCSales AS Month12KCSales -- New         
    , Month12.MonthGP AS Month12GP
    , Month12.MonthNonKCGP  AS Month12NonKCGP  -- New 
    , Month12.MonthKCGP  AS Month12KCGP  -- New         
    , Month12.MonthQTYSold AS Month12QTYSold
    , Month12.MonthNonKCQtySold AS Month12NonKCQtySold -- New 
    , Month12.MonthKCQtySold AS Month12KCQtySold -- New  
    , Month13.Month13 AS Month13
    , Month13.MonthSales AS Month13Sales
    , Month13.MonthNonKCSales AS Month13NonKCSales -- New
    , Month13.MonthKCSales AS Month13KCSales -- New         
    , Month13.MonthGP AS Month13GP
    , Month13.MonthNonKCGP  AS Month13NonKCGP  -- New 
    , Month13.MonthKCGP  AS Month13KCGP  -- New         
    , Month13.MonthQTYSold AS Month13QTYSold
    , Month13.MonthNonKCQtySold AS Month13NonKCQtySold -- New 
    , Month13.MonthKCQtySold AS Month13KCQtySold -- New  
    , Month14.Month14 AS Month14
    , Month14.MonthSales AS Month14Sales
    , Month14.MonthNonKCSales AS Month14NonKCSales -- New
    , Month14.MonthKCSales AS Month14KCSales -- New         
    , Month14.MonthGP AS Month14GP
    , Month14.MonthNonKCGP  AS Month14NonKCGP  -- New 
    , Month14.MonthKCGP  AS Month14KCGP  -- New         
    , Month14.MonthQTYSold AS Month14QTYSold
    , Month14.MonthNonKCQtySold AS Month14NonKCQtySold -- New 
    , Month14.MonthKCQtySold AS Month14KCQtySold -- New  
    , Month15.Month15 AS Month15
    , Month15.MonthSales AS Month15Sales
    , Month15.MonthNonKCSales AS Month15NonKCSales -- New
    , Month15.MonthKCSales AS Month15KCSales -- New         
    , Month15.MonthGP AS Month15GP
    , Month15.MonthNonKCGP  AS Month15NonKCGP  -- New 
    , Month15.MonthKCGP  AS Month15KCGP  -- New         
    , Month15.MonthQTYSold AS Month15QTYSold
    , Month15.MonthNonKCQtySold AS Month15NonKCQtySold -- New 
    , Month15.MonthKCQtySold AS Month15KCQtySold -- New  
    , Month16.Month16 AS Month16
    , Month16.MonthSales AS Month16Sales
    , Month16.MonthNonKCSales AS Month16NonKCSales -- New
    , Month16.MonthKCSales AS Month16KCSales -- New         
    , Month16.MonthGP AS Month16GP
    , Month16.MonthNonKCGP  AS Month16NonKCGP  -- New 
    , Month16.MonthKCGP  AS Month16KCGP  -- New         
    , Month16.MonthQTYSold AS Month16QTYSold
    , Month16.MonthNonKCQtySold AS Month16NonKCQtySold -- New 
    , Month16.MonthKCQtySold AS Month16KCQtySold -- New  
    , Month17.Month17 AS Month17
    , Month17.MonthSales AS Month17Sales
    , Month17.MonthNonKCSales AS Month17NonKCSales -- New
    , Month17.MonthKCSales AS Month17KCSales -- New         
    , Month17.MonthGP AS Month17GP
    , Month17.MonthNonKCGP  AS Month17NonKCGP  -- New 
    , Month17.MonthKCGP  AS Month17KCGP  -- New         
    , Month17.MonthQTYSold AS Month17QTYSold
    , Month17.MonthNonKCQtySold AS Month17NonKCQtySold -- New 
    , Month17.MonthKCQtySold AS Month17KCQtySold -- New  
    , Month18.Month18 AS Month18
    , Month18.MonthSales AS Month18Sales
    , Month18.MonthNonKCSales AS Month18NonKCSales -- New
    , Month18.MonthKCSales AS Month18KCSales -- New         
    , Month18.MonthGP AS Month18GP
    , Month18.MonthNonKCGP  AS Month18NonKCGP  -- New 
    , Month18.MonthKCGP  AS Month18KCGP  -- New         
    , Month18.MonthQTYSold AS Month18QTYSold
    , Month18.MonthNonKCQtySold AS Month18NonKCQtySold -- New 
    , Month18.MonthKCQtySold AS Month18KCQtySold -- New  
    , Month19.Month19 AS Month19
    , Month19.MonthSales AS Month19Sales
    , Month19.MonthNonKCSales AS Month19NonKCSales -- New
    , Month19.MonthKCSales AS Month19KCSales -- New         
    , Month19.MonthGP AS Month19GP
    , Month19.MonthNonKCGP  AS Month19NonKCGP  -- New 
    , Month19.MonthKCGP  AS Month19KCGP  -- New         
    , Month19.MonthQTYSold AS Month19QTYSold
    , Month19.MonthNonKCQtySold AS Month19NonKCQtySold -- New 
    , Month19.MonthKCQtySold AS Month19KCQtySold -- New  
    , Month20.Month20 AS Month20
    , Month20.MonthSales AS Month20Sales
    , Month20.MonthNonKCSales AS Month20NonKCSales -- New
    , Month20.MonthKCSales AS Month20KCSales -- New         
    , Month20.MonthGP AS Month20GP
    , Month20.MonthNonKCGP  AS Month20NonKCGP  -- New 
    , Month20.MonthKCGP  AS Month20KCGP  -- New         
    , Month20.MonthQTYSold AS Month20QTYSold
    , Month20.MonthNonKCQtySold AS Month20NonKCQtySold -- New 
    , Month20.MonthKCQtySold AS Month20KCQtySold -- New 
    , Month21.Month21 AS Month21
    , Month21.MonthSales AS Month21Sales
    , Month21.MonthNonKCSales AS Month21NonKCSales -- New
    , Month21.MonthKCSales AS Month21KCSales -- New         
    , Month21.MonthGP AS Month21GP
    , Month21.MonthNonKCGP  AS Month21NonKCGP  -- New 
    , Month21.MonthKCGP  AS Month21KCGP  -- New         
    , Month21.MonthQTYSold AS Month21QTYSold
    , Month21.MonthNonKCQtySold AS Month21NonKCQtySold -- New 
    , Month21.MonthKCQtySold AS Month21KCQtySold -- New     
    , Month22.Month22 AS Month22
    , Month22.MonthSales AS Month22Sales
    , Month22.MonthNonKCSales AS Month22NonKCSales -- New
    , Month22.MonthKCSales AS Month22KCSales -- New         
    , Month22.MonthGP AS Month22GP
    , Month22.MonthNonKCGP  AS Month22NonKCGP  -- New 
    , Month22.MonthKCGP  AS Month22KCGP  -- New         
    , Month22.MonthQTYSold AS Month22QTYSold
    , Month22.MonthNonKCQtySold AS Month22NonKCQtySold -- New 
    , Month22.MonthKCQtySold AS Month22KCQtySold -- New  
    , Month23.Month23 AS Month23
    , Month23.MonthSales AS Month23Sales
    , Month23.MonthNonKCSales AS Month23NonKCSales -- New
    , Month23.MonthKCSales AS Month23KCSales -- New         
    , Month23.MonthGP AS Month23GP
    , Month23.MonthNonKCGP  AS Month23NonKCGP  -- New 
    , Month23.MonthKCGP  AS Month23KCGP  -- New         
    , Month23.MonthQTYSold AS Month23QTYSold
    , Month23.MonthNonKCQtySold AS Month23NonKCQtySold -- New 
    , Month23.MonthKCQtySold AS Month23KCQtySold -- New  
    , Month24.Month24 AS Month24
    , Month24.MonthSales AS Month24Sales
    , Month24.MonthNonKCSales AS Month24NonKCSales -- New
    , Month24.MonthKCSales AS Month24KCSales -- New         
    , Month24.MonthGP AS Month24GP
    , Month24.MonthNonKCGP  AS Month24NonKCGP  -- New 
    , Month24.MonthKCGP  AS Month24KCGP  -- New         
    , Month24.MonthQTYSold AS Month24QTYSold
    , Month24.MonthNonKCQtySold AS Month24NonKCQtySold -- New 
    , Month24.MonthKCQtySold AS Month24KCQtySold -- New       
/*********** section 4 **********************/
    , 'TBD'	AS Owner
    , PGC.ixPGC AS PGC
    , PGC.sDescription AS PGCDescription -- concat on report side
    , SKU.iQOS AS OH
    , ISNULL(vwQO.QTYOutstanding,0) AS OPOQ -- add both together on report side for "INV OH+OPO QTY" field
    , (CASE WHEN SKU.flgAdditionalHandling = '1' THEN 'Truck'
            ELSE 'Parcel'
      END) AS ShipMethod    
    , B.sBrandDescription AS Brand
    , 'TBD'	AS Proprietary  
    , D.dtDate AS ItemCreationDate  
FROM tblSKU SKU
LEFT JOIN tblPGC PGC ON PGC.ixPGC = SKU.ixPGC
LEFT JOIN tblDate D ON D.ixDate = SKU.ixCreateDate
LEFT JOIN tblVendorSKU VSKU ON VSKU.ixSKU = SKU.ixSKU 
LEFT JOIN tblVendor V ON V.ixVendor = VSKU.ixVendor
LEFT JOIN vwSKUQuantityOutstanding vwQO ON vwQO.ixSKU = SKU.ixSKU
LEFT JOIN tblBrand B ON B.ixBrand = SKU.ixBrand
LEFT JOIN (SELECT AMS.ixSKU
				, SUM(AMS.AdjustedSales) AS	YTDSales
				, SUM(AMS.AdjustedNonKCSales) AS YTDNonKCSales -- New
				, SUM(AMS.KCSales) AS YTDKCSales -- New
				, SUM(AMS.AdjustedGP) AS YTDGP
				, SUM(AMS.AdjustedNonKCGP) AS YTDNonKCGP -- New 
				, SUM(AMS.KCGP) AS YTDKCGP -- New 
				, SUM(AMS.AdjustedQTYSold) AS YTDQTYSold
				, SUM(AMS.AdjustedNonKCQtySold) AS YTDNonKCQtySold -- New 
				, SUM(AMS.KCQtySold) AS YTDKCQtySold -- New 
				, AVG(AMS.AVGInvCost) AS AVGInvCost
		   FROM tblSnapAdjustedMonthlySKUSalesNEW AMS
           WHERE AMS.iYearMonth >= DATEADD(mm, DATEDIFF(mm,0,@Date)-12, 0)    -- 12 months ago
			 AND AMS.iYearMonth < @Date -- previous month
		   GROUP BY AMS.ixSKU
		  ) YTD ON YTD.ixSKU = SKU.ixSKU
-- YTD BOM
LEFT JOIN (SELECT BOMTD.ixSKU
                , SUM(CAST(BOMTD.iQuantity AS INT)* CAST(BOMTM.iCompletedQuantity AS INT)) AS QTY 
           FROM tblBOMTransferMaster BOMTM 
           JOIN tblBOMTransferDetail BOMTD ON BOMTD.ixTransferNumber = BOMTM.ixTransferNumber
           JOIN tblDate D on D.ixDate = BOMTM.ixCreateDate
                         AND D.dtDate >= DATEADD(mm, DATEDIFF(mm,0,@Date)-12, 0)    -- 12 months ago
				         AND D.dtDate < @Date -- previous month
           GROUP BY BOMTD.ixSKU
          ) BOMYTD ON BOMYTD.ixSKU = YTD.ixSKU
LEFT JOIN (SELECT AMS.ixSKU
                , SUM(AMS.BOMQuantity) AS YR2BOMQty
				, SUM(AMS.AdjustedSales) AS YR2Sales
				, SUM(AMS.AdjustedNonKCSales) AS YR2NonKCSales -- New
				, SUM(AMS.KCSales) AS YR2KCSales -- New				
				, SUM(AMS.AdjustedGP) AS YR2GP
				, SUM(AMS.AdjustedNonKCGP) AS YR2NonKCGP -- New 
				, SUM(AMS.KCGP) AS YR2KCGP -- New 				
				, SUM(AMS.AdjustedQTYSold) AS YR2QTYSold
				, SUM(AMS.AdjustedNonKCQtySold) AS YR2NonKCQtySold -- New 
				, SUM(AMS.KCQtySold) AS YR2KCQtySold -- New 				
				, AVG(AMS.AVGInvCost) AS YR2AVGInvCost
		   FROM tblSnapAdjustedMonthlySKUSalesNEW AMS
		   WHERE AMS.iYearMonth >= DATEADD(mm, DATEDIFF(mm,0,@Date)-24, 0)    -- 24 months ago
			 AND AMS.iYearMonth < DATEADD(mm, DATEDIFF(mm,0,@Date)-12, 0)    -- 12 months ago
		   GROUP BY AMS.ixSKU
		  ) YR2 on YR2.ixSKU = SKU.ixSKU
-- YR2 BOM
LEFT JOIN (SELECT BOMTD.ixSKU
                , SUM(CAST(BOMTD.iQuantity AS INT)* CAST(BOMTM.iCompletedQuantity AS INT)) AS QTY 
           FROM tblBOMTransferMaster BOMTM 
           JOIN tblBOMTransferDetail BOMTD ON BOMTD.ixTransferNumber = BOMTM.ixTransferNumber
           JOIN tblDate D ON D.ixDate = BOMTM.ixCreateDate
                         AND D.dtDate >= DATEADD(mm, DATEDIFF(mm,0,@Date)-24, 0)    -- 24 months ago
				         AND D.dtDate < DATEADD(mm, DATEDIFF(mm,0,@Date)-12, 0)    -- 12 months ago
           GROUP BY BOMTD.ixSKU
          ) BOMYR2 on BOMYR2.ixSKU = YR2.ixSKU
--  YTD Qty Consumed for KITS
LEFT JOIN (SELECT ixSKU
                , SUM(mExtendedCost) AS KitCompCost
                , SUM(iQuantity) AS KitCompQtyConsumed
           FROM tblOrderLine
           WHERE flgKitComponent = 1  
             AND dtOrderDate >= DATEADD(mm, DATEDIFF(mm,0,@Date)-12, 0)    -- 12 months ago
             AND dtOrderDate < @Date -- previous month
             AND flgLineStatus = 'Shipped'
           GROUP BY ixSKU
          ) TYDKit ON TYDKit.ixSKU = SKU.ixSKU
--  YR2 Qty Consumed for KITS
LEFT JOIN (SELECT ixSKU
                , SUM(mExtendedCost) AS KitCompCost
                , SUM(iQuantity) AS KitCompQtyConsumed
           FROM tblOrderLine
           WHERE flgKitComponent = 1  
             AND dtOrderDate >=  DATEADD(mm, DATEDIFF(mm,0,@Date)-24, 0)    -- 24 months ago    -- 12 months ago
             AND dtOrderDate < DATEADD(mm, DATEDIFF(mm,0,@Date)-12, 0)    -- 12 months ago -- previous month
             AND flgLineStatus = 'Shipped'
           GROUP BY ixSKU
          ) YR2Kit ON YR2Kit.ixSKU = SKU.ixSKU
LEFT JOIN (SELECT iYearMonth AS Month01
				, ixSKU
				, SUM(AdjustedSales)AS MonthSales
				, SUM(AdjustedNonKCSales) AS MonthNonKCSales -- New
				, SUM(KCSales) AS MonthKCSales -- New					
				, SUM(AdjustedGP) AS MonthGP
				, SUM(AdjustedNonKCGP) AS MonthNonKCGP -- New 
				, SUM(KCGP) AS MonthKCGP -- New 					
			    , SUM(AdjustedQTYSold) AS MonthQTYSold
				, SUM(AdjustedNonKCQtySold) AS MonthNonKCQtySold -- New 
				, SUM(KCQtySold) AS MonthKCQtySold -- New 			    
		   FROM tblSnapAdjustedMonthlySKUSalesNEW
           WHERE iYearMonth >= DATEADD(mm, DATEDIFF(mm,0,@Date)-1, 0)    -- first of the month for @Date
			 AND iYearMonth < DATEADD(mm, DATEDIFF(mm,0,@Date), 0) -- first of the month for @Date
		   GROUP BY iYearMonth
		          , ixSKU
		  ) Month01 ON Month01.ixSKU = SKU.ixSKU
LEFT JOIN (SELECT iYearMonth AS Month02
				, ixSKU
				, SUM(AdjustedSales)AS MonthSales
				, SUM(AdjustedNonKCSales) AS MonthNonKCSales -- New
				, SUM(KCSales) AS MonthKCSales -- New					
				, SUM(AdjustedGP) AS MonthGP
				, SUM(AdjustedNonKCGP) AS MonthNonKCGP -- New 
				, SUM(KCGP) AS MonthKCGP -- New 					
			    , SUM(AdjustedQTYSold) AS MonthQTYSold
				, SUM(AdjustedNonKCQtySold) AS MonthNonKCQtySold -- New 
				, SUM(KCQtySold) AS MonthKCQtySold -- New 	
		   FROM tblSnapAdjustedMonthlySKUSalesNEW
		   WHERE iYearMonth >= DATEADD(mm, DATEDIFF(mm,0,@Date)-2, 0)    
			 AND iYearMonth <= DATEADD(mm, DATEDIFF(mm,0,@Date)-1, 0) 
		   GROUP BY iYearMonth, ixSKU
		  ) Month02 on Month02.ixSKU = SKU.ixSKU
LEFT JOIN (SELECT iYearMonth AS Month03
				, ixSKU
				, SUM(AdjustedSales)AS MonthSales
				, SUM(AdjustedNonKCSales) AS MonthNonKCSales -- New
				, SUM(KCSales) AS MonthKCSales -- New					
				, SUM(AdjustedGP) AS MonthGP
				, SUM(AdjustedNonKCGP) AS MonthNonKCGP -- New 
				, SUM(KCGP) AS MonthKCGP -- New 					
			    , SUM(AdjustedQTYSold) AS MonthQTYSold
				, SUM(AdjustedNonKCQtySold) AS MonthNonKCQtySold -- New 
				, SUM(KCQtySold) AS MonthKCQtySold -- New 	
		   FROM tblSnapAdjustedMonthlySKUSalesNEW
		   WHERE iYearMonth >= DATEADD(mm, DATEDIFF(mm,0,@Date)-3, 0)    
			 AND iYearMonth <= DATEADD(mm, DATEDIFF(mm,0,@Date)-2, 0) 
		   GROUP BY iYearMonth, ixSKU
		  ) Month03 on Month03.ixSKU = SKU.ixSKU
LEFT JOIN (SELECT iYearMonth AS Month04
				, ixSKU
				, SUM(AdjustedSales)AS MonthSales
				, SUM(AdjustedNonKCSales) AS MonthNonKCSales -- New
				, SUM(KCSales) AS MonthKCSales -- New					
				, SUM(AdjustedGP) AS MonthGP
				, SUM(AdjustedNonKCGP) AS MonthNonKCGP -- New 
				, SUM(KCGP) AS MonthKCGP -- New 					
			    , SUM(AdjustedQTYSold) AS MonthQTYSold
				, SUM(AdjustedNonKCQtySold) AS MonthNonKCQtySold -- New 
				, SUM(KCQtySold) AS MonthKCQtySold -- New 	
		   FROM tblSnapAdjustedMonthlySKUSalesNEW
		   WHERE iYearMonth >= DATEADD(mm, DATEDIFF(mm,0,@Date)-4, 0)    
			 AND iYearMonth <= DATEADD(mm, DATEDIFF(mm,0,@Date)-3, 0) 
		   GROUP BY iYearMonth, ixSKU
		  ) Month04 on Month04.ixSKU = SKU.ixSKU
LEFT JOIN (SELECT iYearMonth AS Month05
				, ixSKU
				, SUM(AdjustedSales)AS MonthSales
				, SUM(AdjustedNonKCSales) AS MonthNonKCSales -- New
				, SUM(KCSales) AS MonthKCSales -- New					
				, SUM(AdjustedGP) AS MonthGP
				, SUM(AdjustedNonKCGP) AS MonthNonKCGP -- New 
				, SUM(KCGP) AS MonthKCGP -- New 					
			    , SUM(AdjustedQTYSold) AS MonthQTYSold
				, SUM(AdjustedNonKCQtySold) AS MonthNonKCQtySold -- New 
				, SUM(KCQtySold) AS MonthKCQtySold -- New 	
		   FROM tblSnapAdjustedMonthlySKUSalesNEW
		   WHERE iYearMonth >= DATEADD(mm, DATEDIFF(mm,0,@Date)-5, 0)    
			 AND iYearMonth <= DATEADD(mm, DATEDIFF(mm,0,@Date)-4, 0) 
		   GROUP BY iYearMonth, ixSKU
		  ) Month05 on Month05.ixSKU = SKU.ixSKU
LEFT JOIN (SELECT iYearMonth AS Month06
				, ixSKU
				, SUM(AdjustedSales)AS MonthSales
				, SUM(AdjustedNonKCSales) AS MonthNonKCSales -- New
				, SUM(KCSales) AS MonthKCSales -- New					
				, SUM(AdjustedGP) AS MonthGP
				, SUM(AdjustedNonKCGP) AS MonthNonKCGP -- New 
				, SUM(KCGP) AS MonthKCGP -- New 					
			    , SUM(AdjustedQTYSold) AS MonthQTYSold
				, SUM(AdjustedNonKCQtySold) AS MonthNonKCQtySold -- New 
				, SUM(KCQtySold) AS MonthKCQtySold -- New 	
		   FROM tblSnapAdjustedMonthlySKUSalesNEW
		   WHERE iYearMonth >= DATEADD(mm, DATEDIFF(mm,0,@Date)-6, 0)    
			 AND iYearMonth <= DATEADD(mm, DATEDIFF(mm,0,@Date)-5, 0) 
		   GROUP BY iYearMonth, ixSKU
		  ) Month06 on Month06.ixSKU = SKU.ixSKU
LEFT JOIN (SELECT iYearMonth AS Month07
				, ixSKU
				, SUM(AdjustedSales)AS MonthSales
				, SUM(AdjustedNonKCSales) AS MonthNonKCSales -- New
				, SUM(KCSales) AS MonthKCSales -- New					
				, SUM(AdjustedGP) AS MonthGP
				, SUM(AdjustedNonKCGP) AS MonthNonKCGP -- New 
				, SUM(KCGP) AS MonthKCGP -- New 					
			    , SUM(AdjustedQTYSold) AS MonthQTYSold
				, SUM(AdjustedNonKCQtySold) AS MonthNonKCQtySold -- New 
				, SUM(KCQtySold) AS MonthKCQtySold -- New 	
		   FROM tblSnapAdjustedMonthlySKUSalesNEW
		   WHERE iYearMonth >= DATEADD(mm, DATEDIFF(mm,0,@Date)-7, 0)    
			 AND iYearMonth <= DATEADD(mm, DATEDIFF(mm,0,@Date)-6, 0) 
		   GROUP BY iYearMonth, ixSKU
		  ) Month07 on Month07.ixSKU = SKU.ixSKU
LEFT JOIN (SELECT iYearMonth AS Month08
				, ixSKU
				, SUM(AdjustedSales)AS MonthSales
				, SUM(AdjustedNonKCSales) AS MonthNonKCSales -- New
				, SUM(KCSales) AS MonthKCSales -- New					
				, SUM(AdjustedGP) AS MonthGP
				, SUM(AdjustedNonKCGP) AS MonthNonKCGP -- New 
				, SUM(KCGP) AS MonthKCGP -- New 					
			    , SUM(AdjustedQTYSold) AS MonthQTYSold
				, SUM(AdjustedNonKCQtySold) AS MonthNonKCQtySold -- New 
				, SUM(KCQtySold) AS MonthKCQtySold -- New 	
		   FROM tblSnapAdjustedMonthlySKUSalesNEW
		   WHERE iYearMonth >= DATEADD(mm, DATEDIFF(mm,0,@Date)-8, 0)    
			 AND iYearMonth <= DATEADD(mm, DATEDIFF(mm,0,@Date)-7, 0) 
		   GROUP BY iYearMonth, ixSKU
		  ) Month08 on Month08.ixSKU = SKU.ixSKU
LEFT JOIN (SELECT iYearMonth AS Month09
				, ixSKU
				, SUM(AdjustedSales)AS MonthSales
				, SUM(AdjustedNonKCSales) AS MonthNonKCSales -- New
				, SUM(KCSales) AS MonthKCSales -- New					
				, SUM(AdjustedGP) AS MonthGP
				, SUM(AdjustedNonKCGP) AS MonthNonKCGP -- New 
				, SUM(KCGP) AS MonthKCGP -- New 					
			    , SUM(AdjustedQTYSold) AS MonthQTYSold
				, SUM(AdjustedNonKCQtySold) AS MonthNonKCQtySold -- New 
				, SUM(KCQtySold) AS MonthKCQtySold -- New 	
		   FROM tblSnapAdjustedMonthlySKUSalesNEW
		   WHERE iYearMonth >= DATEADD(mm, DATEDIFF(mm,0,@Date)-9, 0)    
			 AND iYearMonth <= DATEADD(mm, DATEDIFF(mm,0,@Date)-8, 0) 
		   GROUP BY iYearMonth, ixSKU
		  ) Month09 on Month09.ixSKU = SKU.ixSKU
LEFT JOIN (SELECT iYearMonth AS Month10
				, ixSKU
				, SUM(AdjustedSales)AS MonthSales
				, SUM(AdjustedNonKCSales) AS MonthNonKCSales -- New
				, SUM(KCSales) AS MonthKCSales -- New					
				, SUM(AdjustedGP) AS MonthGP
				, SUM(AdjustedNonKCGP) AS MonthNonKCGP -- New 
				, SUM(KCGP) AS MonthKCGP -- New 					
			    , SUM(AdjustedQTYSold) AS MonthQTYSold
				, SUM(AdjustedNonKCQtySold) AS MonthNonKCQtySold -- New 
				, SUM(KCQtySold) AS MonthKCQtySold -- New 	
		   FROM tblSnapAdjustedMonthlySKUSalesNEW
		   WHERE iYearMonth >= DATEADD(mm, DATEDIFF(mm,0,@Date)-10, 0)    
			 AND iYearMonth <= DATEADD(mm, DATEDIFF(mm,0,@Date)-9, 0) 
		   GROUP BY iYearMonth, ixSKU
		  ) Month10 on Month10.ixSKU = SKU.ixSKU
LEFT JOIN (SELECT iYearMonth AS Month11
				, ixSKU
				, SUM(AdjustedSales)AS MonthSales
				, SUM(AdjustedNonKCSales) AS MonthNonKCSales -- New
				, SUM(KCSales) AS MonthKCSales -- New					
				, SUM(AdjustedGP) AS MonthGP
				, SUM(AdjustedNonKCGP) AS MonthNonKCGP -- New 
				, SUM(KCGP) AS MonthKCGP -- New 					
			    , SUM(AdjustedQTYSold) AS MonthQTYSold
				, SUM(AdjustedNonKCQtySold) AS MonthNonKCQtySold -- New 
				, SUM(KCQtySold) AS MonthKCQtySold -- New 	
		   FROM tblSnapAdjustedMonthlySKUSalesNEW
		   WHERE iYearMonth >= DATEADD(mm, DATEDIFF(mm,0,@Date)-11, 0)    
			 AND iYearMonth <= DATEADD(mm, DATEDIFF(mm,0,@Date)-10, 0) 
		   GROUP BY iYearMonth, ixSKU
		  ) Month11 on Month11.ixSKU = SKU.ixSKU
LEFT JOIN (SELECT iYearMonth AS Month12
				, ixSKU
				, SUM(AdjustedSales)AS MonthSales
				, SUM(AdjustedNonKCSales) AS MonthNonKCSales -- New
				, SUM(KCSales) AS MonthKCSales -- New					
				, SUM(AdjustedGP) AS MonthGP
				, SUM(AdjustedNonKCGP) AS MonthNonKCGP -- New 
				, SUM(KCGP) AS MonthKCGP -- New 					
			    , SUM(AdjustedQTYSold) AS MonthQTYSold
				, SUM(AdjustedNonKCQtySold) AS MonthNonKCQtySold -- New 
				, SUM(KCQtySold) AS MonthKCQtySold -- New 	
		   FROM tblSnapAdjustedMonthlySKUSalesNEW
		   WHERE iYearMonth >= DATEADD(mm, DATEDIFF(mm,0,@Date)-12, 0)    
			 AND iYearMonth <= DATEADD(mm, DATEDIFF(mm,0,@Date)-11, 0) 
		   GROUP BY iYearMonth, ixSKU
		  ) Month12 on Month12.ixSKU = SKU.ixSKU
LEFT JOIN (SELECT iYearMonth AS Month13
				, ixSKU
				, SUM(AdjustedSales)AS MonthSales
				, SUM(AdjustedNonKCSales) AS MonthNonKCSales -- New
				, SUM(KCSales) AS MonthKCSales -- New					
				, SUM(AdjustedGP) AS MonthGP
				, SUM(AdjustedNonKCGP) AS MonthNonKCGP -- New 
				, SUM(KCGP) AS MonthKCGP -- New 					
			    , SUM(AdjustedQTYSold) AS MonthQTYSold
				, SUM(AdjustedNonKCQtySold) AS MonthNonKCQtySold -- New 
				, SUM(KCQtySold) AS MonthKCQtySold -- New 	
		   FROM tblSnapAdjustedMonthlySKUSalesNEW
		   WHERE iYearMonth >= DATEADD(mm, DATEDIFF(mm,0,@Date)-13, 0)    
			 AND iYearMonth <= DATEADD(mm, DATEDIFF(mm,0,@Date)-12, 0) 
		   GROUP BY iYearMonth, ixSKU
		  ) Month13 on Month13.ixSKU = SKU.ixSKU
LEFT JOIN (SELECT iYearMonth AS Month14
				, ixSKU
				, SUM(AdjustedSales)AS MonthSales
				, SUM(AdjustedNonKCSales) AS MonthNonKCSales -- New
				, SUM(KCSales) AS MonthKCSales -- New					
				, SUM(AdjustedGP) AS MonthGP
				, SUM(AdjustedNonKCGP) AS MonthNonKCGP -- New 
				, SUM(KCGP) AS MonthKCGP -- New 					
			    , SUM(AdjustedQTYSold) AS MonthQTYSold
				, SUM(AdjustedNonKCQtySold) AS MonthNonKCQtySold -- New 
				, SUM(KCQtySold) AS MonthKCQtySold -- New 	
		   FROM tblSnapAdjustedMonthlySKUSalesNEW
		   WHERE iYearMonth >= DATEADD(mm, DATEDIFF(mm,0,@Date)-14, 0)    
			 AND iYearMonth <= DATEADD(mm, DATEDIFF(mm,0,@Date)-13, 0) 
		   GROUP BY iYearMonth, ixSKU
		  ) Month14 on Month14.ixSKU = SKU.ixSKU
LEFT JOIN (SELECT iYearMonth AS Month15
				, ixSKU
				, SUM(AdjustedSales)AS MonthSales
				, SUM(AdjustedNonKCSales) AS MonthNonKCSales -- New
				, SUM(KCSales) AS MonthKCSales -- New					
				, SUM(AdjustedGP) AS MonthGP
				, SUM(AdjustedNonKCGP) AS MonthNonKCGP -- New 
				, SUM(KCGP) AS MonthKCGP -- New 					
			    , SUM(AdjustedQTYSold) AS MonthQTYSold
				, SUM(AdjustedNonKCQtySold) AS MonthNonKCQtySold -- New 
				, SUM(KCQtySold) AS MonthKCQtySold -- New 	
		   FROM tblSnapAdjustedMonthlySKUSalesNEW
		   WHERE iYearMonth >= DATEADD(mm, DATEDIFF(mm,0,@Date)-15, 0)    
			 AND iYearMonth <= DATEADD(mm, DATEDIFF(mm,0,@Date)-14, 0) 
		   GROUP BY iYearMonth, ixSKU
		  ) Month15 on Month15.ixSKU = SKU.ixSKU
LEFT JOIN (SELECT iYearMonth AS Month16
				, ixSKU
				, SUM(AdjustedSales)AS MonthSales
				, SUM(AdjustedNonKCSales) AS MonthNonKCSales -- New
				, SUM(KCSales) AS MonthKCSales -- New					
				, SUM(AdjustedGP) AS MonthGP
				, SUM(AdjustedNonKCGP) AS MonthNonKCGP -- New 
				, SUM(KCGP) AS MonthKCGP -- New 					
			    , SUM(AdjustedQTYSold) AS MonthQTYSold
				, SUM(AdjustedNonKCQtySold) AS MonthNonKCQtySold -- New 
				, SUM(KCQtySold) AS MonthKCQtySold -- New 	
		   FROM tblSnapAdjustedMonthlySKUSalesNEW
		   WHERE iYearMonth >= DATEADD(mm, DATEDIFF(mm,0,@Date)-16, 0)    
			 AND iYearMonth <= DATEADD(mm, DATEDIFF(mm,0,@Date)-15, 0) 
		   GROUP BY iYearMonth, ixSKU
		  ) Month16 on Month16.ixSKU = SKU.ixSKU
LEFT JOIN (SELECT iYearMonth AS Month17
				, ixSKU
				, SUM(AdjustedSales)AS MonthSales
				, SUM(AdjustedNonKCSales) AS MonthNonKCSales -- New
				, SUM(KCSales) AS MonthKCSales -- New					
				, SUM(AdjustedGP) AS MonthGP
				, SUM(AdjustedNonKCGP) AS MonthNonKCGP -- New 
				, SUM(KCGP) AS MonthKCGP -- New 					
			    , SUM(AdjustedQTYSold) AS MonthQTYSold
				, SUM(AdjustedNonKCQtySold) AS MonthNonKCQtySold -- New 
				, SUM(KCQtySold) AS MonthKCQtySold -- New 	
		   FROM tblSnapAdjustedMonthlySKUSalesNEW
		   WHERE iYearMonth >= DATEADD(mm, DATEDIFF(mm,0,@Date)-17, 0)    
			 AND iYearMonth <= DATEADD(mm, DATEDIFF(mm,0,@Date)-16, 0) 
		   GROUP BY iYearMonth, ixSKU
		  ) Month17 on Month17.ixSKU = SKU.ixSKU
LEFT JOIN (SELECT iYearMonth AS Month18
				, ixSKU
				, SUM(AdjustedSales)AS MonthSales
				, SUM(AdjustedNonKCSales) AS MonthNonKCSales -- New
				, SUM(KCSales) AS MonthKCSales -- New					
				, SUM(AdjustedGP) AS MonthGP
				, SUM(AdjustedNonKCGP) AS MonthNonKCGP -- New 
				, SUM(KCGP) AS MonthKCGP -- New 					
			    , SUM(AdjustedQTYSold) AS MonthQTYSold
				, SUM(AdjustedNonKCQtySold) AS MonthNonKCQtySold -- New 
				, SUM(KCQtySold) AS MonthKCQtySold -- New 	
		   FROM tblSnapAdjustedMonthlySKUSalesNEW
		   WHERE iYearMonth >= DATEADD(mm, DATEDIFF(mm,0,@Date)-18, 0)    
			 AND iYearMonth <= DATEADD(mm, DATEDIFF(mm,0,@Date)-17, 0) 
		   GROUP BY iYearMonth, ixSKU
		  ) Month18 on Month18.ixSKU = SKU.ixSKU
LEFT JOIN (SELECT iYearMonth AS Month19
				, ixSKU
				, SUM(AdjustedSales)AS MonthSales
				, SUM(AdjustedNonKCSales) AS MonthNonKCSales -- New
				, SUM(KCSales) AS MonthKCSales -- New					
				, SUM(AdjustedGP) AS MonthGP
				, SUM(AdjustedNonKCGP) AS MonthNonKCGP -- New 
				, SUM(KCGP) AS MonthKCGP -- New 					
			    , SUM(AdjustedQTYSold) AS MonthQTYSold
				, SUM(AdjustedNonKCQtySold) AS MonthNonKCQtySold -- New 
				, SUM(KCQtySold) AS MonthKCQtySold -- New 	
		   FROM tblSnapAdjustedMonthlySKUSalesNEW
		   WHERE iYearMonth >= DATEADD(mm, DATEDIFF(mm,0,@Date)-19, 0)    
			 AND iYearMonth <= DATEADD(mm, DATEDIFF(mm,0,@Date)-18, 0) 
		   GROUP BY iYearMonth, ixSKU
		  ) Month19 on Month19.ixSKU = SKU.ixSKU
LEFT JOIN (SELECT iYearMonth AS Month20
				, ixSKU
				, SUM(AdjustedSales)AS MonthSales
				, SUM(AdjustedNonKCSales) AS MonthNonKCSales -- New
				, SUM(KCSales) AS MonthKCSales -- New					
				, SUM(AdjustedGP) AS MonthGP
				, SUM(AdjustedNonKCGP) AS MonthNonKCGP -- New 
				, SUM(KCGP) AS MonthKCGP -- New 					
			    , SUM(AdjustedQTYSold) AS MonthQTYSold
				, SUM(AdjustedNonKCQtySold) AS MonthNonKCQtySold -- New 
				, SUM(KCQtySold) AS MonthKCQtySold -- New 	
		   FROM tblSnapAdjustedMonthlySKUSalesNEW
		   WHERE iYearMonth >= DATEADD(mm, DATEDIFF(mm,0,@Date)-20, 0)    
			 AND iYearMonth <= DATEADD(mm, DATEDIFF(mm,0,@Date)-19, 0) 
		   GROUP BY iYearMonth, ixSKU
		  ) Month20 on Month20.ixSKU = SKU.ixSKU
LEFT JOIN (SELECT iYearMonth AS Month21
				, ixSKU
				, SUM(AdjustedSales)AS MonthSales
				, SUM(AdjustedNonKCSales) AS MonthNonKCSales -- New
				, SUM(KCSales) AS MonthKCSales -- New					
				, SUM(AdjustedGP) AS MonthGP
				, SUM(AdjustedNonKCGP) AS MonthNonKCGP -- New 
				, SUM(KCGP) AS MonthKCGP -- New 					
			    , SUM(AdjustedQTYSold) AS MonthQTYSold
				, SUM(AdjustedNonKCQtySold) AS MonthNonKCQtySold -- New 
				, SUM(KCQtySold) AS MonthKCQtySold -- New 	
		   FROM tblSnapAdjustedMonthlySKUSalesNEW
		   WHERE iYearMonth >= DATEADD(mm, DATEDIFF(mm,0,@Date)-21, 0)    
			 AND iYearMonth <= DATEADD(mm, DATEDIFF(mm,0,@Date)-20, 0) 
		   GROUP BY iYearMonth, ixSKU
		  ) Month21 on Month21.ixSKU = SKU.ixSKU
LEFT JOIN (SELECT iYearMonth AS Month22
				, ixSKU
				, SUM(AdjustedSales)AS MonthSales
				, SUM(AdjustedNonKCSales) AS MonthNonKCSales -- New
				, SUM(KCSales) AS MonthKCSales -- New					
				, SUM(AdjustedGP) AS MonthGP
				, SUM(AdjustedNonKCGP) AS MonthNonKCGP -- New 
				, SUM(KCGP) AS MonthKCGP -- New 					
			    , SUM(AdjustedQTYSold) AS MonthQTYSold
				, SUM(AdjustedNonKCQtySold) AS MonthNonKCQtySold -- New 
				, SUM(KCQtySold) AS MonthKCQtySold -- New 	
		   FROM tblSnapAdjustedMonthlySKUSalesNEW
		   WHERE iYearMonth >= DATEADD(mm, DATEDIFF(mm,0,@Date)-22, 0)    
			 AND iYearMonth <= DATEADD(mm, DATEDIFF(mm,0,@Date)-21, 0) 
		   GROUP BY iYearMonth, ixSKU
		  ) Month22 on Month22.ixSKU = SKU.ixSKU
LEFT JOIN (SELECT iYearMonth AS Month23
				, ixSKU
				, SUM(AdjustedSales)AS MonthSales
				, SUM(AdjustedNonKCSales) AS MonthNonKCSales -- New
				, SUM(KCSales) AS MonthKCSales -- New					
				, SUM(AdjustedGP) AS MonthGP
				, SUM(AdjustedNonKCGP) AS MonthNonKCGP -- New 
				, SUM(KCGP) AS MonthKCGP -- New 					
			    , SUM(AdjustedQTYSold) AS MonthQTYSold
				, SUM(AdjustedNonKCQtySold) AS MonthNonKCQtySold -- New 
				, SUM(KCQtySold) AS MonthKCQtySold -- New 	
		   FROM tblSnapAdjustedMonthlySKUSalesNEW
		   WHERE iYearMonth >= DATEADD(mm, DATEDIFF(mm,0,@Date)-23, 0)    
			 AND iYearMonth <= DATEADD(mm, DATEDIFF(mm,0,@Date)-22, 0) 
		   GROUP BY iYearMonth, ixSKU
		  ) Month23 on Month23.ixSKU = SKU.ixSKU
LEFT JOIN (SELECT iYearMonth AS Month24
				, ixSKU
				, SUM(AdjustedSales)AS MonthSales
				, SUM(AdjustedNonKCSales) AS MonthNonKCSales -- New
				, SUM(KCSales) AS MonthKCSales -- New					
				, SUM(AdjustedGP) AS MonthGP
				, SUM(AdjustedNonKCGP) AS MonthNonKCGP -- New 
				, SUM(KCGP) AS MonthKCGP -- New 					
			    , SUM(AdjustedQTYSold) AS MonthQTYSold
				, SUM(AdjustedNonKCQtySold) AS MonthNonKCQtySold -- New 
				, SUM(KCQtySold) AS MonthKCQtySold -- New 	
		   FROM tblSnapAdjustedMonthlySKUSalesNEW
		   WHERE iYearMonth >= DATEADD(mm, DATEDIFF(mm,0,@Date)-24, 0)    
			 AND iYearMonth <= DATEADD(mm, DATEDIFF(mm,0,@Date)-23, 0) 
		   GROUP BY iYearMonth, ixSKU
		  ) Month24 on Month24.ixSKU = SKU.ixSKU
LEFT JOIN (SELECT DISTINCT (ixSKU)
           FROM tblBOMTemplateDetail
          ) BOM ON BOM.ixSKU = SKU.ixSKU
WHERE V.ixVendor BETWEEN @VendorStart AND @VendorEnd
-- V.ixVendor = '0101'
  AND
   (YTD.YTDQTYSold IS NOT NULL 
         OR YR2.YR2QTYSold IS NOT NULL)
  AND VSKU.iOrdinality = 1
-- AND SKU.ixSKU = '8352601874'
ORDER BY SKU.ixSKU