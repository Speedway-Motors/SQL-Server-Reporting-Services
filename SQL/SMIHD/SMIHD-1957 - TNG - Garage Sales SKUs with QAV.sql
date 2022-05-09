/* TNG - Garage Sales SKUs with QAV
   RUN in TOAD on TNG
*/   
                SELECT distinct ixSOPSKU as 'ixSKU'
                -- , SV.iTotalQAV -- 9,712
                 -- ,M.sMarketName as 'ixMarket'
                FROM tblmarket M 
                   join tblskubasemarket SBM on M.ixMarket = SBM.ixMarket  
                   join tblskubase SB on SBM.ixSKUBase = SB.ixSKUBase 
                   join tblskuvariant SV on SB.ixSKUBase = SV.ixSKUBase 
                   inner join tblproductpageskubase PPSB on PPSB.ixSKUBase = SB.ixSKUBase
                   inner join tblproductpage PP on PP.ixProductPage = PPSB.ixProductPage
                WHERE 
                  SV.ixSOPSKU is not null 
                  and SV.iTotalQAV > 0
                      -- or
                      --  SV.flgBackorderable = 1)
                  and M.sMarketName = 'Garage Sale'
                  and SV.flgPublish = 1
                  and SB.flgWebPublish = 1
                  and PP.flgActive = 1
                ORDER BY SV.ixSOPSKU
