-- Case 15882 - add last touches to Parts Not Returned rpt
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
   'SMI'                      as 'Owner',
   T.sCID                     CID
from (select BS.ixSKU, BS.ixBin, BS.sPickingBin, SUM(BS.iSKUQuantity) QTYinBin
              from tblBinSku BS
                  join tblBin B on BS.ixBin = B.ixBin
              where BS.ixBin = 'LOST' /*(BS.ixBin = @Bin
                    OR (@Bin = 'IO%' and B.sBinType = 'LN' ))
                    */
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
   BS.QTYinBin,
   T.sCID
--order by BS.ixBin,  isnull(V.sName,' n/a'), BS.ixSKU


UNION ALL

-- NOW GOING TO GET THE ITEMS AFCO OWNS THAT ARE STORED AT LINCOLN LOCATION 
SELECT 
   isnull(SMIV.ixVendor,' n/a') PrimVendorNum,    -- SMI info   
   isnull(SMIV.sName,' n/a')    COLLATE SQL_Latin1_General_CP1_CS_AS     PrimeVendor,      -- SMI info   
   BS.ixBin                     COLLATE SQL_Latin1_General_CP1_CS_AS     Bin,              -- AFCO info OK
   SMIVS.ixSKU                  COLLATE SQL_Latin1_General_CP1_CS_AS     SKU,              -- SMI info  
   BS.sPickingBin               COLLATE SQL_Latin1_General_CP1_CS_AS     PickingBin,       -- AFCO info OK
   BS.QTYinBin,                                 -- AFCO info OK
   SMISKU.sOriginalSource       COLLATE SQL_Latin1_General_CP1_CS_AS     OriginalSource,   -- SMI info
   SMISKU.sDescription          COLLATE SQL_Latin1_General_CP1_CS_AS     Description,      -- SMI info
   SMISKU.mPriceLevel1          Retail,           -- SMI info
   SMISKU.mLatestCost           Cost,             -- SMI info   
   max(D.dtDate)                LastTransDate,     -- AFCO info OK
   'AFCO'                       as 'Owner',
   T.sCID                       COLLATE SQL_Latin1_General_CP1_CS_AS     CID
from (select BS.ixSKU, BS.ixBin, BS.sPickingBin, SUM(BS.iSKUQuantity) QTYinBin, BS.ixLocation
              from [AFCOReporting].dbo.tblBinSku BS
                  join [AFCOReporting].dbo.tblBin B on BS.ixBin = B.ixBin
              where BS.ixBin = 'LOST' /*(BS.ixBin = @Bin
                 OR (@Bin = 'IO%' and B.sBinType = 'LN' )) 
                 */                 
              --where (BS.ixBin in ('GOOD-WILL','CLAIM','CUST-RTN','RTV','SHOWRM','REVIEW','GARAGE','COUNTER','IOIT','IT','RCV','SOUTHDOCK','5A00A1','X00A1','Y00A1','Z00A1','BSOOA1','RETURN','LOST','LOSTNC')
              --      OR (BS.ixBin LIKE 'IO%' and B.sBinType = 'LN' ))
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
   left join tblVendorSKU SMIVS on SMIVS.sVendorSKU = SKU.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS and SMIVS.iOrdinality = 1
   left join tblVendor SMIV on SMIVS.ixVendor = SMIV.ixVendor
   left join tblSKU SMISKU on SMISKU.ixSKU = SMIVS.ixSKU
where VS.iOrdinality = 1
group by   
   isnull(SMIV.ixVendor,' n/a'),
   isnull(SMIV.sName,' n/a'),
   BS.ixBin,
   SMIVS.ixSKU,
   BS.sPickingBin,
   BS.QTYinBin,   
   SKU.sOriginalSource,
   SKU.sDescription,
   SMISKU.sOriginalSource,
   SMISKU.sDescription,
   SMISKU.mPriceLevel1,
   SMISKU.mLatestCost,
   T.sCID
   
   
   
   new subquery
Left Join on sCID
   SELECT INFO
   WHERE BIN <> "LOST"


select top 10 * from tblSKUTransaction


select sCID, ixSKU, sUser, 
    ixDate, ixTime,sTransactionType
from tblSKUTransaction
where --ixSKU = '6552801'
  --and sToBin <> 'LOST'
  --and 
  sCID = '164460'
order by ixDate desc, ixTime desc

sCID	sUser	ixDate	ixTime	sTransactionType
164460	BDR	16158	56235	T
164459	BDR	16158	56231	T


select count(distinct ixDate) from tblSKUTransaction -- 1,112 days in 

-- showing All the transactions for a specific TESTING SKU 
select sCID, sUser, ixDate, ixTime,sTransactionType
    ,sBin, sToBin
from tblSKUTransaction
where 
    ixDate >= 16100 and
     sToBin <> 'LOST'
    and ixSKU = '4912351'
    --and ixDate in (select ixDate, ixTime
    --                from tblSKUTransaction
    --                where sToBin <> 'LOST'
    --                    and sCID = '1302303'
    --                    and ixTime in (select maxsCID, sUser, ixDate, ixTime,sTransactionType
    --                                        ,sBin, sToBin
    --                                    from tblSKUTransaction
    --                                    where sToBin <> 'LOST'
    --                                        and sCID = '1302303'
    --                                   )
    --                group by ixTime    
    --                order by ixDate desc, ixTime Desc
    --                )

order by ixDate desc, ixTime Desc
/*
sCID	sUser	ixDate	ixTime	sTransactionType	sBin	sToBin

*/

select top 1
ixDate, ixTime
from tblSKUTransaction
where sToBin <> 'LOST'
    and sCID = '4912351'
order by ixDate desc, ixTime desc    

group by sCID, sUser


  --and ixSKU = '91066300'
  --and sToBin = 'LOST'
  --and sCID = '164460'
order by ixDate desc, ixTime desc


select * from tblSKUTransaction
where sCID = '1054663'
order by ixDate desc, ixTime