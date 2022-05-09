-- Case 26036 - Customers that received cat 402 and or 501 and where not in LB files
select * from PJC_26036_LB_AWOL_Customers -- 14,365
select distinct ixCustomer from PJC_26036_LB_AWOL_Customers



select M.ixCustomer, C.dtAccountCreateDate, C.ixCustomerType, C.sCustomerType, C.sMailToCountry, C.sMailToState, C.sMailToZip, C.sMailingStatus,
CO.ixSourceCode 'SC402', 
CO2.ixSourceCode 'SC501' ,
--MAX(dtRequestDate) 'LatestCRDate',
(Case when SP.ixCustomer is not null then 'Y'
 else 'N'
 end) as 'CST_US_StartingPool_NOW',
 (Case when SP.ixCustomer is not null then 'Y'
 else 'N'
 end) as 'CST_CA_StartingPool_NOW'
from PJC_26036_LB_AWOL_Customers M
left join [SMI Reporting].dbo.tblCustomerOffer CO on M.ixCustomer = CO.ixCustomer and CO.ixSourceCode like '402%'
left join [SMI Reporting].dbo.tblCustomerOffer CO2 on M.ixCustomer = CO2.ixCustomer and CO2.ixSourceCode like '501%'
left join [SMI Reporting].dbo.tblCustomer C on M.ixCustomer = C.ixCustomer
--left join [SMI Reporting].dbo.tblCatalogRequest CR on CR.ixCustomer = M.ixCustomer
left join [SMI Reporting].dbo.vwCSTStartingPool SP on SP.ixCustomer = M.ixCustomer
left join [SMI Reporting].dbo.vwCSTStartingPool SPC on SPC.ixCustomer = M.ixCustomer
left join [SMI Reporting].dbo.tblStates S on C.sMailToState = S.ixState
--WHERE                                                                       -- 14,883 AWOL
--    (C.sMailToCountry is NULL or  C.sMailToCountry = 'US')
--    and S.ixState is NOT NULL                                               --  7,136 Foreign Customers
--    and (C.sMailingStatus is NULL or C.sMailingStatus = 0)                  --  2,961 Invalid Mailing Status (7,8,9)
--                                                                            --    116 were created after extracts were sent
--    and (CO.ixSourceCode is NOT NULL or CO2.ixSourceCode is NOT NULL)       --    108 did not get mark with Offers for 402 OR 501)
--    and sCustomerType = 'Retail'                                           --     51 non retail customers (MRR, PRS, Other)
    
ORDER by  C.dtAccountCreateDate desc
--sMailingStatus desc
-- LEN(sMailToZip) desc only one possible invalid
group by M.ixCustomer, C.dtAccountCreateDate, C.ixCustomerType, C.sCustomerType, C.sMailToCountry, C.sMailToState, C.sMailToZip, C.sMailingStatus,
    CO.ixSourceCode, 
    CO2.ixSourceCode ,
    (Case when SP.ixCustomer is not null then 'Y'
     else 'N'
     end)
order by C.sMailingStatus, C.sMailToCountry, M.ixCustomer
/* RESULTS OF ABOVE

14,384 total AWOL custs (out of 430K = 3.3%)
======
6,259 canadian
  887 other foreign
2,825 currently flagged do not mail
   56 didn't receive either catalog
   47 non-retail
  189 created after extract was sent
======
10,263 cause Identified

puting the remaining 4,120 customes in table below for further analysis
*/

select * from PJC_26036_LB_AWOL_Customers_Still_Unknown -- 4,120

select C.*
from PJC_26036_LB_AWOL_Customers_Still_Unknown SM
    left join [SMI Reporting].dbo.tblCustomer C on SM.ixCustomer = C.ixCustomer
    

select CO.ixSourceCode, COUNT(SM.ixCustomer) CustCnt -- 381,387         -- 1000 merged
from [SMI Reporting].dbo.tblCustomerOffer CO    
    left join [SMI Reporting].dbo.tblCustomer C on CO.ixCustomer = C.ixCustomer
    left join [SMI Reporting].dbo.tblSourceCode SC on CO.ixSourceCode = SC.ixSourceCode
    join PJC_26036_LB_AWOL_Customers_Still_Unknown SM on C.ixCustomer = SM.ixCustomer
where SC.ixCatalog = '501' 
group by CO.ixSourceCode
order by COUNT(SM.ixCustomer) desc --CO.ixSourceCode

select CO.ixSourceCode, COUNT(SM.ixCustomer) CustCnt -- 381,387         -- 1000 merged
from [SMI Reporting].dbo.tblCustomerOffer CO    
    left join [SMI Reporting].dbo.tblCustomer C on CO.ixCustomer = C.ixCustomer
    left join [SMI Reporting].dbo.tblSourceCode SC on CO.ixSourceCode = SC.ixSourceCode
    join PJC_26036_LB_AWOL_Customers_Still_Unknown SM on C.ixCustomer = SM.ixCustomer
where SC.ixCatalog = '402' 
group by CO.ixSourceCode
order by COUNT(SM.ixCustomer) desc --CO.ixSourceCode

select top 10 * from [SMI Reporting].dbo.tblCatalogRequest



select SM.ixCustomer, SUM(O.mMerchandise) Sales
from [SMI Reporting].dbo.tblOrder O
join PJC_26036_LB_AWOL_Customers_Still_Unknown SM on O.ixCustomer = SM.ixCustomer
where    O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtShippedDate >= '01/01/2015' --between '01/01/2012' and '12/31/2012'
GROUP by SM.ixCustomer
order by SUM(O.mMerchandise) desc
/* Out of the remaining 4,120 customers only 73 have placed orders between 1/1/15 and 4/30/15
for a total of $10K and an average of $138 each

125308	1261.50
653281	986.87
1057984	549.91
1796902	509.97
589484	439.95
1991375	436.95
1933372	430.98
1651466	400.00
1922676	373.98
1846978	268.95
237249	251.92
1933061	239.99
810231	239.98
1683082	201.93
1911177	196.94
417993	151.95
1865761	150.00
2012743	144.96
1374548	120.78
1711584	119.99
1293385	109.98
1516773	102.89
1116464	100.00
1606472	100.00
1117167	100.00
1847763	100.00
1291484	98.89
714877	79.99
1975277	75.00
50305	74.98
1657270	70.00
1897766	67.97
1859078	65.98
1973352	65.94
2070645	64.99
1066287	59.99
1826872	50.99
1881175	50.00
1820772	50.00
1865766	50.00
1538927	50.00
2082843	50.00
1845677	49.99
1483871	49.99
489941	49.98
388556	44.99
1468169	44.98
837467	40.00
1781771	40.00
2195443	39.99
1237573	39.99
1796572	37.94
1784577	35.00
1240366	34.99
1289957	30.00
1635267	30.00
1763172	30.00
1712874	30.00
1320870	29.99
1742875	29.99
788717	29.98
1513179	29.98
2889632	26.97
1000921	25.00
1559259	24.99
846633	24.99
1206784	22.99
2920130	19.98
88810	18.99
1218070	17.99
725252	16.99
1072366	10.99
1474871	10.99
*/
