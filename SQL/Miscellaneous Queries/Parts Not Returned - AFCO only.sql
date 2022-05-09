 -- NOW GOING TO GET THE ITEMS AFCO OWNS THAT ARE STORED AT LINCOLN LOCATION 
SELECT 
   isnull(SMIV.ixVendor,' n/a') PrimVendorNum,    -- SMI info   
  -- isnull(SMIV.sName,' n/a')    COLLATE SQL_Latin1_General_CP1_CS_AS     PrimeVendor,      -- SMI info   
   BS.ixBin                     COLLATE SQL_Latin1_General_CP1_CS_AS     Bin,              -- AFCO info OK
   SMIVS.ixSKU                  COLLATE SQL_Latin1_General_CP1_CS_AS     SKU,              -- SMI info  
   BS.ixSKU AFCOVendorSKUtemp, -- <--may need to COLLATE for the UNION
 --  BS.sPickingBin               COLLATE SQL_Latin1_General_CP1_CS_AS     PickingBin,       -- AFCO info OK
   BS.QTYinBin,                                 -- AFCO info OK
 --  SMISKU.sOriginalSource       COLLATE SQL_Latin1_General_CP1_CS_AS     OriginalSource,   -- SMI info
   SMISKU.sDescription          COLLATE SQL_Latin1_General_CP1_CS_AS     Description,      -- SMI info
  -- SMISKU.mPriceLevel1          Retail,           -- SMI info
  -- SMISKU.mLatestCost           Cost,             -- SMI info   
   max(D.dtDate)                LastTransDate   -- AFCO info OK
  -- 'AFCO' as 'Owner' --,   T.sCID                       COLLATE SQL_Latin1_General_CP1_CS_AS      sCID  
from (select BS.ixSKU, BS.ixBin, BS.sPickingBin, SUM(BS.iSKUQuantity) QTYinBin, BS.ixLocation
              from [AFCOReporting].dbo.tblBinSku BS
                  join [AFCOReporting].dbo.tblBin B on BS.ixBin = B.ixBin
              where (BS.ixBin in ('CLAIM','GOOD-WILL','5A00A1','IOIT','IT','RETURN','X00A1','Y00A1','Z00A1','RTV','SHOWRM','CUST-RTN','AG99A1','COUNTER','GARAGE',
                                  'QC-SHOP','QCSHOP','REVIEW','LNKRCV','QC-RCV','QCRCV','RCV','SDOCK','BA25A1','BS00A1','CONSOL','LOST','LOSTNC','X00B1','Z25A1','Z25A2','Z25A3')
                    OR B.sBinType = 'LN' 
                    )                  
                and BS.iSKUQuantity <> 0
                and BS.ixLocation = '68'
              GROUP BY BS.ixSKU, BS.ixBin, BS.sPickingBin, BS.ixLocation
              ) BS
   left join [AFCOReporting].dbo.tblBin B on B.ixBin  = BS.ixBin 
   left join [AFCOReporting].dbo.vwSKULocalLocation SKU on SKU.ixSKU  = BS.ixSKU 
   left join [AFCOReporting].dbo.tblVendorSKU VS on VS.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS = isnull(SKU.ixOriginalPart,SKU.ixSKU) COLLATE SQL_Latin1_General_CP1_CS_AS -- some SKUs don't have ixOriginalPart #'s
   left join [AFCOReporting].dbo.tblVendor V on V.ixVendor = VS.ixVendor 
   left join [AFCOReporting].dbo.tblSKUTransaction T on T.ixSKU = SKU.ixSKU
                  and isnull(T.sToBin,T.sBin) = BS.ixBin
   left join [AFCOReporting].dbo.tblDate D on D.ixDate = T.ixDate
   -- NOW JOINING BACK TO SMI TABLES to get the SMI-specific details
  left join [AFCOReporting].dbo.tblVendorSKU SMIVS on SMIVS.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS = SKU.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS and SMIVS.iOrdinality = 1
   left join tblVendor SMIV on SMIVS.ixVendor COLLATE SQL_Latin1_General_CP1_CS_AS = SMIV.ixVendor COLLATE SQL_Latin1_General_CP1_CS_AS
   left join tblSKU SMISKU on SMISKU.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS = SMIVS.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS
   left join tblSKUTransaction SMIT on SMIT.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS = SMISKU.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS
                  and isnull(SMIT.sToBin,SMIT.sBin) COLLATE SQL_Latin1_General_CP1_CS_AS = BS.ixBin COLLATE SQL_Latin1_General_CP1_CS_AS   -- HOW DO WE FIX THIS JOIN????????
where VS.iOrdinality = 1
group by   
   isnull(SMIV.ixVendor,' n/a'),
   isnull(SMIV.sName,' n/a'),
   BS.ixBin,
   SMIVS.ixSKU,
BS.ixSKU ,   
   BS.sPickingBin,
   BS.QTYinBin,   
   SKU.sOriginalSource,
   SKU.sDescription,
   SMISKU.sOriginalSource,
   SMISKU.sDescription,
   SMISKU.mPriceLevel1,
   SMISKU.mLatestCost
order by  SMIVS.ixSKU,BS.ixBin -- max(D.dtDate)                        