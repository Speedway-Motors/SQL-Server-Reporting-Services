-- to be run each month prior to delivering the VPH to Marketing (CCC & Jesse Cowles)

SELECT max(iYearMonth) FROM tblSnapAdjustedMonthlySKUSalesNEW -- 2018-09-15 00:00:00.000

/************   Checks on TEST SKU 91008051-STR   **********************/
DECLARE @ReportRunDate datetime, @ixSKU varchar(30)

SELECT @ReportRunDate = '09/01/2018', @ixSKU = '91008051-STR'  -- usually the 1st of the current month
       
SELECT ISNULL(SKUSales.iYearMonth,SKUReturns.iYearMonth)           iYearMonth,
    --   ISNULL(SKUSales.ixSKU,SKUReturns.ixSKU)                     ixSKU,
       (ISNULL(SKUSales.NonKCSales,0) - ISNULL(SKUSales.NonKCCost,0)) - ISNULL(SKUReturns.GP,0) AdjNonKCGP_COL_AI,
       (ISNULL(SKUSales.KCSales,0) - ISNULL(SKUSales.KCCost,0)) KCGP_COL_AJ,       
       ISNULL(SKUSales.NonKCQtySold,0) - ISNULL(SKUReturns.QTYCredited,0) AdjNonKCQtySold_COL_AQ,
       ISNULL(SKUSales.KCQtySold,0) KCQtySold_COL_AR
FROM 
       /****** RETURNS *********/  
      (SELECT CMD.ixSKU
            , D.iYearMonth
            , SUM(CMD.iQuantityCredited) QTYCredited
            , SUM(CMD.mExtendedPrice) Sales
            , SUM(CMD.mExtendedCost) Cost
            , (SUM(CMD.mExtendedPrice) - SUM(CMD.mExtendedCost)) GP
       FROM tblCreditMemoDetail CMD
       JOIN tblCreditMemoMaster CMM ON CMM.ixCreditMemo = CMD.ixCreditMemo 
       LEFT JOIN tblDate D ON D.dtDate = CMM.dtCreateDate
       LEFT JOIN vwSKULocalLocation S ON S.ixSKU = CMD.ixSKU 
       WHERE CMM.dtCreateDate >= '01/01/2007' 
         AND CMM.flgCanceled = 0
         AND CMD.ixSKU = @ixSKU
         AND iYearMonth >= DATEADD(mm, DATEDIFF(mm,0,@ReportRunDate)-12, 0)    -- 12 months ago
         AND iYearMonth < @ReportRunDate -- previous month
       GROUP BY CMD.ixSKU
              , D.iYearMonth   
      ) SKUReturns 
FULL JOIN 
        /****** SALES *********/   
      (SELECT OL.ixSKU
            , D.iYearMonth
            , SUM(OL.iQuantity) AS QTYSold
            , SUM(CASE WHEN OL.flgKitComponent = '1' THEN 0 ELSE OL.iQuantity END) AS NonKCQtySold
            , SUM(CASE WHEN OL.flgKitComponent = '0' THEN 0 ELSE OL.iQuantity END) AS KCQtySold                        
            , SUM(CASE WHEN OL.flgKitComponent = '1' THEN 0 ELSE OL.mExtendedPrice END) AS NonKCSales
            , SUM(CASE WHEN OL.flgKitComponent = '0' THEN 0 ELSE S.mPriceLevel1 * OL.iQuantity END) AS KCSales                          
            , SUM(CASE WHEN OL.flgKitComponent = '1' THEN 0 ELSE OL.mExtendedCost END) AS NonKCCost
            , SUM(CASE WHEN OL.flgKitComponent = '0' THEN 0 ELSE OL.mExtendedCost END) AS KCCost
            -- do separate GP Equations on the report side                          
       FROM tblOrder O 
       FULL JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder 
       LEFT JOIN tblDate D ON D.dtDate = OL.dtOrderDate 
       LEFT JOIN vwSKULocalLocation S ON S.ixSKU = OL.ixSKU 
       WHERE O.sOrderChannel <> 'INTERNAL'
         AND OL.flgLineStatus IN ('Shipped','Dropshipped')
         AND OL.ixSKU = @ixSKU
         AND iYearMonth >= DATEADD(mm, DATEDIFF(mm,0,@ReportRunDate)-12, 0)    -- 12 months ago
         AND iYearMonth < @ReportRunDate -- previous month    
       GROUP BY OL.ixSKU
              , D.iYearMonth
      ) SKUSales ON SKUSales.iYearMonth = SKUReturns.iYearMonth 
                AND SKUSales.ixSKU = SKUReturns.ixSKU            
