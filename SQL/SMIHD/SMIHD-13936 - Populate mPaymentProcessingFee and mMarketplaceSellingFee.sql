-- SMIHD-13936 - Populate mPaymentProcessingFee and mMarketplaceSellingFee

-- SELECT @@SPID as 'Current SPID' -- 140
 
-- set rowcount 200000
BEGIN TRAN

    UPDATE tblOrder -- 3-5 months at a time
    SET mPaymentProcessingFee = 
                                (CASE WHEN sOrderStatus = 'Shipped'  AND (mMerchandise+mShipping+mTax-mCredits) > 0 THEN 
                                (CASE WHEN sMethodOfPayment= 'VISA' THEN 0.021*(mMerchandise+mShipping+mTax-mCredits)
                                    WHEN sMethodOfPayment= 'AMEX' THEN 0.03 *(mMerchandise+mShipping+mTax-mCredits)
                                    WHEN sMethodOfPayment= 'DISCOVER' THEN 0.021*(mMerchandise+mShipping+mTax-mCredits)
                                    WHEN sMethodOfPayment= 'MASTERCARD' THEN 0.021*(mMerchandise+mShipping+mTax-mCredits)
                                    WHEN sMethodOfPayment= 'PP-AUCTION' THEN 0.0195*(mMerchandise+mShipping+mTax-mCredits)
                                    WHEN sMethodOfPayment= 'PAYPAL' THEN 0.0195*(mMerchandise+mShipping+mTax-mCredits)
                                    else 0 
                                    end)
                                ELSE 0
                                end),
        mMarketplaceSellingFee = 
                                 (CASE WHEN sOrderStatus = 'Shipped' AND (mMerchandise+mShipping+mTax-mCredits) > 0 THEN
                                                (CASE WHEN sSourceCodeGiven like '%EBAY%' THEN 0.07*(mMerchandise+mShipping+mTax-mCredits)
                                                    WHEN sSourceCodeGiven like 'AMAZON%' THEN 0.12*(mMerchandise+mShipping+mTax-mCredits)
                                                    WHEN sSourceCodeGiven = 'WALMART' THEN 0.12*(mMerchandise+mShipping+mTax-mCredits)
                                                    else 0 
                                                end)
                                          ELSE 0
                                          end)
    WHERE dtOrderDate >= '01/01/2006'
            -- dtInvoiceDate >= '01/01/2001'
        --and sOrderStatus = 'Shipped'
        AND mPaymentProcessingFee IS NULL -- 1:52
        --AND mMarketplaceSellingFee < 0
       -- AND ixOrder in ('7302106','7351009','6522010','2516492','2577789','2588319','2588329','2588338','2588339','2571198','2571216','2571221','2571224','2571240','4371859')

ROLLBACK TRAN






/**********************************    CURRENT counts     ***********************************/
select 'TARGET', FORMAT(count(*),'###,###') 'OrderCnt', FORMAT(GETDATE(),'hh:mm') 'AsOf'
from tblOrder 
where mPaymentProcessingFee is NOT NULL -- TARGET	6,522,213	09:02

select 'TARGET', FORMAT(count(*),'###,###') 'CURRENT', FORMAT(GETDATE(),'hh:mm')  'AsOf'
from tblOrder 
where mMarketplaceSellingFee is NOT NULL -- TARGET	6,255,352	09:02
/********************************************************************************************/






/************* RUN AND MONITOR ON DW.SPEEDWAY2.COM  **********************************/
SELECT 'CURRENT',
        FORMAT(count(*),'###,###') 'OrderCnt',     
        FORMAT(GETDATE(),'hh:mm') 'AsOf'
FROM tblOrder 
WHERE mPaymentProcessingFee is NOT NULL 
/*      COUNT       AsOf
        =======     =====
TARGET	6,522,213	09:02

CURRENT	6,522,332	02:47
*/



SELECT 'CURRENT',
        FORMAT(count(*),'###,###') 'CURRENT',     
        FORMAT(GETDATE(),'hh:mm')  'AsOf'
