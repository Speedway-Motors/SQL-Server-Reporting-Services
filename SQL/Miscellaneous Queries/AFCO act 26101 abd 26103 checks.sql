USE [AFCOReporting]

-- ORDERS
select O.ixCustomer, 
    count(distinct O.ixOrder) OrdCount, 
    count(OL.ixOrder) OLCount,
    sum (O.mMerchandise) OSales,
    sum (OL.mExtendedPrice) OLSales,
    getdate() 'RunDate'
from tblOrder O
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
where O.ixCustomer in ('26101', '26103')    
group by O.ixCustomer
order by O.ixCustomer
/*
ixCustomer	OrdCount	OLCount OSales	    OLSales     RunDate
26101	    5,362	    6,754	?           ?           2013-09-12 16:25:45.497
26101	    5,386	    6,778	970,514     492,885     2013-12-18 08:02:42.340


26103	    31,725	    38,119	?           ?           2013-09-12 16:25:45.497
26103	    34,200	    41,561	4,695,853   2,377,828   2013-12-18 08:02:42.340

*/

-- CREDIT MEMOS
select ixCustomer, count(*) CMCount, sum(mMerchandise) Merch,
    getdate() 'RunDate'
from tblCreditMemoMaster 
where ixCustomer in ('26101', '26103') 
group by ixCustomer   -- if 0 results... error report
/*
ixCustomer	CMCount	Merch       RunDate
26103	    1224    ?           2013-09-12 16:25:45.497
26103	    1341	127579.09   2013-12-18 08:05:13.087

26101       0     <-- there should never be ANY for this account
*/

select count(CMM.ixCreditMemo) 
from tblCreditMemoMaster CMM
    left join tblCreditMemoDetail CMD on CMM.ixCreditMemo = CMD.ixCreditMemo
     where CMM.ixCustomer = '26101' -- should be zero
select count(CMM.ixCreditMemo) 
from tblCreditMemoMaster CMM
    left join tblCreditMemoDetail CMD on CMM.ixCreditMemo = CMD.ixCreditMemo
     where CMM.ixCustomer = '26103' -- 1,479 @9-19-2013


select sum(mExtendedPrice) from tblOrderLine where ixCustomer = '26103'     -- $2,163,569 @9-12-2013
select sum(mExtendedPrice)  from tblOrderLine where ixCustomer = '26101'    -- $  489,571 @9-12-2013


select min(dtOrderDate) from tblOrderLine where ixCustomer in ( '26101','26103') -- 2011-09-17 


 
