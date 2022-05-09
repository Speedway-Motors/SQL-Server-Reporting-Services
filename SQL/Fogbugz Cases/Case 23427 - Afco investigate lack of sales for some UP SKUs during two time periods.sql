-- Case 23427 - Afco investigate lack of sales for some UP SKUs during two time periods

-- getting the SKUs in the report without importing into a temp table
select * from tblSKU
where ixSKU between 'UP2128' and 'UP2877' -- 745 SKUs on the report output
  and len(ixSKU) = 6                      -- 750
  and ixPGC = 'Yk'                        -- 746   <-- one extra SKU, not going to bother finding/excluding it


select ixSKU, iQuantity, dtShippedDate 
from tblOrderLine
           where ixSKU between 'UP2128' and 'UP2877'
           and len(ixSKU) = 6 
           and dtShippedDate >= '01/01/2013' 
order by dtShippedDate
/*
The first shipment of any of those SKUs since 1/1/2013 was on 6-18-13.  That would prevent any from showing in the previous years date range of 5-3-2013 to 6-6-2013.

The most recent shipment of any of those SKUs is 5-2-14.  That would prevent any from showing in this years date range of 5-3-2014 to 6-6-2014.
*/

select top 10 * from tblDate

-- breakdown by Yr & Period
select iYear, iPeriod, count(*) Yk_OrderLines
from tblOrderLine OL
 join tblDate D on OL.ixShippedDate = D.ixDate
where ixSKU between 'UP2128' and 'UP2877'
           and len(ixSKU) = 6 
           and dtShippedDate >= '01/01/2010' 
           and ixCustomer in ('10511','34795')
group by iYear, D.iPeriod  
order by iYear desc, iPeriod desc                   
/*  LOOKS like orders stopped after period 4 2014

iYear	iPeriod	Yk_OrderLines
2014	4	103
2014	3	29
2014	2	67
2014	1	32
2013	12	34
2013	11	67
2013	10	72
2013	9	145
2013	8	17
2013	7	46
2013	6	150
*/          
           
-- ixDate 16925 starts period 5 2014
select * from tblDate where dtDate = '05/03/2013'   -- 16560
select * from tblDate where dtDate = '06/06/2013'   -- 16594
select * from tblDate where dtDate > '07/23/2014'

-- Transaction history
select * from tblSKUTransaction where ixSKU between 'UP2128' and 'UP2877'
           and len(ixSKU) = 6 
           and ixDate >= 16803 -- 1/1/14     
order by ixDate desc   




select * from tblSKU
where ixSKU between 'UP0001' and 'UP9999' -- 745 SKUs on the report output
  and len(ixSKU) = 6                      -- 750
  and ixPGC = 'Yk'   
  
select ixDate, ixPGC, COUNT(*) 
from tblSnapshotSKU  
where ixDate >= 16438
and ixSKU like 'UP%'
and ixPGC = 'Yk'   
group by ixDate, ixPGC
order by ixDate desc, ixPGC desc

select * from tblSnapshotSKU
where ixPGC = 'Yk'

select top 10 * from tblSnapshotSKU


select SS.ixDate, SS.ixPGC, COUNT(SS.ixSKU) SKUCount
from tblSnapshotSKU  SS -- 2891
where SS.ixDate >= 16925
and SS.ixSKU like 'UP%'
and SS.ixPGC = 'Yk' 
and iFIFOQuantity > 0  
group by SS.ixDate, ixPGC
order by SS.ixDate desc, SS.ixPGC desc
/*
ixDate	ixPGC	SKUCount
17008	Yk	    11
17007	Yk	    11
17006	Yk	    11
17005	Yk	    11
17004	Yk	    11
17003	Yk	    11
17002	Yk	    11
17001	Yk	    11
*/


select SS.ixDate, SS.ixPGC, SS.ixSKU, SS.iFIFOQuantity
from tblSnapshotSKU  SS -- 2891
where SS.ixDate >= 16925
and SS.ixSKU like 'UP%'
and SS.ixPGC = 'Yk' 
and iFIFOQuantity > 0  
--group by SS.ixDate, ixPGC
order by SS.ixDate desc, SS.ixPGC desc


select ixSKU, iQAV, iQOS, sDescription
from vwSKUMultiLocation
where ixSKU like 'UP%'
    and ixPGC = 'Yk' 
    and (iQAV > 0
         OR
         iQOS >0)
/*
ixSKU	iQAV	iQOS	sDescription
UP2883	0	    1	Chrome Shock with Urethane
UP2945	0	    1	RAD-MINI CAGE 21IN NPT
UP2947	0	    1	SHOCK-ALUM MONO 9IN NON ADJ
UP2948	0	    1	RAD, 42-48 CHEVY STREET
UP2949	0	    1	RAD, 42-48 CHEVY STREET
UP2951	0	    1	AFCO T2 DA 9IN DLM RR
UP2953	0	    1	SHOCK-ALUM 7IN DOUBLE ADJ
UP2954	0	    3	AFCO T2 DA 9IN DLM LR BEHIND
UP2955	0	    3	C/O HDW KIT AFC THR BOD AL SHO
UP2956	0	    2	ROD END SWIV-ALIGN CONV KIT
UP589	1	    1	SBC 67-69 CAMARO HEADER SET
*/

select * from tblDate where ixDate = 16965