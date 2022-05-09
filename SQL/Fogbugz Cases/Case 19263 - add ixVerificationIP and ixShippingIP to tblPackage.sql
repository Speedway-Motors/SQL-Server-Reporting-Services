-- Case 19263 - add ixVerificationIP and ixShippingIP to tblPackage

/***************************     SMI      ****************************************/

-- 
select count(*) from tblPackage                                     -- 1,857,285
select count(*) from tblPackage where ixVerificationIP is NOT NULL  --  6604
select count(*) from tblPackage where ixShippingIP is NOT NULL      --  6192
select count(*) from tblPackage where ixShippingIP is NOT NULL      --  6648
            OR ixVerificationIP is NOT NULL

select count(*) from tblPackage where dtDateLastSOPUpdate is NOT NULL      --           SOP is feeding 6,625

-- missing SOP update timestamps
select * from tblPackage 
where (ixShippingIP is NOT NULL      -- 6606
            OR ixVerificationIP is NOT NULL )
       AND dtDateLastSOPUpdate IS NULL
       
       
select * from tblErrorCode where sDescription like '%tblPackage%'  
--1149	Failure to update tblPackage
select * from tblErrorLogMaster
where ixErrorCode = '1149'
order by dtDate desc


select distinct   ixVerificationIP from tblPackage      -- 11 dif
select distinct   ixShippingIP from tblPackage  -- 5 dif

select ixVerificationIP, count(*)
from tblPackage where ixVerificationIP is NOT NULL
group by ixVerificationIP
192.168.240.29

select ixShippingIP, count(*)
from tblPackage where ixShippingIP is NOT NULL
group by ixShippingIP
192.168.240.34


select * from tblIPAddress
where ixIP in ('192.168.240.29','192.168.240.34')

select distinct   ixVerificationIP from tblPackage  




select * from tblPackage 
where ixShippingIP is NOT NULL      -- 6606
      AND ixVerificationIP is NULL
            
            
            
/***************************     AFCO      ****************************************/
select count(*) from tblPackage                                     -- 153,035
select count(*) from tblPackage where ixVerificationIP is NOT NULL  --  231
select count(*) from tblPackage where ixShippingIP is NOT NULL      -- 171
select count(*) from tblPackage where ixShippingIP is NOT NULL      -- 232
            OR ixVerificationIP is NOT NULL
            
select count(*) from tblPackage where dtDateLastSOPUpdate is NOT NULL      -- 232   

select * from tblPackage 
where (ixShippingIP is NOT NULL      -- none
            OR ixVerificationIP is NOT NULL )
       AND dtDateLastSOPUpdate IS NULL
       
       
select distinct   ixVerificationIP from tblPackage      -- 3 dif
select distinct   ixShippingIP from tblPackage          -- 3 dif

--Verification IPs
select ixVerificationIP, count(*)
from tblPackage where ixVerificationIP is NOT NULL
group by ixVerificationIP
/*
ixVerificationIP	(No column name)
172.18.1.241	48
172.18.1.242	147
172.18.1.243	36
*/

--Shipping IPs
select ixShippingIP, count(*)
from tblPackage where ixShippingIP is NOT NULL
group by ixShippingIP
/*
172.18.1.240	163
172.18.1.37	6
172.18.1.45	3
*/
     
     
select * from tblPackage 
where ixShippingIP is NOT NULL      -- 1
      AND ixVerificationIP is NULL               