-- SMIHD-3437 - EMI initial Labor Cost analysis

/*
SELECT ixDate, CONVERT(VARCHAR, dtDate, 101) AS 'FirstDayofPeriod',iPeriod
--,iDayOfFiscalPeriod
from tblDate
where iPeriodYear in (2015,2016)
    and iDayOfFiscalPeriod = 1
    and dtDate < '03/10/2016'
ORDER BY ixDate

ixDate	Date	    iPeriod	iDayOfFiscalPeriod
17170	01/03/2015	1	    1
17198	01/31/2015	2	    1
17233	03/07/2015	3	    1
17261	04/04/2015	4	    1
17289	05/02/2015	5	    1
17324	06/06/2015	6	    1
17352	07/04/2015	7	    1
17380	08/01/2015	8	    1
17415	09/05/2015	9	    1
17443	10/03/2015	10	    1
17471	10/31/2015	11	    1
17506	12/05/2015	12	    1
17534	01/02/2016	1	    1
17562	01/30/2016	2	    1
17597	03/05/2016	3	    1
*/

DECLARE
    @StartShipDate datetime,
    @EndShipDate datetime
SELECT
    @StartShipDate = '04/30/2016', -- P5 date range is 04.30.16 – 06.03.16
    @EndShipDate = '06/03/2016'  
   

SELECT SKU.ixSKU AS 'FinishedSKU'
    , SKU.sDescription AS 'Description'
    , PGC.ixPGC AS 'PGC'      
    , SKU.mPriceLevel1 AS 'PriceLevel1'     
    , (CASE WHEN BOM.ixSKU IS NULL THEN 'N' -- all of them are finished SKUs
            ELSE 'Y'
      END) AS 'BOMCompnt'
    , isnull(SALES.Sales,0) as 'Sales'
    , isnull(SALES.QtySold,0) as QtySold
    , ELC.mTotLaborCost 'EMILaborCost'
    , ELC.mTotMatCost 'EMIMaterialCost' 
    , isnull(SALES.QtySold,0)* isnull(ELC.mTotLaborCost,0) AS 'ExtEMILaborCost'
    , isnull(SALES.QtySold,0)* isnull(ELC.mTotMatCost,0) AS 'ExtEMIMaterialCost'    
    --, isnull(BOMYTD.QTY,0) as 'BOMQty'      
    --, isnull(BOMYTD.QTY,0)+isnull(SALES.QtySold,0) 'SoldAndBOMQty'    
FROM tblSKU SKU
    JOIN vwEagleBOMs ELC ON SKU.ixSKU = ELC.ixFinishedSKU
    -- JOIN SMITemp.dbo.PJC_SMIHD_3437_EMILaborCosts ELC ON SKU.ixSKU = ELC.ixFinishedSKU
    LEFT JOIN tblPGC PGC ON PGC.ixPGC = SKU.ixPGC
    LEFT JOIN (SELECT OL.ixSKU, SUM(OL.iQuantity) QtySold, SUM(OL.mExtendedPrice) Sales
               FROM tblOrderLine OL
                    JOIN tblOrder O on OL.ixOrder = O.ixOrder
               WHERE O.dtShippedDate between @StartShipDate and @EndShipDate --'01/03/2015' and '01/30/2015'
                  and O.sOrderStatus = 'Shipped'
                  and OL.flgLineStatus IN ('Shipped','Dropshipped')
                --and O.sOrderType <> 'Internal'   -- USUALLY filtered
		       GROUP BY OL.ixSKU
		      ) SALES ON SALES.ixSKU = SKU.ixSKU
    LEFT JOIN (-- BOM Components
                SELECT DISTINCT (ixSKU)
               FROM tblBOMTemplateDetail
              ) BOM ON BOM.ixSKU = SKU.ixSKU		  
    /*		  
    LEFT JOIN (SELECT BOMTD.ixSKU
                    , SUM(CAST(BOMTD.iQuantity AS INT)* CAST(BOMTM.iCompletedQuantity AS INT)) AS QTY 
               FROM tblBOMTransferMaster BOMTM 
               JOIN tblBOMTransferDetail BOMTD ON BOMTD.ixTransferNumber = BOMTM.ixTransferNumber
               WHERE BOMTM.ixCreateDate between 17168 and 17592 -- '01/01/2015' and '02/29/2016'
               GROUP BY BOMTD.ixSKU
              ) BOMYTD ON BOMYTD.ixSKU = SALES.ixSKU
    */          
