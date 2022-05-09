-- SMIHD-9695 - Dynatech sales by account report

/******** requested by Jeff Scales
 sku, 
 sku description, 
 net qty by sku, 
 net revenue, 
 net margin, 
 customer account #, 
 customer name
 
 for X time period—a couple of years would be good. 
 If you can build the flat table, we should be able to generate what we need via pivot table.
***********/

/********* QUESTIONS
	Report with some similar data that can be used to verify totals.... Executive Dashboards > PGC Sales by Customer.rdl     CUST 10701 is a good example
			
			
 EXCLUSIONS:
	any Order Types, Customer Types, Specific Accounts?
		JEFF said no exclusions for now... they can remove manually if needed
***********/

DECLARE @StartDate datetime,        @EndDate datetime
SELECT  @StartDate = '01/01/16',    @EndDate = '12/31/17'  
-- NEW REPORT QUERY
SELECT 	DS.ixPGC 'PGC', -- 13,109
	SUBSTRING(DS.ixPGC, 1, 1) 'PGCMajor', 
	SUBSTRING(DS.ixPGC, 2, 1) 'PGCMinor',
	O.ixCustomer 'CustNum',
	C.sCustomerFirstName 'CustFirstName',
	C.sCustomerLastName 'CustLastName',
	O.dtShippedDate 'Shipped/Return Date',
	DS.ixSKU 'SKU', 
	DS.sDescription 'Description',
	OL.iQuantity 'GrossQtySold',
	OL.mExtendedPrice 'GrossRevenue',
	OL.mExtendedCost 'GrossCost',
	(OL.mExtendedPrice-OL.mExtendedCost) 'GrossMargin',
    NULL 'GM%',-- GM$ = GP/GrossRev       CAN'T ACTUALLY CALC BECAUSE OF DIV BY 0
	0 as 'ReturnQty',
	0 as 'ReturnDollars'

	/**** RETURNS
			WHAT LOGIC SHOULD BE APPLIED HERE? 
			Can only apply CMs that list specific SKU credits in tblCreditMemoDetail
			must be a FULL OUTER JOIN to sales (e.g. Customer 123 may have ordered 300 of SKU A, and 0 of SKU B but could have returned 50 of SKU B dufing the same date range)
	*******/
	-- (GrossMargin-Returns) 'NetRevenue'     (OL.mExtendedPrice-OL.mExtendedCost) - Returns
FROM [AFCOTemp].dbo.vwDynatechSKUs DS -- Dynatech SKUs
	left join tblOrderLine OL on OL.ixSKU = DS.ixSKU
	left join tblOrder O on O.ixOrder = OL.ixOrder
	left join tblCustomer C on O.ixCustomer = C.ixCustomer

	--left join tblSKU S on S.ixSKU = DS.ixSKU
WHERE O.dtShippedDate  between @StartDate and @EndDate -- verify date should be SHIPPED date 
	AND OL.flgLineStatus = 'Shipped' 
-- AND O.ixCustomer = 10701 TESTING ONLY


UNION ALL
					-- RETURNS
                     select DS.ixPGC 'PGC',						-- 827
						SUBSTRING(DS.ixPGC, 1, 1) 'PGCMajor', 
						SUBSTRING(DS.ixPGC, 2, 1) 'PGCMinor',
					  	CMM.ixCustomer 'CustNum',
						C.sCustomerFirstName 'CustFirstName',
						C.sCustomerLastName 'CustLastName',
						CMM.dtCreateDate as 'Shipped/Return Date',
						DS.ixSKU 'SKU', 
						DS.sDescription 'Description',
						0 as 'GrossQtySold',
						0 as 'GrossRevenue',
						0 as 'GrossCost',
						0 as 'GrossMargin',
						0 as 'GM%',
                        CMD.iQuantityCredited 'ReturnQty',
                        (CMD.iQuantityCredited*CMD.mUnitPrice) 'ReturnDollars'

                    from tblCreditMemoDetail CMD
						JOIN [AFCOTemp].dbo.vwDynatechSKUs DS ON CMD.ixSKU = DS.ixSKU
                        join tblCreditMemoMaster CMM on CMM.ixCreditMemo = CMD.ixCreditMemo 
                        left join tblDate D on D.dtDate = CMM.dtCreateDate
                        left join tblSKU S on S.ixSKU = CMD.ixSKU 
						left join tblCustomer C on CMM.ixCustomer = C.ixCustomer
                    where     CMM.dtCreateDate  between @StartDate and @EndDate
                           -- and CMM.ixCustomer = @Customer
                            and CMM.flgCanceled = 0
						-- AND CMM.ixCustomer = 10701 TESTING ONLY
					ORDER BY 'CustNum', DS.ixPGC, DS.ixSKU