ORDER BY iYearMonth DESC     



/***********************************************************************************************************************************    
*****   Starting Nov 2017 RESULTS SHOULD NOW BE PASTED INTO VPH "Monthly Validation Checks.xlsb" located in the DOCUMENTS folder
************************************************************************************************************************************/


/*********************************************************************************/
 -- Checks on "Current 12 month Sales non-kit comp ($)" (col Z) for the grand total row

DECLARE @ReportRunDate datetime 

SELECT @ReportRunDate = '09/01/2018' -- usually the 1st of the current month

SELECT ISNULL(SKUSales.iYearMonth,SKUReturns.iYearMonth)           iYearMonth,
       ISNULL(SKUSales.NonKCSales,0) - ISNULL(SKUReturns.Sales,0)  AdjustedNonKCSales_COLAA
FROM 
       /****** RETURNS *********/  
      (SELECT D.iYearMonth
            , SUM(CMD.mExtendedPrice) Sales
       FROM tblCreditMemoDetail CMD
       JOIN tblCreditMemoMaster CMM ON CMM.ixCreditMemo = CMD.ixCreditMemo 
       LEFT JOIN tblDate D ON D.dtDate = CMM.dtCreateDate
       LEFT JOIN vwSKULocalLocation S ON S.ixSKU = CMD.ixSKU 
       WHERE CMM.dtCreateDate >= '01/01/2007' 
         AND CMM.flgCanceled = 0
         AND iYearMonth >= DATEADD(mm, DATEDIFF(mm,0,@ReportRunDate)-12, 0)    -- 12 months ago
         AND iYearMonth < @ReportRunDate -- previous month
       GROUP BY D.iYearMonth   
      ) SKUReturns 
FULL JOIN 
      /****** SALES *********/   
      (SELECT D.iYearMonth
            , SUM(CASE WHEN OL.flgKitComponent = '1' THEN 0 
                       ELSE OL.mExtendedPrice
                  END) AS NonKCSales
      FROM tblOrder O 
       FULL JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder 
       LEFT JOIN tblDate D ON D.dtDate = OL.dtOrderDate 
       LEFT JOIN vwSKULocalLocation S ON S.ixSKU = OL.ixSKU 
       WHERE O.sOrderChannel <> 'INTERNAL'
         AND OL.flgLineStatus IN ('Shipped','Dropshipped')
         AND iYearMonth >= DATEADD(mm, DATEDIFF(mm,0,@ReportRunDate)-12, 0)    -- 12 months ago
         AND iYearMonth < @ReportRunDate -- previous month    
       GROUP BY D.iYearMonth
      ) SKUSales ON SKUSales.iYearMonth = SKUReturns.iYearMonth                       
ORDER BY iYearMonth DESC  
/* 
 Total          $114,853,690 Col AA on VPH pt1 <-- LOOK for totals row on SECOND TAB of 1st xlsb file!
 FROM query         $661,663 Col AA on VPH pt2  DELTA
 ============   =============================   =====
 $115,459,436   $115,515,353 combo VPH          0.05%   <-- Delta's should always be <= 1% !!!
 

Rpt      Current 12 month
Run      Sales non-kit
Date     comp ($) (col AA both combined sheets) 
======   =================
09/01/17 $115,556,805
08/01/17 $114,500,264
07/01/17 $113,027,393
04/01/17 $112,337,736
01/01/17 $110,682,720

12/01/16 $110,746,154
07/01/16 $108,695,690
05/01/16 $106,453,547  

12/01/15 $101,027,710
10/12/15  $99,645,978
07/30/15  $97,486,940 **report failed multiple times which delayed processing
04/13/15  $95,539,634
02/03/15  $94,317,701

12/02/14  $93,145,984
10/03/14  $92,664,220
07/03/14  $91,123,781

*/
