select * from tblCatalogMaster
where ixCatalog in ('325','326')
order by ixCatalog


select * from tblCatalogMaster
where ixCatalog in ('323','325','332','327')
order by ixCatalog


select SC.ixCatalog Cat, sum(O.mMerchandise)Sales
from tblOrder O
    join tblSourceCode SC on O.sMatchbackSourceCode = SC.ixSourceCode
where SC.ixCatalog in ('323','325','332')
    and O.dtOrderDate between '10/15/2011' and '11/30/2011'
group by SC.ixCatalog

/*
Cat	  Sales
323	 96,103.30
325	505,798.08
332	 72,128.26
*/

select SC.ixCatalog Cat, O.dtShippedDate, sum(O.mMerchandise)Sales
from tblOrder O
    join tblSourceCode SC on O.sMatchbackSourceCode = SC.ixSourceCode
where SC.ixCatalog in ('323','325','332')
    and O.dtShippedDate between '10/15/2011' and '11/30/2011'
group by SC.ixCatalog, O.dtShippedDate
order by Cat, O.dtShippedDate