/*******************************************************************
-- CODE FROM AFCO > Executive Dashboards > PGC Sales by Customer.rdl
 *******************************************************************/
SELECT
    QualifyingSKUS.ixSKU    SKU,
    QualifyingSKUS.ixPGC,
    QualifyingSKUS.MajorSC,
    QualifyingSKUS.MinorSC,
    Performance.YTDQTYSold,
    Performance.YTDSales,
    Performance.YTDCost,
    Performance.YTDGP,
    Performance.YR2QTYSold,
    Performance.YR2Sales,
    Performance.YR2Cost, 
    Performance.YR2GP
FROM
    (SELECT
        distinct(OL.ixSKU),
        SKU.ixPGC,
        SUBSTRING(SKU.ixPGC,1,1) MajorSC,
        SUBSTRING(SKU.ixPGC,2,1) MinorSC
    FROM tblOrderLine OL 
              join tblOrder O on OL.ixOrder = O.ixOrder
        left join tblSKU SKU on SKU.ixSKU = OL.ixSKU
        left join tblPGC PGC on PGC.ixPGC = SKU.ixPGC
    WHERE 
            OL.flgLineStatus = 'Shipped'
        and OL.dtShippedDate >= DATEADD(yy, -1,@StartDate) 	--	1 year prior to Start Date
        and OL.dtShippedDate < (@EndDate+1)
       and O.ixCustomer = @Customer
    ) QualifyingSKUS

