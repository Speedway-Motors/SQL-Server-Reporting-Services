-- DSOTHER-17 Identify all join fields that need to cleaned to prep for data cubes

-- tblBin
        select * from tblBin where sAisle is NULL
        GO
        select sAisle, count(*) 'Count'
        from tblBin group by sAisle order by 'Count' desc

        select COUNT(*) 'Qty',
                (Case when dtDateLastSOPUpdate IS null then 'NULL'
                else 'Have Update Dates'
                end
                ) 'dtDateLastSOPUpdate'
        from tblBin
        group by (Case when dtDateLastSOPUpdate IS null then 'NULL'
                else 'Have Update Dates'
                end
                )


-- tblBinSku
        select * from tblBinSku where ixSKU is NULL
        GO
        select ixSKU, count(*) 'Count'
        from tblBinSku group by ixSKU order by 'Count' desc

        select ixSKU from tblBinSku where ixSKU NOT IN (select ixSKU from tblSKU)

        select * from tblBinSku where sPickingBin is NULL
        GO
        select sPickingBin, count(*) 'Count'
        from tblBinSku group by sPickingBin order by 'Count' desc




        select COUNT(*) 'Qty',
                (Case when ixTimeLastSOPUpdate IS null then 'NULL'
                else 'Have Update Dates'
                end
                ) 'dtDateLastSOPUpdate'
        from tblBinSku
        group by (Case when ixTimeLastSOPUpdate IS null then 'NULL'
                else 'Have Update Dates'
                end
                )
        
-- tblBOMSequence        
select count(*) from tblBOMSequence where sLaborType is NULL --  1
select count(*) from tblBOMSequence where sDepartment is NULL --  6
select count(*) from tblBOMSequence where sResource is NULL --  2
select count(*) from tblBOMSequence where sOperation is NULL --  2


SELECT max(dtDateLastSOPUpdate) maxUpdate
from tblBOMTemplateMaster


select distinct sResource from tblBOMSequence

select sOperation, count(*)
from tblBOMSequence
group by sOperation
        
        select COUNT(*) 'Qty',
                (Case when ixTimeLastSOPUpdate IS null then 'NULL'
                else 'Have Update Dates'
                end
                ) 'dtDateLastSOPUpdate'
        from tblBOMSequence
        group by (Case when ixTimeLastSOPUpdate IS null then 'NULL'
                else 'Have Update Dates'
                end
                )        
        
-- tblBOMTemplateDetail     
    select count(*) from tblBOMTemplateDetail where ixFinishedSKU is NULL -- 
    select count(*) from tblBOMTemplateDetail where ixSKU is NULL -- 
    select count(*) from tblBOMTemplateDetail where iQuantity is NULL -- 
    select count(*) from tblBOMTemplateDetail where dtDateLastSOPUpdate is NULL -- 
    select count(*) from tblBOMTemplateDetail where ixTimeLastSOPUpdate is NULL -- 
    select count(*) from tblBOMTemplateDetail where flgDeletedFromSOP is NULL -- 


select * from tblBOMTemplateDetail
        select COUNT(*) 'Qty',
                (Case when ixTimeLastSOPUpdate IS null then 'NULL'
                else 'Have Update Dates'
                end
                ) 'dtDateLastSOPUpdate'
        from tblBOMTemplateDetail
        group by (Case when ixTimeLastSOPUpdate IS null then 'NULL'
                else 'Have Update Dates'
                end
                )    

-- tblBOMTemplateMaster     
    select count(*) from tblBOMTemplateMaster where ixFinishedSKU is NULL -- 0
    select count(*) from tblBOMTemplateMaster where ixCreateDate is NULL -- 625
    select count(*) from tblBOMTemplateMaster where ixCreateUser is NULL -- 624
    select count(*) from tblBOMTemplateMaster where ixUpdateDate is NULL -- 3043
    select count(*) from tblBOMTemplateMaster where ixUpdateUser is NULL -- 3043
    select count(*) from tblBOMTemplateMaster where iFactor is NULL -- 0
    select count(*) from tblBOMTemplateMaster where dtDateLastSOPUpdate is NULL -- 94
    select count(*) from tblBOMTemplateMaster where ixTimeLastSOPUpdate is NULL -- 94
    select count(*) from tblBOMTemplateMaster where flgDeletedFromSOP is NULL -- 0
            

        select COUNT(*) 'Qty',
                (Case when ixTimeLastSOPUpdate IS null then 'NULL'
                else 'Have Update Dates'
                end
                ) 'dtDateLastSOPUpdate'
        from tblBOMTemplateMaster
        group by (Case when ixTimeLastSOPUpdate IS null then 'NULL'
                else 'Have Update Dates'
                end
                )    

    select distinct iFactor from tblBOMTemplateMaster

