-- Case 19108 - analyze difs on SKUs Missing SEMA Categorization lists

-- Compare Channel Advisors list of SKUs Missing SEMA Categorizations to DWs



select count(ixSKU) from PJC_19108_SKUsMissingSEMAperChanAdv            -- 286
select count(distinct ixSKU) from PJC_19108_SKUsMissingSEMAperChanAdv   -- 286

select count(ixSKU) from PJC_19108_SKUsMissingSEMAperDW                 -- 1026 
select count(distinct ixSKU) from PJC_19108_SKUsMissingSEMAperDW        -- 1026


-- SKUs in CA list but not in DW list
select CA.ixSKU 'SKU',
       SKU.sSEMACategory,
       SKU.sSEMASubCategory,
       SKU.sSEMAPart,
       SKU.flgActive -- must = '1'
   --    ,SKU.flgIntangible, -- must = '0'
   --    ,SKU.flgDeletedFromSOP,
   --    ,DW.ixSKU 'DW SKU'
from PJC_19108_SKUsMissingSEMAperChanAdv CA
    left join [SMI Reporting].dbo.tblSKU SKU on CA.ixSKU = SKU.ixSKU
    left join PJC_19108_SKUsMissingSEMAperDW DW on CA.ixSKU = DW.ixSKU
where DW.ixSKU is NULL    
/*
91099949.2
60874665
93515118
UP33237
91802215-WIDE
9351010-83
91072010
UP33239
UP32630
9606214-RH
91072420
UP33158
UP32897
93585107
54544025.GS
91064530
42516051
9606210
93515401
91080325
UP33232
UP32903
10687002
UP26099
10621209X
9606214-LH
91061087
*/

-- SKUs in DW list but not in CA list
select CA.ixSKU 'CA SKU', -- 767
       SKU.sSEMACategory,
       SKU.sSEMASubCategory,
       SKU.sSEMAPart,
       SKU.flgActive,
       DW.ixSKU 'DW SKU'
from PJC_19108_SKUsMissingSEMAperDW DW
    left join [SMI Reporting].dbo.tblSKU SKU on DW.ixSKU = SKU.ixSKU
    left join PJC_19108_SKUsMissingSEMAperChanAdv CA on CA.ixSKU = DW.ixSKU
where CA.ixSKU is NULL  


94037026
/*not found on WEB site*/
100051
10620107
1370TPB
31179400945
45580024
5821000
72682700
9001010
97493113
A550070136
UP13500
UP32224
UP6411
UPSSAT

-- CH ADV. shows these SKUs as active... DW does not
select ixSKU, flgActive, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
from tblSKU
where ixSKU in ('10687002','42516051','60874665','91061087','91064530','91072010','91072420','91080325','91099949.2','93515118','93515401','93585107','10621209X','91802215-WIDE','9351010-83','UP26099')
order by dtDateLastSOPUpdate desc


