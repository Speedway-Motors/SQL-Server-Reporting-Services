-- REFRESH CUSTOMER data

SELECT FORMAT(Records,'###,###,##0') 'Records', DaysOld, CONVERT(VARCHAR, GETDATE(), 102) 'As of' FROM vwDataFreshness
WHERE sTableName = 'tblCustomer' ORDER BY 'DaysOld'   
/*
Records   DaysOld As of
========= ======= ==========
    5,571	   <=1  2020.11.02
   13,929	   2-7
2,113,736	  8-30
  518,282	 31-180

6,259	   <=1    2020.10.05
15,770	   2-7
43,432	   8-30
1,045,285 31-180
1,520,152  181+

206,217	   <=1    2020.06.05
320,330	   2-7
53,292	  8-30
1,944,825 31-180


AFCO
Records   DaysOld As of
========= ======= ==========
59,453	   <=1	    2020.10.05



*/

    SELECT top 100000 -- approx 2k/min  10k/5min  25k/11 min   50k/21min  100k/45 min      
         --count(ixCustomer)
         ixCustomer, CONVERT(VARCHAR, dtDateLastSOPUpdate, 102) 'SOP_LU', ixTimeLastSOPUpdate  -- 749000
    FROM tblCustomer
    WHERE flgDeletedFromSOP = 0
        AND dtDateLastSOPUpdate < '06/11/2020'  --  77k   1,178,177 @10/30/18               
    ORDER BY dtDateLastSOPUpdate, 
        ixTimeLastSOPUpdate  -- 2020.06.02	66049	TO  2020.06.04	45803


SELECT count(*) FROM tblCustomer WHERE flgDeletedFromSOP = 1 -- 2,154,773       66,591 deleted

SELECT * from tblOrder where ixCustomer = 1541668

DELETE FROM tblCustomer where ixCustomer = 154166844

select * from tblMergedCustomers 
where ixCustomerOriginal = 1541668 or ixCustomerMergedTo = 1541668
-- SMI deleted customers   SET FLAGS

ixCustomerOriginal	ixCustomerMergedTo
888	782720


BEGIN TRAN
    UPDATE [SMI Reporting].dbo.tblCustomer
    SET flgDeletedFromSOP=1
    WHERE ixCustomer in ('2823250')
ROLLBACK TRAN

-- refeed and delete
1109965
1119864
2097574
1731213
2380461






dtDateLastSOPUpdate


BEGIN TRAN

UPDATE tblCustomer
set flgDeletedFromSOP = 1
where ixCustomer = '3588433'

ROLLBACK TRAN