-- tblBOMTransferDetail     
    select count(*) from tblBOMTransferDetail where ixTransferNumber is NULL -- 0
    select count(*) from tblBOMTransferDetail where ixSKU is NULL -- 0
    select count(*) from tblBOMTransferDetail where iQuantity is NULL -- 0
    select count(*) from tblBOMTransferDetail where dtDateLastSOPUpdate is NULL -- 0
    select count(*) from tblBOMTransferDetail where ixTimeLastSOPUpdate is NULL -- 0              

-- tblBOMTransferMaster  
    select count(*) from tblBOMTransferMaster where ixTransferNumber is NULL -- 0
    select count(*) from tblBOMTransferMaster where ixFinishedSKU is NULL -- 0
    select count(*) from tblBOMTransferMaster where iQuantity is NULL -- 0
    select count(*) from tblBOMTransferMaster where iCompletedQuantity is NULL -- 0
    select count(*) from tblBOMTransferMaster where flgReverseBOM is NULL -- 0
    select count(*) from tblBOMTransferMaster where ixCreateDate is NULL -- 0
    select count(*) from tblBOMTransferMaster where ixDueDate is NULL -- 0
    select count(*) from tblBOMTransferMaster where dtCanceledDate is NULL -- 40630
    select count(*) from tblBOMTransferMaster where flgClosed is NULL -- 0
    select count(*) from tblBOMTransferMaster where iOpenQuantity is NULL -- 0
    select count(*) from tblBOMTransferMaster where dtDateLastSOPUpdate is NULL -- 0
    select count(*) from tblBOMTransferMaster where ixTimeLastSOPUpdate is NULL -- 0
              
-- tblBrand
    select count(*) from tblBrand where ixBrand is NULL -- 
    select count(*) from tblBrand where sBrandDescription is NULL -- 
    select count(*) from tblBrand where dtDateLastSOPUpdate is NULL -- 
    select count(*) from tblBrand where ixTimeLastSOPUpdate is NULL -- 
    select count(*) from tblBrand where flgDeletedFromSOP is NULL --                 



-- tblCanadianProvince
    select count(*) from tblCanadianProvince where ixProvince is NULL
    select count(*) from tblCanadianProvince where sDescription is NULL  


-- tblCard
    select count(*) from tblCard where ixCard is NULL
    select count(*) from tblCard where ixCardUser is NULL  
    select count(*) from tblCard where ixCardScanNum is NULL  
    select count(*) from tblCard where sPrintedCardNum is NULL  
    select count(*) from tblCard where flgActive is NULL  
    
    select count(*) from tblCard where iActivationDate is NULL
    select count(*) from tblCard where iDeactivationDate is NULL  

-- tblCardUser
    select count(*) from tblCardUser where ixCardUser is NULL
    select count(*) from tblCardUser where ixEmployee is NULL  
    select count(*) from tblCardUser where sFirstName is NULL  
    select count(*) from tblCardUser where sLastName is NULL  
    select count(*) from tblCardUser where sExtraInfo is NULL 
    
-- tblCatalogDetail
    select count(*) from tblCatalogDetail where ixCatalog is NULL
    select count(*) from tblCatalogDetail where ixSKU is NULL  
    select count(*) from tblCatalogDetail where mPriceLevel1 is NULL  
    select count(*) from tblCatalogDetail where mPriceLevel2 is NULL  
    select count(*) from tblCatalogDetail where mPriceLevel3 is NULL  
    
    select count(*) from tblCatalogDetail where mPriceLevel4 is NULL
    select count(*) from tblCatalogDetail where mPriceLevel5 is NULL  
    select count(*) from tblCatalogDetail where i1stPage is NULL  
    select count(*) from tblCatalogDetail where i2ndPage is NULL  
    select count(*) from tblCatalogDetail where i3rdPage is NULL
     
    select count(*) from tblCatalogDetail where i4thPage is NULL
    select count(*) from tblCatalogDetail where i5thPage is NULL  
    select count(*) from tblCatalogDetail where i6thPage is NULL  
    select count(*) from tblCatalogDetail where i7thPage is NULL  
    select count(*) from tblCatalogDetail where dSquareInches is NULL  
    
