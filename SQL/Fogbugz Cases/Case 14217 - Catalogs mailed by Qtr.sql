/*
select top 10 * from tblCatalogMaster
select top 10 * from tblCustomerOffer
select top 10 * from tblDate
select top 10 * from tblSourceCode
select top 10 * from tblSourceCodeType
*/

select D.iYear, D.iMonth, COUNT(CO.ixCustomerOffer) CatQty
from tblCustomerOffer CO
    join tblSourceCode SC on CO.ixSourceCode = SC.ixSourceCode
    left join tblDate D on CO.ixActiveStartDate = D.ixDate
where --CO.sType = 'OFFER'
    --AND CO.dtActiveStartDate between '06/01/2011' and '05/31/2012'
     SC.ixCatalog between '319' and '350'
    AND SC.sSourceCodeType in ('CAT-H','CAT-P')
group by D.iYear, D.iMonth   
order by D.iYear desc, D.iMonth desc

/*
iYear	iMonth	CatQty
2012	6	    223094
2012	5	    135843
2012	4	    597677
2012	3	    241485
2012	2	    394739
2012	1	    404646
2011	11	    473772
2011	10	    394329
2011	9	    66055
2011	8	    160
2011	7	    82685
NULL	NULL	1869
*/




select sType, COUNT(*)
from tblCustomerOffer
group by sType


select * from tblCatalogMaster
where ixCatalog between '319' and '350'
order by dtStartDate