-- LNK SQL LIVE 2    lastest SKU Transactions

-- SMIHD-20120 - SKU Transactions updates are getting missed in AFCO Reporting
SELECT ixDate, 
    FORMAT(count(1),'###,###') 'Records', 
    FORMAT(max(iSeq)+1,'###,###') 'MaxSeq+1', 'SMI' 'Where',
    (count(1)-(max(iSeq)+1)) 'MissingTrans'
from tblSKUTransaction
where ixDate >= 19751 --  01/27/2022               
group by ixDate
order by ixDate desc
/*
ixDate	Records	MaxSeq+1	Where	MissingTrans
19469	18,417	18,417	    SMI	    0           --04/20/2021     AS OF 3:30PM 5/1/21
*/




select top 5 ixOrder, FORMAT(dtOrderDate,'MM/dd/yyyy') OrderDate, T.chTime 
from tblOrder O
    left join tblTime T on O.ixOrderTime = T.ixTime
order by dtOrderDate desc, T.ixTime desc
/*

ix
Order	OrderDate	chTime      AS OF 3:30PM 5/1/21
Q197440	04/20/2021	16:58:21  
926640	04/20/2021	16:57:00  
926639	04/20/2021	16:56:12  
926638	04/20/2021	16:55:15  
926637	04/20/2021	16:52:26  

*/


