-- SMIHD-15852 - Harmonized Tariff Code rebate analysis

-- SKU, DESCRIPTION, VENDOR (s), HTC in SOP, SEMA categories

select S.ixSKU 'SKU',
    ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription',
    V.ixVendor 'Pv', 
    V.sName 'PV Name',
    S.ixHarmonizedTariffCode 'HTC',
    S.sSEMACategory 'Category',
    S.sSEMASubCategory 'SubCategory',
    S.sSEMAPart 'Part'
from tblSKU S
    left join tblVendorSKU VS on S.ixSKU = VS.ixSKU and VS.iOrdinality = 1
    left join tblVendor V on VS.ixVendor = V.ixVendor
where S.flgDeletedFromSOP = 0
    and V.ixVendor in ('1154','2404','2304','3290','3895','3896','1363','3238','3415','0099')
    and S.ixSKU in (select distinct ixSKU
                        from tblPOMaster PO
                            join tblPODetail PD on PO.ixPO = PD.ixPO
                        where PO.ixIssueDate >= 18181 -- '10/10/17'
                     )

select distinct ixVendor
from tblPOMaster PO
where ixIssueDate >= 18181 -- '10/10/17'
and flg

select * from tblDate where dtDate = '10/10/17'


SELECT * FROM tblVendor WHERE ixVendor in ('5023','5118','5558','5631','5727','5918','6125','6167','6361','6379','6458','6687','7448','7462','7484','7522','7551','7552','7556','7558','7561','7572','7573','7577','7582','7595','7615','7623','7624','7626','7628','7652','7657','7658','7668','7680','7692','7709','7711','7713','7717','7719','7766','8085')

-- AFCO
select S.ixSKU 'SKU',
    ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription',
    V.ixVendor 'Pv', 
    V.sName 'PV Name',
    S.ixHarmonizedTariffCode 'HTC'---,
 --   S.sSEMACategory 'Category',
 --   S.sSEMASubCategory 'SubCategory',
 --   S.sSEMAPart 'Part'
from tblSKU S
    left join tblVendorSKU VS on S.ixSKU = VS.ixSKU and VS.iOrdinality = 1
    left join tblVendor V on VS.ixVendor = V.ixVendor
where S.flgDeletedFromSOP = 0
    and V.ixVendor in ('5023','5118','5558','5631','5727','5918','6125','6167','6361','6379','6458','6687','7448','7462','7484','7522','7551','7552','7556','7558','7561','7572','7573','7577','7582','7595','7615','7623','7624','7626','7628','7652','7657','7658','7668','7680','7692','7709','7711','7713','7717','7719','7766','8085')
    and S.ixSKU in (select distinct ixSKU
                        from tblPOMaster PO
                            join tblPODetail PD on PO.ixPO = PD.ixPO
                        where PO.ixIssueDate >= 18181 -- '10/10/17'
                     )