-- tblCatalogMaster
    select count(*) from tblCatalogMaster where ixCatalog is NULL
    select count(*) from tblCatalogMaster where sDescription is NULL  
    select count(*) from tblCatalogMaster where sMarket is NULL  
    select count(*) from tblCatalogMaster where ixStartDate is NULL  
    select count(*) from tblCatalogMaster where ixEndDate is NULL  
    
    select count(*) from tblCatalogMaster where dtStartDate is NULL
    select count(*) from tblCatalogMaster where dtEndDate is NULL  
    select count(*) from tblCatalogMaster where iQuantityPrinted is NULL  
    select count(*) from tblCatalogMaster where iPages is NULL  
    select count(*) from tblCatalogMaster where mPrintingCost is NULL
     
    select count(*) from tblCatalogMaster where mPreparationCost is NULL
    select count(*) from tblCatalogMaster where mPostageCost is NULL  
    select count(*) from tblCatalogMaster where mPaperCost is NULL  
    select count(*) from tblCatalogMaster where mBMCFreightForwardingCost is NULL  
    select count(*) from tblCatalogMaster where mOtherCost is NULL   

-- tblCatalogRequest
    select count(*) from tblCatalogRequest where ixGUID is NULL
    select count(*) from tblCatalogRequest where ixCustomer is NULL  
    select count(*) from tblCatalogRequest where ixRequestDate is NULL  
    select count(*) from tblCatalogRequest where ixRequestTime is NULL  
    select count(*) from tblCatalogRequest where dtRequestDate is NULL  
    
    select count(*) from tblCatalogRequest where ixCatalogMarket is NULL
    select count(*) from tblCatalogRequest where ixSourceCode is NULL  
    select count(*) from tblCatalogRequest where ixZipCode is NULL  
    select count(*) from tblCatalogRequest where iBatchNumber is NULL  
    select count(*) from tblCatalogRequest where dtDateLastSOPUpdate is NULL
     
    select count(*) from tblCatalogRequest where ixTimeLastSOPUpdate is NULL

-- tblCounterOrderScans
    select count(*) from tblCounterOrderScans where ixGUID is NULL
    select count(*) from tblCounterOrderScans where ixEmployee is NULL  
    select count(*) from tblCounterOrderScans where ixScanDate is NULL  
    select count(*) from tblCounterOrderScans where dtScanDate is NULL  
    select count(*) from tblCounterOrderScans where ixScanTime is NULL  
    
    select count(*) from tblCounterOrderScans where ixOrder is NULL
    select count(*) from tblCounterOrderScans where ixIP is NULL  
    select count(*) from tblCounterOrderScans where dtDateLastSOPUpdate is NULL  
    select count(*) from tblCounterOrderScans where ixTimeLastSOPUpdate is NULL  

-- tblCreditMemoDetail
    select count(*) from tblCreditMemoDetail where ixCreditMemoLine is NULL
    select count(*) from tblCreditMemoDetail where ixCreditMemo is NULL  
    select count(*) from tblCreditMemoDetail where ixSKU is NULL  
    select count(*) from tblCreditMemoDetail where iQuantityReturned is NULL  
    select count(*) from tblCreditMemoDetail where iQuantityCredited is NULL  
    
    select count(*) from tblCreditMemoDetail where mUnitPrice is NULL
    select count(*) from tblCreditMemoDetail where mUnitCost is NULL  
    select count(*) from tblCreditMemoDetail where sReturnType is NULL  
    select count(*) from tblCreditMemoDetail where sReasonCode is NULL  
    select count(*) from tblCreditMemoDetail where mExtendedPrice is NULL
     
    select count(*) from tblCreditMemoDetail where mExtendedCost is NULL
    select count(*) from tblCreditMemoDetail where dtDateLastSOPUpdate is NULL  
    select count(*) from tblCreditMemoDetail where ixTimeLastSOPUpdate is NULL  

-- tblCreditMemoMaster
    select count(*) from tblCreditMemoMaster where ixCreditMemo is NULL
    select count(*) from tblCreditMemoMaster where ixCustomer is NULL  
    select count(*) from tblCreditMemoMaster where ixOrder is NULL  
    select count(*) from tblCreditMemoMaster where ixCreateDate is NULL  
    select count(*) from tblCreditMemoMaster where sOrderChannel is NULL  
    
    select count(*) from tblCreditMemoMaster where mMerchandise is NULL
    select count(*) from tblCreditMemoMaster where sMemoType is NULL  
    select count(*) from tblCreditMemoMaster where dtCreateDate is NULL  
    select count(*) from tblCreditMemoMaster where mMerchandiseCost is NULL  
    select count(*) from tblCreditMemoMaster where ixOrderTaker is NULL
     
    select count(*) from tblCreditMemoMaster where mShipping is NULL
    select count(*) from tblCreditMemoMaster where mTax is NULL  
    select count(*) from tblCreditMemoMaster where mRestockFee is NULL  
    select count(*) from tblCreditMemoMaster where flgCanceled is NULL  
    select count(*) from tblCreditMemoMaster where sMethodOfPayment is NULL

    select count(*) from tblCreditMemoMaster where dtDateLastSOPUpdate is NULL
    select count(*) from tblCreditMemoMaster where ixTimeLastSOPUpdate is NULL  
    select count(*) from tblCreditMemoMaster where sMemoTransactionType is NULL  

