select * 
from tblVendor where upper(sName) like '%Q%'
order by sName


select flgKitComponent, sum(OL.mExtendedCost) Sales
from tblOrder O
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder -- 1,060,340.799
    left join tblVendorSKU VS on OL.ixSKU = VS.ixSKU
where VS.ixVendor in ('9111','2602','0255')
and O.dtShippedDate between '12/01/2012' and '11/30/2013'
and OL.flgLineStatus in ('Shipped','Dropshipped')
group by flgKitComponent


select distinct flgLineStatus
from tblOrderLine

VPH
=======
V#	    V Name				        12mo NON-Kit	12mo Kit	
2602	QA1 PRECISION PRODUCTS INC	$144,300	    $334,637	
0255	QA1 PRECISION PRODUCTS INC	$148,605	    $385,186	

9111	QA1 PRECISION PRODUCTS		 $16,023	    $17,269



in ('mExtendedCost')        


select distinct ixSKU 
into [SMITemp].dbo.PJC_QA1
from tblVendorSKU where ixVendor in ('9111','2602','0255') -- 3,041 SKUs
