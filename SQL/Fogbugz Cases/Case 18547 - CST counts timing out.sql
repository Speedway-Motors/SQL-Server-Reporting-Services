-- Case 18547 - CST counts timing out

/* TESTING CST PROC
 allowed Markets:
    R  - Race
    SR - Street
    B  - Both (Street & Race)
    SM - Sprint Midget
    2B - T-Bucket
    AD - Afco/Dynatech (Even tho CST shows it as an option, it will not work. No PGC's(and therefore SKUs) are assigned to a market of AD)    
*/    
 -- Smallest Segment
 EXEC spCSTSegmentPull 12,'5','10000','SM','SM'--      11 in  4 seconds @5-3-2013
  
 EXEC spCSTSegmentPull 36,'3','500','R','R'    --  24,025 in 15 seconds @5-3-2013

 EXEC spCSTSegmentPull 12,'5','1000','SR','SR' --   4,613 in 12 seconds @5-3-2013
 
 -- Largest segments
 EXEC spCSTSegmentPull 72,'1','1','SR','SR'    -- 318,484 in 34 seconds @5-2-2013  
 EXEC spCSTSegmentPull 72,'1','1','R','R'      --  82,149 in 18 seconds @5-3-2013   
 EXEC spCSTSegmentPull 72,'1','1','B','B'      -- 225,547 in 24 seconds @5-3-2013
 EXEC spCSTSegmentPull 72,'1','1','SM','SM'    --  37,416 in  6 seconds @5-3-2013
 EXEC spCSTSegmentPull 72,'1','1','2B','2B'    --  37,144 in  5 seconds @5-3-2013 
 EXEC spCSTSegmentPull 72,'1','1','AD','AD' 

select PGC.ixMarket, M.sDescription, COUNT(distinct PGC.ixPGC) PGCcount, COUNT(SKU.ixSKU) SKUCount
from tblPGC PGC
    left join tblSKU SKU on SKU.ixPGC = PGC.ixPGC
    left join tblMarket M on M.ixMarket = PGC.ixMarket
where (SKU.flgDeletedFromSOP = 0 
       or
       SKU.flgDeletedFromSOP is NULL)
group by PGC.ixMarket, M.sDescription
order by SKUCount desc
/*
Market	sDescription	PGCcount	SKUCount -- as of 05/03/2013
R	    Race	        83	        79,666
SR	    StreetRod	    69	        38,100
B	    BothRaceStreet	73	        16,267
SM	    SprintMidget	21	        9,306
2B	    TBucket	        19	        2,375


PC	    PedalCar	    22	        2,030
NULL	NULL	        5	        729
SC	    SportCompact	20	        673
TE	    Tools&Equip	    7	        477
UK	    Unknown	        1	        0
*/

select * from tblPGC where ixMarket is NULL




