-- SMIHD-1972 - Zip Code Radius Customer Counts
-- got zip codes radius lists from http://www.freemaptools.com/find-zip-codes-inside-radius.htm

/************************************   AFCO Zip = 47601  ************************************/

    /******************     0-50 Mile radius    *****************/
       
        SELECT COUNT(ixZip) ZipQty, COUNT(distinct(ixZip)) DistQty
        FROM [AFCOTemp].dbo.PJC_SMIHD_1972_AFCOZips_0to50Miles
        -- ZipQty	DistQty
        -- 186	    186
        
        
        SELECT MIN(len(ixZip)) MinLen, MIN(len(ixZip)) MaxLen
        FROM [AFCOTemp].dbo.PJC_SMIHD_1972_AFCOZips_0to50Miles
        --    MinLen	MaxLen
        --    5	        5


        -- how many zips are in tblCustomer
        SELECT COUNT(*) FROM [AFCOTemp].dbo.PJC_SMIHD_1972_AFCOZips_0to50Miles -- 102
        WHERE ixZip in (select distinct sMailToZip 
                        from [AFCOReporting].dbo.tblCustomer 
                        where flgDeletedFromSOP = 0)
        

        -- how many AFCO customers (buyers) in the zip radius
        SELECT --COUNT(distinct C.ixCustomer) CustQty          --  485
        distinct C.ixCustomer
        FROM [AFCOReporting].dbo.tblCustomer C
            join [AFCOReporting].dbo.tblOrder O on O.ixCustomer = C.ixCustomer
            join [AFCOTemp].dbo.PJC_SMIHD_1972_AFCOZips_0to50Miles R  on C.sMailToZip COLLATE SQL_Latin1_General_CP1_CS_AS = R.ixZip COLLATE SQL_Latin1_General_CP1_CS_AS   
        WHERE C.flgDeletedFromSOP = 0
        and C.ixCustomer NOT IN ('10890','34897') -- AFCO INTERNAL ACCOUNTS
        and O.dtOrderDate >= '08/26/2010'
        and O.sOrderStatus = 'Shipped'
        and O.mMerchandise > 0 -- > 1 if looking at non-US orders
        and O.sOrderType <> 'Internal'   -- the are USUALLY filtered

        -- 12 Mo Sales from AFCO Customers in the zip radius
        SELECT SUM(O.mMerchandise) 'Sales',          --  221,720
               SUM(O.mMerchandiseCost) 'Cost',
               (SUM(O.mMerchandise) - SUM(O.mMerchandiseCost)) 'GP' -- 105,953
        FROM [AFCOReporting].dbo.tblCustomer C
            join [AFCOReporting].dbo.tblOrder O on O.ixCustomer = C.ixCustomer
            join [AFCOTemp].dbo.PJC_SMIHD_1972_AFCOZips_0to50Miles R  on C.sMailToZip COLLATE SQL_Latin1_General_CP1_CS_AS = R.ixZip COLLATE SQL_Latin1_General_CP1_CS_AS   
        WHERE C.flgDeletedFromSOP = 0
        and C.ixCustomer NOT IN ('10890','34897') -- AFCO INTERNAL ACCOUNTS        
        and O.dtOrderDate >= '08/26/2014'
        and O.sOrderStatus = 'Shipped'
        and O.mMerchandise > 0 -- > 1 if looking at non-US orders
        and O.sOrderType <> 'Internal'   -- the are USUALLY filtered
            
        -- how many SMI customers (buyers) in the zip radius
        SELECT COUNT(distinct C.ixCustomer) CustQty          -- 2,106
        FROM [SMI Reporting].dbo.tblCustomer C
            join [SMI Reporting].dbo.tblOrder O on O.ixCustomer = C.ixCustomer
            join [AFCOTemp].dbo.PJC_SMIHD_1972_AFCOZips_0to50Miles R  on C.sMailToZip COLLATE SQL_Latin1_General_CP1_CS_AS = R.ixZip COLLATE SQL_Latin1_General_CP1_CS_AS   
        WHERE C.flgDeletedFromSOP = 0
        and O.dtOrderDate >= '08/26/2010'
        and O.sOrderStatus = 'Shipped'
        and O.mMerchandise > 0 -- > 1 if looking at non-US orders
        and O.sOrderType <> 'Internal'   -- the are USUALLY filtered
        and C.ixCustomer NOT IN ('707952','2218745','1728974') -- SMI INTERNAL ACCOUNTS

        -- 12 Mo Sales from SMI Customers in the zip radius
        SELECT SUM(O.mMerchandise) 'Sales',          --  549,379
               SUM(O.mMerchandiseCost) 'Cost',
               (SUM(O.mMerchandise) - SUM(O.mMerchandiseCost)) 'GP' -- 180,632
        FROM [SMI Reporting].dbo.tblCustomer C
            join [SMI Reporting].dbo.tblOrder O on O.ixCustomer = C.ixCustomer
            join [AFCOTemp].dbo.PJC_SMIHD_1972_AFCOZips_0to50Miles R  on C.sMailToZip COLLATE SQL_Latin1_General_CP1_CS_AS = R.ixZip COLLATE SQL_Latin1_General_CP1_CS_AS   
        WHERE C.flgDeletedFromSOP = 0
        and C.ixCustomer NOT IN ('707952','2218745','1728974') -- SMI INTERNAL ACCOUN       
        and O.dtOrderDate >= '08/26/2014'
        and O.sOrderStatus = 'Shipped'
        and O.mMerchandise > 0 -- > 1 if looking at non-US orders
        and O.sOrderType <> 'Internal'   -- the are USUALLY filtered



    /******************    51-100 Mile radius    *****************/
        -- remove zips from smaller radius files
        DELETE 
        -- SELECT * 
        FROM [AFCOTemp].dbo.PJC_SMIHD_1972_AFCOZips_51to100Miles
        WHERE ixZip in (select ixZip from [AFCOTemp].dbo.PJC_SMIHD_1972_AFCOZips_0to50Miles)
        
        
        SELECT COUNT(ixZip) ZipQty, COUNT(distinct(ixZip)) DistQty
        FROM [AFCOTemp].dbo.PJC_SMIHD_1972_AFCOZips_51to100Miles
        -- ZipQty	DistQty
        -- 496	    496
        
        
        SELECT MIN(len(ixZip)) MinLen, MIN(len(ixZip)) MaxLen
        FROM [AFCOTemp].dbo.PJC_SMIHD_1972_AFCOZips_51to100Miles
        --    MinLen	MaxLen
        --    5	        5

        -- how many zips are in tblCustomer
        SELECT COUNT(*) FROM [AFCOTemp].dbo.PJC_SMIHD_1972_AFCOZips_51to100Miles -- 225
        WHERE ixZip in (select distinct sMailToZip 
                        from [AFCOReporting].dbo.tblCustomer 
                        where flgDeletedFromSOP = 0)
        
        -- how many AFCO customers (buyers) in the zip radius
        SELECT COUNT(distinct C.ixCustomer) CustQty          --  275
        FROM [AFCOReporting].dbo.tblCustomer C
            join [AFCOReporting].dbo.tblOrder O on O.ixCustomer = C.ixCustomer
            join [AFCOTemp].dbo.PJC_SMIHD_1972_AFCOZips_51to100Miles R  on C.sMailToZip COLLATE SQL_Latin1_General_CP1_CS_AS = R.ixZip COLLATE SQL_Latin1_General_CP1_CS_AS   
        WHERE C.flgDeletedFromSOP = 0
        and C.ixCustomer NOT IN ('10890','34897') -- AFCO INTERNAL ACCOUNTS
        and O.dtOrderDate >= '08/26/2010'
        and O.sOrderStatus = 'Shipped'
        and O.mMerchandise > 0 -- > 1 if looking at non-US orders
        and O.sOrderType <> 'Internal'   -- the are USUALLY filtered

        -- 12 Mo Sales from AFCO Customers in the zip radius
        SELECT SUM(O.mMerchandise) 'Sales',          --  90,691
               SUM(O.mMerchandiseCost) 'Cost',
               (SUM(O.mMerchandise) - SUM(O.mMerchandiseCost)) 'GP' -- 44,338
        FROM [AFCOReporting].dbo.tblCustomer C
            join [AFCOReporting].dbo.tblOrder O on O.ixCustomer = C.ixCustomer
            join [AFCOTemp].dbo.PJC_SMIHD_1972_AFCOZips_51to100Miles R  on C.sMailToZip COLLATE SQL_Latin1_General_CP1_CS_AS = R.ixZip COLLATE SQL_Latin1_General_CP1_CS_AS   
        WHERE C.flgDeletedFromSOP = 0
        and C.ixCustomer NOT IN ('10890','34897') -- AFCO INTERNAL ACCOUNTS        
        and O.dtOrderDate >= '08/26/2014'
        and O.sOrderStatus = 'Shipped'
        and O.mMerchandise > 0 -- > 1 if looking at non-US orders
        and O.sOrderType <> 'Internal'   -- the are USUALLY filtered
            
        -- how many SMI customers (buyers) in the zip radius
        SELECT COUNT(distinct C.ixCustomer) CustQty          -- 2,106
        FROM [SMI Reporting].dbo.tblCustomer C
            join [SMI Reporting].dbo.tblOrder O on O.ixCustomer = C.ixCustomer
            join [AFCOTemp].dbo.PJC_SMIHD_1972_AFCOZips_51to100Miles R  on C.sMailToZip COLLATE SQL_Latin1_General_CP1_CS_AS = R.ixZip COLLATE SQL_Latin1_General_CP1_CS_AS   
        WHERE C.flgDeletedFromSOP = 0
        and O.dtOrderDate >= '08/26/2010'
        and O.sOrderStatus = 'Shipped'
        and O.mMerchandise > 0 -- > 1 if looking at non-US orders
        and O.sOrderType <> 'Internal'   -- the are USUALLY filtered
        and C.ixCustomer NOT IN ('707952','2218745','1728974') -- SMI INTERNAL ACCOUNTS

        -- 12 Mo Sales from SMI Customers in the zip radius
        SELECT SUM(O.mMerchandise) 'Sales',          --  549,379
               SUM(O.mMerchandiseCost) 'Cost',
               (SUM(O.mMerchandise) - SUM(O.mMerchandiseCost)) 'GP' -- 180,632
        FROM [SMI Reporting].dbo.tblCustomer C
            join [SMI Reporting].dbo.tblOrder O on O.ixCustomer = C.ixCustomer
            join [AFCOTemp].dbo.PJC_SMIHD_1972_AFCOZips_51to100Miles R  on C.sMailToZip COLLATE SQL_Latin1_General_CP1_CS_AS = R.ixZip COLLATE SQL_Latin1_General_CP1_CS_AS   
        WHERE C.flgDeletedFromSOP = 0
        and C.ixCustomer NOT IN ('707952','2218745','1728974') -- SMI INTERNAL ACCOUN       
        and O.dtOrderDate >= '08/26/2014'
        and O.sOrderStatus = 'Shipped'
        and O.mMerchandise > 0 -- > 1 if looking at non-US orders
        and O.sOrderType <> 'Internal'   -- the are USUALLY filtered

        
    /******************    101-150 Mile radius    *****************/
        -- remove zips from smaller radius files
        DELETE 
        -- SELECT * 
        FROM [AFCOTemp].dbo.PJC_SMIHD_1972_AFCOZips_101to150Miles
        WHERE ixZip in (select ixZip from PJC_SMIHD_1972_AFCOZips_0to50Miles)

        DELETE 
        -- SELECT * 
        FROM [AFCOTemp].dbo.PJC_SMIHD_1972_AFCOZips_101to150Miles
        WHERE ixZip in (select ixZip from PJC_SMIHD_1972_AFCOZips_51to100Miles)        
        
        SELECT COUNT(ixZip) ZipQty, COUNT(distinct(ixZip)) DistQty
        FROM [AFCOTemp].dbo.PJC_SMIHD_1972_AFCOZips_101to150Miles
        -- ZipQty	DistQty
        -- 840	    840
        
        
        SELECT MIN(len(ixZip)) MinLen, MIN(len(ixZip)) MaxLen
        FROM [AFCOTemp].dbo.PJC_SMIHD_1972_AFCOZips_101to150Miles
        --    MinLen	MaxLen
        --    5	        5

        -- how many zips are in tblCustomer
        SELECT COUNT(*) FROM [AFCOTemp].dbo.PJC_SMIHD_1972_AFCOZips_101to150Miles -- 352
        WHERE ixZip in (select distinct sMailToZip 
                        from [AFCOReporting].dbo.tblCustomer 
                        where flgDeletedFromSOP = 0)
                        
        -- how many AFCO customers (buyers) in the zip radius
        SELECT COUNT(distinct C.ixCustomer) CustQty          --  311
        FROM [AFCOReporting].dbo.tblCustomer C
            join [AFCOReporting].dbo.tblOrder O on O.ixCustomer = C.ixCustomer
            join [AFCOTemp].dbo.PJC_SMIHD_1972_AFCOZips_101to150Miles R  on C.sMailToZip COLLATE SQL_Latin1_General_CP1_CS_AS = R.ixZip COLLATE SQL_Latin1_General_CP1_CS_AS   
        WHERE C.flgDeletedFromSOP = 0
        and C.ixCustomer NOT IN ('10890','34897') -- AFCO INTERNAL ACCOUNTS
        and O.dtOrderDate >= '08/26/2010'
        and O.sOrderStatus = 'Shipped'
        and O.mMerchandise > 0 -- > 1 if looking at non-US orders
        and O.sOrderType <> 'Internal'   -- the are USUALLY filtered

        -- 12 Mo Sales from AFCO Customers in the zip radius
        SELECT SUM(O.mMerchandise) 'Sales',          --  984,914
               SUM(O.mMerchandiseCost) 'Cost',
               (SUM(O.mMerchandise) - SUM(O.mMerchandiseCost)) 'GP' -- 522925
        FROM [AFCOReporting].dbo.tblCustomer C
            join [AFCOReporting].dbo.tblOrder O on O.ixCustomer = C.ixCustomer
            join [AFCOTemp].dbo.PJC_SMIHD_1972_AFCOZips_101to150Miles R  on C.sMailToZip COLLATE SQL_Latin1_General_CP1_CS_AS = R.ixZip COLLATE SQL_Latin1_General_CP1_CS_AS   
        WHERE C.flgDeletedFromSOP = 0
        and C.ixCustomer NOT IN ('10890','34897') -- AFCO INTERNAL ACCOUNTS        
        and O.dtOrderDate >= '08/26/2014'
        and O.sOrderStatus = 'Shipped'
        and O.mMerchandise > 0 -- > 1 if looking at non-US orders
        and O.sOrderType <> 'Internal'   -- the are USUALLY filtered
            
        -- how many SMI customers (buyers) in the zip radius
        SELECT COUNT(distinct C.ixCustomer) CustQty          -- 2,106
        FROM [SMI Reporting].dbo.tblCustomer C
            join [SMI Reporting].dbo.tblOrder O on O.ixCustomer = C.ixCustomer
            join [AFCOTemp].dbo.PJC_SMIHD_1972_AFCOZips_101to150Miles R  on C.sMailToZip COLLATE SQL_Latin1_General_CP1_CS_AS = R.ixZip COLLATE SQL_Latin1_General_CP1_CS_AS   
        WHERE C.flgDeletedFromSOP = 0
        and O.dtOrderDate >= '08/26/2010'
        and O.sOrderStatus = 'Shipped'
        and O.mMerchandise > 0 -- > 1 if looking at non-US orders
        and O.sOrderType <> 'Internal'   -- the are USUALLY filtered
        and C.ixCustomer NOT IN ('707952','2218745','1728974') -- SMI INTERNAL ACCOUNTS

        -- 12 Mo Sales from SMI Customers in the zip radius
        SELECT SUM(O.mMerchandise) 'Sales',          --  549,379
               SUM(O.mMerchandiseCost) 'Cost',
               (SUM(O.mMerchandise) - SUM(O.mMerchandiseCost)) 'GP' -- 522925
        FROM [SMI Reporting].dbo.tblCustomer C
            join [SMI Reporting].dbo.tblOrder O on O.ixCustomer = C.ixCustomer
            join [AFCOTemp].dbo.PJC_SMIHD_1972_AFCOZips_101to150Miles R  on C.sMailToZip COLLATE SQL_Latin1_General_CP1_CS_AS = R.ixZip COLLATE SQL_Latin1_General_CP1_CS_AS   
        WHERE C.flgDeletedFromSOP = 0
        and C.ixCustomer NOT IN ('707952','2218745','1728974') -- SMI INTERNAL ACCOUN       
        and O.dtOrderDate >= '08/26/2014'
        and O.sOrderStatus = 'Shipped'
        and O.mMerchandise > 0 -- > 1 if looking at non-US orders
        and O.sOrderType <> 'Internal'   -- the are USUALLY filtered                        




