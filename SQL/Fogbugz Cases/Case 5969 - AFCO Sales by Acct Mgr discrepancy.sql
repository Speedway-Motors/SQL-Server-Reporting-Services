select * from tblCustomer
where upper(sCustomerLastName) like '%SPEEDWAY%' -- 12410 Speedway ixCustomer

/*
Speedway- F-1007, F-1039, F-1040
Smiley's- F-1037 $3839.07
Motor State- F-1028 $13,818.33
*/
select * from tblCreditMemoMaster where ixCreditMemo in ('F-1007','F-1039','F-1040') 
/*
ixCreditMemo	ixCustomer	ixOrder	ixCreateDate	sOrderChannel	mMerchandise	sMemoType	dtCreateDate	        mMerchandiseCost	ixOrderTaker
F-1007	        10511	    FSCR	14981	        NULL        	70572.88	    Refund	    2009-01-05 00:00:00.000	NULL	            5TMH
F-1039	        10511	    FSCR	14981	        NULL	        178353.78	    Refund	    2009-01-05 00:00:00.000	NULL	            5TMH
F-1040	        10511	    FSCR	14981	        NULL	        9073.86	        Refund	    2009-01-05 00:00:00.000	NULL	            5TMH
*/
select * from tblCreditMemoMaster where ixCreditMemo in ('F-1037','F-1028') 
/*
ixCreditMemo	ixCustomer	ixOrder	ixCreateDate	sOrderChannel	mMerchandise	sMemoType	dtCreateDate	mMerchandiseCost	ixOrderTaker
F-1028	        10164	    FSCR	14981	        NULL	        13818.33	    Refund	2009-01-05 00:00:00.000	NULL	5TMH
F-1037	        10679	    FSCR	14981	        NULL	        3839.07	        Refund	2009-01-05 00:00:00.000	NULL	5TMH
*/

select * from tblCreditMemoDetail where ixCreditMemo in ('F-1007','F-1039','F-1040','F-1037','F-1028')


select CMM.ixCustomer,
                          SUM(CMD.iQuantityCredited) QTYCredited,
                          SUM(CMD.iQuantityCredited*CMD.mUnitPrice) ReturnsRev,
                          SUM(CMD.iQuantityCredited*CMD.mUnitCost) ReturnsCost,
                          SUM((CMD.mUnitPrice-CMD.mUnitCost)*CMD.iQuantityCredited) GP
                    from tblCreditMemoMaster CMM
                    
                        left join tblCreditMemoDetail CMD on CMD.ixCreditMemo = CMM.ixCreditMemo
                            and CMM.dtCreateDate >= '01/01/2010'
                            and CMM.dtCreateDate < '02/01/2010'
                        left join tblDate D on D.dtDate = CMM.dtCreateDate
                        left join tblCustomer C on C.ixCustomer = CMM.ixCustomer
                        -- innermost subselects - use report parameter filters here
                        where CMM.ixCustomer = '10511'
                                  --      isnull(C.ixAccountManager,'UNASSIGNED') in (@AccountManager)
                        
                    group by CMM.ixCustomer


select * from tblCreditMemoMaster
where mMerchandise <> (select

select * from tblCreditMemoDetail
where ixCreditMemo = 'F-5711' -- like 'F-%'

select sum(mMerchandise) 
from tblCreditMemoMaster
where ixCreditMemo not in (select ixCreditMemo from tblCreditMemoDetail)
and ixCreditMemo not like 'F-%'
and ixCreateDate > 15342


select sum(mMerchandise) MastPrice  -- 2,939,245.73
from tblCreditMemoMaster CMM
where ixCreateDate > 15342
  and ixCreditMemo in (select ixCreditMemo from tblCreditMemoDetail)

select sum(CMD.mUnitPrice*CMD.iQuantityCredited) DetailExtendedPrice  -- 2939245.681
from tblCreditMemoDetail CMD
    join tblCreditMemoMaster CMM on CMM.ixCreditMemo = CMD.ixCreditMemo
where CMM.ixCreateDate > 15342

select * from tblCreditMemoMaster



select CMM.ixCreditMemo, CMM.mMerchandiseCost, sum(CMD.iQuantityCredited*CMD.mUnitCost) 
from tblCreditMemoMaster CMM
    left join tblCreditMemoDetail CMD on CMD.ixCreditMemo = CMM.ixCreditMemo
group by CMM.ixCreditMemo, CMM.mMerchandiseCost
HAVING CMM.mMerchandiseCost <> sum(CMD.iQuantityCredited*CMD.mUnitCost)



select * from tblCreditMemoMaster

select CMM.*,CMD.* 
from tblCreditMemoMaster CMM
    left join tblCreditMemoDetail CMD on CMD.ixCreditMemo = CMM.ixCreditMemo
where CMM.ixCreditMemo = 'C-5655'

select * from tblCreditMemoMaster 
where ixCreditMemo = 'C-5655'

select * from tblCreditMemoDetail 
where ixCreditMemo = 'C-5655'



select sum(mMerchandise) from tblCreditMemoMaster
where ixCreditMemo not in (select ixCreditMemo from tblCreditMemoDetail)
and ixCreateDate > 15342



select * from tblSKUTransaction


SELECT *  
FROM ::fn_listextendedproperty (null, 'user', 'dbo', 'table', 
                                'tblDoorEvent', 'column', default) 


SELECT name  
FROM sysobjects  
WHERE id IN ( SELECT id FROM syscolumns WHERE upper(name) = 'IXSKU' ) 
ORDER BY name 


SELECT SC.*  
FROM sysobjects SO
    JOIN syscolumns SC ON 
WHERE SO.name = 'tblSKUTransaction' 


SELECT * FROM syscolumns


SELECT name  
FROM sysobjects  
ORDER BY NAME


SELECT TOP 20 * FROM tblSKUTransaction 
where ixDate >=15704
order by NEWid()

SELECT TOP 10 * FROM tblSKUTransaction
WHERE sToGID is not null

select sum(iQty*10) from tblSKUTransaction


select max(iSeq) from tblSKUTransaction



select min(dtDate), max(dtDate)
from tblSKUTransaction ST
    join tblDate D on D.ixDate = ST.ixDate
where ST.iSeq is NOT null
--  to 2010-12-29 = 17 months ... 256,549 transactions = 15k MO

select count(*) from tblSKUTransaction  -- 6,229,770 rows from last 12 months   = avg 520K rows/MO
where ixDate >= 15340
select count(*) from 

select count(distinct iSeq)
from tblSKUTransaction 