-- tblCreditMemoReasonCode
    select count(*) from tblCreditMemoReasonCode where ixReasonCode is NULL
    select count(*) from tblCreditMemoReasonCode where sDescription is NULL  
    select count(*) from tblCreditMemoReasonCode where dtDateLastSOPUpdate is NULL  
    select count(*) from tblCreditMemoReasonCode where ixTimeLastSOPUpdate is NULL  

-- tblCustomer
    select count(*) from tblCustomer where ixCustomer is NULL
    select count(*) from tblCustomer where sCustomerType is NULL  
    select count(*) from tblCustomer where ixAccountCreateDate is NULL  
    select count(*) from tblCustomer where sMailToCity is NULL  
    select count(*) from tblCustomer where sMailToState is NULL  
       
    select count(*) from tblCustomer where sMailToZip is NULL
    select count(*) from tblCustomer where sMailToCountry is NULL  
    select count(*) from tblCustomer where ixSourceCode is NULL  
    select count(*) from tblCustomer where dtAccountCreateDate is NULL  
    select count(*) from tblCustomer where ixAccountManager is NULL  
       
    select count(*) from tblCustomer where sCustomerFirstName is NULL
    select count(*) from tblCustomer where sCustomerLastName is NULL  
    select count(*) from tblCustomer where iPriceLevel is NULL  
    select count(*) from tblCustomer where sEmailAddress is NULL  
    select count(*) from tblCustomer where flgMarketingEmailSubscription is NULL  
       
    select count(*) from tblCustomer where ixCustomerType is NULL
    select count(*) from tblCustomer where sMapTerms is NULL  
    select count(*) from tblCustomer where sMapTermsLongDescription is NULL  
    select count(*) from tblCustomer where sMailingStatus is NULL  
    select count(*) from tblCustomer where sCustomerMarket is NULL  
       
    select count(*) from tblCustomer where ixOriginalMarket is NULL
    select count(*) from tblCustomer where flgDeletedFromSOP is NULL  
    select count(*) from tblCustomer where sDayPhone is NULL  
    select count(*) from tblCustomer where sNightPhone is NULL  
    select count(*) from tblCustomer where sCellPhone is NULL  
       
    select count(*) from tblCustomer where flgTaxable is NULL
    select count(*) from tblCustomer where dtDateLastSOPUpdate is NULL  
    select count(*) from tblCustomer where ixTimeLastSOPUpdate is NULL  
    select count(*) from tblCustomer where sFax is NULL  
    select count(*) from tblCustomer where dtDeceasedStatusUpdateDate is NULL  
       
    select count(*) from tblCustomer where flgDeceasedMailingStatusExempt is NULL
    select count(*) from tblCustomer where ixDeceasedStatusSource is NULL  
    select count(*) from tblCustomer where ixLastUpdateUser is NULL  





