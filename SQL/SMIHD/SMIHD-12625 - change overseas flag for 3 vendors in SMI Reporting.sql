-- SMIHD-12625 - change overseas flag for 3 vendors in SMI Reporting
-- 1914 should come off this list.
-- Two vendors to be added to the list: 1780 3280

SELECT ixVendor, flgOverseas
FROM tblVendor
where ixVendor in ('1914','1780','3280')
order by ixVendor
/* BEFORE

ix      flg
Vendor	Overseas
======  ========
1780	0
1914	1
3280	0

*/
        BEGIN TRAN
            UPDATE tblVendor
            set flgOverseas = 0
            WHERE ixVendor = '1914'
        ROLLBACK TRAN

        BEGIN TRAN
            UPDATE tblVendor
            set flgOverseas = 1
            WHERE ixVendor IN ('1780','3280')
        ROLLBACK TRAN

SELECT ixVendor, flgOverseas
FROM tblVendor
where ixVendor in ('1914','1780','3280')
order by ixVendor
/* AFTER

ix      flg
Vendor	Overseas
======  ========
1780	1
1914	0
3280	1

*/