full outer join (
    SELECT
        isnull(YTD.ixSKU,YR2.ixSKU) ixSKU,                -- Our Part Number
        /*********** section 2 TY_YTD & LY_YTD SUMMARY **********/
        isnull(YTD.QTYSold,0)   YTDQTYSold,
        isnull(YTD.Sales,0)     YTDSales,
        isnull(YTD.Cost,0)      YTDCost,
        isnull(YTD.GP,0)        YTDGP,
        isnull(YR2.QTYSold,0)   YR2QTYSold,
        isnull(YR2.Sales,0)     YR2Sales,
        isnull(YR2.Cost,0)      YR2Cost, 
        isnull(YR2.GP,0)        YR2GP
    FROM 
             /****** YTD SALES-RETURNS *********/ 
               (SELECT
                    isnull(SKUSales.ixSKU,SKUReturns.ixSKU)                     ixSKU,              
                    isnull(SKUSales.QTYSold,0)-isnull(SKUReturns.QTYCredited,0) QTYSold,
                    isnull(SKUSales.Sales,0)-isnull(SKUReturns.Sales,0)         Sales,
                    isnull(SKUSales.Cost,0) -isnull(SKUReturns.Cost,0)          Cost,
                    isnull(SKUSales.GP,0)-isnull(SKUReturns.GP,0)               GP
                FROM 
                    /****** RETURNS *********/  
                    (select CMD.ixSKU,
                          SUM(CMD.iQuantityCredited) QTYCredited,
                          SUM(CMD.iQuantityCredited*CMD.mUnitPrice) Sales,
                          SUM(CMD.iQuantityCredited*CMD.mUnitCost) Cost,
                          SUM((CMD.mUnitPrice-CMD.mUnitCost)*CMD.iQuantityCredited) GP
                    from tblCreditMemoDetail CMD
                        join tblCreditMemoMaster CMM on CMM.ixCreditMemo = CMD.ixCreditMemo 
                        left join tblDate D on D.dtDate = CMM.dtCreateDate
                        left join tblSKU S on S.ixSKU = CMD.ixSKU 
                    where     CMM.dtCreateDate >= @StartDate
                            and CMM.dtCreateDate < (@EndDate+1)
                            and CMM.ixCustomer = @Customer
                            and CMM.flgCanceled = 0
                    group by CMD.ixSKU
                    ) SKUReturns 
                full outer join
                     /****** SALES *********/   
                    (select OL.ixSKU,
                            SUM(OL.iQuantity) QTYSold,
                            SUM(OL.iQuantity*CAST(OL.mUnitPrice as Money)) Sales,
                            SUM(OL.mExtendedCost) Cost,
                            SUM((OL.mUnitPrice-OL.mCost)* CAST(OL.iQuantity as Money)) GP
                     from tblOrder O 
                        join tblOrderLine OL on OL.ixOrder = O.ixOrder 
                        left join tblDate D on D.dtDate = OL.dtShippedDate
                        left join tblSKU S on S.ixSKU = OL.ixSKU 
                     where OL.flgLineStatus = 'Shipped' 
                                and OL.dtShippedDate >= @StartDate
                                and OL.dtShippedDate < (@EndDate+1)
                                and flgKitComponent = 0
                                and O.ixCustomer = @Customer
                     -- per Laurie, INCLUDE internal orders
                     group by OL.ixSKU
                    ) SKUSales on SKUSales.ixSKU = SKUReturns.ixSKU
                      ) YTD 
            /****** YR2 (last year YTD) SALES-RETURNS *********/ 
            full outer join (SELECT
                        isnull(SKUSales.ixSKU,SKUReturns.ixSKU)                     ixSKU,              
                        isnull(SKUSales.QTYSold,0)-isnull(SKUReturns.QTYCredited,0) QTYSold,
                        isnull(SKUSales.Sales,0)-isnull(SKUReturns.Sales,0)         Sales,
                        isnull(SKUSales.Cost,0) -isnull(SKUReturns.Cost,0)          Cost,
                        isnull(SKUSales.GP,0)-isnull(SKUReturns.GP,0)               GP
                        FROM 
                    /****** RETURNS *********/  
                        (select CMD.ixSKU,
                              SUM(CMD.iQuantityCredited) QTYCredited,
                              SUM(CMD.iQuantityCredited*CMD.mUnitPrice) Sales,
                              SUM(CMD.iQuantityCredited*CMD.mUnitCost) Cost,
                              SUM((CMD.mUnitPrice-CMD.mUnitCost)*CMD.iQuantityCredited) GP
                        from tblCreditMemoDetail CMD
                            join tblCreditMemoMaster CMM on CMM.ixCreditMemo = CMD.ixCreditMemo 
                            left join tblDate D on D.dtDate = CMM.dtCreateDate
                            left join tblSKU S on S.ixSKU = CMD.ixSKU 
                       where      CMM.dtCreateDate >= '01/01/2017' --DATEADD(yy, -1,@StartDate) 	--	1 year prior to Start Date
                                and CMM.dtCreateDate < '12/31/2017'-- DATEADD(yy, -1,(@EndDate+1)) 	--	1 year prior to End Date
                              and CMM.ixCustomer = '10701' --@Customer
                        group by CMD.ixSKU
                        ) SKUReturns 
                     full join
                     /****** SALES *********/   
                        (select OL.ixSKU,
                                SUM(OL.iQuantity) QTYSold,
                                SUM(OL.iQuantity*CAST(OL.mUnitPrice as Money)) Sales,
                                SUM(OL.mExtendedCost) Cost,
                                SUM((OL.mUnitPrice-OL.mCost)* CAST(OL.iQuantity as Money)) GP
                         from tblOrder O 
                            join tblOrderLine OL on OL.ixOrder = O.ixOrder 
                            left join tblDate D on D.dtDate = OL.dtShippedDate 
                            left join tblSKU S on S.ixSKU = OL.ixSKU 
                         -- per Laurie, INCLUDE internal orders
                         where        OL.flgLineStatus = 'Shipped' 
                                    and O.ixCustomer = @Customer
                                    and OL.dtShippedDate >= DATEADD(yy, -1,@StartDate) 	--	1 year prior to Start Date
                                    and OL.dtShippedDate < DATEADD(yy, -1,(@EndDate+1)) 	--	1 year prior to End Date
                                    and flgKitComponent = 0
                         group by OL.ixSKU
                        ) SKUSales on SKUSales.ixSKU = SKUReturns.ixSKU

                      ) YR2 on YR2.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = YTD.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS

    ) Performance on Performance.ixSKU = QualifyingSKUS.ixSKU