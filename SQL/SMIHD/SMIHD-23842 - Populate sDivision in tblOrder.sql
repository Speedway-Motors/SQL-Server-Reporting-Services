-- SMIHD-23842 - Populate sDivision in tblOrder

-- SELECT @@SPID as 'Current SPID' -- 62 

-- SET ROWCOUNT 50000

	UPDATE O
		SET O.sDivision = 'SMI'
		FROM tblOrder O
		WHERE ixOrderDate < 19725 --and 14200 -- 2 batches to go  
			and O.sDivision is NULL  

/*
19725	01/01/2022
13881	01/01/2006
*/





/*******   ON AWS	****************/

-- SELECT @@SPID as 'Current SPID' -- 109 

--										       k
select FORMAT(count(*),'###,###') 'OrdCnt'	-- 50  @3:24 GOAL		-- AWS updating about 150k/hr   
from tblOrder								-- 103 @3:32
where sDivision is NULL						-- ##### @
											-- ##### @
											

/*
select sDivision, FORMAT(count(*),'###,###') 'OrdCnt'
from tblOrder
group by sDivision
order by count(*) desc

sDiv	OrdCnt
====	=========	@3/9/22 09:38
SMI		9,342,257
EMI		    4,968
TSS		    2,621
BDC		      883
NULL	      152
18151ý43606	    1
*/
























/*											
SELECT FORMAT(count(*),'###,###') 'OrdCnt'	
FROM tblOrder								 
WHERE ixOrderDate < 19725 and -- k
	sDivision IS NULL							-- 50 @3:24

*/


/**********		SMI		**********
select sDivision, FORMAT(count(*),'###,###') 'OrdCnt' -- 3-4 mins
from tblOrder
group by sDivision
order by count(*) desc

	BEFORE
Div		Orders
=====	=========
NULL	9,272,697
EMI		4
SMI		11,396

	SO FAR
Div		Orders
=====	=========		@3/2/22 09:20
NULL	4,746,271
SMI		4,561,909
EMI		    4,957
TSS		    2,621
BDC		      883
18151ý43606	1




select * from tblOrder where sDivision = '18151ý43606'


			SELECT COUNT(*) 
			FROM [SMITemp].dbo.PJC_SMIHD23842_SMI_sDivision DIV -- 8,445


			BEGIN TRAN 

				UPDATE O
				SET O.sDivision = DIV.sDivision
				from tblOrder O
					join [SMITemp].dbo.PJC_SMIHD23842_SMI_sDivision DIV on O.ixOrder = DIV.ixOrder COLLATE SQL_Latin1_General_CP1_CI_AS
				WHERE O.sDivision is NULL

			ROLLBACK TRAN

			BEGIN TRAN 
				UPDATE O
				SET O.sDivision = 'AFCO'
				from [AFCOReporting].dbo.tblOrder O
				WHERE O.sDivision is NULL
			ROLLBACK TRAN
*/



/**********		AFCO	**********
		
			select sDivision, FORMAT(count(*),'###,###') 'OrdCnt'
			from [SMITemp].dbo.PJC_SMIHD23842_AFCO_sDivision
			group by sDivision

			sDivision	OrdCnt
			DEWITTS		32,242
			LONGACRE	60,800
			CSI			 5,280
			PROSHOCKS	19,967


			Select DIV.*,O.ixOrder, O.sDivision
			from [SMITemp].dbo.PJC_SMIHD23842_AFCO_sDivision DIV
				left join [AFCOReporting].dbo.tblOrder O on DIV.ixOrder COLLATE SQL_Latin1_General_CP1_CI_AS = O.ixOrder
			WHERE O.sDivision is NOT NULL
			-- And DIV.sDivision <> O.sDivision
			order by DIV.ixOrder desc

			SELECT COUNT(*) 
			FROM [SMITemp].dbo.PJC_SMIHD23842_AFCO_sDivision DIV -- 118,289
			

select sDivision, FORMAT(count(*),'###,###') 'OrdCnt'
from [AFCOReporting].dbo.tblOrder
group by sDivision

sDivision	Orders
=========	======
NULL		521,210
AFCO		151
DEWITTS		110
LONGACRE	80
PROSHOCKS	37

	AFTER UPDATES
AFCO		403,412
CSI			  5,280
DEWITTS		 32,259
LONGACRE	 60,801
PROSHOCKS	 19,925
*/

