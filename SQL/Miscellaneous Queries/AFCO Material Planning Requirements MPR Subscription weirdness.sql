-- AFCO Material Planning Requirements MPR Subscription weirdness

-- all buyers for SKUs
SELECT DISTINCT V.ixBuyer
FROM tblVendor V
    LEFT JOIN tblVendorSKU VS ON VS.ixVendor = V.ixVendor
    LEFT JOIN tblSKU S on VS.ixSKU = S.ixSKU 
WHERE VS.iOrdinality = 1 
    and S.flgDeletedFromSOP = 0
ORDER BY V.ixBuyer
/* complete list of buyers as of 8-23-21

NULL <- doesn't show up in report dropdown
5AAW
5BAB
5KDL
5LAL
5RJM
5SRP
5VLJ
BMB
CGC
ELJ
GSA
KLB
KMB
KMH
LMC1
MQK
MRB
SAC
SAC2
SQC
*/

SELECT DISTINCT V.ixBuyer, V.ixVendor 
FROM tblVendor V
    LEFT JOIN tblVendorSKU VS ON VS.ixVendor = V.ixVendor
    LEFT JOIN tblSKU S on VS.ixSKU = S.ixSKU 
WHERE VS.iOrdinality = 1 
    and S.flgDeletedFromSOP = 1
    and V.ixBuyer = 'GSA'
ORDER BY V.ixBuyer

select * from tblEmployee
where ixEmployee = 'BMB'

select * from tblVendor where ixBuyer = 'BMB'



select ixBuyer
from tblSKU
where flgDeletedFromSOP = 0

select * from tblVendor


SELECT DISTINCT V.ixBuyer
FROM tblVendor V
    LEFT JOIN tblVendorSKU VS ON VS.ixVendor = V.ixVendor
    LEFT JOIN tblSKU S on VS.ixSKU = S.ixSKU 
WHERE VS.iOrdinality = 1 
   and S.flgDeletedFromSOP = 0
ORDER BY V.ixBuyer

SELECT * from tblEmployee
where ixEmployee in ('5AAW','5BAB','5KDL','5LAL','5RJM','5SRP','5VLJ','BMB','CGC','ELJ','GSA','KLB','KMB','KMH','LMC1','MQK','MRB','SAC','SAC2','SQC')
order by flgCurrentEmployee, ixEmployee

select VS.*
FROM tblVendor V
    LEFT JOIN tblVendorSKU VS ON VS.ixVendor = V.ixVendor
  --  LEFT JOIN tblSKU S on VS.ixSKU = S.ixSKU 
WHERE VS.iOrdinality = 1 
and V.ixBuyer is NULL

select * from tblVendor V
where ixBuyer is NOT NULL




SELECT V.ixBuyer, VS.iOrdinality, VS.ixVendor, V.sName -- V.ixBuyer
FROM tblVendor V
    LEFT JOIN tblVendorSKU VS ON VS.ixVendor = V.ixVendor
    LEFT JOIN tblSKU S on VS.ixSKU = S.ixSKU 
WHERE VS.iOrdinality = 1 
   and S.flgDeletedFromSOP = 0
   and V.ixBuyer is NULL
ORDER BY V.ixBuyer

select S.*
from tblSKU S
    left join tblVendorSKU VS on VS.ixSKU = S.ixSKU and VS.iOrdinality = 1
where VS.ixVendor = '5556'

select * from tblOrderLine where ixSKU = '100228'
order by dtOrderDate desc



