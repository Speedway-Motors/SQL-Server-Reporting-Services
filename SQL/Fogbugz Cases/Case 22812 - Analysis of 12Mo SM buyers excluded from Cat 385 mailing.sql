--Case 22812 - Analysis of 12Mo SM buyers excluded from Cat 385 mailing

-- TOTAL Cust & Sales for SM last 12 Months
select count(C.ixCustomer) CustCount, sum(OL.mExtendedPrice) SMSales
from tblCustomer C                                  
    join tblOrder O on C.ixCustomer = O.ixCustomer
    join tblOrderLine OL on O.ixOrder = OL.ixOrder
    join tblSKU S on OL.ixSKU = S.ixSKU
    join tblPGC PGC on PGC.ixPGC = S.ixPGC
  --  join vwCSTStartingPool SP on C.ixCustomer = SP.ixCustomer
where O.dtShippedDate between '05/20/2013' and '05/19/2014'
 and O.sOrderStatus = 'Shipped'
 and O.sOrderChannel <> 'INTERNAL'
 and O.sOrderType <> 'Internal'
 and O.mMerchandise >1
 and PGC.ixMarket = 'SM'
 and OL.flgLineStatus in ('Shipped','Dropshipped')
 and C.flgDeletedFromSOP = 0
/*
CustCount	SMSales
75,648	    
*/

-- NOT in the 385 mailing
select C.sCustomerType, C.sMailingStatus, C.sMailToCountry, count(C.ixCustomer) CustCount, sum(OL.mExtendedPrice) SMSales 
from tblCustomer C                                  
    join tblOrder O on C.ixCustomer = O.ixCustomer
    join tblOrderLine OL on O.ixOrder = OL.ixOrder
    join tblSKU S on OL.ixSKU = S.ixSKU
    join tblPGC PGC on PGC.ixPGC = S.ixPGC
  --  join vwCSTStartingPool SP on C.ixCustomer = SP.ixCustomer
where O.dtShippedDate between '05/20/2013' and '05/19/2014'
 and O.sOrderStatus = 'Shipped'
 and O.sOrderChannel <> 'INTERNAL'
 and O.sOrderType <> 'Internal' 
 and O.mMerchandise >1
 and PGC.ixMarket = 'SM'
 and OL.flgLineStatus in ('Shipped','Dropshipped')
 and C.flgDeletedFromSOP = 0 
 and C.ixCustomer not in (select distinct CO.ixCustomer 
                          from tblCustomerOffer CO
                            join tblSourceCode SC on CO.ixSourceCode = SC.ixSourceCode
                          where SC.ixCatalog = '385')
GROUP BY C.sCustomerType, C.sMailingStatus, C.sMailToCountry                          
                          
/*
CustCount	SMSales
21,183	1,659,712.06
*/

-- looking at EXCLUDED custs by sCustomerType
select C.sCustomerType, count(C.ixCustomer) CustCount, sum(OL.mExtendedPrice) SMSales 
from tblCustomer C                                  
    join tblOrder O on C.ixCustomer = O.ixCustomer
    join tblOrderLine OL on O.ixOrder = OL.ixOrder
    join tblSKU S on OL.ixSKU = S.ixSKU
    join tblPGC PGC on PGC.ixPGC = S.ixPGC
  --  join vwCSTStartingPool SP on C.ixCustomer = SP.ixCustomer
where O.dtShippedDate between '05/20/2013' and '05/19/2014'
 and O.sOrderStatus = 'Shipped'
 and O.sOrderChannel <> 'INTERNAL'
 and O.sOrderType <> 'Internal'
 and O.mMerchandise >1  
 and PGC.ixMarket = 'SM'
 and OL.flgLineStatus in ('Shipped','Dropshipped')
 and C.flgDeletedFromSOP = 0 
 and C.ixCustomer not in (select distinct CO.ixCustomer 
                          from tblCustomerOffer CO
                            join tblSourceCode SC on CO.ixSourceCode = SC.ixSourceCode
                          where SC.ixCatalog = '385')
group by C.sCustomerType                          
/*
sCust   Cust
Type	Count	SMSales
MRR	    439	     19,144
Other	4436	365,347
PRS	    9653	976,007
Retail	6451	299,208
*/                     
                         
-- looking at EXCLUDED RETAIL custs by sMailingStatus
select C.sMailingStatus, count(C.ixCustomer) CustCount, sum(OL.mExtendedPrice) SMSales 
from tblCustomer C                                  
    join tblOrder O on C.ixCustomer = O.ixCustomer
    join tblOrderLine OL on O.ixOrder = OL.ixOrder
    join tblSKU S on OL.ixSKU = S.ixSKU
    join tblPGC PGC on PGC.ixPGC = S.ixPGC
  --  join vwCSTStartingPool SP on C.ixCustomer = SP.ixCustomer
where O.dtShippedDate between '05/20/2013' and '05/19/2014'
 and O.sOrderStatus = 'Shipped'
 and O.sOrderChannel <> 'INTERNAL'
 and O.sOrderType <> 'Internal' 
 and PGC.ixMarket = 'SM'
 and OL.flgLineStatus in ('Shipped','Dropshipped')
 and C.flgDeletedFromSOP = 0 
 and C.sCustomerType = 'Retail'
 and C.ixCustomer not in (select distinct CO.ixCustomer 
                          from tblCustomerOffer CO
                            join tblSourceCode SC on CO.ixSourceCode = SC.ixSourceCode
                          where SC.ixCatalog = '385')
group by C.sMailingStatus                           
/*
sMailingCust
Status	Count	SMSales
NULL	812	     28,395
0	    5088	218,697
8	    2	         24
9	    681	     52,094
*/
      
      
-- Details on sCustomerType 'Other'
select C.ixCustomer, count(O.ixOrder) OrdCount, sum(OL.mExtendedPrice) SMSales 
from tblCustomer C                                  
    join tblOrder O on C.ixCustomer = O.ixCustomer
    join tblOrderLine OL on O.ixOrder = OL.ixOrder
    join tblSKU S on OL.ixSKU = S.ixSKU
    join tblPGC PGC on PGC.ixPGC = S.ixPGC
  --  join vwCSTStartingPool SP on C.ixCustomer = SP.ixCustomer
where O.dtShippedDate between '05/20/2013' and '05/19/2014'
 and O.sOrderStatus = 'Shipped'
 and O.sOrderChannel <> 'INTERNAL'
 and O.sOrderType <> 'Internal'
 and O.mMerchandise >1  
 and PGC.ixMarket = 'SM'
 and OL.flgLineStatus in ('Shipped','Dropshipped')
 and C.flgDeletedFromSOP = 0 
 and C.ixCustomer not in (select distinct CO.ixCustomer 
                          from tblCustomerOffer CO
                            join tblSourceCode SC on CO.ixSourceCode = SC.ixSourceCode
                          where SC.ixCatalog = '385')
 and C.sCustomerType = 'Other'
 and C.sMailingStatus NOT in (7,8,9)                          
group by C.ixCustomer 
order by  sum(OL.mExtendedPrice) desc                              
/*TOP 10 'Other' purchasers

Cust#	OrdCount	SMSales
1073350	3687	    304,141  <-- Eagle Sports
1155856	198	        19,001   <-- Eagle Sports
778710	32	         3,182
241476	44	         2,045
96165	43	         1,906
1716225	1	         1,592
833346	10	         1,161
163138	12	         1,011
597070	6	           735
508583	2	           647
*/
select * from tblCustomer where ixCustomer = '778710'