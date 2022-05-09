-- ALL SKUs currently appearing on Parts Not Returned reports
select DISTINCT SKU.ixSKU
/*
    BS.ixBin, SKU.ixSKU, SKU.dtDateLastSOPUpdate--,BS.ixBin  -- 4,772   4,768
    , SKU.sCountryOfOrigin
    , max(D.dtDate)              LastTransDate
*/    
from (select BS.ixSKU, BS.ixBin, BS.sPickingBin, SUM(BS.iSKUQuantity) QTYinBin
              from tblBinSku BS
                  join tblBin B on BS.ixBin = B.ixBin AND B.ixLocation = '99' 
               where (BS.ixBin in ('GOOD-WILL','CLAIM','CUST-RTN','RTV','SHOWRM','REVIEW','GARAGE','COUNTER','IOIT','IT','RCV','SOUTHDOCK','5A00A1','X00A1','Y00A1','Z00A1','BSOOA1','RETURN','LOST','LOSTNC')
                    OR (BS.ixBin LIKE 'IO%' and B.sBinType = 'LN' ))              
                and BS.iSKUQuantity <> 0
                and BS.ixLocation = '99'
              GROUP BY BS.ixSKU, BS.ixBin, BS.sPickingBin
              ) BS
   left join tblSKU SKU on SKU.ixSKU = BS.ixSKU 
   left join tblSKUTransaction T on T.ixSKU = SKU.ixSKU
                  and isnull(T.sToBin,T.sBin) = BS.ixBin
   left join tblDate D on D.ixDate = T.ixDate  
   
group by  BS.ixBin, SKU.ixSKU, SKU.dtDateLastSOPUpdate--,BS.ixBin
    , SKU.sCountryOfOrigin   
ORDER BY SKU.sCountryOfOrigin    



-- SPEEDWAY OWNED ITEMS STORED AT LINCOLN
select 
   isnull(V.ixVendor,' n/a')  PrimVendorNum,
   isnull(V.sName,' n/a')     PrimeVendor,
   BS.ixBin                   Bin,
   BS.ixSKU                   SKU, 
   BS.sPickingBin             PickingBin,  
   BS.QTYinBin,
   SKU.sOriginalSource        OriginalSource,
   SKU.sDescription           Description,
   mPriceLevel1               Retail,
   SKU.mLatestCost            Cost,
   max(D.dtDate)              LastTransDate,
   'SMI' as 'Owner'
--,   T.sCID 
from (select BS.ixSKU, BS.ixBin, BS.sPickingBin, SUM(BS.iSKUQuantity) QTYinBin
              from tblBinSku BS
                  join tblBin B on BS.ixBin = B.ixBin AND B.ixLocation = '99' 
              where (BS.ixBin = @Bin
                    OR (@Bin = 'IO%' and B.sBinType = 'LN' ))
              --where (BS.ixBin in ('GOOD-WILL','CLAIM','CUST-RTN','RTV','SHOWRM','REVIEW','GARAGE','COUNTER','IOIT','IT','RCV','SOUTHDOCK','5A00A1','X00A1','Y00A1','Z00A1','BSOOA1','RETURN','LOST','LOSTNC')
              --      OR (BS.ixBin LIKE 'IO%' and B.sBinType = 'LN' ))              
                and BS.iSKUQuantity <> 0
                and BS.ixLocation = '99'
              GROUP BY BS.ixSKU, BS.ixBin, BS.sPickingBin
              ) BS
   left join tblBin B on B.ixBin = BS.ixBin
   left join vwSKULocalLocation SKU on SKU.ixSKU = BS.ixSKU 
   left join tblVendorSKU VS on VS.ixSKU = isnull(SKU.ixOriginalPart,SKU.ixSKU) -- some SKUs don't have ixOriginalPart #'s
   left join tblVendor V on V.ixVendor = VS.ixVendor 
   left join tblSKUTransaction T on T.ixSKU = SKU.ixSKU
                  and isnull(T.sToBin,T.sBin) = BS.ixBin
   left join tblDate D on D.ixDate = T.ixDate
where VS.iOrdinality = 1
group by   
   isnull(V.ixVendor,' n/a'),
   isnull(V.sName,' n/a'),
   BS.ixBin,
   BS.ixSKU,
   BS.sPickingBin,
   SKU.sOriginalSource,
   SKU.sDescription,
   mPriceLevel1,
   SKU.mLatestCost,
   VS.iOrdinality,
   BS.QTYinBin--,   T.sCID
--order by BS.ixBin,  isnull(V.sName,' n/a'), BS.ixSKU
