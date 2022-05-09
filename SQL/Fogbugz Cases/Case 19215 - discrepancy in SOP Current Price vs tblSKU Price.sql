-- Case 19215 - discrepancy in SOP Current Price vs tblSKU Price

-- Drop table PJC_19215_SOPPrices
                                                        -- 149,985
select count(*) from PJC_19215_SOPPrices                -- 149,985
select count(distinct ixSKU) from PJC_19215_SOPPrices   -- 149,985



select SOP.*,
    mPriceLevel1, 
    ixPGC, sDescription, 
    dtCreateDate, 
    dtDiscontinuedDate, 
    sBaseIndex, 
    dWeight, 
    sOriginalSource, 
    --flgAdditionalHandling, ixBrand, ixOriginalPart, ixHarmonizedTariffCode, 
    flgIsKit, iLength, iWidth, iHeight, 
    flgShipAloneStatus, flgIntangible, 
    ixCreator, iLeadTime, 
    sSEMACategory, sSEMASubCategory, sSEMAPart, 
    flgMadeToOrder, ixForecastingSKU, flgDeletedFromSOP, 
    iMinOrderQuantity, sWebUrl, sWebImageUrl, sWebDescription, 
    sCountryOfOrigin, sAlternateItem1, sAlternateItem2, sAlternateItem3, 
    flgBackorderAccepted, dtDateLastSOPUpdate, ixTimeLastSOPUpdate, ixReasonCode, 
    sHandlingCode, ixProductLine, mMSRP
from PJC_19215_SOPPrices SOP
left join [SMI Reporting].dbo.tblSKU S on S.ixSKU = SOP.ixSKU
where 
SOP.Price <> S.mPriceLevel1
/*
and
SOP.ixSKU in ('91023103',
'91011209',
'91011203',
'3251801',
'3251802',
'3251803',
'3257183',
'69880604',
'69870054',
'3252999',
'3251126',
'91044145',
'91044095',
'25510-275',
'3252975',
'3252921',
'57523411',
'930FR100C',
'97415987')
*/
and S.flgDeletedFromSOP = 0
order by S.mPriceLevel1 
/*

            Export  tblSKU          SOP     SOP
ixSKU	    SOP	    mPriceLevel1    LP      CP
91802843	25.99	19.99           19.99   19.99
AUP2270	    49.99	99.99           156.99  99.99           
91055190	135.99	99.99           135.99  99.99
UP33719	    224.99	179.99          224.99  179.99


*/

select * from 