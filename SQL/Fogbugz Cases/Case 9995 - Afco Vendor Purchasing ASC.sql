SELECT V.ixVendor AS VendorNo
     , V.sName AS VendorName
     --, V.ixBuyer
     , S.ixSKU AS AfcoPartNo
     --, S.sDescription AS Description
     , SL.iQOS AS QtyOnHand 
     -- ^^ Split QOS above to show by reserve and by pick location ^^
     , ISNULL(RES.TotQty,0) AS ReserveQty
     , ISNULL(PIC.TotQty,0) AS PickQty 
     --, ISNULL(WIP.TotQty,0) AS WorkInProgressQty
     , SL.iQAV AS QtyAvail 
     , ISNULL(SKUSALES.TotalQty,0) + ISNULL(BOMUSAGE.TotalQty,0) AS '12MOUsage'
     -- Qty. on Hand / Monthly Avg. = MonthsOnHand 
     , (CASE WHEN ((ISNULL(SKUSALES.TotalQty,0) + ISNULL(BOMUSAGE.TotalQty,0)) / 12) = 0 THEN NULL
             ELSE ISNULL(SL.iQOS,0) / ((ISNULL(SKUSALES.TotalQty,0) + ISNULL(BOMUSAGE.TotalQty,0)) / 12)
        END) AS MonthsOnHand --Case Statement to get rid of divide by zero error
     -- 12 Month Usage / 12 = MonthlyAvg 
     , (ISNULL(SKUSALES.TotalQty,0) + ISNULL(BOMUSAGE.TotalQty,0)) / 12 AS MonthlyAvg
     -- Monthly Avg. * Forecast Factor = MonthlyForecast 
     , ((ISNULL(SKUSALES.TotalQty,0) + ISNULL(BOMUSAGE.TotalQty,0)) / 12) * 1.25 AS MonthlyForecast -- @ForecastFactor sub for 1.25 on report
     , ISNULL(dbo.TotQtyOnOrder (S.ixSKU),0) as TotQtyOnOrder
     -- Total Qty. on Order / Monthly Avg. = MonthsOnOrder 
     , (CASE WHEN ((ISNULL(SKUSALES.TotalQty,0) + ISNULL(BOMUSAGE.TotalQty,0)) / 12) = 0 THEN NULL 
             ELSE (ISNULL(dbo.TotQtyOnOrder (S.ixSKU),0)) / ((ISNULL(SKUSALES.TotalQty,0) + ISNULL(BOMUSAGE.TotalQty,0)) / 12)
        END) AS MonthsOnOrder --Case Statement to get rid of divide by zero error
     -- (Months On Hand + Total Qty. on Order) / Monthly Avg. = Total Months on Hand + Months On Order 
     , (CASE WHEN ((ISNULL(SKUSALES.TotalQty,0) + ISNULL(BOMUSAGE.TotalQty,0)) / 12) = 0 THEN NULL
             ELSE (ISNULL(SL.iQOS,0) / ((ISNULL(SKUSALES.TotalQty,0) + ISNULL(BOMUSAGE.TotalQty,0)) / 12)) 
                      + (ISNULL(dbo.TotQtyOnOrder (S.ixSKU),0) / ((ISNULL(SKUSALES.TotalQty,0) + ISNULL(BOMUSAGE.TotalQty,0)) / 12))
        END) AS 'TotMonthsOH+MonthsOO' --Case Statement to get rid of divide by zero error
     , SL.iQOS + (dbo.TotQtyOnOrder (S.ixSKU)) AS 'TotQtyOH+OO'
    /*** add Standard PO report ADD PO issue Date ***/
     , VS.iLeadTime AS LeadTime
     , S.iCartonQuantity AS PkgQty
     , ISNULL(S.iMinOrderQuantity,0) AS MinOrdQty
     , VS.sVendorSKU AS VendorPartNo
     , BO.BOQty
     , (BO.BOQty * S.mPriceLevel1) AS Retail
     , OBO.OrdersOnBO
     , OBO.OldestBO
     , CBO.CustsOnBO
     , VOC.VendorOrderCount
     , VCC.VendorCustomerCount

