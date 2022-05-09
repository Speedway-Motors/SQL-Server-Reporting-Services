select ixSourceCode,
dtStartDate 'Start',
dtEndDate 'End',
sDescription 'Description',
ixCatalog 'Cat',
ixMostSimilarSourceCode 'MostSimSC',
sSourceCodeType 'SC Type'
from tblSourceCode
where 
--iQuantityPrinted = 100
 sSourceCodeType like 'CAT%' 
AND (ixMostSimilarSourceCode is NULL
     or ixMostSimilarSourceCode = 'NONE')
and dtStartDate >= '01/01/2010'
order by 'Cat'


select sSourceCodeType, count(*) 
from tblSourceCode
where 
--iQuantityPrinted = 100
    sSourceCodeType like 'CAT%' 
  AND (ixMostSimilarSourceCode is NULL
       or ixMostSimilarSourceCode = 'NONE')
  and dtStartDate >= '01/01/2010'
  and (ixCatalog like '2%'
       or ixCatalog like '3%')
group by sSourceCodeType

/*
sSourceCodeType	(No column name)
CAT-E	250
CAT-H	30
CAT-P	17
CAT-R	2
*/


select * from tblSourceCodeType