/*
in the past 12 months AFCO sales were 14% of SMI sales

SELECT SUM(O.mMerchandise) 'Sales'          --  74,655,455
        FROM [SMI Reporting].dbo.tblCustomer C
            join [SMI Reporting].dbo.tblOrder O on O.ixCustomer = C.ixCustomer
        WHERE C.flgDeletedFromSOP = 0
        and C.ixCustomer NOT IN ('707952','2218745','1728974') -- SMI INTERNAL ACCOUN       
        and O.dtOrderDate >= '08/26/2014'
        and O.sOrderStatus = 'Shipped'
        AND O.iShipMethod = 1        
        and O.mMerchandise > 0 -- > 1 if looking at non-US orders
        and O.sOrderType <> 'Internal'   -- the are USUALLY filtered     
        
SELECT SUM(O.mMerchandise) 'Sales'          --  10,775,095
        FROM [AFCOReporting].dbo.tblCustomer C
            join [AFCOReporting].dbo.tblOrder O on O.ixCustomer = C.ixCustomer
        WHERE C.flgDeletedFromSOP = 0
        and C.ixCustomer NOT IN ('10890','34897')  -- SMI INTERNAL ACCOUN       
        and O.dtOrderDate >= '01/01/2015'
        and O.sOrderStatus = 'Shipped'
        AND O.iShipMethod = 1
        and O.mMerchandise > 0 -- > 1 if looking at non-US orders
        and O.sOrderType <> 'Internal'   -- the are USUALLY filtered                              
     
*/
    
