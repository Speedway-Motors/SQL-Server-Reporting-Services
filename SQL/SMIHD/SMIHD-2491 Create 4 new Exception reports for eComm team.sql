-- SMIHD-2491 Create 4 new Exception reports for eComm team
/*
Pat, we have a couple of SSRS reports that need created when you have the time. I have no idea where to create tasks for you.

They will all need a subscription setup to email  an excel file to Wyatt ( we can add more people on as needed later) before 9:00 am on Monday.

Nothing fancy, most of the leg work has been done. Just call the stored procedures (from DW1) and use the fields it returns.
If you have access to JIRA this relates to tasks
https://speedwaymotors.atlassian.net/browse/DI-444
https://speedwaymotors.atlassian.net/browse/DI-443 


Report Names:

    1 - SEMA Categories Missing Images
    2 - SKUs Missing Product Lines
    3 - SKU Bases Missing Images
4 - SKU Bases With Short Info Tabs

*/

/********   1 - SEMA Categories Missing Images   ********/
    -- How to call from MSSQL
    select sCategoryName, sSubcategoryName, sPartName
    , COUNT(*) 'RecordCount'
    from openQuery([TNGREADREPLICA],'CALL spCategory_MissingImage();') -- 301 rows  <-- MySQL proc written by Ron
    group by sCategoryName, sSubcategoryName, sPartName
    order by sCategoryName, sSubcategoryName, sPartName
    /*
    sCategoryName	        sSubcategoryName	    sPartName
    Emission Control	    Control Modules	        Powertrain Control Modules
    Air and Fuel Delivery	Carburetion	            Carburetor Metering Rod
    Driveline and Axles	    Driveshaft	            Driveshaft End Yokes
    Safety Products	        Miscellaneous Safety	Safety Wire
    */



/********   2 - SKUs Missing Product Lines   ********/
    -- How to call from MSSQL
    select * 
    from openQuery([TNGREADREPLICA],'CALL spBase_MissingProductLine()')
    order by ixSOPSKUBase -- 17,099 rows     <-- MySQL proc written by Ron
    or
    exec ('call spBase_MissingProductLine') at [TNGREADREPLICA];
    /*
    ixSOPSKUBase	sName	                                                    ixProductLine	sSubCategoryName	sCategoryName	sSemaPartName	sBrandName	        ixSOPBrand
    1063840FBNCBG	Afco 3840FBNCBG Eliminator BNC Front Shock, GM A, B-Bodies  NULL	        NULL	            NULL	        NULL	        AFCO	            10038
    124114	        Alpinestars GP Race Uniform                                 NULL	        NULL	            NULL	        NULL	        Alpinestars	        10310
    1241209	        TECH 1-K SHOES	                                            NULL	        NULL	            NULL	        NULL	        No Brand Assigned	10013
    */





/********   3 - SKU Bases Missing Images    ********/
    -- How to call from MSSQL
    SELECT ixSOPSKUBase, sName,
        sCategoryName, sSubCategoryName, sSemaPartName,
        sBrandName, ixSOPBrand,
        COUNT(*) 'RecordCount'
    FROM openQuery([TNGREADREPLICA],'CALL spBase_MissingImage();')
    GROUP BY ixSOPSKUBase, sName,
        sCategoryName, sSubCategoryName, sSemaPartName,
        sBrandName, ixSOPBrand
    ORDER BY ixSOPSKUBase --519 rows   <-- MySQL proc written by Ron
    or
    exec ('CALL spBase_MissingImage;') at [TNGREADREPLICA]; 
    /*
    ixSOPSKUBase	sName	                                                                    sSubCategoryName	        sCategoryName	sSemaPartName	    sBrandName	    ixSOPBrand
    725941157	    Vintage Air 941157 1958-59 Chevy Truck, Std. GenIV SureFit Complete Kit	    A/C Clutch and Compressor	HVAC	        A/C Compressors	    Vintage Air	    11117
    */




/******** 4 - SKU Bases With Short Info Tabs   ********/
    -- How to call from MSSQL
    SELECT ixSOPSKUBase, sName,         -- 1,068 rows 
        sTextBlock 'InfoTabTextBlock',
        sCategoryName, sSubCategoryName, sSemaPartName, sBrandName, ixSOPBrand,
        1 as 'RecordCount' 
    FROM openQuery([TNGREADREPLICA],'CALL spBase_ShortInfoTab();') --   <-- MySQL proc written by Ron
    ORDER BY ixSOPSKUBase    
    
    
    SELECT sTextBlock
    FROM openQuery([TNGREADREPLICA],'CALL spBase_ShortInfoTab();') --   <-- MySQL proc written by Ron
    ORDER BY sTextBlock   
        
    
    /*
    ixSOPSKUBase	sName	                        sTextBlock	                                sSubCategoryName	    sCategoryName	    sSemaPartName	            sBrandName	ixSOPBrand
    5509868	        Tri-Bar Air Cleaner Wing Nut	Tri-Bar Air Cleaner Wing Nut, 1/4&quot; 	Air Injection System	Emission Control	Air Cleaner Mounting Nuts	Mr Gasket	10476
    */


SELECT * FROM
(    SELECT *
    FROM openQuery([TNGREADREPLICA],'CALL spBase_ShortInfoTab();')
) X
WHERE X.sTextBlock is NULL -- 1,066
ORDER BY sTextBlock      





