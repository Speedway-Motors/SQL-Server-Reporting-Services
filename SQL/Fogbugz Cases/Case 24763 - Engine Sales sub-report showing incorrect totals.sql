-- Case 24763 - Engine Sales sub-report showing incorrect totals


select ixOrder, ixSKU, mExtendedPrice 
from tblOrderLine 
where ixSKU in ('12100001','12100300','12100900','12100910','91619258602','UPGS.00245','UPGS.00246','UPGS.00247')


select * from tblOrder 
where ixOrder in (  select distinct(ixOrder) 
                    from tblOrderLine 
                    where ixSKU in ('12100001','12100300','12100900','12100910','91619258602','UPGS.00245','UPGS.00246','UPGS.00247'
                    )
                    
                    
                    
                    
                    
                    
                    