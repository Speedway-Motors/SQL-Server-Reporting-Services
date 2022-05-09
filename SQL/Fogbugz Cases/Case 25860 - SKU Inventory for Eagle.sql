-- Case 25860 - SKU Inventory for Eagle
select BS.ixSKU 'SKU', BS.iSKUQuantity 'Qty', S.sDescription 'SKU Description', S.mPriceLevel1 'PriceLvl1', --(BS.iSKUQuantity*mPriceLevel1) 'ExtPrice', 
    S.flgIntangible 'Intangible'
-- S.mMSRP 'MSRP',    ,BS.ixBin 'Bin', BS.sPickingBin 'PickingBin', BS.ixLocation 'Location'
from tblBinSku BS-- 1271
    left join tblSKU S on BS.ixSKU = S.ixSKU
where BS.ixLocation = '98'
    and iSKUQuantity <> 0
--and S.mPriceLevel1 <> S.mMSRP
AND BS.ixSKU in ('M3R1.00D.065H','94600-WELD','M2S2.0B.125H','910047-BLK.1','M2S1.25B.120H','M4R1.00N.02H','M2R1.375P.095H','M2R1.75P.095H','M2R1.25P.065H','M2R1.00P.065H')
order by S.flgIntangible,BS.ixSKU --BS.iSKUQuantity




select ixBin, COUNT(*)
from tblBinSku
where ixLocation = '98'
--and iSKUQuantity > 0
group by ixBin
order by COUNT(*) desc



select *
from tblBinSku
where ixLocation = '98'
--and iSKUQuantity > 0
and ixSKU in ('97610001') -- '9707107'

select * from tblSKUTransaction
where ixSKU in ('97610001') -- '9707107'
and ixDate = 17259
order by ixSKU, ixTime desc