FROM tblVendor V
LEFT JOIN tblVendorSKU VS on VS.ixVendor = V.ixVendor 
LEFT JOIN tblSKU S on S.ixSKU = VS.ixSKU
LEFT JOIN tblSKULocation SL on SL.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS 
              = S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
AND SL.ixLocation = '99' --Where SL.ixLocation ='99'?? 

-- QOS Split Out: Reserve Location 
LEFT JOIN (SELECT DISTINCT S.ixSKU AS SKU 
                , SUM(BS.iSKUQuantity) AS TotQty
		   FROM tblSKU S 
		   LEFT JOIN tblSKULocation SL on SL.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS 
                         = S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS 
                      AND SL.ixLocation = '99' --Afco only 
		   LEFT JOIN tblBinSku BS ON BS.ixSKU = S.ixSKU 
		   LEFT JOIN tblBin B ON B.ixBin = BS.ixBin     
		   WHERE S.flgDeletedFromSOP = '0' 
			 AND BS.ixLocation = '99' 
			 AND S.flgActive = '1'    
			 AND B.sBinType = 'R' --Reserve
			 AND B.ixLocation = '99' 
		   GROUP BY   S.ixSKU
		  ) RES ON RES.SKU = S.ixSKU 

-- QOS Split Out: PIC Location 
LEFT JOIN (SELECT DISTINCT S.ixSKU AS SKU 
                , SUM(BS.iSKUQuantity) AS TotQty
		   FROM tblSKU S 
		   LEFT JOIN tblSKULocation SL on SL.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS 
                         = S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS 
                      AND SL.ixLocation = '99' --Afco only 
		   LEFT JOIN tblBinSku BS ON BS.ixSKU = S.ixSKU 
		   LEFT JOIN tblBin B ON B.ixBin = BS.ixBin     
		   WHERE S.flgDeletedFromSOP = '0' 
			 AND BS.ixLocation = '99' 
			 AND S.flgActive = '1'    
			 AND B.sBinType = 'P' --PIC 
			 AND B.ixLocation = '99' 
		   GROUP BY   S.ixSKU
		  ) PIC ON PIC.SKU = S.ixSKU 

-- QOS Split Out: WIP Location 
LEFT JOIN (SELECT DISTINCT S.ixSKU AS SKU 
                , SUM(BS.iSKUQuantity) AS TotQty
		   FROM tblSKU S 
		   LEFT JOIN tblSKULocation SL on SL.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS 
                         = S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS 
                      AND SL.ixLocation = '99' --Afco only 
		   LEFT JOIN tblBinSku BS ON BS.ixSKU = S.ixSKU 
		   LEFT JOIN tblBin B ON B.ixBin = BS.ixBin     
		   WHERE S.flgDeletedFromSOP = '0' 
			 AND BS.ixLocation = '99' 
			 AND S.flgActive = '1'    
			 AND B.sBinType = 'WIP' --Work in Progress  
			 AND B.ixLocation = '99' 
		   GROUP BY   S.ixSKU
		  ) WIP ON WIP.SKU = S.ixSKU 
		  		  		   
-- 12 MO. SKU SALES 
LEFT JOIN (SELECT OL.ixSKU AS SKU
				, SUM(OL.iQuantity) AS TotalQty
		   FROM tblOrderLine OL 
		   WHERE OL.flgLineStatus = 'Shipped' 
			 and OL.dtShippedDate BETWEEN DATEADD(yy, -1, GETDATE()) AND GETDATE()
		   GROUP BY OL.ixSKU) AS SKUSALES ON SKUSALES.SKU = S.ixSKU 
		   
		   
