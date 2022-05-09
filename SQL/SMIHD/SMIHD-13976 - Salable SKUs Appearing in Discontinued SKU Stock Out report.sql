-- SMIHD-13976 - Salable SKUs Appearing in Discontinued SKU Stock Out report
--      VARIOUS QUERY RESULTS AND NOTES WERE PUT IN 
--          "SMIHD-13976 - findings for Salable SKUs Appearing in Discontinued SKU Stock Out report.xlsx"


-- Discontinued SKU Stock Out.rdl
/* ver 19.20.1
DECLARE @TodayixDate int,   @YdayixDate int

SELECT @TodayixDate = (SELECT D.ixDate 'TodayixDate'
                       FROM tblDate D
                       WHERE D.dtDate = FORMAT(getdate(),'MM/dd/yyyy') 
                       ),
        @YdayixDate = (@TodayixDate-1)
*/
SELECT DISTINCT SSToday.ixSKU 'SKU', 
    FORMAT(S.dtDiscontinuedDate,'MM/dd/yyyy') 'Discontinued',
    B.sBrandDescription 'Brand',
    S.sSEMAPart 'SEMAPart',
    ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription',
    S.sWebUrl 'WebURL',
    SL.iQAV, SL.iQOS
FROM tblSKU S
    left join tblSnapshotSKU SSToday on S.ixSKU = SSToday.ixSKU
                                and SSToday.ixDate = @TodayixDate --18624 --  '12/27/18'
                                and SSToday.iFIFOQuantity <= 0 -- 353,151
    left join tblSnapshotSKU SSYday on SSToday.ixSKU = SSYday.ixSKU
                                and SSYday.ixDate = @YdayixDate -- 18623  --  '12/26/18'
                                and SSYday.iFIFOQuantity > 0 -- 353151
    left join tblBrand B on S.ixBrand = B.ixBrand     
    left join tblSKULocation SL on SL.ixSKU = S.ixSKU and SL.ixLocation = 99                               
WHERE S.dtDiscontinuedDate <= getdate()
    and S.ixSKU NOT LIKE 'AUP%'
    and S.ixSKU NOT LIKE 'UP%'
    and SSToday.ixSKU is NOT NULL
    and SSYday.ixSKU is NOT NULL
    and S.sWebUrl is NOT NULL
    and SL.iQOS <= 0
ORDER BY SSToday.ixSKU

-- select * from tblEmployee where ixEmployee in ('BPH','JRB')




/*
select S.ixSKU, dtDiscontinuedDate, SL.iQAV, SL.iQOS
from tblSKU S
    left join tblSKULocation SL on SL.ixSKU = S.ixSKU and SL.ixLocation = 99
where S.ixSKU in ('10624-350','1681011301-WOAK','582G848','6221000','91037002-18',
                  '10623-200','50342515-030','59262935','9103232-RED',
                  '91048342-486-STD','91048342-583-STD','91048343-370-STD','91048343-620-STD','91048343-650-LITE','91048343-700-STD')
ORDER BY SL.ixSKU


select ixSKU,iFIFOQuantity,
    FORMAT(D.dtDate,'MM/dd/yyyy') SSDate,
    ixPGC,ixPrimaryVendor--,dtDateLastSOPUpdate 
from tblSnapshotSKU SS
    left join tblDate D on SS.ixDate = D.ixDate
where ixSKU in ('10624-350','1681011301-WOAK','582G848','6221000','91037002-18','10623-200','50342515-030','59262935','9103232-RED','91048342-486-STD','91048342-583-STD','91048343-370-STD','91048343-620-STD','91048343-650-LITE','91048343-700-STD')
    and D.ixDate >= 18756
order by ixSKU, D.dtDate
*/




/*
5/9/19 Report	"Daily
                Snapshot
                Quantity"
10624-350	        0
1681011301-WOAK	    0
582G848	            0
6221000	            0
91037002-18	        0
	
5/11/19 Report	
10623-200	        3
50342515-030	    1
59262935	        1
9103232-RED	        3
	
5/14/19 Report	
91048342-486-STD	0
91048342-583-STD	0
91048343-370-STD	0
91048343-620-STD	0
91048343-650-LITE	0
91048343-700-STD	0
*/

-- SKU TRANSACTIONS 
/*
select * from tblSKUTransaction -- 5/9/19 report
where ixSKU in ('10624-350','1681011301-WOAK','582G848','6221000','91037002-18')
    and ixDate between 18756 and 18758 -- 05/08/2019 and 05/10/2019
ORDER BY ixSKU, ixDate desc, iSeq desc

select * from tblSKUTransaction -- 5/11/19 report
where ixSKU in ('10623-200','50342515-030','59262935','9103232-RED')
    and ixDate between 18758 and 18760 -- 05/10/2019 and 05/12/2019
ORDER BY ixSKU, ixDate desc, iSeq desc

select * from tblSKUTransaction -- 5/14/19 report
where ixSKU in ('91048342-486-STD','91048342-583-STD','91048343-370-STD','91048343-620-STD','91048343-650-LITE','91048343-700-STD')
    and ixDate between 18761 and 18763 -- 05/13/2019 and 05/15/2019
ORDER BY ixSKU, ixDate desc, iSeq desc




ixSKU,iFIFOQuantity,ixDate,ixPGC,ixPrimaryVendor,dtDateLastSOPUpdate
9103232-RED	3	81.00	27.00	18762	27.00	Oc	0009	2019-05-14 00:00:00.000	19605	39.99






*/