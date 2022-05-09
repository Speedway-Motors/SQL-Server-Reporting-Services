-- SMIHD-13936 - add mPaymentProcessingFee and mMarketplaceSellingFee fields to tblOrder
SELECT
    ixOrder,
    mMerchandise, mShipping, mTax, mCredits, 
    sSourceCodeGiven,
    dtOrderDate,
    sOrderStatus,

(CASE WHEN sMethodOfPayment= 'VISA' then 0.021*(mMerchandise+mShipping+mTax-mCredits)
    WHEN sMethodOfPayment= 'AMEX' then 0.03 *(mMerchandise+mShipping+mTax-mCredits)
    WHEN sMethodOfPayment= 'DISCOVER' then 0.021*(mMerchandise+mShipping+mTax-mCredits)
    WHEN sMethodOfPayment= 'MASTERCARD' then 0.021*(mMerchandise+mShipping+mTax-mCredits)
    WHEN sMethodOfPayment= 'PP-AUCTION' then 0.0195*(mMerchandise+mShipping+mTax-mCredits)
    WHEN sMethodOfPayment= 'PAYPAL' then 0.0195*(mMerchandise+mShipping+mTax-mCredits)
    else 0
  end
) as 'mPaymentProcessingFee',
(CASE 
    WHEN sSourceCodeGiven like '%EBAY%' then 0.07*(mMerchandise+mShipping+mTax-mCredits)
    WHEN sSourceCodeGiven = 'AMAZON' then 0.12*(mMerchandise+mShipping+mTax-mCredits)
    WHEN sSourceCodeGiven = 'WALMART' then 0.12*(mMerchandise+mShipping+mTax-mCredits)
    else 0
   end
) as 'mMarketplaceSellingFee'

from tblOrder
where dtOrderDate = '04/01/2019'
and sOrderStatus <>  'Shipped'

select distinct sOrderStatus
from tblOrder
where dtOrderDate >= '01/01/2019'

mPaymentProcessingFee & mMarketplaceSellingFee

-- TEST ORDERS -- NEED TO change some to OPEN status
select *
into [SMITemp].dbo.PJC_SMIHD13936_TestOrderBefore
from tblOrder
where dtOrderDate = '04/01/2019' --and'04/02/2019'
ORDER BY sOrderStatus
-- ALL SCs
-- ALL MoPs

-- COPY TEST DATA TO SECOND TABLE
SELECT * 
INTO [SMITemp].dbo.PJC_SMIHD13936_TestOrderAfter
FROM [SMITemp].dbo.PJC_SMIHD13936_TestOrderBefore
-- DROP TABLE [SMITemp].dbo.PJC_SMIHD13936_TestOrderAfter

SELECT ixOrder, sSourceCodeGiven, sMethodOfPayment,mPaymentProcessingFee, mMarketplaceSellingFee
FROM [SMITemp].dbo.PJC_SMIHD13936_TestOrderAfter



-- FINAL LOGIC for mPaymentProcessingFee
UPDATE [SMITemp].dbo.PJC_SMIHD13936_TestOrderAfter
SET mPaymentProcessingFee = (CASE WHEN sOrderStatus = 'Shipped' AND (mMerchandise+mShipping+mTax-mCredits) > 0 THEN 
                                          (CASE WHEN sMethodOfPayment= 'VISA' then 0.021*(mMerchandise+mShipping+mTax-mCredits)
                                                WHEN sMethodOfPayment= 'AMEX' then 0.03 *(mMerchandise+mShipping+mTax-mCredits)
                                                WHEN sMethodOfPayment= 'DISCOVER' then 0.021*(mMerchandise+mShipping+mTax-mCredits)
                                                WHEN sMethodOfPayment= 'MASTERCARD' then 0.021*(mMerchandise+mShipping+mTax-mCredits)
                                                WHEN sMethodOfPayment= 'PP-AUCTION' then 0.0195*(mMerchandise+mShipping+mTax-mCredits)
                                                WHEN sMethodOfPayment= 'PAYPAL' then 0.0195*(mMerchandise+mShipping+mTax-mCredits)
                                                else 0 
                                                end)
                              ELSE 0
                              end) 

--  FINAL LOGIC formMarketplaceSellingFee
UPDATE [SMITemp].dbo.PJC_SMIHD13936_TestOrderAfter
SET mMarketplaceSellingFee = (CASE WHEN sOrderStatus = 'Shipped' THEN 
                                          (CASE WHEN sSourceCodeGiven like '%EBAY%' then 0.07*(mMerchandise+mShipping+mTax-mCredits)
                                                WHEN sSourceCodeGiven = 'AMAZON' then 0.12*(mMerchandise+mShipping+mTax-mCredits)
                                                WHEN sSourceCodeGiven = 'WALMART' then 0.12*(mMerchandise+mShipping+mTax-mCredits)
                                                else 0 
                                            end)
                              ELSE 0
                              end) 





SELECT ixOrder, sSourceCodeGiven, sMethodOfPayment, (mMerchandise+mShipping+mTax-mCredits) 'TotCharge',
    mPaymentProcessingFee, mMarketplaceSellingFee
FROM [SMITemp].dbo.PJC_SMIHD13936_TestOrderAfter
WHERE mMarketplaceSellingFee > 0
order by 'TotCharge' desc


Select ixOrder, sSourceCodeGiven, sMethodOfPayment, 
    mMerchandise, mShipping, mTax, mCredits, 
    mPaymentProcessingFee, mMarketplaceSellingFee 
FROM [SMITemp].dbo.PJC_SMIHD13936_TestOrderAfter
WHERE mPaymentProcessingFee < 0

ORDER BY  mPaymentProcessingFee DESC




select * from tblIPAddress
order by sGroup




