-- RETURNS...  QTY Returned vs. QTY Credited

 select sum(CMD.iQuantityReturned) RET, sum(CMD.iQUantityCredited) CRED
 from tblCreditMemoDetail CMD
		left join tblCreditMemoMaster CMM on CMM.ixCreditMemo = CMD.ixCreditMemo
 where CMM.dtCreateDate >= '01/01/2010'
   and CMM.dtCreateDate < '08/11/2010'
   
   
YR	RET		CRED
YTD	35762	35762  --  0.0%
09	41082	47770  -- 16.2%
08  36740	46087  -- 25.4%
07	34697	42481  -- 22.4%