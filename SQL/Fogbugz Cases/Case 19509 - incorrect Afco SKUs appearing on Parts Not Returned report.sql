-- Case 19509 - incorrect Afco SKUs appearing on Parts Not Returned report

-- NOW GOING TO GET THE ITEMS AFCO OWNS THAT ARE STORED AT LINCOLN LOCATION 
SELECT 
   isnull(SMIV.ixVendor,' n/a') PrimVendorNum,    -- SMI info   
   isnull(SMIV.sName,' n/a')    COLLATE SQL_Latin1_General_CP1_CS_AS     PrimeVendor,      -- SMI info   
   BS.ixBin                     COLLATE SQL_Latin1_General_CP1_CS_AS     Bin              -- AFCO info OK
   /*
   SMIVS.ixSKU                  COLLATE SQL_Latin1_General_CP1_CS_AS     SKU,              -- SMI info  
   BS.sPickingBin               COLLATE SQL_Latin1_General_CP1_CS_AS     PickingBin,       -- AFCO info OK
   BS.QTYinBin,                                 -- AFCO info OK
   SMISKU.sOriginalSource       COLLATE SQL_Latin1_General_CP1_CS_AS     OriginalSource,   -- SMI info
   SMISKU.sDescription          COLLATE SQL_Latin1_General_CP1_CS_AS     Description,      -- SMI info
   SMISKU.mPriceLevel1          Retail,           -- SMI info
   SMISKU.mLatestCost           Cost,             -- SMI info   
   max(D.dtDate)                LastTransDate,     -- AFCO info OK
   'AFCO' as 'Owner' --,   T.sCID                       COLLATE SQL_Latin1_General_CP1_CS_AS      sCID  
   */
from (select BS.ixSKU, BS.ixBin, BS.sPickingBin, SUM(BS.iSKUQuantity) QTYinBin, BS.ixLocation
              from [AFCOReporting].dbo.tblBinSku BS
                  join [AFCOReporting].dbo.tblBin B on BS.ixBin = B.ixBin
              where BS.ixBin = 'IOKDL'
                 
              --where (BS.ixBin in ('GOOD-WILL','CLAIM','CUST-RTN','RTV','SHOWRM','REVIEW','GARAGE','COUNTER','IOIT','IT','RCV','SOUTHDOCK','5A00A1','X00A1','Y00A1','Z00A1','BSOOA1','RETURN','LOST','LOSTNC')
              --      OR (BS.ixBin LIKE 'IO%' and B.sBinType = 'LN' ))
                and BS.iSKUQuantity <> 0
                and BS.ixLocation = '68'
              GROUP BY BS.ixSKU, BS.ixBin, BS.sPickingBin, BS.ixLocation
              ) BS
--   left join [AFCOReporting].dbo.tblBin B on B.ixBin  = BS.ixBin 
   left join [AFCOReporting].dbo.vwSKULocalLocation SKU on SKU.ixSKU  = BS.ixSKU 
 --  left join [AFCOReporting].dbo.tblVendorSKU VS on VS.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS = isnull(SKU.ixOriginalPart,SKU.ixSKU) COLLATE SQL_Latin1_General_CP1_CS_AS -- some SKUs don't have ixOriginalPart #'s
  -- left join [AFCOReporting].dbo.tblVendor V on V.ixVendor = VS.ixVendor 
 --  left join [AFCOReporting].dbo.tblSKUTransaction T on T.ixSKU = SKU.ixSKU
 --                 and isnull(T.sToBin,T.sBin) = BS.ixBin
 --  left join [AFCOReporting].dbo.tblDate D on D.ixDate = T.ixDate
   /*
   -- NOW JOINING BACK TO SMI TABLES to get the SMI-specific details
   left join tblVendorSKU SMIVS on SMIVS.sVendorSKU = SKU.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS and SMIVS.iOrdinality = 1
   left join tblVendor SMIV on SMIVS.ixVendor = SMIV.ixVendor
   left join tblSKU SMISKU on SMISKU.ixSKU = SMIVS.ixSKU
   left join tblSKUTransaction SMIT on SMIT.ixSKU = SMISKU.ixSKU
                  and isnull(SMIT.sToBin,SMIT.sBin) COLLATE SQL_Latin1_General_CP1_CS_AS = BS.ixBin COLLATE SQL_Latin1_General_CP1_CS_AS   -- HOW DO WE FIX THIS JOIN????????
*/
   -- NOW JOINING BACK TO SMI TABLES to get the SMI-specific details
   left join tblVendorSKU SMIVS on SMIVS.sVendorSKU COLLATE SQL_Latin1_General_CP1_CS_AS = SKU.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS and SMIVS.iOrdinality = 1
   left join tblVendor SMIV on SMIVS.ixVendor COLLATE SQL_Latin1_General_CP1_CS_AS = SMIV.ixVendor COLLATE SQL_Latin1_General_CP1_CS_AS
 --  left join tblSKU SMISKU on SMISKU.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS = SMIVS.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS
 --  left join tblSKUTransaction SMIT on SMIT.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS = SMISKU.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS
 --                 and isnull(SMIT.sToBin,SMIT.sBin) COLLATE SQL_Latin1_General_CP1_CS_AS = BS.ixBin COLLATE SQL_Latin1_General_CP1_CS_AS   -- HOW DO WE FIX THIS JOIN????????                  