/* FACTS

Mile
Radius                      AFCO                SMI
from        Tot     AFCO    Custs       SMI     Custs
47601       Zips    Custs   12M GP      Custs   12M GP
=========   ====    =====   =====       =====   =====
0-50	    186	    487 	$105,953 	 2,106 	 $  180,632 
51-100	    496	    275 	 $44,338 	 6,530 	 $  439,490 
101-150	    840	    311 	$522,925 	12,053 	 $  869,859 
=
		            1,073 	$673,216 	20,689 	 $1,489,981 

*/


select O.ixCustomer, SUM(O.mMerchandise) Sales -- 474,233.01
from tblOrder O
where O.dtOrderDate >= '08/26/2014'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   -- the are USUALLY filtered
AND O.ixCustomer in ('43444','29721','30657','10016','26295','23338','20312','44194','11556','11270','20347','32226','20447','38277','12824','26146','41085','44480','23155','37341','35052','21701','41235','21498','37877','28082','11505','39563','24555','13074','20462','36692','16767','27481','43557','20780','15831','33329','30458','43726','12256','12791','25091','14277','27181','26296','10015','21430','37978','11555','37474','21834','15700','16032','44780','40400','25859','26363','22819','41903','10433','23838','27714','11255','30290','23506','37902','44237','33073','23779','22611','10760','14055','11413','20069','44537','37636','26870','22694','26421','11247','10328','29212','41363','36449','22660','29278','11262','22460','37634','29029','10692','11245','10260','44003','20456','11279','39589','28744','25804','33037','20686','11062','43199','12130','20520','11311','34577','12047','14185','27221','41310','37017','32686','11979','22058','41797','17280','26102','22762','36264','38989','39421','21826','24800','24196','24296','31187','10365','24869','19889','38048','25748','23633','14218','13271','24703','35601','20759','32466','33036','22863','13471','40547','30660','35867','30394','11808','11265','41149','22463','30360','20734','34897','33970','42085','17685','20625','17190','41249','10338','10908','14675','38439','29585','38573','39143','11274','37271','27284','13716','44759','11074','20468','40311','26482','26050','12010','36776','10238','38339','44857','40615','21259','10631','17615','10840','42092','11644','10299','10997','44625','29626','25012','10808','20366','29849','18947','38649','12738','28221','13563','39528','12913','31029','11273','39585','20315','38349','26842','40264','25863','24595','24120','29593','41693','20190','44240','33569','28757','11259','14660','12988','21644','37774','20540','34194','10012','11709','38167','36395','10387','33487','10441','33258','10430','12234','22891','38531','42218','27067','14667','26792','30350','14449','24688','39035','12477','11627','21176','41482','32783','10187','26117','40632','38113','39885','10056','44841','29876','20241','39425','27225','40461','28808','10013','20541','42276','41967','25898','36426','41767','33077','40874','11156','41472','37396','12287','11717','10890','10011','11285','14525','20050','37362','30108','10581','39704','39727','17331','35917','33143','45143','33945','27504','11260','14225','40002','15127','41099','15938','31003','43646','43171','40933','34481','30167','25421','36719','32984','37498','16599','40495','16095','14223','33889','10010','20404','18898','20470','41781','26452','45187','12933','11261','37235','10008','35478','26871','33323','20536','16211','37101','42013','30532','30681','25669','24146','32470','44000','42915','30698','23963','42830','12282','36850','25735','20185','25652','11729','23797','44504','11280','31283','29611','10576','40394','16309','36667','10493','31151','11263','40477','40558','22593','15222','10946','32151','38571','44353','27290','39490','10425','41628','20672','20572','16728','35921','15466','21331','11135','10803','42038','40819','15598','23218','10368','36857','24122','12272','11539','28516','13225','13543','30306','34167','29656','41870','24607','15951','22735','22617','17737','21899','33432','20413','16569','37625','25861','11603','44192','21499','11271','24739','10436','44396','30456','11286','21431','14229','36404','38062','28152','25876','38179','43460','39794','39462','32724','42216','10689','41984','29784','11064','42820','28805','37879','25722','31181','38108','42127','23232','37272','24529','15930','11050','10764','26376','33910','36025','37436','23250','39294','35607','40837','19938','14826','41298','27787','36443','45060','24779','26794','10739','26551','35307','10003','39469','36704','28612','11257','32417','37904','14733','36954','12025','33960','41866','27694','29852','36636','20910','41909','36218','36968','32574','20074')
GROUP BY ixCustomer
order by SUM(O.mMerchandise)  desc


