-- Case 23027 Clean-up of Race Banquet Customer data for manual bulk SOP update


-- DROP TABLE [PJC_Banquet_and_RodRun_newCusts]

/* back up table so you can revert at any point
    -- DROP TABLE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts_BU
    select *
    into [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts_BU -- 31,158
    from [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts


        IF YOU NEED TO REVERT....
        -- DROP TABLE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
        select *
        into [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts -- 31,158
        from [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts_BU
*/

select COUNT(*) from [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts_BU -- 31158
select COUNT(*) from [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts    -- 31158


/****** LAST NAME CLEAN-UP ******/
    select * 
    from [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    --where len(LastName) > 1 
    order by len(LastName) desc

    -- DELETE from [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts where LEN(LastName) = 0 

    SELECT *
    FROM [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    WHERE LastName LIKE '%[^A-Z0-9 ()-]''%'

    -- ASTERIK '*' clean-up
    select * 
    from [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    where LastName like '%*%'

    select REPLACE(LastName, '*', ''), LastName, * 
    from [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    where LastName like '%*%'

    select LastName
    from [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    where Email in ('ATHMOTORSPORTS@ORANGEMOD3.COM','BARNARD@DIODECOM.NET','CJ9454@EARTHLINK.NET','FEARINGKEVIN@YAHOO.COM','FLODMANR@YAHOO.COM','H7204@HOTMAIL.COM','H7204@HOTMAIL.COM','MANNINGMOTORSPORTS52@MSN.COM','REDLINED@FIDALGO.NET','SPRNT12@YAHOO.COM','SWAMEDOG_93@HOTMAIL.COM','THEBULLET84@HOTMAIL.COM','THESHOPINC@WINDSTREAM.NET')

    UPDATE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    set LastName = REPLACE(LastName, '*', '')
    where LastName like '%*%'

    select LastName
    from [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    where Email in ('ATHMOTORSPORTS@ORANGEMOD3.COM','BARNARD@DIODECOM.NET','CJ9454@EARTHLINK.NET','FEARINGKEVIN@YAHOO.COM','FLODMANR@YAHOO.COM','H7204@HOTMAIL.COM','H7204@HOTMAIL.COM','MANNINGMOTORSPORTS52@MSN.COM','REDLINED@FIDALGO.NET','SPRNT12@YAHOO.COM','SWAMEDOG_93@HOTMAIL.COM','THEBULLET84@HOTMAIL.COM','THESHOPINC@WINDSTREAM.NET')

    SELECT *
    FROM [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts -- 271
    WHERE LastName LIKE '%[^A-Z0-9 %-()]%'

    -- ending with .
    UPDATE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    set LastName = REPLACE(LastName, '.', '')
    where LastName like '%.'

    UPDATE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    set LastName = REPLACE(LastName, '&', ' AND ')
    where LastName like '%&%'

    UPDATE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    set LastName = REPLACE(LastName, '/', ' AND ')
    where LastName like '%/%'

    UPDATE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    set LastName = REPLACE(LastName, ',', ' ')
    where LastName like '%,%'

    UPDATE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    set LastName = REPLACE(LastName, '"', ' ')
    where LastName like '%"%'

    UPDATE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    set LastName = REPLACE(LastName, '^', ' ')
    where LastName like '%^%'

    UPDATE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    set LastName = REPLACE(LastName, '+', ' AND ')
    where LastName like '%+%'


    UPDATE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    set LastName = REPLACE(LastName, '?', '''')
    where LastName like '%?%'

    SELECT *
    FROM [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    WHERE LastName LIKE '%''%'

    UPDATE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    set LastName = REPLACE(LastName, '`', ' ')
    where LastName like '%`%'


    -- replace double space with single space <-- RUN SEVERAL TIMES UNTIL NO RESULTS (e.g. a value of 8 consecuttive spaces would be replaced with 4 the FirstName time, 2 the second, etc.
    UPDATE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    set LastName = REPLACE(LastName, '  ', ' ')
    where LastName like '%  %'

    UPDATE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    set LastName = LTRIM(RTRIM(LastName))
    where LastName like '% %' -- will update (but not change) records with a space in the MIDDLE of the string



/****** FIRST NAME CLEAN-UP ******/
    select * 
    from [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    where len(FirstName) > 1 
    order by len(FirstName) desc

    -- DELETE from [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts where LEN(FirstName) = 0 

    SELECT *
    FROM [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    WHERE FirstName LIKE '%[^A-Z0-9 (-)]%' -- 2973

    -- ASTERIK '*' clean-up
    select * 
    from [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    where FirstName like '%*%'

    select REPLACE(FirstName, '*', ''), FirstName, * 
    from [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    where FirstName like '%*%'

    select FirstName
    from [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    where Email in ('ATHMOTORSPORTS@ORANGEMOD3.COM','BARNARD@DIODECOM.NET','CJ9454@EARTHLINK.NET','FEARINGKEVIN@YAHOO.COM','FLODMANR@YAHOO.COM','H7204@HOTMAIL.COM','H7204@HOTMAIL.COM','MANNINGMOTORSPORTS52@MSN.COM','REDLINED@FIDALGO.NET','SPRNT12@YAHOO.COM','SWAMEDOG_93@HOTMAIL.COM','THEBULLET84@HOTMAIL.COM','THESHOPINC@WINDSTREAM.NET')

    UPDATE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    set FirstName = REPLACE(FirstName, '*', '')
    where FirstName like '%*%'

    select FirstName
    from [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    where Email in ('ATHMOTORSPORTS@ORANGEMOD3.COM','BARNARD@DIODECOM.NET','CJ9454@EARTHLINK.NET','FEARINGKEVIN@YAHOO.COM','FLODMANR@YAHOO.COM','H7204@HOTMAIL.COM','H7204@HOTMAIL.COM','MANNINGMOTORSPORTS52@MSN.COM','REDLINED@FIDALGO.NET','SPRNT12@YAHOO.COM','SWAMEDOG_93@HOTMAIL.COM','THEBULLET84@HOTMAIL.COM','THESHOPINC@WINDSTREAM.NET')

    -- ending with .
    UPDATE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    set FirstName = REPLACE(FirstName, '.', '')
    where FirstName like '%.'

    UPDATE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    set FirstName = REPLACE(FirstName, '&', ' AND ')
    where FirstName like '%&%'

    UPDATE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    set FirstName = REPLACE(FirstName, '/', ' AND ')
    where FirstName like '%/%'

    UPDATE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    set FirstName = REPLACE(FirstName, ',', ' ')
    where FirstName like '%,%'

    UPDATE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    set FirstName = REPLACE(FirstName, ',', ' ')
    where FirstName like '%,%'    

    UPDATE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    set FirstName = REPLACE(FirstName, '"', ' ')
    where FirstName like '%"%'

    UPDATE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    set FirstName = REPLACE(FirstName, '^', ' ')
    where FirstName like '%^%'

    UPDATE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    set FirstName = REPLACE(FirstName, '+', ' AND ')
    where FirstName like '%+%'


    UPDATE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    set FirstName = REPLACE(FirstName, '?', '''')
    where FirstName like '%?%'

    SELECT *
    FROM [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    WHERE FirstName LIKE '%''%'

    UPDATE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    set FirstName = REPLACE(FirstName, '`', ' ')
    where FirstName like '%`%'


    -- replace double space with single space <-- RUN SEVERAL TIMES UNTIL NO RESULTS (e.g. a value of 8 consecuttive spaces would be replaced with 4 the FirstName time, 2 the second, etc.
    UPDATE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    set FirstName = REPLACE(FirstName, '  ', ' ')
    where FirstName like '%  %'

    UPDATE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    set FirstName = LTRIM(RTRIM(FirstName))
    where FirstName like '% %' -- will update (but not change) records with a space in the MIDDLE of the string


-- Address clean-up
    SELECT *
    FROM [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts -- 4744
    WHERE Address LIKE '%[^A-Z0-9 %-()]%'
    
    UPDATE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    set Address = REPLACE(Address, 'AVE.', 'AVE')
    where Address like '%AVE.'    

    UPDATE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    set Address = REPLACE(Address, 'RD.', 'RD')
    where Address like '%RD.' 
    
    UPDATE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    set Address = REPLACE(Address, 'DR.', 'DR')
    where Address like '%DR.'     
    
    UPDATE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    set Address = REPLACE(Address, 'ST.', 'ST')
    where Address like '%ST.' 
    
    UPDATE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    set Address = REPLACE(Address, 'LN.', 'LN')
    where Address like '%LN.'             

    UPDATE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    set Address = REPLACE(Address, 'CT.', 'CT')
    where Address like '%CT.'     
  
    UPDATE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    set Address = REPLACE(Address, 'CIR.', 'CIR')
    where Address like '%CIR.'     

    UPDATE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    set Address = REPLACE(Address, '®', '')
    where Address like '%®%'         
  
    UPDATE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    set Address = REPLACE(Address, '?', '')
    where Address like '%?%'  
            
    SELECT *
    FROM [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts -- 4744
    WHERE Address LIKE '%[^A-Z0-9 %-().,/#]%'
    

    UPDATE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    set Address = REPLACE(Address, '"', ' ')
    where Address like '%"%'
    
    -- replace double space with single space <-- RUN SEVERAL TIMES UNTIL NO RESULTS (e.g. a value of 8 consecuttive spaces would be replaced with 4 the FirstName time, 2 the second, etc.
    UPDATE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    set Address = REPLACE(Address, '  ', ' ')
    where Address like '%  %'

    UPDATE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    set Address = LTRIM(RTRIM(Address))
    where Address like '% %' -- will update (but not change) records with a space in the MIDDLE of the string

-- City Clean-up
    SELECT *
    FROM [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts 
    ORDER BY City
   
    UPDATE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    set City = REPLACE(City, '. ', ' ')
    where City like '. %'      

    UPDATE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    set City = REPLACE(City, '  ', ' ')
    where City like '%  %'

    UPDATE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    set City = LTRIM(RTRIM(City))
    where City like '% %' -- will update (but not change) records with a space in the MIDDLE of the string
    
    SELECT *
    FROM [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts 
    WHERE City like '%?%'
    ORDER BY City
    
    UPDATE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    set City = 'COEUR D''ALENE' where City = 'COEUR D?ALENE'

    select * from [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    where City like 'COEUR%'
    
        
    SELECT *
    FROM [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts -- 4744
    WHERE City LIKE '%[^A-Z0-9 %-().]%'
    
    select * from [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    where City like '%,%'
    order by City
            
    UPDATE [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    set City = REPLACE(City, ',', '')
    where City like '%,'

-- valid country                
    select Count(*) Qty, Country
    from [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    group by Country
    order by Country              
    /*
    Qty	    Country
    1	    ?
    46	    CANADA
    31111	USA
    */                
    -- DELETE FROM [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts WHERE Country = '?'

select Country, State, Count(*)
from [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
group by Country, State 
order by Country, State                

-- valid states
    select * from [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    where Country = 'USA'
    and State NOT IN (select ixState 
                      from [SMI Reporting].dbo.tblStates 
                      where flgUSTerritory = 0
                      and flgMilitary = 0)
               
-- valid province                  
    select * from [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    where Country = 'CANADA'
    and State NOT IN (select ixProvince 
                      from [SMI Reporting].dbo.tblCanadianProvince)
                  
                 
                 
select * from [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
where LEN(Zip)<> 5
and Country = 'USA'
order by LEN(Zip), Zip                 

-- DELETE FROM [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
WHERE  LEN(Zip) = 6
and Country = 'USA'

                 
select * from [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
where LEN(Zip)<> 6
and Country = 'CANADA'
order by LEN(Zip), Zip     

SELECT SourceCode, COUNT(*) Qty
FROM [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
GROUP BY SourceCode
/*
SourceCode	Qty
338801	    17954
347500	    13198
*/



-- another BU BEFORE REMOVING duplicates
    select * -- 31,152
    into [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts_BU_before_DEDUPE -- 31,158
    from [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
    
    
    
-- already exists in SMI Reporting?
SELECT distinct NC.*--,C.sEmailAddress,C.ixSourceCode, C.dtAccountCreateDate,  -- 9,706 already exist!?!
--C.sCustomerFirstName, C.sCustomerLastName, C.sMailToCity, C.sMailToState, C.sMailToZip
into PJC_Banquet_and_RodRun_newCusts_DUPES
FROM [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts NC
    JOIN [SMI Reporting].dbo.tblCustomer C on NC.FirstName = C.sCustomerFirstName
                                        and NC.LastName = C.sCustomerLastName
                                        and NC.Zip = C.sMailToZip
where C.flgDeletedFromSOP = 0   
order by C.ixSourceCode

UPDATE NC
SET NC.flgDupe = 1
FROM [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts NC
    join [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts_DUPES D on NC.FirstName = D.FirstName
                                        and NC.LastName = D.LastName
                                        and NC.Zip = D.Zip

DELETE from [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts 
where flgDupe = 1


 

-- WHEN PASTING RESULTS BACK INTO SPREADSHEET
-- BE SURE ZIP CODES DON'T LOSE THE 00000 FORMAT !!!!
select * from [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts -- 21,444
order by Country, Zip




-- profanity checks
select * 
from [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
WHERE LastName LIKE '%SHIT%'
 or FirstName LIKE  '%SHIT%'
 or Address LIKE  '%SHIT%'
 or City LIKE  '%SHIT%'

select * 
from [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
WHERE LastName LIKE '%SUCK%'
 or FirstName LIKE  '%SUCK%'
 or Address LIKE  '%SUCK%'
 or City LIKE  '%SUCK%' 
 
select * 
from [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
WHERE LastName LIKE '%FUCK%'
 or FirstName LIKE  '%FUCK%'
 or Address LIKE  '%FUCK%'
 or City LIKE  '%FUCK%'

select * 
from [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
WHERE LastName LIKE '%ASSHOLE%'
 or FirstName LIKE  '%ASSHOLE%'
 or Address LIKE  '%ASSHOLE%'
 or City LIKE  '%ASSHOLE%'
 
select * 
from [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
WHERE LastName LIKE '%PUSSY%'
 or FirstName LIKE  '%PUSSY%'
 or Address LIKE  '%PUSSY%'
 or City LIKE  '%PUSSY%'
 
select * 
from [SMITemp].dbo.PJC_Banquet_and_RodRun_newCusts
WHERE LastName LIKE '%DICK%'
 --or FirstName LIKE  '%DICK%'
 or Address LIKE  '%DICK%'
 or City LIKE  '%DICK%' 
 










