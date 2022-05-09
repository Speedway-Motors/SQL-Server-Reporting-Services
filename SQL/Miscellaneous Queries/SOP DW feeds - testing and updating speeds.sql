-- SOP FEED UPDATE SPEEDS
  
/************************** Populate temp table so that update timestamps can be used to determine speed **************************/

/****  BINS ****/
    -- TRUNCATE TABLE [SMITemp].dbo.PJC_Bin_toRefeed
    -- insert into [SMITemp].dbo.PJC_Bin_toRefeed
    SELECT --  top 21600 
        ixBin, dtDateLastSOPUpdate, ixTimeLastSOPUpdate -- 40867 to 40978
    --into [SMITemp].dbo.PJC_Bin_toRefeed
    FROM [SMI Reporting].dbo.tblBin
    WHERE flgDeletedFromSOP = 0
        and dtDateLastSOPUpdate < '11/12/2016' --  between '05/01/2014' and '06/01/2014'
    ORDER BY dtDateLastSOPUpdate, ixTimeLastSOPUpdate

    SELECT COUNT(*) FROM [SMI Reporting].dbo.tblBin -- 210,718
                    WHERE flgDeletedFromSOP = 0     -- 201,362
                    
    SELECT TOP 10 * FROM [SMI Reporting].dbo.tblBin
    
    SELECT * FROM [SMITemp].dbo.PJC_Bin_toRefeed


/****  BOMS  ****/
    -- TRUNCATE TABLE [SMITemp].dbo.PJC_BOM_toRefeed
    -- insert into [SMITemp].dbo.PJC_BOM_toRefeed
    SELECT --top 8979 
        ixFinishedSKU, dtDateLastSOPUpdate, ixTimeLastSOPUpdate -- 40867 to 40978
    --into [SMITemp].dbo.PJC_BOM_toRefeed
    FROM [SMI Reporting].dbo.tblBOMTemplateMaster
    WHERE flgDeletedFromSOP = 0
        and dtDateLastSOPUpdate < '08/04/2017' --  between '06/01/2014' and '06/01/2014'
        and ixTimeLastSOPUpdate < 46200
        --and ixFinishedSKU = '1012006201'
    ORDER BY dtDateLastSOPUpdate, ixTimeLastSOPUpdate

    select * from [SMITemp].dbo.PJC_BOM_toRefeed

    
    SELECT COUNT(*) FROM [SMI Reporting].dbo.tblBOMTemplateMaster -- 10,892
                    WHERE flgDeletedFromSOP = 0                   -- 10,534
                    
    SELECT TOP 10 * FROM [SMI Reporting].dbo.tblBOMTemplateMaster   
    
    -- BE SURE TO UPDATE tblBOMTemplateTemplate too for any that need to be flagged as deleted from SOP
 
 
 
 
/****  BOM TRANSFERSS  ****/
    -- TRUNCATE TABLE [SMITemp].dbo.PJC_BOM_toRefeed
    -- insert into [SMITemp].dbo.PJC_BOM_toRefeed
    SELECT top 7500 
        ixTransferNumber, dtDateLastSOPUpdate, ixTimeLastSOPUpdate -- 40867 to 40978
    --into [SMITemp].dbo.PJC_BOM_toRefeed
    FROM [SMI Reporting].dbo.tblBOMTransferMaster
    WHERE ---flgDeletedFromSOP = 0
         dtDateLastSOPUpdate < '08/04/2017' --  between '06/01/2014' and '06/01/2014'
        --and ixFinishedSKU = '1012006201'
    ORDER BY dtDateLastSOPUpdate, ixTimeLastSOPUpdate

    select * from [SMITemp].dbo.PJC_BOM_toRefeed

    
    SELECT COUNT(*) FROM [SMI Reporting].dbo.tblBOMTransferMaster -- 10,892

                    
    SELECT TOP 10 * FROM [SMI Reporting].dbo.tblBOMTransferMaster  
    WHERE ixTransferNumber = '1530405-1' 
    
    -- BE SURE TO UPDATE tblBOMTemplateTemplate too for any that need to be flagged as deleted from SOP
    
    
        
    
/****  CATALOG REQUESTS ****/
    -- TRUNCATE TABLE [SMITemp].dbo.PJC_CatalogRequests_toRefeed
    insert into [SMITemp].dbo.PJC_CatalogRequests_toRefeed
    select *
    into [SMITemp].dbo.PJC_CatalogRequests_toRefeed
    from [SMI Reporting].dbo.tblCatalogRequests
    where --flgDeletedFromSOP = 0
          dtDateLastSOPUpdate  between '05/01/2014' and '06/01/2014'
    order by newid()

        select * from [SMITemp].dbo.PJC_CatalogRequests_toRefeed
        