select * from tblCustomer where ixCustomer in ('10890','26870','34897','28221','16599','33432','11156','26871','10187','22694')

select * from tblCustomer
where UPPER(sCustomerFirstName) like '%INVENTORY%'
or UPPER(sCustomerLastName) like '%INVENTORY%'

select * from tblCustomer
where UPPER(sCustomerFirstName) like '%INVENTORY%'
or UPPER(sCustomerLastName) like '%INVENTORY%'


SELECT O.ixCustomer, SUM(O.mMerchandise) 'Sales'  
FROM [SMI Reporting].dbo.tblCustomer C
            join [SMI Reporting].dbo.tblOrder O on O.ixCustomer = C.ixCustomer
      --      join [AFCOTemp].dbo.PJC_SMIHD_1972_AFCOZips_0to50Miles R  on C.sMailToZip COLLATE SQL_Latin1_General_CP1_CS_AS = R.ixZip COLLATE SQL_Latin1_General_CP1_CS_AS   
        WHERE C.flgDeletedFromSOP = 0
      --  and C.ixCustomer NOT IN ('10890','34897') -- AFCO INTERNAL ACCOUNTS        
        and O.dtOrderDate >= '08/26/2014'
        and O.sOrderStatus = 'Shipped'
        and O.mMerchandise > 0 -- > 1 if looking at non-US orders
        and O.sOrderType <> 'Internal'   -- the are USUALLY filtered