FROM tblOrder 
WHERE mMarketplaceSellingFee is NOT NULL 
/*      COUNT       AsOf
        =======     =====
TARGET	6,255,352	09:02

CURRENT	6,255,473	02:47
*/

/*****************************************************************************************/









-- all Shipped Marketplace orders with totals > 0 have a fee greater than 0?
select count(*)
    --  sOrderStatus,COUNT(ixOrder) -- 5,888
from tblOrder
where (sSourceCodeGiven like '%EBAY%' 
      or sSourceCodeGiven like 'AMAZON%' 
      or sSourceCodeGiven = 'WALMART')
 AND mMarketplaceSellingFee = 0 --IS NULL
 and sOrderStatus = 'Shipped'
 AND (mMerchandise+mShipping+mTax-mCredits) > 0
 group by sOrderStatus



 -- all Shipped orders with approprate Methods of Payment and orders with totals > 0 have a Payment Processing Fee greater than 0?
select ixOrder, (mMerchandise+mShipping+mTax-mCredits), mMerchandise, mShipping, mTax, mCredits, sMethodOfPayment, mPaymentProcessingFee, sOrderStatus
from tblOrder
where sMethodOfPayment in ('VISA','AMEX','DISCOVER','MASTERCARD','PP-AUCTION','PAYPAL')
    and sOrderStatus = 'Shipped'
    and (mMerchandise+mShipping+mTax-mCredits) > 0
   and mPaymentProcessingFee <=0 --> 0 --is NULL
order by mPaymentProcessingFee


select ixOrder, (mMerchandise+mShipping+mTax-mCredits), mMerchandise, mShipping, mTax, mCredits, sMethodOfPayment, mPaymentProcessingFee, sOrderStatus -- count(*) 
from tblOrder
where mPaymentProcessingFee is NULL -- 726,840

select ixOrder, (mMerchandise+mShipping+mTax-mCredits), mMerchandise, mShipping, mTax, mCredits, sMethodOfPayment, mPaymentProcessingFee, sOrderStatus
 from tblOrder
where
sMethodOfPayment in ('VISA','AMEX','DISCOVER','MASTERCARD','PP-AUCTION','PAYPAL')
    and sOrderStatus = 'Shipped'
    and (mMerchandise+mShipping+mTax-mCredits) > 0
order by mPaymentProcessingFee









select FORMAT(count(*),'###,###'), FORMAT(GETDATE(),'hh:mm')  'AsOf' from tblOrder 
where(mPaymentProcessingFee is NULL or mMarketplaceSellingFee is NULL) 
    and ixOrder NOT LIKE 'P%'    --             AsOf
    and ixOrder NOT LIKE 'Q%'   -- 1,828,488    01:50
                                -- 1,058,670	03:59
                                --   682,170	04:41




select FORMAT(count(*),'###,###') from tblOrder

select FORMAT(count(*),'###,###') from tblOrder where dtOrderDate < '01/01/2017' and ixOrder like 'Q%'

