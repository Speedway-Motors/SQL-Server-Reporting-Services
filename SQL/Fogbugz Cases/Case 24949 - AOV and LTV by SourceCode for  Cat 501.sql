-- Case 24949 - AOV and LTV by SourceCode for  Cat 501
select ixSourceCode, SUM(MLTotal) LTV, SUM(Frequency) TotFrequency,
(SUM(MLTotal)/ SUM(Frequency)) AOV
FROM
        (
        select CO.ixCustomer, CO.ixSourceCode, 
            CS.Frequency,
            CS.MLTotal
        from tblCustomerOffer CO                                    -- 22,113
            join CSTCustSummary CS on CO.ixCustomer = CS.ixCustomer
        where CO.ixSourceCode in ('50140A','50140C','50140F','50140H','50140J','50141A','50141C','50141F','50141H','50141J','50144A','50144C','50144F','50144H','50144J',
                               '50145A','50145C','50145F','50145H','50145J','50148A','50148C','50148F','50148H','50148J','50149A','50149C','50149F','50149H','50149J')
         ) X              
group by ixSourceCode       
order by ixSourceCode    



            