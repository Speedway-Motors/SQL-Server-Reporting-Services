-- SMI REPORTING - AFCO VENDOR ACCOUNTS

-- USE BRANDS INSTEAD!!!!

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







-- VENDORS
SELECT ixVendor, sName 
from tblVendor
WHERE ixVendor IN ('0055','0106','0108','0111','0126','0133','0134','0136','0311','0313','0475','0476','0578','0582','9106','9311')

/*
    Vendor	sName
    0055	AMAZON-AFCO WHSE ITEMS
    0106	AFCO RACING
    0108	AFCO DROP.SHIP
    0111	AFAB SHOCKS
    0126	AFCO BUY BACK
    0133	DEWITTS RADIATOR
    0134	DEWITTS RADIATOR DROP.SHIP
    0136	AFAB LLC
    0311	DYNATECH
    0313	DYNATECH DROP.SHIP
    0475	LONGACRE AUTOMOTIVE
    0476	LONGACRE DROP.SHIP
    0578	PRO-FORMANCE SHOCKS DROP.SHIP
    0582	PRO-FORMANCE SHOCKS
    9106	AFCO-GS
    9311	DYNATECH-GS
*/
0106
0111
0133
0311
0475


-- possible other AFCO accounts to add?
SELECT ixVendor, sName 
from tblVendor
WHERE UPPER(sName) NOT LIKE '%GS%'
and UPPER(sName) NOT LIKE '%GARAGE%SALE%'
and ixVendor NOT IN ('0055','0106','0108','0111','0126','0133','0134','0136','0311','0313','0475','0476','0578','0582','9106','9311')-- <-- already using these accounts
AND (UPPER(sName) LIKE '%AFCO%'
    OR UPPER(sName) LIKE '%DYNAT%'
    OR UPPER(sName) LIKE '%AFAB%'
    OR UPPER(sName) LIKE '%PRO%SHO%'
    OR UPPER(sName) LIKE '%LONG%ACRE%'
    OR UPPER(sName) LIKE '%DEWIT%'
    )
/*
ix
Vendor	sName
0055	AMAZON-AFCO WHSE ITEMS
0111	AFAB SHOCKS
0136	AFAB LLC
*/

AFCO:
    0106
    0108
    0126
    9106
Dynatech:
    0311
    0313
    9311
Dewitts:
    0133
    0134
Longacre:
    0475
    0476
Pro-Shocks:
    0578
    0582


0055	AMAZON-AFCO WHSE ITEMS
0126	AFCO BUY BA
0136	AFAB LLC
9311	DYNATECH-GS

SELECT * FROM tblVendorSKU
where ixVendor in ('0055','0111','0136','0311','0313','9311')
and iOrdinality = 1


-- CUSTOMER ACCOUNTS
SELECT ixCustomer, sCustomerType, sMailToState, sCustomerFirstName, sCustomerLastName
FROM tblCustomer
where  UPPER(sCustomerFirstName) LIKE '%AFCO%'
    OR UPPER(sCustomerFirstName) LIKE '%DYNAT%'
    OR UPPER(sCustomerFirstName) LIKE '%AFAB%'
    OR UPPER(sCustomerFirstName) LIKE '%PRO%SHO%'
    OR UPPER(sCustomerFirstName) LIKE '%LONG%ACRE%'
    OR UPPER(sCustomerFirstName) LIKE '%DEWIT%'
    OR UPPER(sCustomerLastName) LIKE '%AFCO%'
    OR UPPER(sCustomerLastName) LIKE '%DYNAT%'
    OR UPPER(sCustomerLastName) LIKE '%AFAB%'
    OR UPPER(sCustomerLastName) LIKE '%PRO%SHO%'
    OR UPPER(sCustomerLastName) LIKE '%LONG%ACRE%'
    OR UPPER(sCustomerLastName) LIKE '%DEWIT%'
order by sCustomerType, sMailToState