/*
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
                                                WHEN sSourceCodeGiven like 'AMAZON%' then 0.12*(mMerchandise+mShipping+mTax-mCredits)
                                                WHEN sSourceCodeGiven = 'WALMART' then 0.12*(mMerchandise+mShipping+mTax-mCredits)
                                                else 0 
                                            end)
                              ELSE 0
                              end) 





                mPaymentProcessingFee = (CASE WHEN sOrderStatus = 'Shipped' AND (mMerchandise+mShipping+mTax-mCredits) > 0 THEN 
                                          (CASE WHEN sMethodOfPayment= 'VISA' then 0.021*(mMerchandise+mShipping+mTax-mCredits)
                                                WHEN sMethodOfPayment= 'AMEX' then 0.03 *(mMerchandise+mShipping+mTax-mCredits)
                                                WHEN sMethodOfPayment= 'DISCOVER' then 0.021*(mMerchandise+mShipping+mTax-mCredits)
                                                WHEN sMethodOfPayment= 'MASTERCARD' then 0.021*(mMerchandise+mShipping+mTax-mCredits)
                                                WHEN sMethodOfPayment= 'PP-AUCTION' then 0.0195*(mMerchandise+mShipping+mTax-mCredits)
                                                WHEN sMethodOfPayment= 'PAYPAL' then 0.0195*(mMerchandise+mShipping+mTax-mCredits)
                                                else 0 
                                                end)
                                ELSE 0
                                end), -- mPaymentProcessingFee
                 mMarketplaceSellingFee = (CASE WHEN sOrderStatus = 'Shipped' THEN 
                                                  (CASE WHEN sSourceCodeGiven like '%EBAY%' then 0.07*(mMerchandise+mShipping+mTax-mCredits)
                                                        WHEN sSourceCodeGiven like 'AMAZON%' then 0.12*(mMerchandise+mShipping+mTax-mCredits)
                                                        WHEN sSourceCodeGiven = 'WALMART' then 0.12*(mMerchandise+mShipping+mTax-mCredits)
                                                        else 0 
                                                    end)
                                      ELSE 0
                                      end)  -- mMarketplaceSellingFee


select * from tblTime where chTime = '14:59:00'                                      

SELECT ixOrder, sOrderStatus, sSourceCodeGiven, sMethodOfPayment, (mMerchandise+mShipping+mTax-mCredits) 'TotCharge',
        mPaymentProcessingFee, mMarketplaceSellingFee, dtDateLastSOPUpdate, T.chTime as 'LastSOPUpdateTime', dtOrderDate, dtShippedDate, mMerchandise,mShipping,mTax,mCredits
FROM tblOrder
    left join tblTime T on ixTimeLastSOPUpdate = T.ixTime 
WHERE dtDateLastSOPUpdate = '05/24/2019' and ixTimeLastSOPUpdate >= 53940
    AND mPaymentProcessingFee IS not null
    AND sOrderStatus = 'Shipped'
    AND sMethodOfPayment IN ('VISA','AMEX','DISCOVER','MASTERCARD')
    --AND mPaymentProcessingFee = 0
    and (mMerchandise+mShipping+mTax-mCredits) > 0
ORDER BY --ixTimeLastSOPUpdate desc
   ixOrder-- mPaymentProcessingFee

('8101865','8103867','8104866','8105866','8107866','8108861','8110869','8111867','8114862','8114866','8115861','8115862','8116869','8117862','8119862','8120864','8123866','8125862','8126869','8128860','8128864','8131863','8134764','8135865','8137865','8137868','8138567','8141862','8142869','8143869','8149666','8152860','8158869','8184760','8191668')

SELECT ixOrder, sOrderStatus, sSourceCodeGiven, sMethodOfPayment, (mMerchandise+mShipping+mTax-mCredits) 'TotCharge',
        mPaymentProcessingFee, mMarketplaceSellingFee, dtDateLastSOPUpdate, T.chTime as 'LastSOPUpdateTime', dtShippedDate, mMerchandise,mShipping,mTax,mCredits
FROM tblOrder
    left join tblTime T on ixTimeLastSOPUpdate = T.ixTime 
WHERE dtDateLastSOPUpdate = '05/24/2019' and ixTimeLastSOPUpdate > = 40740
and ixOrder in ('8101865','8103867','8104866','8105866','8107866','8108861','8110869','8111867','8114862','8114866','8115861','8115862','8116869','8117862','8119862','8120864','8123866','8125862','8126869','8128860','8128864','8131863','8134764','8135865','8137865','8137868','8138567','8141862','8142869','8143869','8149666','8152860','8158869','8184760','8191668')
ORDER BY ixTimeLastSOPUpdate desc
   --ixOrder-- mPaymentProcessingFee


SELECT ixOrder, sOrderStatus, sSourceCodeGiven, sMethodOfPayment, (mMerchandise+mShipping+mTax-mCredits) 'TotCharge',
        mPaymentProcessingFee, mMarketplaceSellingFee, dtDateLastSOPUpdate, ixTimeLastSOPUpdate, dtShippedDate
FROM tblOrder
WHERE dtDateLastSOPUpdate = '05/24/2019' and ixTimeLastSOPUpdate > = 40740
    AND mMarketplaceSellingFee IS not null
    AND sOrderStatus = 'Shipped'
ORDER BY --ixTimeLastSOPUpdate desc
    mMarketplaceSellingFee






BEGIN TRAN

--  FINAL LOGIC formMarketplaceSellingFee
UPDATE tblOrder
SET mMarketplaceSellingFee = (CASE WHEN sOrderStatus = 'Shipped' THEN 
                                          (CASE WHEN sSourceCodeGiven like '%EBAY%' then 0.07*(mMerchandise+mShipping+mTax-mCredits)
                                                WHEN sSourceCodeGiven like 'AMAZON%' then 0.12*(mMerchandise+mShipping+mTax-mCredits)
                                                WHEN sSourceCodeGiven = 'WALMART' then 0.12*(mMerchandise+mShipping+mTax-mCredits)
                                                else 0 
                                            end)
                              ELSE 0
                              end) 







                                              (CASE WHEN @sOrderStatus = 'Shipped'  AND (@mMerchandise+@mShipping+@mTax-@mCredits) > 0 THEN 
                                          (CASE WHEN @sMethodOfPayment= 'VISA' THEN 0.021*(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                WHEN @sMethodOfPayment= 'AMEX' THEN 0.03 *(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                WHEN @sMethodOfPayment= 'DISCOVER' THEN 0.021*(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                WHEN @sMethodOfPayment= 'MASTERCARD' THEN 0.021*(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                WHEN @sMethodOfPayment= 'PP-AUCTION' THEN 0.0195*(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                WHEN @sMethodOfPayment= 'PAYPAL' THEN 0.0195*(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                else 0 
                                                end)
                                ELSE 0
                                end),-- mPaymentProcessingFee
                (CASE WHEN @sOrderStatus = 'Shipped' THEN 
                                            (CASE WHEN @sSourceCodeGiven like '%EBAY%' THEN 0.07*(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                WHEN @sSourceCodeGiven like 'AMAZON%' THEN 0.12*(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                WHEN @sSourceCodeGiven = 'WALMART' THEN 0.12*(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                else 0 
                                            end)
                                      ELSE 0
                                      end)-- mMarketplaceSellingFee
                )















SET rowcount 0

BEGIN TRAN

UPDATE tblOrder -- 
SET mMarketplaceSellingFee = 
                             (CASE WHEN sOrderStatus = 'Shipped' THEN 
                                            (CASE WHEN sSourceCodeGiven like '%EBAY%' THEN 0.07*(mMerchandise+mShipping+mTax-mCredits)
                                                WHEN sSourceCodeGiven like 'AMAZON%' THEN 0.12*(mMerchandise+mShipping+mTax-mCredits)
                                                WHEN sSourceCodeGiven = 'WALMART' THEN 0.12*(mMerchandise+mShipping+mTax-mCredits)
                                                else 0 
                                            end)
                                      ELSE 0
                                      end)
WHERE dtInvoiceDate >= '12/28/2018'
    and sOrderStatus = 'Shipped'
    and (sSourceCodeGiven  like '%EBAY%'
         or sSourceCodeGiven like 'AMAZON%'
         or sSourceCodeGiven = 'WALMART')
    AND mMarketplaceSellingFee IS NULL

ROLLBACK TRAN

select FORMAT(count(*),'###,###') 'OrderCnt',     
    FORMAT(GETDATE(),'hh:mm') 
from tblOrder 
where mMarketplaceSellingFee is NOT NULL -- 82,207	04:37
    and (sSourceCodeGiven  like '%EBAY%'
         or sSourceCodeGiven like 'AMAZON%'
         or sSourceCodeGiven = 'WALMART')





     @sSourceCodeGiven like '%EBAY%' THEN 0.07*(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                WHEN @sSourceCodeGiven like 'AMAZON%' THEN 0.12*(@mMerchandise+@mShipping+@mTax-@mCredits)
                                                WHEN @sSourceCodeGiven = 'WALMART' T

                                                */
