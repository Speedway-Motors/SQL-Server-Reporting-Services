--Case 22931 - Analysis of 12Mo Race buyers excluded from Cat 381 mailing

-- TOTAL Cust & Sales for SM last 12 Months
select count(distinct C.ixCustomer) CustCount, sum(OL.mExtendedPrice) SMSales
from tblCustomer C                                  
    join tblOrder O on C.ixCustomer = O.ixCustomer
    join tblOrderLine OL on O.ixOrder = OL.ixOrder
    join tblSKU S on OL.ixSKU = S.ixSKU
    join tblPGC PGC on PGC.ixPGC = S.ixPGC
  --  join vwCSTStartingPool SP on C.ixCustomer = SP.ixCustomer
where O.dtShippedDate between '06/04/2013' and '06/03/2014'
 and O.sOrderStatus = 'Shipped'
 and O.sOrderChannel <> 'INTERNAL'
 and O.sOrderType <> 'Internal'
 and O.mMerchandise >1
 and PGC.ixMarket = 'R'
 and OL.flgLineStatus in ('Shipped','Dropshipped')
 and C.flgDeletedFromSOP = 0
/*
CustCount	SMSales
98,349	    30,746,427
*/

-- NOT in the 381 mailing
-- paste results into Excel... turn on filters
select C.sCustomerType, C.sMailingStatus, 
    (Case when C.sMailToCountry is NULL then NULL
          when C.sMailToCountry = 'USA' then 'USA'
          else 'Non-US'
          end) as 'MailToCountry'
          , MOI.sOptInStatus, 
    (Case when sMailToZip like '962%' then 'Military'
            when sMailToZip like '963%' then 'Military'
            when sMailToZip like '964%' then 'Military'
            when sMailToZip like '965%' then 'Military'
            when sMailToZip like '966%' then 'Military'
            when sMailToZip like '09%'  then 'Military'
            when sMailToZip BETWEEN '01000' AND '99999' then 'Valid'
            else 'Invalid US Zip'
           end) 'MailToZip',
    (Case when SP.ixCustomer is NOT NULL then 'Yes'
        else 'No'
        end) as 'InCSTStartingPool',
    count(distinct C.ixCustomer) CustCount, sum(OL.mExtendedPrice) Sales 
from tblCustomer C                                  
    left join tblOrder O on C.ixCustomer = O.ixCustomer
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
    left join tblSKU S on OL.ixSKU = S.ixSKU
    left join tblPGC PGC on PGC.ixPGC = S.ixPGC
    left join tblMailingOptIn MOI on MOI.ixCustomer = C.ixCustomer and MOI.ixMarket = 'R'  
    left join vwCSTStartingPool SP on C.ixCustomer = SP.ixCustomer
where O.dtShippedDate between '06/04/2013' and '06/03/2014'
 and O.sOrderStatus = 'Shipped'
 and O.sOrderChannel <> 'INTERNAL'
 and O.sOrderType <> 'Internal' 
 and O.mMerchandise >1
 and PGC.ixMarket = 'R'
 and OL.flgLineStatus in ('Shipped','Dropshipped')
 and C.flgDeletedFromSOP = 0 
 and C.ixCustomer not in (select distinct CO.ixCustomer 
                          from tblCustomerOffer CO
                            join tblSourceCode SC on CO.ixSourceCode = SC.ixSourceCode
                          where SC.ixCatalog = '381')
GROUP BY C.sCustomerType, C.sMailingStatus, MOI.sOptInStatus,
    (Case when C.sMailToCountry is NULL then NULL
          when C.sMailToCountry = 'USA' then 'USA'
          else 'Non-US'
          end),
    (Case when sMailToZip like '962%' then 'Military'
            when sMailToZip like '963%' then 'Military'
            when sMailToZip like '964%' then 'Military'
            when sMailToZip like '965%' then 'Military'
            when sMailToZip like '966%' then 'Military'
            when sMailToZip like '09%'  then 'Military'
            when sMailToZip BETWEEN '01000' AND '99999' then 'Valid'
            else 'Invalid US Zip'
           end),     
    (Case when SP.ixCustomer is NOT NULL then 'Yes'
         else 'No'
         end)                          

/*
CustCount	RSales
12,597 	    $7,148,108 
*/

-- looking at EXCLUDED custs by sCustomerType
select C.sCustomerType, count(distinct C.ixCustomer) CustCount, sum(OL.mExtendedPrice) SMSales 
from tblCustomer C                                  
    join tblOrder O on C.ixCustomer = O.ixCustomer
    join tblOrderLine OL on O.ixOrder = OL.ixOrder
    join tblSKU S on OL.ixSKU = S.ixSKU
    join tblPGC PGC on PGC.ixPGC = S.ixPGC
  --  join vwCSTStartingPool SP on C.ixCustomer = SP.ixCustomer
