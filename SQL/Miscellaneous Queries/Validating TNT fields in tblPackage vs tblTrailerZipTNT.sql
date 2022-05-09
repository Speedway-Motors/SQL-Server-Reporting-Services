-- Validating TNT fields in tblPackage vs tblTrailerZipTNT
select SM.ixShipMethod, SM.ixCarrier, sDescription 'MoS', count(P.sTrackingNumber) PkgCnt
from tblOrder O
    join tblPackage P on O.ixOrder = P.ixOrder
    join tblShipMethod SM on SM.ixShipMethod = O.iShipMethod
where O.dtShippedDate >= '01/01/2014'
and P.ixShipTNT = 0
and iShipMethod IN (3,4)
group by SM.ixShipMethod, SM.ixCarrier,SM.sDescription
order by SM.ixShipMethod


-- Validating TNT fields in tblPackage vs tblTrailerZipTNT
select O.iShipMethod, SM.ixCarrier, sDescription 'MoS', count(P.sTrackingNumber) PkgCnt
from tblOrder O
    join tblPackage P on O.ixOrder = P.ixOrder
    join tblShipMethod SM on SM.ixShipMethod = O.iShipMethod
where O.dtShippedDate >= '01/01/2014'
and P.ixShipTNT = 0
and iShipMethod IN (3,4)
group by O.iShipMethod, SM.ixCarrier,SM.sDescription
order by O.iShipMethod

select * from tblOrderRouting where ixTrailer IN ('OGP','OGF')

count(P.sTrackingNumber) desc



select ixOrder, dtDateLastSOPUpdate
from tblOrderRouting
where ixOrder in ('5328364','5328365','5328366')


dtDateLastSOPUpdate = '05/01/2014'




select * from vwDataFreshness
where sTableName = 'tblOrderRouting'
order by DaysOld

select COUNT(*)
from tblOrder
where dtOrderDate >= '05/01/2014'

select ixOrder from tblOrder
where dtDateLastSOPUpdate is NULL
and dtOrderDate >= '07/01/2011'




select SM.ixShipMethod, SM.ixCarrier, sDescription 'MoS', count(P.sTrackingNumber) PkgCnt
from tblOrder O
    join tblPackage P on O.ixOrder = P.ixOrder
    join tblShipMethod SM on SM.ixShipMethod = O.iShipMethod
where O.dtShippedDate >= '01/01/2014'
and P.ixShipTNT = 0
and iShipMethod NOT in (1,6,8,10,11,12,18,19,26,27)
group by SM.ixShipMethod, SM.ixCarrier,SM.sDescription
order by SM.ixShipMethod


select * from tblShipMethod


-- DROP table [SMITemp].dbo.PJC_Pkg_TNT_verification

select P.sTrackingNumber, P.ixOrder, O.sShipToZip, O.iShipMethod, P.ixTrailer, P.ixShipTNT 'PkgTNT', NULL AS 'TZTNT'-- TZ.iTNT 'TZTNT',
--(P.ixShipTNT - TZ.iTNT) 'Delta'
into [SMITemp].dbo.PJC_Pkg_TNT_verification
from tblOrder O
    join tblPackage P on O.ixOrder = P.ixOrder
   -- left join tblTrailerZipTNT TZ on O.sShipToZip = TZ.ixZipCode
  --  join tblShipMethod SM on SM.ixShipMethod = O.iShipMethod
--where O.dtShippedDate between '05/01/2014' and '05/14/2014'
where O.dtShippedDate >= '01/01/2014'-- and '05/14/2014'
and iShipMethod IN (3,4) --NOT in (1,6,8,10,11,12,18,19,26,27)

update PV 
set TZTNT = B.iTNT
from [SMITemp].dbo.PJC_Pkg_TNT_verification PV
 join tblTrailerZipTNT B on PV.ixTrailer = B.ixTrailer and PV.sShipToZip = B.ixZipCode 


select ixTrailer, COUNT(*) 'Deltas'
from [SMITemp].dbo.PJC_Pkg_TNT_verification -- 26,953
where ixTrailer is NOT NULL -- 24,873
and (PkgTNT is NULL
    or TZTNT is NULL
    or PkgTNT <> TZTNT)