and O.ixCustomer in ('758429','707952','1728974','2218745','222222')
group by O.ixCustomer

('707952','2218745','1728974') -- SMI INTERNAL ACCOUNTS

-- AFCO ALL Customers
select C.ixCustomer 'Customer', C.sMailToZip 'Zip', C.sCustomerFirstName 'FirstName', C.sCustomerLastName 'LastName', TM.Sales12Mo '12MoSales', 
    C.dtAccountCreateDate'AccountCreated', O.LastOrder'LatestOrder'
from [AFCOReporting].dbo.tblCustomer C-- 30,362
    left join (SELECT ixCustomer,  MAX(O.dtOrderDate) 'LastOrder' -- 12,197
               FROM [AFCOReporting].dbo.tblOrder O 
               WHERE O.sOrderStatus = 'Shipped'
                and O.mMerchandise > 0 -- > 1 if looking at non-US orders
                and O.sOrderType <> 'Internal'   -- the are USUALLY filtered
                GROUP BY ixCustomer
               ) O on O.ixCustomer = C.ixCustomer
    left join (SELECT ixCustomer,  SUM(O.mMerchandise) 'Sales12Mo' -- 12,197
               FROM [AFCOReporting].dbo.tblOrder O 
               WHERE O.sOrderStatus = 'Shipped'
                and O.dtShippedDate between '08/26/2014' and '08/25/2015'
                and O.mMerchandise > 0 -- > 1 if looking at non-US orders
                and O.sOrderType <> 'Internal'   -- the are USUALLY filtered
                GROUP BY ixCustomer
               ) TM on TM.ixCustomer = C.ixCustomer               