where O.dtShippedDate between '06/04/2013' and '06/03/2014'
 and O.sOrderStatus = 'Shipped'
 and O.sOrderChannel <> 'INTERNAL'
 and O.sOrderType <> 'Internal'
 and O.mMerchandise >1  
 and PGC.ixMarket = 'R'
 and OL.flgLineStatus in ('Shipped','Dropshipped')
 and C.flgDeletedFromSOP = 0 
 and C.ixCustomer not in (select distinct CO.ixCustomer 
                          from tblCustomerOffer CO
                            join tblSourceCode SC on CO.ixSourceCode = SC.ixSourceCode
                          where SC.ixCatalog = '381')
group by C.sCustomerType                          
/*
sCust   Cust
Type	Count	SMSales
MRR	    474	     221,949
Other	226	     168,732
PRS	    380	     572,4807
Retail	11517	1,032,618
*/                     
                         
-- looking at EXCLUDED RETAIL custs by sMailingStatus
select C.sMailingStatus, count(distinct C.ixCustomer) CustCount, sum(OL.mExtendedPrice) SMSales 
from tblCustomer C                                  
    join tblOrder O on C.ixCustomer = O.ixCustomer
    join tblOrderLine OL on O.ixOrder = OL.ixOrder
    join tblSKU S on OL.ixSKU = S.ixSKU
    join tblPGC PGC on PGC.ixPGC = S.ixPGC
  --  join vwCSTStartingPool SP on C.ixCustomer = SP.ixCustomer
where O.dtShippedDate between '06/04/2013' and '06/03/2014'
 and O.sOrderStatus = 'Shipped'
 and O.sOrderChannel <> 'INTERNAL'
 and O.sOrderType <> 'Internal' 
 and PGC.ixMarket = 'R'
 and OL.flgLineStatus in ('Shipped','Dropshipped')
 and C.flgDeletedFromSOP = 0 
 and C.sCustomerType = 'Retail'
 and C.ixCustomer not in (select distinct CO.ixCustomer 
                          from tblCustomerOffer CO
                            join tblSourceCode SC on CO.ixSourceCode = SC.ixSourceCode
                          where SC.ixCatalog = '381')
group by C.sMailingStatus                           
/*
sMailingCust
Status	Count	SMSales
NULL	1977	101,067
0	    9196	744,797
8	    14	      1,455
9	    580	    185,316
*/
      
      
-- Details on sCustomerType 'Other'
select C.ixCustomer 'CustNum', count(Distinct O.ixOrder) 'OrdQty', sum(OL.mExtendedPrice) 'MktSales'
from tblCustomer C                                  
    join tblOrder O on C.ixCustomer = O.ixCustomer
    join tblOrderLine OL on O.ixOrder = OL.ixOrder
    join tblSKU S on OL.ixSKU = S.ixSKU
    join tblPGC PGC on PGC.ixPGC = S.ixPGC
  --  join vwCSTStartingPool SP on C.ixCustomer = SP.ixCustomer
where O.dtShippedDate between '06/04/2013' and '06/03/2014'
 and O.sOrderStatus = 'Shipped'
 and O.sOrderChannel <> 'INTERNAL'
 and O.sOrderType <> 'Internal'
 and O.mMerchandise >1  
 and PGC.ixMarket = 'R'
 and OL.flgLineStatus in ('Shipped','Dropshipped')
 and C.flgDeletedFromSOP = 0 
 and C.ixCustomer not in (select distinct CO.ixCustomer 
                          from tblCustomerOffer CO
                            join tblSourceCode SC on CO.ixSourceCode = SC.ixSourceCode
                          where SC.ixCatalog = '381')
 and C.sCustomerType = 'Other'
 and C.sMailingStatus NOT in (7,8,9)                          
group by C.ixCustomer 
order by  sum(OL.mExtendedPrice) desc                              
/*TOP 10 'Other' purchasers

CustNum	OrdQty	MktSales
1073350	467	    37,974  <-- Eagle Sports
786886	73	     6,289
1155856	51	     3,246  <-- Eagle Sports
1890312	2	     3,031
503174	8	     2,530
1579845	6	     2,518
163138	7	     2,123
1616808	7	     1,759
241476	10	     1,636
655702	3	     1,570
*/




select * from tblCustomer where ixCustomer = '786886'