WHERE isnull(SALES.QtySold,0) <> 0
ORDER BY FinishedSKU



SELECT * from vwEagleBOMs -- noon 

SELECT * FROM tblBOMTemplateMaster
where mEMITotalLaborCost+mEMITotalMaterialCost > 0  -- 392
ORDER BY dtDateLastSOPUpdate

SELECT * FROM SMITemp.dbo.PJC_SMIHD_3437_EMILaborCosts -- 284



-- SUMMARY by period
    DECLARE
        @StartShipDate datetime,
        @EndShipDate datetime
    SELECT
        @StartShipDate = '03/05/2016',
        @EndShipDate = '04/01/2016'  
        
    SELECT D.iPeriodYear 'Year', D.iPeriod 'Period',
           SUM(OL.mExtendedPrice) Sales,
         --  SUM(OL.iQuantity) QtySold, 
           SUM(isnull(OL.iQuantity,0)* isnull(ELC.mTotLaborCost,0)) AS 'ExtEMILaborCost',
           SUM(isnull(OL.iQuantity,0)* isnull(ELC.mTotMatCost,0)) AS 'ExtEMIMaterialCost'  
   FROM tblOrderLine OL
        JOIN tblOrder O on OL.ixOrder = O.ixOrder
        JOIN SMITemp.dbo.PJC_SMIHD_3437_EMILaborCosts ELC ON OL.ixSKU = ELC.ixFinishedSKU
        LEFT JOIN tblDate D on O.ixShippedDate = D.ixDate
        
   WHERE O.dtShippedDate between @StartShipDate and @EndShipDate --'01/03/2015' and '01/30/2015'
      and O.sOrderStatus = 'Shipped'
      and OL.flgLineStatus IN ('Shipped','Dropshipped')
    --and O.sOrderType <> 'Internal'   -- USUALLY filtered
   GROUP BY D.iPeriodYear, D.iPeriod
   ORDER BY D.iPeriodYear DESC, D.iPeriod DESC





SELECT * 
FROM SMITemp.dbo.PJC_SMIHD_3437_EMILaborCosts
WHERE ixFinishedSKU in (SELECT ixSKU from tblSKU)

SELECT *
into SMITemp.dbo.PJC_SMIHD_3437_EMILaborCosts_20160407
from SMITemp.dbo.PJC_SMIHD_3437_EMILaborCosts

SELECT * FROM SMITemp.dbo.PJC_SMIHD_3437_EMILaborCosts_20160301
WHERE ixFinishedSKU NOT IN (SELECT ixFinishedSKU from SMITemp.dbo.PJC_SMIHD_3437_EMILaborCosts)

-- TRUNCATE TABLE SMITemp.dbo.PJC_SMIHD_3437_EMILaborCosts
ixFinishedSKU	mTotLaborCost	mTotMatCost
97617702	8.71	3.249

SELECT * from tblBOMTemplateMaster
where ixFinishedSKU = '96622930'

SELECT * FROM SMITemp.dbo.PJC_SMIHD_3437_EMILaborCosts_20160301
SELECT * FROM  SMITemp.dbo.PJC_SMIHD_3437_EMILaborCosts_20160324
SELECT * FROM  SMITemp.dbo.PJC_SMIHD_3437_EMILaborCosts_20160407

-- DIF between current data set and previous
SELECT *, 
(B.mTotLaborCost-A.mTotLaborCost) 'LaborCostChange',
(B.mTotMatCost-A.mTotMatCost) 'MatCostChange'
FROM  SMITemp.dbo.PJC_SMIHD_3437_EMILaborCosts_20160324 A
FULL OUTER JOIN SMITemp.dbo.PJC_SMIHD_3437_EMILaborCosts_20160407 B on A.ixFinishedSKU = B.ixFinishedSKU
WHERE (A.ixFinishedSKU is NULL or B.ixFinishedSKU is NULL) -- SKU is missing from either table
    OR A.mTotLaborCost <> B.mTotLaborCost
    OR A.mTotMatCost <> B.mTotMatCost
ORDER BY B.ixFinishedSKU

SELECT * from [SMI Reporting].dbo.tblSKU 
where ixSKU in ('9652124','97010072','9708001','97052090')

