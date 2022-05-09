select count(*) QTY, ixCreator
from tblSKU
where dtCreateDate = '12/04/2012'
group by ixCreator
/*
QTY	ixCreator
156	CAF
5	DAS
5	DKS1
3	KDL
2	NJS
11	RDW
42	SAL
1	WAA1
*/


select VS.ixVendor, count(VS.ixSKU) QTY
from tblSKU SKU
    left join tblVendorSKU VS on SKU.ixSKU = VS.ixSKU
where dtCreateDate = '12/04/2012'
and ixCreator = 'CAF'
and VS.iOrdinality = 1
group by VS.ixVendor
/*
ixVendor	QTY
0493	    156
*/


select * from tblVendor where ixVendor = '0493'



select OL.*
from tblSKU SKU
   join tblOrderLine OL on SKU.ixSKU = OL.ixSKU
where SKU.dtCreateDate = '12/04/2012'
    and SKU.ixCreator = 'CAF'
    
    


    and ixSKU not in ('4911000','49120601') -- these 2 have sales    
    


update tblSKU
set flgDeletedFromSOP = 1
where ixSKU in (
select ixSKU
from tblSKU
where dtCreateDate = '12/04/2012'
    and ixCreator = 'CAF'
    and ixSKU not in ('4911000','49120601') -- these 2 have sales   
    )