-- 12 MO. BOM USAGE 
LEFT JOIN (SELECT ST.ixSKU AS SKU
		        , SUM(ST.iQty) * -1 AS TotalQty 
		   FROM tblSKUTransaction ST 
		   LEFT JOIN tblDate D ON D.ixDate = ST.ixDate 
		   WHERE D.dtDate BETWEEN DATEADD(yy, -1, GETDATE()) AND GETDATE()
			 and ST.sTransactionType = 'BOM' 
			 and ST.iQty < 0
		   GROUP BY ST.ixSKU) AS BOMUSAGE ON BOMUSAGE.SKU = S.ixSKU 
		   
-- SKU Qty on BO
LEFT JOIN (SELECT OL.ixSKU
                , SUM(OL.iQuantity) AS BOQty 
           FROM tblOrder O
           LEFT JOIN tblOrderLine OL on OL.ixOrder = O.ixOrder
           WHERE O.sOrderStatus = 'Backordered'
           GROUP BY OL.ixSKU
          ) BO on BO.ixSKU = S.ixSKU

-- # of Orders on BO per SKU
LEFT JOIN (SELECT OL.ixSKU
                , COUNT(DISTINCT O.ixOrder) AS OrdersOnBO
                , MIN(O.dtOrderDate) AS OldestBO
           FROM tblOrder O
           JOIN tblOrderLine OL on O.ixOrder = OL.ixOrder
           WHERE O.sOrderStatus = 'Backordered'
           GROUP BY OL.ixSKU
          ) OBO on BO.ixSKU = OBO.ixSKU

-- # of Customers on BO per SKU
LEFT JOIN (SELECT OL.ixSKU
                , COUNT(DISTINCT O.ixCustomer) AS CustsOnBO 
           FROM tblOrder O
           JOIN tblOrderLine OL on O.ixOrder = OL.ixOrder
           WHERE O.sOrderStatus = 'Backordered'
           GROUP BY OL.ixSKU
          ) CBO on CBO.ixSKU = OBO.ixSKU

-- # of Orders on BO per Vendor
LEFT JOIN (SELECT V.ixVendor
                , COUNT(O.ixOrder) AS VendorOrderCount
           FROM tblOrder O
           JOIN tblOrderLine OL on O.ixOrder = OL.ixOrder
           JOIN tblSKU S on S.ixSKU = OL.ixSKU
           JOIN tblSKULocation SL on SL.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS 
				 = S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
				AND SL.ixLocation = '99'
           LEFT JOIN tblVendorSKU VS on VS.ixSKU = OL.ixSKU 
           LEFT JOIN tblVendor V on V.ixVendor = VS.ixVendor
           WHERE O.sOrderStatus = 'Backordered'
             AND VS.iOrdinality = 1 -- Primary Vendor 
             AND VS.ixVendor <> '0009'
             AND S.flgIsKit = 0
             AND SL.iQAV < 0
           GROUP BY V.ixVendor
          ) VOC on VOC.ixVendor = V.ixVendor

-- # of Customers on BO per Vendor
LEFT JOIN (SELECT V.ixVendor
                , COUNT(DISTINCT O.ixCustomer) VendorCustomerCount
           FROM tblOrder O
           JOIN tblOrderLine OL on O.ixOrder = OL.ixOrder
           JOIN tblSKU S on S.ixSKU = OL.ixSKU
           JOIN tblSKULocation SL on SL.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS 
				 = S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
				AND SL.ixLocation = '99'
           LEFT JOIN tblVendorSKU VS on VS.ixSKU = OL.ixSKU 
           LEFT JOIN tblVendor V on V.ixVendor = VS.ixVendor
           WHERE O.sOrderStatus = 'Backordered'
             AND VS.iOrdinality = 1 -- Primary Vendor 
             AND VS.ixVendor <> '0009'
             AND S.flgIsKit = 0
             AND SL.iQAV < 0
           GROUP BY V.ixVendor
          ) VCC on VCC.ixVendor = V.ixVendor

WHERE VS.iOrdinality = 1 -- Primary Vendor
  AND VS.ixVendor <> '0009'
  AND S.flgIsKit = 0
  AND V.ixVendor IN ('5002') -- (@Vendor)
  AND SL.ixLocation = '99'

ORDER BY V.ixVendor, S.ixSKU