where C.flgDeletedFromSOP = 0
    and LEN(C.sMailToZip) = 5
    and C.sMailToCountry is NULL --     AFCO never has US or UNITED STATES 
    and C.ixCustomer NOT IN (34795,10890,34897,26103,26103,10511,10511) -- INTERNAL ACCOUNTS   29,291
order by TM.Sales12Mo, O.LastOrder

-- SMI Counter Customers
select C.ixCustomer 'Customer', C.sMailToZip 'Zip', C.sCustomerFirstName 'FirstName', C.sCustomerLastName 'LastName', TM.Sales12Mo '12MoSales', 
    C.dtAccountCreateDate'AccountCreated', O.LastOrder'LatestOrder'
from [SMI Reporting].dbo.tblCustomer C-- 30,362
    left join (SELECT ixCustomer,  MAX(O.dtOrderDate) 'LastOrder' -- 12,197
               FROM [SMI Reporting].dbo.tblOrder O 
               WHERE O.sOrderStatus = 'Shipped'
                and O.mMerchandise > 0 -- > 1 if looking at non-US orders
                and O.sOrderType <> 'Internal'   -- the are USUALLY filtered
                GROUP BY ixCustomer
               ) O on O.ixCustomer = C.ixCustomer
    left join (SELECT ixCustomer,  SUM(O.mMerchandise) 'Sales12Mo' -- 12,197
               FROM [SMI Reporting].dbo.tblOrder O 
               WHERE O.sOrderStatus = 'Shipped'
                and O.dtShippedDate between '08/26/2014' and '08/25/2015'
                and O.mMerchandise > 0 -- > 1 if looking at non-US orders
                and O.sOrderType <> 'Internal'   -- the are USUALLY filtered
                GROUP BY ixCustomer
               ) TM on TM.ixCustomer = C.ixCustomer   
    join [SMITemp].dbo.PJC_SMIHD1972_SMI_CounterCustomers CC on C.ixCustomer = CC.ixCustomer                     