--where VS.iOrdinality = 1
group by   
   isnull(SMIV.ixVendor,' n/a'),
   isnull(SMIV.sName,' n/a'),
   BS.ixBin
   /*,
   SMIVS.ixSKU,
   BS.sPickingBin,
   BS.QTYinBin,   
   SKU.sOriginalSource,
   SKU.sDescription,
   SMISKU.sOriginalSource,
   SMISKU.sDescription,
   SMISKU.mPriceLevel1,
   SMISKU.mLatestCost
   */
   
   
 --  select * from tblVendorSKU where ixSKU = '6051021'
 
 
 
 
 -- NOW GOING TO GET THE ITEMS AFCO OWNS THAT ARE STORED AT LINCOLN LOCATION 
SELECT 

   isnull(SMIV.ixVendor,' n/a') PrimVendorNum,    -- SMI info   
   isnull(SMIV.sName,' n/a')    COLLATE SQL_Latin1_General_CP1_CS_AS     PrimeVendor,      -- SMI info   
   BS.ixBin                     COLLATE SQL_Latin1_General_CP1_CS_AS     Bin              -- AFCO info OK
   ,BS.ixSKU
  -- SMIVS.ixSKU                  COLLATE SQL_Latin1_General_CP1_CS_AS     SKU,              -- SMI info  

from (select BS.ixSKU, BS.ixBin, BS.sPickingBin, SUM(BS.iSKUQuantity) QTYinBin, BS.ixLocation
              from [AFCOReporting].dbo.tblBinSku BS
                  join [AFCOReporting].dbo.tblBin B on BS.ixBin = B.ixBin
              where BS.ixBin = 'IOKDL'
                and BS.iSKUQuantity <> 0
                and BS.ixLocation = '68'
              GROUP BY BS.ixSKU, BS.ixBin, BS.sPickingBin, BS.ixLocation
              ) BS

   left join [AFCOReporting].dbo.vwSKULocalLocation SKU on SKU.ixSKU  = BS.ixSKU 
   -- NOW JOINING BACK TO SMI TABLES to get the SMI-specific details
   left join [AFCOReporting].dbo.tblVendorSKU SMIVS on SMIVS.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS = SKU.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS and SMIVS.iOrdinality = 1
-- SHOULD THIS BE....   left join tblVendorSKU SMIVS on SMIVS.ixSKU   INSTEAD?
   left join tblVendor SMIV on SMIVS.ixVendor COLLATE SQL_Latin1_General_CP1_CS_AS = SMIV.ixVendor COLLATE SQL_Latin1_General_CP1_CS_AS
group by   
   isnull(SMIV.ixVendor,' n/a'),
   isnull(SMIV.sName,' n/a'),
   BS.ixBin
,BS.ixSKU
   
   
 --  select * from tblVendorSKU where ixSKU = '6051021'
 
 select * from [AFCOReporting].dbo.tblVendorSKU where ixSKU = '1021'
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 


   