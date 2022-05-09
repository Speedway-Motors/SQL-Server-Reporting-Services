-- SMIHD-15978 - Unconfirmed Purchase Orders

/* Unconfirmed Purchase Orders.rdl
   ver 50.1.19

DECLARE @Issuer varchar(10)
SELECT @Issuer = 'JTM'
*/

SELECT distinct POM.ixPO 'PO',    -- 1,229 open POs
    POM.ixIssuer 'Issuer',
    POM.ixVendor 'Vendor',
    V.sName 'VendorName',
    V.sPhone 'VendorPhone',
    V.s800Number 'Vendor800',
    V.sFax 'VendorFax',
    V.sInsideSalesContact 'InsideSalesContact',
    D.dtDate 'IssueDate',
    DATEDIFF(DAY,D.dtDate,  GETDATE()) 'Days WO Confirmation'
   -- POM.ixBuyer, POM.sPaymentTerms, POM.sFreightTerms, POM.flgBlanket, 
   -- POM.sMessage1, POM.sMessage2, POM.sMessage3,
   -- POM.ixLocation
FROM tblPOMaster POM
    left join tblPODetail POD on POM.ixPO = POD.ixPO
    left join tblVendor V on POM.ixVendor = V.ixVendor
    left join tblDate D on D.ixDate = POM.ixIssueDate
WHERE POM.flgOpen = 1
    and POM.flgIssued = 1
    and POM.ixPO in (-- PO has not received ANY qty
                     SELECT ixPO --, sum(iQuantityPosted) 'TotQtyPosted'
                     from tblPODetail 
                     group by ixPO
                     having sum(iQuantityPosted) = 0
                    )
    and ixVendorConfirmDate is NULL
    and ixIssuer in (@Issuer) -- 
        --    or ixIssuer = 'JDS'
 --   and POM.ixPO = '144360'
 --   and POM.ixPO in ('143397','143492') -- not confirmed
--and POM.ixPO in ('144267','144445') -- confirmed
order by ixIssuer DATEDIFF(DAY,D.dtDate,  GETDATE()) desc


/*
select distinct ixIssuer from tblPOMaster
where ixIssueDate >= 18264	--01/01/2018
AAI
ABS
ACO
AHH
AJBIII
BJB
BMB
CAK1
CCC
CGN
CRM
CWS
DGS
DWW
FWG
IDA
JDS
JMM
JTM
KDL
KRV
LJH
MAL2
NFT
NJS
RLT
RNK
SAH
SAL
VLJ
ZLW

LOGIC: 
    PO is flagged as Open  
    AND PO is issued
    AND PO has no Vendor Confirmation date
    AND PO is flagged as Open
    AND PO has 0 Posted Quantity
    AND Jason Martin is the issuer

*/

-- SELECT * FROM tblVendor where sInsideSalesContact is not null   838 

Potentail other fields:

Buyer
Payment Terms
Freight Terms
Blanket flag

ixVendo

select distinct POM.sMessage5 from tblPOMaster POM

