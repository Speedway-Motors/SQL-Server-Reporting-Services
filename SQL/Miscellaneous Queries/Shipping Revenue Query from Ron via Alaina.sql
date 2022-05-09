-- Shipping Revenue Query from Ron via Alaina
SELECT top 20
  tt.ixSopWebOrderNumber
  , tts.mPreDiscountPrice
  , tts.mPostDiscountPrice
  , tts.ixOrderShippingMethod
  , tts.sOrderShippingMethod
  , tts.dtExpectedDeliveryDate
  , tts.sTimeInTransit
  , tts.sSopShippingLocation
  , tts.flgBestValue
  , tts.flgSelected
  , tts.flgGuaranteedShipping
  , tts.flgDealerFreeShipping
  , tts.flgSOPShippingQuote
  FROM tng.tblcheckout_transaction_shippingmethod AS tts
  INNER JOIN tng.tblcheckout_transaction AS tt ON tts.ixTransactionGuid = tt.ixTransactionGuid
WHERE tt.ixSopWebOrderNumber IS NOT NULL
    AND tt.ixSopWebOrderNumber = 'E2478373'
ORDER BY tt.dtCreateDate desc

 


