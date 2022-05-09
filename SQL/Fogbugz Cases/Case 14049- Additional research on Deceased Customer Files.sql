
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
    max(O.dtOrderDate) LastOrder,
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
                                                                                                                                                                                                             
                                                                                                                                                                                                             








/************  WEDNESDAY 6-13-2012 *********************/
                         
-- drop table   PJC_ComboDeceased_MOD2                        
-- copying original work table and adding two SMI columns to populate later                          
select Keycode, CUST, 
'        ' SMI_Cust_Act_Create_Date, 
'        ' SMI_Latest_Order_Date, 
DATE_OF_DEATH, DECEASED_FOOTNOTES, CONFIDENCE_CODE, DECEASED_MATCH_TYPE
into PJC_ComboDeceased_MOD2
from PJC_COMBODeceased    

-- Change datatype and allow NULLs for SMI_Latest_Order_Date
ALTER TABLE dbo.PJC_ComboDeceased_MOD2
ALTER COLUMN SMI_Cust_Act_Create_Date varchar(8) NULL
ALTER COLUMN SMI_Latest_Order_Date varchar(8) NULL

-- updating with SMI's Customer Account Create Date
update D
set SMI_Cust_Act_Create_Date = CONVERT(VARCHAR(8), C.dtAccountCreateDate, 112)
from PJC_ComboDeceased_MOD2 D
 join tblCustomer C on D.CUST = C.ixCustomer




-- TEMP table for latest order dates
select D.CUST, 
    max(O.dtOrderDate) MostRecentOrderDt
into PJC_MostRecentZombieOrders    
from PJC_ComboDeceased_MOD2 D
    join tblOrder O on D.CUST = O.ixCustomer 
where   O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
-- CONVERT(VARCHAR(8), C.dtAccountCreateDate, 112)
group by D.CUST 


-- updating with SMI's Customer Account Create Date
update D
set SMI_Latest_Order_Date = CONVERT(VARCHAR(8), MRZO.MostRecentOrderDt, 112)
from PJC_ComboDeceased_MOD2 D
 join PJC_MostRecentZombieOrders MRZO on D.CUST = MRZO.CUST

         


select min(len(SMI_Cust_Act_Create_Date)),
max (len(SMI_Cust_Act_Create_Date))
from PJC_ComboDeceased_MOD2
where SMI_Cust_Act_Create_Date <> ' '  

select min(len(SMI_Latest_Order_Date)),
max (len(SMI_Latest_Order_Date))
from PJC_ComboDeceased_MOD2
where SMI_Latest_Order_Date <> ' '  

select min(len(DATE_OF_DEATH)),
max (len(DATE_OF_DEATH))
from PJC_ComboDeceased_MOD2
where DATE_OF_DEATH <> ' '  


select * from    PJC_ComboDeceased_MOD2  




select KEYCODE, CUST, SMI_Cust_Act_Create_Date, SMI_Latest_Order_Date, DATE_OF_DEATH, FILE_NO, LIST_ID, UNIQ_SEQ_NO, NCOA_MoveDate, 
    DECEASED_FOOTNOTES, CONFIDENCE_CODE, DECEASED_MATCH_TYPE, PRISON_MATCH_CODE 
from PJC_Deceased_MOD2
                 
                 
                 
update A 
set COLUMN = B.COLUMN
from FIRSTTABLE A
 join SECONDTABLE B on A.XXX = B.XXX                  
 
 
 
 
 
 /* ZOMBIE SALES SINCE 4-23-12 */                                                                                                                                                                                      
 
 SELECT O.ixCustomer,
    sum(mMerchandise) TotSales,
    count(O.ixOrder) OrdCount
FROM tblOrder O
    join PJC_COMBODeceased CD on O.ixCustomer = CD.CUST
WHERE   O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtShippedDate >= '04/23/2012'
GROUP BY     O.ixCustomer
       
 
 



select count(*) from PJC_COMBODeceased -- 8,218
    186 of them have ordered since 4-23-2012  2.3%
    
8,218 customers marked deceased in our system because they were in the last 4 Deceased files Donnely sent

Since 4-23-2012 (the date the majority of them were flagged as deceased in our system):
186 customers have ordered since then
435 orders placed
$77,243 Sales
$178 Avg Order






    
    

 
 
 