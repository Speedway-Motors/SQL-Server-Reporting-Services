-- FIFO questions for AFCO

select * from tblFIFODetail 
where ixSKU = '0000638.12' 
and ixDate between 17352 and 17379 -- period 7, 2015
order by ixDate
-- NO ROWS RETURNED

select MIN(ixDate) from tblFIFODetail 
where ixSKU = '0000638.12' -- 17614  03/22/2016

select * from tblDate 
where iPeriodYear = 2015 
and iPeriod = 7
order by ixDate
-- (17352 to 17379)


select MIN(ixDate) from tblFIFODetail -- 16318 (09/03/2012) oldest date in tblFIFODetail

select * from tblSKUTransaction
where ixSKU = '0000638.12'
order by ixDate -- 6/1/2015 first transaction


select * from tblDate where ixDate = 17509