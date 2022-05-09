-- Case 12580 - New Report: New SKU Performance

SELECT 
    /*********** section 1 **********************/
    /* 
    @Start & End Dates basec on SKU create date
    
        This version
    grouped by Dept (Emp that created the SKU's dept), 
       then Created by,  then Sales desc
    */    
    DEPT.sDescription as    CreatedByDept,
    SKU.ixCreator           CreatedBy,
    SKU.ixSKU               SKU,                -- Our Part Number
    VSKU.sVendorSKU         PrimaryVendorSKU,   -- Thier Part Number    
    V.ixVendor,
    V.sName                 PrimaryVendor,
    SKU.sDescription        SKUDescription,
    -- SEMA
    SKU.sSEMACategory,
    SKU.sSEMASubCategory,
    SKU.sSEMAPart,
    SKU.flgUnitOfMeasure    SellUM,
    (Case when SKU.flgActive = 1 then 'Y'
               when SKU.flgActive = 0 then 'N'
              else ' '
    end)                    Active,
    SKU.mPriceLevel1        Retail,             -- current price
    VSKU.mCost              PrimaryVendorCost,      
    SKU.dtDiscontinuedDate,
    SKU.dtCreateDate,
     /*********** section 2 YTD SUMMARY **********/
    case 
            when BOM.ixSKU IS NULL THEN BOM.ixSKU
            ELSE 'Y'
    end 'BOM',
          (BOMYTD.QTY)          YTDBOMQty,
    TYDKit.KitCompQtyConsumed,
    TYDKit.KitCompCost,
    isnull(YTD.YTDSales,0)      YTDSales,
    isnull(YTD.YTDGP,0)         YTDGP,
    isnull(YTD.YTDQTYSold,0)    YTDQTYSold,
    isnull(YTD.AVGInvCost,0)    AVGInvCost,
    /*********** section 3 MONTHLY SUMMARIES ******/
    Month01.Month01             FirstMonth,
    Month01.MonthSales          Month01Sales,
    Month01.MonthGP             Month01GP,
    Month01.MonthQTYSold        Month01QTYSold,
    Month02.Month02             Month02,
    Month02.MonthSales          Month02Sales,
    Month02.MonthGP             Month02GP,
    Month02.MonthQTYSold        Month02QTYSold,    
    Month03.Month03             Month03,
    Month03.MonthSales          Month03Sales,
    Month03.MonthGP             Month03GP,
    Month03.MonthQTYSold        Month03QTYSold,
    /*********** section 4 **********************/
    M.ixMarket              'MarketCode',
    M.sDescription          'MarketDescription',
    PGC.ixPGC               'PGC',  
    PGC.sDescription        'PGCDescription',  
    SKU.iQOS OH, 
    isNull(vwQO.QTYOutstanding,0) OPOQ -- add both together on report side for "INV OH+OPO QTY" field
    -- 'INV OH + OPO $$' = OPOQ * PrimaryVendorCost

