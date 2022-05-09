-- Opt-out customers being removed by Loyalty Builders LB

SELECT TOP 10 * FROM [PJC_CustsOptOutsSentToLB_20160630] order by NEWID()

SELECT optout_market, COUNT(*)
FROM [PJC_CustsOptOutsSentToLB_20160630]
GROUP BY optout_market



SELECT * FROM PJC_CustsSentToLB_20160630

SELECT * FROM PJC_CustsNOTSentToLB_20160630

SELECT TOP 10 * FROM PJC_CustSentToLBbutAWOLfromPULL

SELECT Distinct B.optout_market, COUNT(A.ixCustomer)-- 7147
FROM PJC_CustSentToLBbutAWOLfromPULL A
    JOIN PJC_CustsOptOutsSentToLB_20160630 B ON B.custid = A.ixCustomer
GROUP BY B.optout_market    


SELECT COUNT(Distinct A.ixCustomer)-- 7147
FROM PJC_CustSentToLBbutAWOLfromPULL A
    JOIN PJC_CustsOptOutsSentToLB_20160630 B ON B.custid = A.ixCustomer
GROUP BY B.optout_market    