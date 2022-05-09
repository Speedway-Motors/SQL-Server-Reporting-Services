-- SMIHD-3538 - potential logic changes to Loyalty Builders data extracts

SELECT TOP 10 * from vwLBSampleTransactions_TEMP_SMIHD3538
SELECT TOP 10 * from vwLBSampleTransactions
/*
custid	itemid	    txdate	    quantity	amount	order_channel
10042	1750527	    03/10/2010	2	        33.98	PHONE
10042	91089400	03/10/2010	1	        17.99	PHONE
10042	106223559	08/13/2012	1	        19.99	PHONE
10042	66582207	08/13/2012	1	        31.99	PHONE
10042	80285-23	09/19/2009	1	        69.99	PHONE
10042	91720036	06/06/2011	2	        29.98	PHONE
10042	917250-075	06/06/2011	3	        41.97	PHONE
10042	56052652	06/11/2013	1	        49.99	PHONE
10042	91011598	06/11/2013	1	        34.99	PHONE
10042	10610270	04/16/2012	2	        45.98	PHONE
*/
select COUNT(*) from vwLBSampleTransactions                 -- 7,122,797
select COUNT(*) from vwLBSampleTransactions_TEMP_SMIHD3538  -- 7,078,895

select SUM(quantity*amount) Sales -- $740,604,845
FROM vwLBSampleTransactions

select SUM(quantity*amount) Sales -- $732,015,470
FROM vwLBSampleTransactions_TEMP_SMIHD3538

select SUM(quantity*amount) Sales
FROM vwLBSampleTransactions
WHERE txdate = '12/07/2015'  -- $454,010

select SUM(quantity*amount) Sales
FROM vwLBSampleTransactions_TEMP_SMIHD3538
WHERE txdate = '12/07/2015'  -- $445,715

select * from vwLBSampleTransactions -- 3969 rows
where txdate = '12/07/2015' 

select * from vwLBSampleTransactions_TEMP_SMIHD3538 -- 3934 rows
where txdate = '12/07/2015' 


select * from tblOrderLine where dtOrderDate = '12/07/2015'
and ixSKU IN(
                -- item ids not in new view
                select itemid 'ixSKU' from vwLBSampleTransactions
                where txdate = '12/07/2015' 
                and itemid not in (select itemid 
                                   from vwLBSampleTransactions_TEMP_SMIHD3538
                                   where txdate = '12/07/2015')
             )
order by ixSKU