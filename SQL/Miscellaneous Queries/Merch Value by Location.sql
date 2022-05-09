-- Merch value by location

/********************   SMI Merch   **********************************/
    select SL.ixLocation 'LOC', 
    --SKU.sDescription, SL.ixSKU, SL.iQOS, SKU.mAverageCost, 
    ROUND(SUM (SL.iQOS*SKU.mAverageCost),0,10) 'TotMerchCost'
    from tblSKULocation SL
        join tblSKU SKU on SL.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = SKU.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
    where SKU.flgDeletedFromSOP = 0
        and SKU.flgIntangible = 0
        and SL.iQOS > 0
        and sDescription not LIKE '%LABOR%'
        and SL.ixLocation <> 99
    GROUP BY SL.ixLocation
    /*  
        TOT
    LOC	MerchCost
    === ===========
    99  $47,660,171 
    47	   $975,785
    98	   $304,679
    97	    $39,493
    */
        
    -- can't do location 99 because datatype smallmoney won't accomodate value
    select sDescription, SL.ixSKU, SL.iQOS, SKU.mAverageCost
    --ROUND(SUM (SL.iQOS*SKU.mAverageCost),0,10) 'TotMerchCost'
    from tblSKULocation SL
        join tblSKU SKU on SL.ixSKU = SKU.ixSKU
    where SKU.flgDeletedFromSOP = 0
        and SKU.flgIntangible = 0
        and SL.iQOS > 0
        and sDescription not LIKE '%LABOR%'
        and SL.ixLocation = 99
    /* Exported to Excel manually created TotMerchCost formula and totaled column
    ix
    Location	TotMerchCost
    99           $47,660,171 
    */



/********************   AFCO Merch  **********************************/
    select SL.ixLocation 'LOC', 
    --SKU.sDescription, SL.ixSKU, SL.iQOS, SKU.mAverageCost, 
    ROUND(SUM (SL.iQOS*SKU.mAverageCost),0,10) 'TotMerchCost'
    from tblSKULocation SL
        join tblSKU SKU on SL.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = SKU.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
    where SKU.flgDeletedFromSOP = 0
        and SKU.flgIntangible = 0
        and SL.iQOS > 0
        and sDescription not LIKE '%LABOR%'
        and SL.ixLocation <> 99
    GROUP BY SL.ixLocation
    /*  
        TOT
    LOC	MerchCost
    === ==========
    99  $9,715,470     
    68	      $290
    
    */
        
    -- can't do location 99 because datatype smallmoney won't accomodate value
    select sDescription, SL.ixSKU, SL.iQOS, SKU.mAverageCost
    --ROUND(SUM (SL.iQOS*SKU.mAverageCost),0,10) 'TotMerchCost'
    from tblSKULocation SL
        join tblSKU SKU on SL.ixSKU = SKU.ixSKU
    where SKU.flgDeletedFromSOP = 0
        and SKU.flgIntangible = 0
        and SL.iQOS > 0
        and sDescription not LIKE '%LABOR%'
        and SL.ixLocation = 99
    /* Exported to Excel manually created TotMerchCost formula and totaled column
    ix
    Location	TotMerchCost
    99            $9,715,470 
    */



Select SL.ixLocation, SL.ixSKU, S.sDescription, SL.iQOS
from tblSKULocation SL
    join tblSKU S on SL.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
where SL.ixLocation = 68
and SL.iQOS > 0
/*
ixLocation	ixSKU	    sDescription	                iQOS
68	        S49-00001	DYNATECH LOGO TAG-304 STAIN.	725
*/




SELECT * FROM tblLocation
/*
                                     
Loc	sDescription	            State
=== ==========================  =====
47  Boonville	                IN
97  Trackside Support Services	NE
98  Eagle	                    NE
99  Lincoln	                    NE


Loc	sDescription	            State
=== ==========================  =====
30	Eagle	                    NE
31	Trackside Support Services	NE
68	Lincoln	                    NE
99	Boonville	                IN

*/







