-- SOP Reporting Feeds Menu testing

/***************  <8> Job Clock  ********************/   
    -- <D>ate Range  v
        -- single date
        select count(*) from tblJobClock
        where ixDate = 16864 --'03/03/2014'         -- 838 v
        and dtDateLastSOPUpdate = '03/05/2014'
        
        -- multiple dates    
        select count(*) from tblJobClock
        where ixDate between 16858 and 16859 -- 02/25/2014      
        and dtDateLastSOPUpdate = '03/05/2014'

    -- <E>mployee  v
        -- emp counts
        select ixEmployee, count(*)
        from tblJobClock
        where dtDate >= '01/01/2014'
        group by ixEmployee
        order by count(*) desc

        select dtDateLastSOPUpdate, count(*) -- 908 total records   v
        from tblJobClock
        where dtDate >= '01/01/2014'
        and ixEmployee = 'NAP'
        group by dtDateLastSOPUpdate
     
/***************  <9> Kits  ********************/   
    -- <S>ingle kit  v
        select * from tblKit 
        where ixKitSKU = '102713504' 

    -- <A>ll  v
        select * from tblKit 
        order by dtDateLastSOPUpdate 



/***************  <10> Packages  ********************/  

    -- <D>ate Range v
        select count(*) from tblPackage
        where ixVerificationDate = 16847 --'02/14/2014'         -- 1377 v

        select count(*) from tblPackage
        where ixVerificationDate between 16848 and 16851 --'02/15/2014'  to 02/18/2014       -- 7473 v
        and dtDateLastSOPUpdate = '03/05/2014'

            -- speed
            select min(ixTimeLastSOPUpdate), max(ixTimeLastSOPUpdate), (max(ixTimeLastSOPUpdate)-  min(ixTimeLastSOPUpdate)) as TotSeconds
            from tblPackage
            where ixVerificationDate between 16848 and 16851 --'02/15/2014'  to 02/18/2014       -- 7473   78.3 rec/sec
            and dtDateLastSOPUpdate = '03/05/2014'



    -- <O>rder    v
        select O.ixOrder, count(P.sTrackingNumber) PkgCount
        from tblOrder O
            join tblPackage P on O.ixOrder = P.ixOrder
        where O.dtShippedDate = '01-19-2014'
        group by O.ixOrder
        having count(P.sTrackingNumber) > 6
        /*
        ixOrder	PkgCount
        5706745	7
        5765643	7
        */



    -- <L>ist v
        select count(P.sTrackingNumber) PkgQty, O.ixOrder-- v
        from tblOrder O
            join tblPackage P on O.ixOrder = P.ixOrder
        where O.dtShippedDate = '01-15-2014'
        group by O.ixOrder
        having count(P.sTrackingNumber) > 6
        /*
        Pkg
        Qty	ixOrder
        13	5756347
        7	5765348
        8	5781344
        7	5779347
        14	5751045
        13	5765349
        7	5790342
        9	5746343
        === =======
        78  Total Packages
        */
        
        select distinct sTrackingNumber
        from tblPackage where ixOrder in ('5756347','5765348','5781344','5779347','5751045','5765349','5790342','5746343')

        select ixOrder, sTrackingNumber, dtDateLastSOPUpdate, ixTimeLastSOPUpdate -- v
        from tblPackage
        where ixOrder in ('5756347','5765348','5781344','5779347','5751045','5765349','5790342','5746343')
        order by dtDateLastSOPUpdate



/***************  <14> Time Clock  ********************/   
    -- <D>ate Range  v
        -- single date
        select count(*) from tblTimeClock
        where ixDate = 16864 --'03/03/2014'         -- 213
        and dtDateLastSOPUpdate = '03/05/2014'
        
        -- multiple dates    
        select count(*) from tblTimeClock           -- 412
        where ixDate between 16858 and 16859 -- 02/25/14 to 02/26/14    
        and dtDateLastSOPUpdate = '03/05/2014'



    -- <E>mployee  v
        -- emp counts
        select ixEmployee, count(*)
        from tblTimeClock
        where dtDate >= '01/01/2014'
        group by ixEmployee
        order by count(*) desc

        select dtDateLastSOPUpdate, count(*) -- 47 total records   v
        from tblTimeClock
        where dtDate >= '01/01/2014'
        and ixEmployee = 'NAP'
        group by dtDateLastSOPUpdate
        
        
