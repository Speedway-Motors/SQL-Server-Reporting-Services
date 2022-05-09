SELECT 
    SCP.ixSourceCode,
SCP.ixMostSimilarSourceCode,
--
SCP.iQuantityPrinted SCPQP,
SSC.iQuantityPrinted SSCQP,
SSC.OrderCount,
cast((cast(SCP.iQuantityPrinted as decimal)/cast(SSC.iQuantityPrinted as decimal)) * cast(SSC.OrderCount as decimal) as int)            TargetOrders,
--
SSC.CustCount,
cast((cast(SCP.iQuantityPrinted as decimal)/cast(SSC.iQuantityPrinted as decimal)) * cast(SSC.CustCount as decimal) as int)             TargetCustomers,
--
SSC.SalesToDate,
cast((cast(SCP.iQuantityPrinted as decimal)/cast(SSC.iQuantityPrinted as decimal)) * cast(SSC.SalesToDate as decimal) as decimal(12,2)) TargetSales
--
FROM vwSourceCodePerformance SCP
     join vwSourceCodePerformance SSC on SSC.ixSourceCode = SCP.ixMostSimilarSourceCode
where SCP.ixSourceCode = '28719'
order by SCP.ixSourceCode


-- TargetGoal of a Source code =   TotCountOrds * (#newQP/#origQP)
ixSourceCode	OrderCount	CustCount	SalesToDate
28710	        10600	    5766	    2268008.88



