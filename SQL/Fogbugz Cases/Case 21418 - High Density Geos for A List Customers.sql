-- Case 21418 - High Density Zips for 12M 6+ $1,000+ Customers

-- pull all three segments, 
-- merge & dedupe customer #'s
-- import to [SMITemp].dbo.PJC_21418_CustomerAListZips
 EXEC spCSTSegmentPull 12,'1','6000','R','R' -- 1,704 @3-11-14   
 EXEC spCSTSegmentPull 12,'1','6000','SR','SR' -- 2,394   
 EXEC spCSTSegmentPull 12,'1','6000','B','B'    
 
 select count(*) from [SMITemp].dbo.PJC_21418_CustomerAListZips -- 4,106

-- update zips
UPDATE A 
set sMailToZip = C.sMailToZip -- 4,106
from [SMITemp].dbo.PJC_21418_CustomerAListZips A
 join tblCustomer C on A.ixCustomer = C.ixCustomer
 
-- counts by Zip 
 select top 50 substring(sMailToZip,1,5) Zip, count(*) Qty
 from [SMITemp].dbo.PJC_21418_CustomerAListZips
 group by sMailToZip
 order by count(*) desc
 
-- counts by SCF 
 select top 50 substring(sMailToZip,1,3) SCF, count(*) Qty
 from [SMITemp].dbo.PJC_21418_CustomerAListZips
 group by substring(sMailToZip,1,3)
 order by count(*) desc


UPDATE A 
set sMailToState = C.sMailToState -- 4,106
from [SMITemp].dbo.PJC_21418_CustomerAListZips A
 join tblCustomer C on A.ixCustomer = C.ixCustomer
 
-- counts by State
 select top 10 sMailToState, count(*) Qty
 from [SMITemp].dbo.PJC_21418_CustomerAListZips
 group by sMailToState
 order by count(*) desc

 
 
 select * from [SMITemp].dbo.PJC_21418_CustomerAListZips