/**** CUSTOMERS *****/
    select COUNT(ixCustomer) 'Recs', CONVERT(VARCHAR, dtDateLastSOPUpdate, 101) 
    from tblCustomer where flgDeletedFromSOP = 0
    group by dtDateLastSOPUpdate
    having COUNT(ixCustomer) between 3000 and 7000 -- 5K roughly 5 mins
    order by dtDateLastSOPUpdate
    -- 3943	03/08/2017
    
    -- TRUNCATE TABLE [SMITemp].dbo.PJC_Customers_toRefeed
    insert into [SMITemp].dbo.PJC_Customers_toRefeed
    select top 9000 -- around 7k should take roughly 5 mins
            ixCustomer
   -- into [SMITemp].dbo.PJC_Customers_toRefeed
    from [SMI Reporting].dbo.tblCustomer
    where flgDeletedFromSOP = 0
      and dtDateLastSOPUpdate < '01/01/2017' 
    order by newid()

        select * from [SMITemp].dbo.PJC_Customers_toRefeed  -- save output to file to load into SOP      
        
    -- Update Speeds
    select 
        min(ixTimeLastSOPUpdate) 'Start', max(ixTimeLastSOPUpdate) 'End  ', (max(ixTimeLastSOPUpdate)-min(ixTimeLastSOPUpdate)) 'TotSec',
        count(*) 'RecCnt', (count(*)/(max(ixTimeLastSOPUpdate)-min(ixTimeLastSOPUpdate))) 'Rec/Sec(ROUNDED)', CONVERT(VARCHAR, getdate(), 102)  'As of'
    from [SMI Reporting].dbo.tblCustomer C 
        join [SMITemp].dbo.PJC_Customers_toRefeed RF on C.ixCustomer = RF.ixCustomer
    where C.flgDeletedFromSOP = 0 
        and C.dtDateLastSOPUpdate = '03/08/2017'
        -- and C.ixTimeLastSOPUpdate >= 38340  -- only needed if some of the records updated before kicking off the manual feed 
    /*
    Start	End  	TotSec	RecCnt	Rec/Sec(ROUNDED)	As of
    37548	37676	128	    5000	39	                2017.03.08
    40150	40333	183	    7000	38	                2017.03.08    
    38108	38885	777	    11700	15	                2017.03.08
    41184	41811	627	    9000	14	                2017.03.08    
    */


/**** ORDERS *****/
    -- TRUNCATE TABLE [SMITemp].dbo.PJC_Orders_toRefeed
    insert into [SMITemp].dbo.PJC_Orders_toRefeed
    SELECT top 1000 ixOrder
   -- into [SMITemp].dbo.PJC_Orders_toRefeed
    FROM [SMI Reporting].dbo.tblOrder
    -- FROM [AFCOReporting].dbo.tblOrder
    WHERE dtDateLastSOPUpdate between '05/01/2014' and '05/15/2014' --< '4/15/2014'
      --and flgDeletedFromSOP = 0
    ORDER BY newid()

        select * from [SMITemp].dbo.PJC_Orders_toRefeed   
        order by ixOrder     
        
    -- Update Speeds
    SELECT min(ixTimeLastSOPUpdate) 'Start', max(ixTimeLastSOPUpdate) 'End  ', (max(ixTimeLastSOPUpdate)-min(ixTimeLastSOPUpdate)) 'TotSec',
           count(*) 'RecCnt', (count(*)/(max(ixTimeLastSOPUpdate)-min(ixTimeLastSOPUpdate))) 'Rec/Sec(ROUNDED)', getdate() 'CurrentTime'
    FROM [SMI Reporting].dbo.tblOrder O  
        --[AFCOReporting].dbo.tblOrder O 
        join [SMITemp].dbo.PJC_Orders_toRefeed RF on O.ixOrder  = RF.ixOrder 
    WHERE O.dtDateLastSOPUpdate = '08/04/2014'
     --    and O.ixTimeLastSOPUpdate >= 57600  
        -- and O.flgDeletedFromSOP = 0 

