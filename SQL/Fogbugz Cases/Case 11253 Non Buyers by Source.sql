select
	COUNT(1) as 'Customers',
--	D.dtDate,
--	C.ixCustomer,
--	datediff(m, D.dtDate, getdate()),
	(case
		when DATEDIFF(m, D.dtDate, getdate()) <= 12 THEN '0-12'
		when DATEDIFF(m, D.dtDate, getdate()) <= 24 then '13-24'
		when DATEDIFF(m, D.dtDate, getdate()) <= 36 then '25-36'
		when DATEDIFF(m, D.dtDate, getdate()) <= 48 then '37-48'
		when DATEDIFF(m, D.dtDate, getdate()) <= 60 then '49-60'
		when DATEDIFF(m, D.dtDate, getdate()) <= 72 then '61-72'
		when DATEDIFF(m, D.dtDate, getdate()) <= 84 then '73-84'
		else '84+'
	end) as 'Age',
	isnull(SC.sSourceCodeType, 'Unknown'),
	isnull(SC.sDescription, 'Unknown'),
	isnull(C.ixSourceCode, 'Unknown')
from
	tblCustomer C
	left join tblDate D on C.ixAccountCreateDate=D.ixDate
	left join tblSourceCode SC on C.ixSourceCode= SC.ixSourceCode
where
	(C.ixCustomer in 
		(select distinct O.ixCustomer from tblOrder O))
	and C.dtAccountCreateDate >= '2000'
group by
	(case
		when DATEDIFF(m, D.dtDate, getdate()) <= 12 THEN '0-12'
		when DATEDIFF(m, D.dtDate, getdate()) <= 24 then '13-24'
		when DATEDIFF(m, D.dtDate, getdate()) <= 36 then '25-36'
		when DATEDIFF(m, D.dtDate, getdate()) <= 48 then '37-48'
		when DATEDIFF(m, D.dtDate, getdate()) <= 60 then '49-60'
		when DATEDIFF(m, D.dtDate, getdate()) <= 72 then '61-72'
		when DATEDIFF(m, D.dtDate, getdate()) <= 84 then '73-84'
		else '84+'
	end),
	SC.sSourceCodeType,
	SC.sDescription,
	C.ixSourceCode
order by
	(case
		when DATEDIFF(m, D.dtDate, getdate()) <= 12 THEN '0-12'
		when DATEDIFF(m, D.dtDate, getdate()) <= 24 then '13-24'
		when DATEDIFF(m, D.dtDate, getdate()) <= 36 then '25-36'
		when DATEDIFF(m, D.dtDate, getdate()) <= 48 then '37-48'
		when DATEDIFF(m, D.dtDate, getdate()) <= 60 then '49-60'
		when DATEDIFF(m, D.dtDate, getdate()) <= 72 then '61-72'
		when DATEDIFF(m, D.dtDate, getdate()) <= 84 then '73-84'
		else '84+'
	end),
	SC.sSourceCodeType,
	SC.sDescription,
	C.ixSourceCode
	
	