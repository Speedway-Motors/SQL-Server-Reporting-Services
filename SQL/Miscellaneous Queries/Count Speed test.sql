-- Count Speed testing
-- COUNT (*) vs COUNT(1)

select count(*) from tblSnapshotSKU -- 110,014,700 records in 320 sec = 343,795/sec (RAN 1ST)
select count(1) from tblSnapshotSKU -- 110,014,700 records in 370 sec = 297,337/sec

select count(1) from tblFIFODetail -- 76432932 records in 27 sec = 2,830,849/sec (RAN 1ST)
select count(*) from tblFIFODetail -- 76432932 records in 28 sec = 2,729,747/sec

select count(1) from tblSKUTransaction -- 23,276,239 records in 8 sec = 2,909,529/sec (RAN 1ST)
select count(*) from tblSKUTransaction -- 0

select count(*) from tblCustomerOffer -- 18,249,983 records in 2 sec = 9,124,991/sec (RAN 1ST)
select count(1) from tblCustomerOffer -- 18,249,983 records in 0 sec = ###/sec

select count(1) from tblOrderLine -- 12,442,794 records in 11 sec = 1,131,163/sec (RAN 1ST)
select count(*) from tblOrderLine -- 12,442,794 records in 0 sec = ###/sec


select * from tblTableSizeLog
where sRowCount >= 10000000
and dtDate >= '10/28/2013'
order by sRowCount desc

select *
from tblTableSizeLog
where sRowCount >= 10000000 -- 10m
and dtDate >= DATEADD(DD,-1,GETDATE())
order by sRowCount desc

/* LARGEST TABLES

sTableName	          sRowCount	KB	    MB	    dtDate
tblSnapshotSKU	    109,852,116	8020008	7,832   2013-10-28
tblFIFODetail	     76,245,283	3406208	3,326   2013-10-28
tblSKUTransaction	 23,276,239	3697600	3,610   2013-10-28
tblCustomerOffer	 18,249,983	1268144	1,238   2013-10-28
tblOrderLine	     12,441,928	1841720	1,798   2013-10-28

*/


