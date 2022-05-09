-- SMIHD-15487 - Credit Memos missing Business Unit values

-- missing BU

SELECT D.iYear, FORMAT(count(*),'###,###') 'CMcount', FORMAT(getdate(),'yyyy.MM.dd HH:mm') 'AsOf'
from tblCreditMemoMaster CMM
    left join tblDate D on CMM.ixCreateDate = D.ixDate
where ixBusinessUnit is NULL -- 428,165
group by D.iYear
order by D.iYear desc
/*
iYear	CMcount	AsOf
=====   ======= ================
2016	92	    2019.10.22 09:37
2006	16,259	2019.10.22 09:37
*/


 select ixCreditMemo, ixCreateDate -- 163,351 in the file. The first 92 have create date of 12-30-2016.  All the rest are from 2016.
 from tblCreditMemoMaster
 where ixBusinessUnit is NULL
 order by ixCreateDate desc


select sum(mMerchandise) -- distinct ixOrder
from tblCreditMemoMaster
where ixBusinessUnit is NULL
and ixCreateDate between 17533 and 17899

 


-- 90 orders from the CMs with no Business Unit
select ixBusinessUnit, count(*)
from tblOrder where ixOrder in ('7219006','6808394','6874894','7137508','7143807','7296601','6241799','6490896','6864692','6876995','7018706','7107106','6206585','6581781','7121102','7293503','7329107','6720546','7164608','7266304','7378008','7013309','7020101','7109309','7140800','7136805','7192505','7341105','6617994','7026508','7103804','7169101','7257308','7281105','6813799','7039408','7132303','7274706','7214905','7274406','7349103','7381008','6779498-1','7032602','7052804','7223909','7350001','6998097-1','7006407','7329103','7153200','7165800','7362005','6620599','6860390','6921192','7161208','7228903','6671157','6805293','7189108','7266702','7215103','7262007','6208265','6425993','6909199','6953799','7046406','7062704','7098501','7110600','7212705','6366099','7103407','7143501','7166804','7167802','7323108','FSCR','6525999','6833894','6848591','6889298','6890090','6923196','7075203','7087909','7153709','7205107','7275609')
group by ixBusinessUnit






-- mMerchandiseReturnedCost
SELECT FORMAT(COUNT(*) ,'###,###') 'CMCnt' -- 487,067 NOT NULL
FROM tblCreditMemoMaster
where mMerchandiseReturnedCost is NULL -- 11,293   



-- flgCounter 100% populated
SELECT FORMAT(COUNT(*) ,'###,###') 'CMCnt' 
FROM tblCreditMemoMaster
where flgCounter is NULL --    0 NULL



SELECT FORMAT(count(*),'###,###') 'CMcount' -- 11,293   all others have updated since 10/14/19
from tblCreditMemoMaster
where dtDateLastSOPUpdate is NULL
order by ixCreateDate -- 14257 to 15305