where C.flgDeletedFromSOP = 0
    and LEN(C.sMailToZip) = 5
    and C.sMailToCountry is NULL --     AFCO never has US or UNITED STATES 
    and C.ixCustomer NOT IN (34795,10890,34897,26103,26103,10511,10511) -- INTERNAL ACCOUNTS   29,291
--AND C.ixCustomer = 2054657    
order by TM.Sales12Mo, O.LastOrder
             	
-- MANUALLY PULLING THE 82 THAT WERE MISSED
select C.ixCustomer 'Customer', C.sMailToZip 'Zip', C.sCustomerFirstName 'FirstName', C.sCustomerLastName 'LastName', TM.Sales12Mo '12MoSales', 
    C.dtAccountCreateDate'AccountCreated', O.LastOrder'LatestOrder',C.sMailToCountry
from [SMI Reporting].dbo.tblCustomer C-- 30,362
    left join (SELECT ixCustomer,  MAX(O.dtOrderDate) 'LastOrder' -- 12,197
               FROM [SMI Reporting].dbo.tblOrder O 
               WHERE O.sOrderStatus = 'Shipped'
                and O.mMerchandise > 0 -- > 1 if looking at non-US orders
                and O.sOrderType <> 'Internal'   -- the are USUALLY filtered
                GROUP BY ixCustomer
               ) O on O.ixCustomer = C.ixCustomer
    left join (SELECT ixCustomer,  SUM(O.mMerchandise) 'Sales12Mo' -- 12,197
               FROM [SMI Reporting].dbo.tblOrder O 
               WHERE O.sOrderStatus = 'Shipped'
                and O.dtShippedDate between '08/26/2014' and '08/25/2015'
                and O.mMerchandise > 0 -- > 1 if looking at non-US orders
                and O.sOrderType <> 'Internal'   -- the are USUALLY filtered
                GROUP BY ixCustomer
               ) TM on TM.ixCustomer = C.ixCustomer   
  --  join [SMITemp].dbo.PJC_SMIHD1972_SMI_CounterCustomers CC on C.ixCustomer = CC.ixCustomer                     
