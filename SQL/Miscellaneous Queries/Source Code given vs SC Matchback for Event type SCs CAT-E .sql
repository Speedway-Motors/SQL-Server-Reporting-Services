-- Source Code given vs SC Matchback for Event type SCs CAT-E 
    select * from tblSourceCode where ixSourceCode in ( '353534', '353535')
/*
ixSourceCode	ixStartDate	ixEndDate	ixCatalog	sDescription	                sCatalogMarket	dtStartDate	dtEndDate
353534	        16605	        16970	353	        SYRACUSE NATIONALS	            SR	            2013-06-17  2014-06-17 
353535          16605	        16970	353	        GOODGUYS NORTHWEST NATIONALS    SR	            2013-06-17  2014-06-17  
*/




select O.sSourceCodeGiven, count(O.ixOrder) Given
from tblOrder O
    left join tblSourceCode SC on O.sSourceCodeGiven = SC.ixSourceCode
Where SC.sSourceCodeType = 'CAT-E'
    and SC.dtStartDate >= '12/01/2012'
    and O.sOrderStatus = 'Shipped'
    and O.dtShippedDate between '01/01/2013' and '07/31/2013'
group by O.sSourceCodeGiven



select O.sMatchbackSourceCode, count(O.ixOrder) MB
from tblOrder O
    left join tblSourceCode SC on O.sMatchbackSourceCode = SC.ixSourceCode
Where SC.sSourceCodeType = 'CAT-E'
    and SC.dtStartDate >= '12/01/2012'
    and O.sOrderStatus = 'Shipped'
    and O.dtShippedDate between '01/01/2013' and '07/31/2013'
group by O.sMatchbackSourceCode


select * from tblOrder
where sSourceCodeGiven = '2161398' 
and sMatchbackSourceCode <> '2161398'


select count(*) OrdersSCMB
from tblOrder 
where sMatchbackSourceCode = '353535'
and sOrderStatus = 'Shipped'


        Orders QTY  Orders QTY
SC      SC Given    SC MB
======  ==========  ==========  
353534  18          18 
353535   8           8

