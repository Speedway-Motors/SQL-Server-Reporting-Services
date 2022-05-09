-- drop table tblKitList
select distinct K.ixKitSKU, dbo.GetRecentAverageKITCost(K.ixKitSKU) mAvgKitCost
into tblKitList 
from tblKit K



ALTER TABLE tblKitList ALTER COLUMN ixKitSKU 
            varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 

ALTER TABLE tblKitList ADD PRIMARY KEY (ixKitSKU);


select distinct(ixSKU)
from tblSKU
where flgIsKit = 1



ALTER TABLE tblKitList 
ADD dtLastUpdate DATETIME()
add dtLastUpdate Date

select * from tblKitList