where C.flgDeletedFromSOP = 0
  --  and LEN(C.sMailToZip) = 5
  --  and C.sMailToCountry is NULL --     AFCO never has US or UNITED STATES 
    and C.ixCustomer IN (1031980,1044062,1056074,1110783,1133882,1137070,1139245,1250066,1262435,1290784,1327539,1424282,1433980,1437361,1465884,1473883,1488926,1495683,1503287,1512119,1512282,1538189,1563286,1578530,1598287,1611442,1715381,1718339,1718380,1720387,1730681,1737736,1742229,1773325,1775321,1791685,1832769,1840404,1939379,1979015,2009641,2015449,2045142,2085956,2110255,2118253,2120154,2142158,2161140,2170257,2177459,2218552,2240656,2243157,2251541,2276647,2332647,2395945,2474643,2486248,2509041,2595345,2637345,2821834,2853647,2921937,2923238,2936139,2937133,2938137,2963634,2980335,2980433,308688,361178,394740,398383,425753,455084,498340,49842,718772,766131,778313,789073,838827,853627,860460) -- INTERNAL ACCOUNTS   29,291
--AND C.ixCustomer = 2054657    
order by C.ixCustomer -- TM.Sales12Mo, O.LastOrder
 

SELECT distinct(sOrderType) from [SMI Reporting].dbo.tblOrder             