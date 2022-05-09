-- AFCO inventory at LNK

SELECT * FROM tblBrand
where (UPPER(sBrandDescription) LIKE '%AFCO%'
    OR UPPER(sBrandDescription) LIKE '%DYNAT%'
    OR UPPER(sBrandDescription) LIKE '%AFAB%'
    OR UPPER(sBrandDescription) LIKE '%PRO%SHO%'
    OR UPPER(sBrandDescription) LIKE '%LONG%ACRE%'
    OR UPPER(sBrandDescription) LIKE '%DEWIT%'
    )
/*
ixBrand	sBrandDescription
10022	Pro Shocks
10038	AFCO
10066	Dynatech
10137	Longacre
11515	DeWitts
*/



-- Inventory by BRAND
SELECT B.ixBrand 'Brand', B.sBrandDescription 'Description', count(SL.ixSKU) SKUsWithQAV
FROM tblSKULocation SL
    left join tblSKU S on SL.ixSKU = S.ixSKU and SL.ixLocation = 99
    left join tblBrand B on S.ixBrand = B.ixBrand
WHERE S.ixBrand in ('10022','10038','10066','10137','11515')
    and SL.iQAV > 0
GROUP BY B.ixBrand, B.sBrandDescription
ORDER BY B.sBrandDescription
/*                  SKUs
                    WithQAV
Brand	Description	@LNK
=====   =========== =======
10038	AFCO	    3,271
11515	DeWitts	    63
10066	Dynatech	189
10137	Longacre	589
10022	Pro Shocks	1,084
*/




AFCO POs as of 3-30-2020 

Dewitts     147126
AFCO        147201
Dynatech    147202
AFAB Shocks 147206
Longacre    146903,147240,147073

SELECT ixVendor, ixPO from tblPOMaster where ixPO in ('146903','147073','147126','147201','147202','147206','147240')

SELECT ixPO, count(ixSKU), count(distinct ixSKU)
from tblPODetail
where ixPO in ('146903','147073','147126','147201','147202','147206','147240')
group by ixPO

SELECT POM.ixPO 'PO', 
--V.sName 'Vendor', 
POD.ixSKU 'SMISKU', VS.sVendorSKU 'AFCOSKU', POD.iQuantity 'Qty', POD.mCost,
    ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription'
    ,VS.ixVendor
FROM tblPOMaster POM
    LEFT JOIN tblPODetail POD on POM.ixPO = POD.ixPO
    LEFT JOIN tblVendor V on POM.ixVendor = V.ixVendor
    LEFT JOIN tblSKU S on S.ixSKU = POD.ixSKU
    LEFT JOIN tblVendorSKU VS on S.ixSKU = VS.ixSKU and VS.iOrdinality = 1
WHERE V.ixVendor = '0475'and ixFirstReceivedDate >= 19079
ORDER BY POM.ixPO, POD.ixSKU




SELECT VS.ixVendor 'Vendor', V.sName 'VendorName', count(SL.ixSKU) SKUsWithQAV
FROM tblSKULocation SL
    left join tblSKU S on SL.ixSKU = S.ixSKU and SL.ixLocation = 99
    left join tblVendorSKU VS on S.ixSKU = VS.ixSKU and VS.iOrdinality = 1
    left join tblVendor V on VS.ixVendor = V.ixVendor
WHERE VS.ixVendor in ('0055','0106','0108','0111','0126','0133','0134','0136','0311','0313','0475','0476','0578','0582','9106','9311')
    and SL.iQAV > 0
GROUP BY VS.ixVendor, V.sName
ORDER BY V.sName
/*                                      SKUs
Vendor	VendorName	                    WithQAV
0136	AFAB LLC	                    1
0111	AFAB SHOCKS	                    668
0108	AFCO DROP.SHIP	                15
0106	AFCO RACING	                    1449
9106	AFCO-GS	                        20
0133	DEWITTS RADIATOR	            31
0134	DEWITTS RADIATOR DROP.SHIP	    1
0311	DYNATECH	                    123
0475	LONGACRE AUTOMOTIVE	            505
0476	LONGACRE DROP.SHIP	            2
0582	PRO-FORMANCE SHOCKS	            153
0578	PRO-FORMANCE SHOCKS DROP.SHIP	6
*/



/*