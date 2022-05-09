-- SMIHD-15945 - EMI kit report

select KL.* 
from tblKit K
left join tblKitList KL on K.ixKitSKU = KL.ixKitSKU


select * from tblSKU

I need a master list of all kits containing labor from EMi. This looks like all kits will be tied to vendor 1410 but that might only catch the majority and not all. Here are a few examples of skus to look at:

96621210
98611146
98611141
94612220
96621244

-- We are needing to switch all kits containing labor to BOM's. We are hoping to get this master list as soon as possible.

select * from tblSKU
where ixSKU in ('96621210','98611146','98611141','94612220','96621244')

select * from tblKit
where ixKitSKU in ('96621210','98611146','98611141','94612220','96621244')
    or ixSKU in  ('96621210','98611146','98611141','94612220','96621244')
