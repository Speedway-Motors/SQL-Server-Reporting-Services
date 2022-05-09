-- SMIHD-22181 - SMI version of Open Purchase Orders report

/* Open Purchase Orders.rdl
    ver 21.32.1

-- NOTE: This report is currently set to hide the detail row (within report 
--builder to hide if Qty Outstanding <= 0. For whatever reason when 
--this was added to the SQL it was not reflecting so in the report. 
*/
DECLARE @StartDate datetime,        @EndDate datetime,      @DOMESTIC tinyint     
        -- Date Range based on POD.ixExpectedDeliveryDate 
        -- DOMESTIC BASED ON tblSKU.flgOverseas (0 = DOMESTIC    1 = OVERSEAS)
SELECT  @StartDate = '11/13/21',    @EndDate = '12/12/21',  @DOMESTIC = 0



SELECT POM.ixPO AS PONumber --(1,294 rows) 
     , POM.ixVendor AS VendorNumber
     , POM.ixBuyer AS Buyer
     , POD.ixSKU AS Items
     , VS.sVendorSKU 'VendorSKU'
     , D4.dtDate AS 'PONotifyDate'
     , D.dtDate AS dtPODate
     , POD.iQuantity AS QtyOnOrder
     , ISNULL(QA.QtyInQA, 0) AS QtyInQA
     , POD.iQuantityPosted AS QtyReceived 
     , ISNULL(POD.iQuantity, 0) - ISNULL(POD.iQuantityPosted, 0) AS QtyOutstanding
     , D2.dtDate 'dtDeliveryDate'
     , POD.mCost AS Cost
     , POD.mCost * POD.iQuantity AS ExtendedCost 
     , D3.dtDate AS dtConfirmedDate 
     , POM.ixVendorConfirmEmployee AS ConfirmedBy
     , POM.sNotes AS Notes
     , sMessage1
     , sMessage2
     , sMessage3
     , V.sName as 'VendorName'
     , V.sCountry as 'VendorCountry'
     , (CASE WHEN V.flgOverseas = 1 THEN 'N'
            ELSE 'Y'
            END) 'Domestic'
     , S.sCountryOfOrigin 'SKUCountryOfOrigin'
     , S.ixPGC
     , S.ixABCCode 'ABCCode'
     , S.sCycleCode
    , S.ixHarmonizedTariffCode
FROM tblPOMaster POM 
    JOIN tblPODetail POD ON POD.ixPO = POM.ixPO 
    LEFT JOIN tblDate D ON D.ixDate = POM.ixPODate 
    LEFT JOIN tblDate D2 ON D2.ixDate = POD.ixExpectedDeliveryDate 
    LEFT JOIN tblDate D3 ON D3.ixDate = POM.ixVendorConfirmDate
    LEFT JOIN tblDate D4 ON D4.ixDate = POM.ixNotifyDate
    LEFT JOIN tblVendorSKU VS on POD.ixSKU = VS.ixSKU and VS.ixVendor = POM.ixVendor
    LEFT JOIN tblVendor V on V.ixVendor = VS.ixVendor 
    LEFT JOIN tblSKU S on S.ixSKU = POD.ixSKU
    LEFT JOIN tblSKULocation SL on SL.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
                                 and SL.ixLocation = 99
    LEFT JOIN (-- Qty in QA
                SELECT BS.ixSKU, SUM(iSKUQuantity) 'QtyInQA'
                FROM tblBin B
                    left join tblBinSku BS on BS.ixBin = B.ixBin
                WHERE BS.ixLocation = 99
                    and B.ixLocation = 99
                    and B.sBinType = 'QA'
                GROUP BY BS.ixSKU
              ) QA on S.ixSKU = QA.ixSKU
WHERE flgOpen = '1'
  AND (ISNULL(POD.iQuantity, 0) - ISNULL(POD.iQuantityPosted, 0)) > '0'
 -- AND POD.iQuantity > 0 --?? why would this be 
  AND S.flgDeletedFromSOP = 0
  AND V.flgOverseas in (@DOMESTIC)
  AND D2.dtDate between @StartDate and @EndDate -- expected delivery date
ORDER BY QtyOutstanding, dtDeliveryDate


/* POs with open qty that are past due

SELECT distinct POM.ixVendor 'Vendor', 
    (CASE WHEN V.flgOverseas = 1 then 'Overseas'
        ELSE 'Domestic'
        END) 'VendorType'
    , POM.ixPO, POD.ixSKU 'SKU', D.dtDate 'ExpDate', 
    POD.iQuantity 'QtyOrdered', POD.iQuantityPosted 'QtyPosted', 
    --(POD.iQuantity-POD.iQuantityPosted) 'OpenQty',
    --POD.mCost 'UnitCost',
    ((POD.iQuantity-POD.iQuantityPosted) * POD.mCost) 'ExtCost'
     --, POD.ixExpectedDeliveryDate -- 2,875 POs with 3,300 expected dates
-- into #PASTDUEPOS -- DROP TABLE #PASTDUEPOS
FROM tblPOMaster POM                                 -- 1,396 late  
    JOIN tblPODetail POD ON POD.ixPO = POM.ixPO
    LEFT JOIN tblDate D on POD.ixExpectedDeliveryDate = D.ixDate
    left join tblVendor V on POM.ixVendor = V.ixVendor
WHERE flgOpen = '1'
  AND (ISNULL(POD.iQuantity, 0) - ISNULL(POD.iQuantityPosted, 0)) > '0'
  AND POD.ixExpectedDeliveryDate < 19582
order by D.dtDate, ixPO, ixSKU
 -- AND POD.iQuantity > 0 --?? why would this be 

 SELECT COUNT(distinct ixPO) -- 1,239 POs are past due
 from #PASTDUEPOS

 select * from tblSKU
 where ixSKU = '91008589'
*/