-- tblOrder
    select count(*) from tblOrder where ixOrder is NULL     -- 0
    select count(*) from tblOrder where ixCustomer is NULL  -- 0
    select count(*) from tblOrder where ixOrderDate is NULL  -- 0
    select count(*) from tblOrder where sShipToCity is NULL  -- 211
    select count(*) from tblOrder where sShipToState is NULL  -- 3317
    
    select count(*) from tblOrder where sShipToZip is NULL -- 658
    select count(*) from tblOrder where sOrderType is NULL --  0    
    select count(*) from tblOrder where sOrderChannel is NULL --  0 
    select count(*) from tblOrder where sShipToCountry is NULL --  7636
    select count(*) from tblOrder where ixShippedDate is NULL -- 122964
     
    select count(*) from tblOrder where iShipMethod is NULL -- 0
    select count(*) from tblOrder where sSourceCodeGiven is NULL --  0
    select count(*) from tblOrder where sMatchbackSourceCode is NULL --  315228
    select count(*) from tblOrder where sMethodOfPayment is NULL --  22474
    select count(*) from tblOrder where sOrderTaker is NULL -- 1
  
    select count(*) from tblOrder where sPromoApplied is NULL -- 2889065
    select count(*) from tblOrder where mMerchandise is NULL --  0
    select count(*) from tblOrder where mShipping is NULL --  22474
    select count(*) from tblOrder where mTax is NULL --  22474
    select count(*) from tblOrder where mCredits is NULL --22475
         
    select count(*) from tblOrder where sOrderStatus is NULL -- 0
    select count(*) from tblOrder where flgIsBackorder is NULL -- 0  
    select count(*) from tblOrder where mMerchandiseCost is NULL -- 0  
    select count(*) from tblOrder where dtOrderDate is NULL --  0
    select count(*) from tblOrder where dtShippedDate is NULL -- 122964
         
    select count(*) from tblOrder where ixAccountManager is NULL -- 2852809
    select count(*) from tblOrder where ixOrderTime is NULL --  6
    select count(*) from tblOrder where mPromoDiscount is NULL --2889065  
    select count(*) from tblOrder where ixAuthorizationStatus is NULL -- 436847  
    select count(*) from tblOrder where ixOrderType is NULL -- 431148
  
    select count(*) from tblOrder where mPublishedShipping is NULL -- 733301
    select count(*) from tblOrder where sOptimalShipOrigination is NULL --  2533077
    select count(*) from tblOrder where sCanceledReason is NULL --  2922501
    select count(*) from tblOrder where ixCanceledBy is NULL --  21923079
    select count(*) from tblOrder where mAmountPaid is NULL -- 1176861
             
    select count(*) from tblOrder where flgPrinted is NULL -- 1158357
    select count(*) from tblOrder where ixAuthorizationDate is NULL --  1452453
    select count(*) from tblOrder where ixAuthorizationTime is NULL --  1452453
    select count(*) from tblOrder where flgIsResidentialAddress is NULL --  0
    select count(*) from tblOrder where sWebOrderID is NULL -- 2094101
         
    select count(*) from tblOrder where sPhone is NULL -- 1306430
    select count(*) from tblOrder where dtHoldUntilDate is NULL -- 2973387 
    select count(*) from tblOrder where flgDeviceType is NULL --  2704747
    select count(*) from tblOrder where sUserAgent is NULL --  2744410
    select count(*) from tblOrder where dtAuthorizationDate is NULL -- 1757385
        
    select count(*) from tblOrder where dtDateLastSOPUpdate is NULL -- 1534811
    select count(*) from tblOrder where ixTimeLastSOPUpdate is NULL --  1534811
    select count(*) from tblOrder where sAttributedCompany is NULL --  12982
    select count(*) from tblOrder where mBrokerage is NULL --  0
    select count(*) from tblOrder where mDisbursement is NULL -- 0
         
    select count(*) from tblOrder where mVAT is NULL -- 0
    select count(*) from tblOrder where mPST is NULL --  0
    select count(*) from tblOrder where mDuty is NULL -- 0 
    select count(*) from tblOrder where mTransactionFee is NULL --  0
    select count(*) from tblOrder where ixPrimaryShipLocation is NULL -- 2948848
         
         

select COUNT(*) from tblPackage where ixShipDate >= 16784 -- 11,736
select COUNT(*) from [AFCOReporting].dbo.tblPackage where ixShipDate >= 16794
         


select * from tblOrder
where dtOrderDate >= '12/05/2013'
and ixPrimaryShipLocation is NULL



         
         
         



/*********************************************************** 
************************* TEMPLATE *************************  
************************************************************/
-- FIELDS LIST = 
-- TABLE###
    select count(*) from TABLE### where ###FIELD is NULL --
    select count(*) from TABLE### where ###FIELD is NULL --  
    select count(*) from TABLE### where ###FIELD is NULL --  
    select count(*) from TABLE### where ###FIELD is NULL --  
    select count(*) from TABLE### where ###FIELD is NULL --  
    
    select count(*) from TABLE### where ###FIELD is NULL --
    select count(*) from TABLE### where ###FIELD is NULL --  
    select count(*) from TABLE### where ###FIELD is NULL --  
    select count(*) from TABLE### where ###FIELD is NULL --  
    select count(*) from TABLE### where ###FIELD is NULL --
     
    select count(*) from TABLE### where ###FIELD is NULL --
    select count(*) from TABLE### where ###FIELD is NULL --  
    select count(*) from TABLE### where ###FIELD is NULL --  
    select count(*) from TABLE### where ###FIELD is NULL --  
    select count(*) from TABLE### where ###FIELD is NULL --
    
    
       
