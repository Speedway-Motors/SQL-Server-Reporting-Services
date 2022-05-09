/* SKUs created in the last 12 months that we have multiple vendors from

   use one or two of these as examples for JEF so he can tell us how he would
   like the new report to handle them.
   
*/   

select SKU.ixSKU, COUNT(VS.ixVendor) VCount
from tblSKU SKU
join tblVendorSKU VS on SKU.ixSKU = VS.ixSKU
where SKU.dtCreateDate >= '04/24/2012'
and SKU.ixSKU NOT like 'UP%'
group by SKU.ixSKU
order by VCount Desc
/*
ixSKU	VCount
91084754	3
94037030	3
91014754	3
9103541-24.5	3
96065001	3
3165050	3
AUP2010	3
91099949.17	3
91032866-1.25.1	3
91801221.2	3
3000000	3
91004754	3
AUP1623	2
*/





select * 
from tblVendorSKU VS
join tblVendor V on VS.ixVendor = V.ixVendor
where ixSKU = '96065001'











