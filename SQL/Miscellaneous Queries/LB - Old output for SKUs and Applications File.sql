-- LB - Old output for SKUs and Applications File

USE [SMITemp]

select * from [PJC_OLD_SKUs and Applications Output]

select distinct itemid from [PJC_OLD_SKUs and Applications Output]
order by itemid

select application_group, application_subgroup, 
COUNT(*) SKUcount
from [PJC_OLD_SKUs and Applications Output]
group by application_group, application_subgroup
order by application_group, application_subgroup
/*
qty	    application_group
12997	Cars
14815	
1380	Pedal Cars
43879	Race Cars
935	    Trucks
*/