and PkgTNT > 0
group by ixTrailer
order by ixTrailer
/*
OMH	267
OMN	41
OMS	21
*/    

select ixTrailer, COUNT(*) 'Deltas'
from [SMITemp].dbo.PJC_Pkg_TNT_verification -- 26,953
where ixTrailer is NOT NULL -- 24,873
and (PkgTNT is NULL
    or TZTNT is NULL
    or PkgTNT <> TZTNT)
and PkgTNT = 0
group by ixTrailer
order by ixTrailer

select ixTrailer, COUNT(*) 'NODeltas'
from [SMITemp].dbo.PJC_Pkg_TNT_verification -- 26,953
where ixTrailer is NOT NULL -- 24,873
and PkgTNT =TZTNT
group by ixTrailer
/*
ixTrailer	NODeltas
OMH	7
OMN	2
OMS	14
*/
    
select * from [SMITemp].dbo.PJC_Pkg_TNT_verification 
/*
DELTAS
    BEFORE  NOW
KC	9       9
OMH	152     199
DEN	152     152
LNK	81      81
OMN	35      39
OMS	3271    3275
*/

select * from tblTrailerZipTNT
where ixZipCode = '72111' and ixTrailer ='OMS'

                                                        tblPackage  tblTrailerZipTNT    
sTrackingNumber	    ixOrder	sShipToZip	ixTrailer	    TNT	        TNT                 Delta
==================  ======= ==========  =========       ==========  ================    =====
1Z6353580327710809	5392464	99518	    OMH	            4	        6	                -2
1Z6353580327710818	5392464	99518	    OMH	            4	        6	                -2
1Z6353580327717660	5390566	48834	    OMS	            3	        1	                2
1Z6353580327835765	5496762	49112	    OMS	            3	        1	                2
1Z6353580327840375	5495860	49450	    OMS	            3	        1	                2

select iTNT from tblTrailerZipTNT where ixTrailer = 'OMH' and ixZipCode = '99518'



select MAX(dtDateLastSOPUpdate) from 


select * from vwDataFreshness
where sTableName = 'tblTrailerZipTNT'



select * from tbl



select * from [SMITemp].dbo.PJC_Pkg_TNT_verification
where ixTrailer = 'OMS'


select distinct dtDateLastSOPUpdate from tblTrailerZipTNT

select COUNT(*) from tblTrailerZipTNT where dtDateLastSOPUpdate = '03/14/14'


dtDateLastSOPUpdate


128,406

select * from tblTrailerZipTNT
where ixTrailer = 'OMS'

drop table [SMITemp].dbo.PJC_zip_varchar_vs_int_test
select '00210' as ixZipCode into [SMITemp].dbo.PJC_zip_varchar_vs_int_test

select * from [SMITemp].dbo.PJC_zip_varchar_vs_int_test


select sTrackingNumber
from tblPackage
where ixOrder in (
select ixOrder from tblOrder O
where O.dtShippedDate >= '01/01/2014'
and iShipMethod IN (3,4)
)
I mi



select count(*) from tblPackage
where ixOrder in (select ixOrder from tblOrder 
                  where dtShippedDate >= '01/01/2014' -- 203,189
                  and sOrderStatus = 'Shipped'
                  and iShipMethod)       -- 264372
and ixTrailer is NOT NULL                             -- 227492




select count(*) from tblPackage
where ixOrder in (select ixOrder from tblOrder 
                  where dtShippedDate >= '01/01/2014' -- 203,189
                  and sOrderStatus = 'Shipped'
                  and iShipMethod)       -- 264372
and ixTrailer is NOT NULL       



select O.iShipMethod, count(P.sTrackingNumber) PkgCnt
from tblOrder O 
    join tblPackage P on O.ixOrder = P.ixOrder
where  O.dtShippedDate between '01/01/2014' and '05/19/2014' -- 203,189
  and O.sOrderStatus = 'Shipped'          
-- and P.ixTrailer is NULL
group by O.iShipMethod
order by O.iShipMethod

  