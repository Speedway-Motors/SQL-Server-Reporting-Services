-- SMIHD-17710 - AFCO - Invoice to Excel

SELECT * FROM tblPOMaster
where ixIssueDate >= 19160
-- ixPO = '892384'


select *
from tblSKU where ixSKU = 'MANAGERAPPROVAL' -- SHOULD THIS AND OTHER SKUs be excluded?
                                            -- WHAT about Kit Components?
select *
from tblSKU 
where flgActive = 1
    and flgIntangible = 1


-- query for rdl
SELECT O.ixOrder 'Invoice', 
    dtInvoiceDate 'InvoiceDate',            
    'N/A' as 'PONum',
    OL.ixSKU 'PartNumber',
    S.sDescription 'Description',
    OL.iQuantity 'Quantity',
    OL.mUnitPrice 'UnitPrice',
    OL.mExtendedPrice 'ExtendedPrice',
    OL.flgLineStatus
FROM tblOrder O
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
    left join tblSKU S on OL.ixSKU = S.ixSKU
WHERE O.ixOrder = '892384'
    and OL.flgLineStatus in ('Shipped','Dropshipped')
ORDER BY O.ixOrder, OL.iOrdinality




 