/* SMI 1k ORDERS - 1.69  rec/sec BASELINE 1st run
                 - 2.70  rec/sec BASELINE 2nd run (same list of Orders)
                 - 2.68  rec/sec BASELINE 3rd run (same list of Orders)                
                 - 1.63  rec/sec INDEXES DISABLED ON tblOrder (same list of Orders)
                 - 5.16  rec/sec INDEXES DISABLED ON tblOrder AND tblOrderLine (same list of Orders)
                 - 3.04  rec/sec INDEXES RE-ENABLED on tblOrder and still DISABLED ON tblOrderLine (same list of Orders)                 
                 - 8.89  rec/sec INDEXES RE-ENABLED on tblOrder and still DISABLED ON tblOrderLine (same list of Orders)  2nd run  
                 - 7.96  rec/sec INDEXES RE-ENABLED on tblOrder and still DISABLED ON tblOrderLine (same list of Orders)  3rd run  
                 -12.58  rec/sec INDEXES RE-ENABLED on tblOrder and still DISABLED ON tblOrderLine (same list of Orders)  4th run                   
                 -14.68  rec/sec INDEXES RE-ENABLED on tblOrder and still DISABLED ON tblOrderLine (same list of Orders) AND FEEDS OFF                        
                 -14.79  rec/sec INDEXES RE-ENABLED on tblOrder and still DISABLED ON tblOrderLine (same list of Orders)   AND FEEDS OFF 2nd run
                 - 3.85  rec/sec INDEXES RE-ENABLED on tblOrder and still DISABLED ON tblOrderLine (same list of Orders)   AND FEEDS ON
                 - 3.85  rec/sec INDEXES RE-ENABLED on tblOrder and still DISABLED ON tblOrderLine (same list of Orders)   AND FEEDS ON 2nd run
                 -  .83  rec/sec INDEXES RE-ENABLED on tblOrder and still DISABLED ON tblOrderLine (same list of Orders)   AND FEEDS ON 2nd run  <-- CPU Usagae 100%
                 - 7.60  rec/sec INDEXES RE-ENABLED on tblOrder and still DISABLED ON tblOrderLine (same list of Orders)   AND FEEDS ON 3rd run  <-- after DWSTAGING reboot
                 - 6.61  rec/sec INDEXES RE-ENABLED on tblOrder and still DISABLED ON tblOrderLine (same list of Orders)   AND FEEDS ON 3rd run  <-- after DWSTAGING reboot
                 
                 -- same list of 1,000 orders
                    rec/sec
                 -  6.81
                 -  7.16
                 -  9.14
                 - 15.42
                 - 15.89     62 sec   fastest
                 -  5.22    191 sec   slowest
                 - 12.22
                 -  6.73
                 - 10.19
                 - 14.02
                 - 13.39
                 - 15.26
                 - 15.04
                 
                 
*/                 

/**** PACKAGES ****/
    -- TRUNCATE TABLE [SMITemp].dbo.PJC_Packages_toRefeed
    insert into [SMITemp].dbo.PJC_Packages_toRefeed
    select top 40000 sTrackingNumber--,  dtDateLastSOPUpdate
    --into [SMITemp].dbo.PJC_Packages_toRefeed
    from [SMI Reporting].dbo.tblPackage
    where --flgDeletedFromSOP = 0
          dtDateLastSOPUpdate  between '05/01/2014' and '06/01/2014'
    order by newid()

        SELECT * from [SMITemp].dbo.PJC_Packages_toRefeed

    -- Speeds
    select 
        min(ixTimeLastSOPUpdate) 'Start', 
        max(ixTimeLastSOPUpdate) 'End  ',
        (max(ixTimeLastSOPUpdate)-min(ixTimeLastSOPUpdate)) 'TotSec',
        count(*) 'RecCnt',
        (count(*)/(max(ixTimeLastSOPUpdate)-min(ixTimeLastSOPUpdate))) 'Rec/Sec(ROUNDED)'
    from [SMI Reporting].dbo.tblPackage P 
        join [SMITemp].dbo.PJC_Packages_toRefeed RF on P.sTrackingNumber = RF.sTrackingNumber
    where --S.flgDeletedFromSOP = 0 
        P.dtDateLastSOPUpdate = '06/30/2014'
        --and S.ixTimeLastSOPUpdate >= 36758          
        
/**** SKUs ****/
    -- TRUNCATE TABLE [SMITemp].dbo.PJC_SKUs_toRefeed
    insert into [SMITemp].dbo.PJC_SKUs_toRefeed
    select top 1001 ixSKU 
    from [SMI Reporting].dbo.tblSKU
    where flgDeletedFromSOP = 0
        and dtDateLastSOPUpdate <= '06/17/2014'
    order by newid()

    -- DELETE FROM  [SMITemp].dbo.PJC_SKUs_toRefeed where ixSKU = '999'        

        SELECT * from [SMITemp].dbo.PJC_SKUs_toRefeed
            
    -- Update Speeds
    select 
        min(ixTimeLastSOPUpdate) 'Start', 
        max(ixTimeLastSOPUpdate) 'End  ',
        (max(ixTimeLastSOPUpdate)-min(ixTimeLastSOPUpdate)) 'TotSec',
        count(*) 'RecCnt',
        (count(*)/(max(ixTimeLastSOPUpdate)-min(ixTimeLastSOPUpdate))) 'Rec/Sec(ROUNDED)'
    from [SMI Reporting].dbo.tblSKU S 
        join [SMITemp].dbo.PJC_SKUs_toRefeed RF on S.ixSKU = RF.ixSKU
    where S.flgDeletedFromSOP = 0 
        and S.dtDateLastSOPUpdate = '07/17/2014'
        --and S.ixTimeLastSOPUpdate >= 44900   
        
                  
/****************************************************/
select * from tblTime where chTime like '10:33%'    
   
    
    
/******** THINGS TO RESEARCH

UPDATE PROC HISTORY - did something change that would affect speeds?
INDEXES - TEMPORARILY remove indexes from tblSKU to see if it affects speed    

FIND A SOLO PROC TO TEST SPEEDS - SKUs call 7 update procs...issue could be further down the line.
ASK AL what order the procs are called when SKUs are refed

*/

    
    