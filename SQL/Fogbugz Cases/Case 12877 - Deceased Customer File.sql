
--drop table PJC_Deceased


select * from PJC_Deceased

select CUST, DECEASED_FOOTNOTES, CONFIDENCE_CODE, DECEASED_MATCH_TYPE, DATE_OF_DEATH 
from PJC_Deceased
order by DATE_OF_DEATH

select DECEASED_FOOTNOTES, count(*) QTY
from PJC_Deceased
group by DECEASED_FOOTNOTES
/*
DECEASED_FOOTNOTES	QTY
	                379
1	                3
3	                3
G	                2
I	                2
M	                51
*/

select CONFIDENCE_CODE, count(*) QTY
from PJC_Deceased
group by CONFIDENCE_CODE
/*
CONFIDENCE_CODE	QTY
P	            139
V	            301
*/

select DECEASED_MATCH_TYPE, count(*) QTY
from PJC_Deceased
group by DECEASED_MATCH_TYPE
/*
DECEASED_MATCH_TYPE	QTY
B1	                331
C1	                109
*/

select DATE_OF_DEATH, count(*) QTY
from PJC_Deceased
group by DATE_OF_DEATH

select D.CUST, C.dtAccountCreateDate, D.DATE_OF_DEATH
from PJC_Deceased D
    left join tblCustomer C on D.CUST = C.ixCustomer
order by D.DATE_OF_DEATH



select D.NAME_LINE, 
    --C.sCustomerFirstName, C.sCustomerLastName, 
    D.CUST, 
    CONVERT(VARCHAR(8), C.dtAccountCreateDate, 112) AS ActCreateDate, -- formats to YYYYMMDD
    D.DATE_OF_DEATH, C.ixSourceCode,
    max(O.dtOrderDate) LastOrder
from PJC_Deceased D
    join tblCustomer C on D.CUST = C.ixCustomer
    left join tblOrder O on C.ixCustomer = O.ixCustomer and O.sOrderStatus = 'Shipped'
where CONVERT(VARCHAR(8), C.dtAccountCreateDate, 112) >   D.DATE_OF_DEATH  
group by D.NAME_LINE, 
    --C.sCustomerFirstName, C.sCustomerLastName, 
    D.CUST, 
    CONVERT(VARCHAR(8), C.dtAccountCreateDate, 112), 
    D.DATE_OF_DEATH, C.ixSourceCode
order by LastOrder desc,  D.DATE_OF_DEATH


/***** RESULTS *******
440 deceased customers in latest Deceased file
only 159 have customer numbers
  of those 64 have account create dates NEWER than the provided "Date of Death"
  31 of those 64 have placed orders since their "demise"
**********************/ 

select count(CUST) from PJC_Deceased where CUST <> ' ' --is not NULL

select  * from PJC_Deceased


What do the values in the "DECEASED_FOOTNOTES" translate to?  (e.g. 1,3,G,I,M)
What do the values in the "CONFIDENCE_CODE" translate to?  (e.g. P,V)
What do the values in the "DECEASED_MATCH_TYPE" translate to?  (e.g. B1,C1)


/*
COLUMN              POSITION    LENGTH
Keycode             1-6         6   
 JUNK1              7-20        14
CUST                21-27       7
 JUNK2              28-1365     1338
DECEASED_FOOTNOTES  1366        1   
CONFIDENCE_CODE     1367        1
 JUNK3              1368-1375   8
DECEASED_MATCH_TYPE 1376-1377   2
DATE_OF_DEATH       1378-1385   8
 JUNK4              1386-1630   245
*/


8218 rows

-- TRUNCATE TABLE PJC_COMBODeceased
select * from PJC_COMBODeceased

select CUST, DECEASED_FOOTNOTES, CONFIDENCE_CODE, DECEASED_MATCH_TYPE, DATE_OF_DEATH 
from PJC_COMBODeceased
order by DATE_OF_DEATH

select DECEASED_FOOTNOTES, count(*) QTY
from PJC_COMBODeceased
group by DECEASED_FOOTNOTES
/*
QTY	    DECEASED_FOOTNOTES
3	    2
64	    3
5	    4
123	    G
6828	 
43	    1
9	    I
1143	M
*/

select CONFIDENCE_CODE, count(*) QTY
from PJC_COMBODeceased
group by CONFIDENCE_CODE
/*
CONFIDENCE_CODE	QTY
P	            3533
V	            4685
*/

select DECEASED_MATCH_TYPE, count(*) QTY
from PJC_COMBODeceased
group by DECEASED_MATCH_TYPE
/*
DECEASED_MATCH_TYPE	QTY
C1	3144
C2	10
B1	5064
*/

select --D.NAME_LINE, 
    --C.sCustomerFirstName, C.sCustomerLastName, 
    D.CUST, 
    CONVERT(VARCHAR(8), C.dtAccountCreateDate, 112) AS ActCreateDate, -- formats to YYYYMMDD
    D.DATE_OF_DEATH, C.ixSourceCode,
    max(O.dtOrderDate) LastOrder
from PJC_COMBODeceased D
    join tblCustomer C on D.CUST = C.ixCustomer
    left join tblOrder O on C.ixCustomer = O.ixCustomer and O.sOrderStatus = 'Shipped'
where CONVERT(VARCHAR(8), C.dtAccountCreateDate, 112) >   D.DATE_OF_DEATH  
group by-- D.NAME_LINE, 
    --C.sCustomerFirstName, C.sCustomerLastName, 
    D.CUST, 
    CONVERT(VARCHAR(8), C.dtAccountCreateDate, 112), 
    D.DATE_OF_DEATH, C.ixSourceCode
order by LastOrder desc,  D.DATE_OF_DEATH



select --D.NAME_LINE, 
    --C.sCustomerFirstName, C.sCustomerLastName, 
    D.CUST, 
    CONVERT(VARCHAR(8), C.dtAccountCreateDate, 112) AS ActCreateDate, -- formats to YYYYMMDD
    D.DATE_OF_DEATH, C.ixSourceCode,
    max(O.dtOrderDate) LastOrder
from PJC_COMBODeceased D
    join tblCustomer C on D.CUST = C.ixCustomer
    left join tblOrder O on C.ixCustomer = O.ixCustomer and O.sOrderStatus = 'Shipped'
where CONVERT(VARCHAR(8), O.dtOrderDate, 112) >   D.DATE_OF_DEATH  
group by-- D.NAME_LINE, 
    --C.sCustomerFirstName, C.sCustomerLastName, 
    D.CUST, 
    CONVERT(VARCHAR(8), C.dtAccountCreateDate, 112), 
    D.DATE_OF_DEATH, C.ixSourceCode
order by LastOrder desc,  D.DATE_OF_DEATH



8218 customers in the combined Deceased file
2140 of them created their account after DOD
1970 of them placed and order after DOD
                                                                                                                                                                                                             
                                                                                                                                                                                                             
                                                                                                                                                                                                             