-- Case 16684 - customers excluded from CST due to Customer Type

-- Buyers in the past 6 years
select C.sCustomerType, count(C.ixCustomer) QTY, '      ' as 'CST Rule'
from tblCustomer C
    join tblOrder O on O.ixCustomer = C.ixCustomer
where O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtShippedDate >= '02/11/2008'
group by   C.sCustomerType
/*
sCustomerType	QTY	CST Rule
MRR	            42697	Exclude - correct      
Other	        17558	Exclude -   ???       
PRS	            59044	Exclude - correct       
Retail	        2148865	Include - correct      
*/


-- the ixCustomerTypes for the 'Other' sCustomerTypes
select C.ixCustomerType, CT.sDescription,  COUNT(*) QTY
from tblCustomer C
    LEFT join tblCustomerType CT on C.ixCustomerType = CT.ixCustomerType
where C.sCustomerType = 'Other'
and C.flgDeletedFromSOP = 0
and ixCustomer in (select distinct ixCustomer from tblOrder O
                    where O.sOrderStatus = 'Shipped'
                    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
                    and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
                    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
                    and O.dtShippedDate >= '02/11/2013'-- '02/11/2012' --'02/11/2008'
                    )
group by C.ixCustomerType, CT.sDescription
order by C.ixCustomerType  -- COUNT(*) desc



select ixCustomer
from tblCustomer
where ixCustomerType = '20'
order by newid()




-- DROP TABLE tblCustomerType
select distinct ixCustomerType, COUNT(*) QTY --sDescription, sCustomerType, COUNT(*) QTY
from tblCustomer
where flgDeletedFromSOP = 0
group by ixCustomerType, sCustomerType
order by COUNT(*) desc
/*
1	1429321
90	3053
82.1	1367
98	1130
87	824
6	791
82	725
20	715
96	686
40	652
76	619
50	596
89	580
10	522
60	453
80	417
30	393
56	234
88	213
91	198
44	185
90.1	177
99	147
86	100
97	89
45	74
93	67
78	61
85	58
87.1	57
101	52
35	40
79	36
NULL	27
85.1	27
90.2	25
92	24
83	22
94	18
95	14
4	10
81	7
5	6
78.1	3
77	3
3	3
102	3
2	3
90.3	3
0	2
31	2
46	2
80.1	2
80.2	2
443293	1
01	1
EC	1
UK	1
VISA	1
Y	1
*/



insert into tblCustomerType
select distinct ixCustomerType, NULL, sCustomerType, GETDATE() --, sDescription
from tblCustomer
where ixCustomerType is NOT NULL
and flgDeletedFromSOP = 0


update tblCustomerType
SET sDescription = 'RETAIL'
where ixCustomerType = '1'


select * from tblCustomerType
WHERE sDescription is NULL




select C.ixCustomerType, count(C.ixCustomer)
from tblCustomer C
    join tblCustomerType CT on C.ixCustomerType = CT.ixCustomerType
WHERE CT.sDescription is NULL
group by C.ixCustomerType

SELECT ixCustomer
     , ixCustomerType
FROM tblCustomer
WHERE ixCustomerType IN ('0', '01', '2', '3', '443293',  '5', 'EC', 'UK', 'VISA', 'Y')
  AND flgDeletedFromSOP = 0 
ORDER BY ixCustomerType


select * from tblCustomer C where ixCustomer = '1156260'

select ixCustomer, ixCustomerType
from tblCustomer where ixCustomer in ('353554','390901','1740226','237424','381462',
'71967','55608','394918','124204','453552','473917','66642','57851','82838','93706',
'414491','60948','390263','235479','424853')