FROM tblSKU SKU
		left join tblPGC PGC on PGC.ixPGC = SKU.ixPGC
	    left join tblMarket M on PGC.ixMarket = M.ixMarket
		left join tblDate D on D.ixDate = SKU.ixCreateDate
		left join tblVendorSKU VSKU on VSKU.ixSKU = SKU.ixSKU 
		left join tblVendor V on V.ixVendor = VSKU.ixVendor
		left join tblEmployee E on E.ixEmployee = SKU.ixCreator
		left join tblDepartment DEPT on DEPT.ixDepartment = E.ixDepartment
		left join vwSKUQuantityOutstanding vwQO on vwQO.ixSKU = SKU.ixSKU
        left join (SELECT                               
				   AMS.ixSKU,
					 SUM(AMS.AdjustedSales)	YTDSales,
					 SUM(AMS.AdjustedGP)   	YTDGP,
					 SUM(AMS.AdjustedQTYSold)	YTDQTYSold,
					 AVG(AMS.AVGInvCost)          AVGInvCost
				  FROM tblSnapAdjustedMonthlySKUSales AMS
                                                                  WHERE AMS.iYearMonth >= DATEADD(mm, DATEDIFF(mm,0,'08/01/12')-12, 0)    -- 12 months ago
				        and AMS.iYearMonth < '08/01/12' -- previous month
				  GROUP BY AMS.ixSKU
				  ) YTD on YTD.ixSKU = SKU.ixSKU
        -- YTD BOM
        left join (SELECT BOMTD.ixSKU,
                      SUM(CAST(BOMTD.iQuantity AS INT)*CAST(BOMTM.iCompletedQuantity AS INT)) QTY 
                   FROM tblBOMTransferMaster BOMTM 
                        join tblBOMTransferDetail BOMTD on BOMTD.ixTransferNumber = BOMTM.ixTransferNumber
                        join tblDate D on D.ixDate = BOMTM.ixCreateDate
                                       and D.dtDate >= DATEADD(mm, DATEDIFF(mm,0,'08/01/12')-12, 0)    -- 12 months ago
	                                  and D.dtDate < '08/01/12' -- previous month
                   GROUP BY BOMTD.ixSKU
                   ) BOMYTD on BOMYTD.ixSKU = YTD.ixSKU
        -- YTD Qty Consumed for KITS
            left join (select ixSKU, sum(mExtendedCost) KitCompCost, sum(iQuantity) KitCompQtyConsumed
                       from tblOrderLine
                       where flgKitComponent =1  
                         and dtOrderDate >= DATEADD(mm, DATEDIFF(mm,0,'08/01/12')-12, 0)    -- 12 months ago
                         and dtOrderDate < '08/01/12' -- previous month
                         and flgLineStatus = 'Shipped'
                       group by ixSKU
            ) TYDKit on TYDKit.ixSKU = SKU.ixSKU
        left join (SELECT                           
                                                                   iYearMonth                                           Month01,
				  tblSnapAdjustedMonthlySKUSales.ixSKU,
					 SUM(AdjustedSales)	MonthSales,
					 SUM(AdjustedGP)   	MonthGP,
					 SUM(AdjustedQTYSold)	MonthQTYSold
				  FROM tblSnapAdjustedMonthlySKUSales
                                                                 WHERE iYearMonth >= DATEADD(mm, DATEDIFF(mm,0,'08/01/12')-1, 0)    -- first of the month for '08/01/12'
				           and iYearMonth < DATEADD(mm, DATEDIFF(mm,0,'08/01/12'), 0) -- first of the month for '08/01/12'
				  GROUP BY iYearMonth,tblSnapAdjustedMonthlySKUSales.ixSKU
				 ) Month01 on Month01.ixSKU = SKU.ixSKU
          left join (SELECT                           
                                                                   iYearMonth                                           Month02,
				   ixSKU,
					 SUM(AdjustedSales)	MonthSales,
					 SUM(AdjustedGP)   	MonthGP,
					 SUM(AdjustedQTYSold)	MonthQTYSold
				  FROM tblSnapAdjustedMonthlySKUSales
			                  WHERE iYearMonth >= DATEADD(mm, DATEDIFF(mm,0,'08/01/12')-2, 0)    
				        and iYearMonth <= DATEADD(mm, DATEDIFF(mm,0,'08/01/12')-1, 0) 
				  GROUP BY iYearMonth, ixSKU
				 ) Month02 on Month02.ixSKU = SKU.ixSKU
        left join (SELECT                           
                                                                   iYearMonth                                           Month03,
				   ixSKU,
					 SUM(AdjustedSales)	MonthSales,
					 SUM(AdjustedGP)   	MonthGP,
					 SUM(AdjustedQTYSold)	MonthQTYSold
				  FROM tblSnapAdjustedMonthlySKUSales
			                  WHERE iYearMonth >= DATEADD(mm, DATEDIFF(mm,0,'08/01/12')-3, 0)    
				        and iYearMonth <= DATEADD(mm, DATEDIFF(mm,0,'08/01/12')-2, 0) 
				  GROUP BY iYearMonth, ixSKU
				 ) Month03 on Month03.ixSKU = SKU.ixSKU

        left join (select distinct(ixSKU)
                      from tblBOMTemplateDetail
                      ) BOM on BOM.ixSKU = SKU.ixSKU

WHERE 
	SKU.dtCreateDate >= '07/06/2012'
     and VSKU.iOrdinality = 1
-- AND SKU.ixSKU = '8352601874'
order by  SKU.ixSKU





/* DATE parameter query
select max (dbo.DisplayDate((CAST(FLOOR(CAST(dtDate AS DECIMAL(12, 5))) - (DAY(dtDate) - 1) AS DATETIME)))) Date
               
from tblDate
where dtDate between DATEADD(day, -1, GetDate()) and getDate()



GLOBALLY REPLACE '08/01/12' with '08/01/12'
*/