-- SKU Location SUM of all Qty fields
select ixLocation 'Loc', 
    FORMAT(COUNT(ixSKU),'###,###') 'SKUs', 
    FORMAT(SUM(iQOS),'###,###') 'TotQOS', 
    FORMAT(SUM(iQAV),'###,###') 'TotQAV',
    FORMAT(SUM(iQC),'###,###') 'TotQC',
    FORMAT(SUM(iQCBOM),'###,###') 'TotQCBOM',
    FORMAT(SUM(iQCB),'###,###') 'TotQCB',
    FORMAT(SUM(iQCXFER),'###,###')  'TotQCXFER'
from tblSKULocation 
--where ixLocation = 20
group by ixLocation
order by ixLocation
/*  results on LNK-SQL-LIVE-1 as of 3-26 @10:23  

Loc	SKUs	TotQOS	    TotQAV	    TotQC	TotQCBOM	TotQCB	TotQCXFER
=== ======= ==========  =========   =====   =========   ======  =========
20                                                                          -- started deleting Loc 20 records at 9:40
25	509,367	503,539	    494,712	    49			
47	509,367	451,543	    451,227				
85	509,367	770,982	    745,530	    712			
99	509,367	13,698,223	7,556,850	47,575	5,598,293	48,896	



20	260,095     -- AWS @12:47
*/
