-- ixDates 

-- 1st of the year
ixDate	Date
======  ========
18629	01/01/19
18264	01/01/18
17899	01/01/17
17533	01/01/16
17168	01/01/15
16803	01/01/14
16438	01/01/13
16072	01/01/12
15707	01/01/11
15342	01/01/10
14977	01/01/09
14611	01/01/08
14246	01/01/07
13881	01/01/06


-- 2019 calendar months
ixDate between 18629 and 18659	--	01/01/19 - 01/31/19     
ixDate between 18660 and 18687	--	02/01/19 - 02/28/19     
ixDate between 18688 and 18718	--	03/01/19 - 03/31/19     
ixDate between 18719 and 18748	--	04/01/19 - 04/30/19     
ixDate between 18749 and 18779	--	05/01/19 - 05/31/19   
ixDate between 18780 and 18809	--	06/01/19 - 06/30/19 
ixDate between 18810 and 18840	--	07/01/19 - 07/31/19 
ixDate between 18841 and 18871	--	08/01/19 - 08/31/19 
ixDate between 18872 and 18901	--	09/01/19 - 09/90/19   
ixDate between 18902 and 18932	--	10/01/19 - 10/31/19 
ixDate between 18933 and 18962	--	11/01/19 - 11/31/19 
ixDate between 18963 and 18993	--	12/01/19 - 12/31/19 

-- 2018 calendar months
ixDate between 18264 and 18294	--	01/01/18 - 01/31/18   
ixDate between 18295 and 18322	--	02/01/18 - 02/28/18  
ixDate between 18322 and 18353	--	03/01/18 - 03/31/18  
ixDate between 18354 and 18383	--	04/01/18 - 04/30/18  
ixDate between 18384 and 18414	--	05/01/18 - 05/31/18  
ixDate between 18415 and 18444	--	06/01/18 - 06/30/18  
ixDate between 18445 and 18475	--	07/01/18 - 07/31/18  
ixDate between 18476 and 18506	--	08/01/18 - 08/31/18  
ixDate between 18507 and 18536	--	09/01/18 - 09/30/18  
ixDate between 18537 and 18567	--	10/01/18 - 10/31/18  
ixDate between 18568 and 18597	--	11/01/18 - 11/30/18  
ixDate between 18598 and 18628	--	12/01/18 - 12/31/18  





select ixDate, dtDate
from tblDate 
where iYear = 2018
order by ixDate
