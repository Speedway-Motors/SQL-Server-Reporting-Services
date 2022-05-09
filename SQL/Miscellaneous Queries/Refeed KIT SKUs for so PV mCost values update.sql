-- REFEED KIT SKUs for Connie so PV mCost values update      

select flgActive, count(*)
from tblSKU
where flgDeletedFromSOP = 0
    and flgIsKit = 1            -- 31,766 Kits      23,151 Active    8,615 Innactive
    and dtDateLastSOPUpdate < '01/17/19'
group by flgActive
/*
flg     As Of
Active	16:50
0	        0 
1	        0
*/

select ixSKU, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
from tblSKU
where flgDeletedFromSOP = 0
    and flgIsKit = 1
    --and flgActive = 0 -- FEED innactive SKUs LAST
    and dtDateLastSOPUpdate < '01/17/19' --between '11/01/18' and 
order by dtDateLastSOPUpdate, ixTimeLastSOPUpdate -- 1/17 25285 to 1/17 33577   935 SKUs
                                                  -- Records I pushed today started at ixTime 34055

-- CURRENT BATCH
-- LU from 1/1 to 1/16    4,375 SKUs    started at 09:40  ETA 10:30 

-- FEED INNACTIVE SKUS FROM that range next



select D.iMonth, D.iYear, count(ixSKU) 'SKUs'
from tblSKU S
    left join tblDate D on D.dtDate = S.dtDateLastSOPUpdate
where flgDeletedFromSOP = 0
    and flgIsKit = 1
    --and flgActive = 1
group by D.iMonth, D.iYear
order by D.iYear, D.iMonth
/*
iMonth	iYear	SKUs
12	    2018	 6,858
11	    2018	12,654
10	    2018	 6,705
*/

select ixSKU, FORMAT(dtDateLastSOPUpdate,'yyyy.dd.MM') LastSOPUpdate, ixTimeLastSOPUpdate, mAverageCost, mLatestCost
from tblSKU
where flgDeletedFromSOP = 0
and flgIsKit = 1
and ixSKU in ('106230-9-1-8-10','10673-9-7-12','98611250')
/*
BEFORE      
                Last        ixTimeLast  mAvg    mLatest
ixSKU	        SOPUpdate	SOPUpdate	Cost	Cost
106230-9-1-8-10	2019.17.01	33152	    100.49	101.91
10673-9-7-12	2019.17.01	33153	    0.00	85.00
98611250	    2019.17.01	33154	    10.68	10.61

AFTER
                Last        ixTimeLast  mAvg    mLatest
ixSKU	        SOPUpdate	SOPUpdate	Cost	Cost
106230-9-1-8-10	2019.17.01	34571	    100.49	101.91
10673-9-7-12	2019.17.01	34571	    0.00	85.00
98611250	    2019.17.01	34572	    10.68	10.61
*/

SELECT ixSKU, ixVendor, iOrdinality, mCost, FORMAT(dtDateLastSOPUpdate,'yyyy.dd.MM') LastSOPUpdate, ixTimeLastSOPUpdate 
FROM tblVendorSKU
WHERE ixSKU in ('106230-9-1-8-10','10673-9-7-12','98611250')
AND iOrdinality = 1
/*
ixSKU	        ixVendor	iOrdinality	mCost	LastSOPUpdate	ixTimeLastSOPUpdate
106230-9-1-8-10	0002	    1	        101.908	2019.17.01	    34571
10673-9-7-12	0002	    1	        85.00	2019.17.01	    34572
98611250	    0002	    1	        10.61	2019.17.01	    34572

VALUES UPDATED AND MATCH COSTS that Connie sent
*/


