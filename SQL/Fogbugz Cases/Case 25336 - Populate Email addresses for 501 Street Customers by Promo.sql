-- Case 25336 - Populate Email addresses for 501 Street Customers by Promo


/****************************   Questions sent to Leslie and her responses    ****************************

NOTE: For future lists that you need us to populate Email addresses, just send the email to ithelpdesk@speedwaymotors.com +
just address "Pat & Alaina," in the first line and when you need the updated list back by.  The ticket will get assigned to us 
right away and if one of us is out, the other can process it.  Assuming question 1 below can be done, we should be able to get 
the updated file back to you 1-2 hours after you submit it.  

1) Can we get the file with one set of columns (no tabs - adding more columns is fine)?
        a.	Yes! Once I have the ‘tabbed’ file from Dylan I will add my stuff and get it to you in a single sheet
        
2) Currently when there is no email address, the field is populated with "NULL",
   is that OK or do you have dif preference (leave it blank, put "none on file", etc.)
        a.	NULL works for me. It helps me easily sort those out.    
    
3) Are there any additional QC checks you would like us to run other than Dupe Customer and Dupe Promos?    
        a.	Those three are the only ones I need at this point.

************************************************************************************************************/ 



/************   1) Import file into temp table and add Email column Varchar(65) ************/
    -- quick visual check
    Select top 100 * from [SMITemp].dbo.PJC_25336_Cat501Street_PromoEmailCusts
    order by newid()
    
/************   2) dupe customer check  ************/
    select count(*) from [SMITemp].dbo.PJC_25336_Cat501Street_PromoEmailCusts                   -- 92092
    select count(distinct ixCustomer) from [SMITemp].dbo.PJC_25336_Cat501Street_PromoEmailCusts -- 92092

/************   3) Verify all customer numbers are valid    ************/
    -- if any are missing make sure numbers didn't get truncated on import or converted to scientific notation
    select count(PC.ixCustomer) 
    from [SMITemp].dbo.PJC_25336_Cat501Street_PromoEmailCusts PC
        left join [SMI Reporting].dbo.tblCustomer C on PC.ixCustomer = C.ixCustomer
    where C.ixCustomer is NULL    
        -- NONE
    
/************   4) unique promo check   ************/
    select PromoCode, count(*) Qty
    from [SMITemp].dbo.PJC_25336_Cat501Street_PromoEmailCusts 
    group by PromoCode
    having count(*) > 1
    order by PromoCode
    /*
    PromoCode	Qty
    MYFX-QDN7	2
    */
        -- details on dupes
        SELECT * from [SMITemp].dbo.PJC_25336_Cat501Street_PromoEmailCusts 
        where PromoCode in ('MYFX-QDN7')
        /*
        ixCustomer	PromoCode	PromoGroup	EmailAddress
        1728220	    MYFX-QDN7	Free100	    NULL
        970182	    MYFX-QDN7	Free100	    NULL
        */
    
/************   5)Populate Email Address Field  ************/
    UPDATE PC
    SET PC.EmailAddress = C.sEmailAddress
    FROM [SMITemp].dbo.PJC_25336_Cat501Street_PromoEmailCusts PC
        left join [SMI Reporting].dbo.tblCustomer C on PC.ixCustomer = C.ixCustomer

/************   6) Remaining QC and statistics checks   ************/
    -- how many customers had an email address on file
    select count(*) 
    from [SMITemp].dbo.PJC_25336_Cat501Street_PromoEmailCusts 
    where EmailAddress is NOT NULL -- 61,465


    -- DUPE Email Addresses
    select EmailAddress, count(*) QTY
    from [SMITemp].dbo.PJC_25336_Cat501Street_PromoEmailCusts 
    where EmailAddress is NOT NULL
    group by EmailAddress
    having count(*) > 1
    order by count(*) desc, EmailAddress
    -- 185 email addresses are in the file more than once
    /*
    QTY	EmailAddress
    3	DWTWERDY@YAHOO.COM
    3	JAYSPOUSTA@HOTMAIL.COM
    3	SALES@SPEEDWAYMOTORS.COM
    2	2724SLIKER@GMAIL.COM
    2	8862020@GMAIL.COM
    2	A.DREAMER83@GMAIL.COM
    2	ADAMSCLASSICCARS@YAHOO.COM
    .
    .
    .
    */
    
    -- Email Address Counts by PromoGroup
    select PromoGroup, count(*) EmailQTY
    from [SMITemp].dbo.PJC_25336_Cat501Street_PromoEmailCusts 
    where EmailAddress is NOT NULL
    group by PromoGroup
    order by PromoGroup
/*
Promo       EmailAddress
Group	    QTY
=========   =======
Flat100	    3315
Flat75	    6991
Flat84	    5054
Free100	    3304
Free52	    5005
Free75	    7004
Free84	    5056
Gift100	    3371
Gift75	    7039
Percent10	3340
Percent75	7006
Percent84	4980
    
/************   7) paste data into spreadsheet and deliver   ************/
-- Make sure results don't get messed up by Excel formatting 
-- (mainly customer # getting converted to scientific notation)
SELECT * from [SMITemp].dbo.PJC_25336_Cat501Street_PromoEmailCusts 
order by PromoGroup, PromoCode


PROVIDE SUMMARY INFO WITH EXCEL FILE
    
92,092 Customers in file (no dupes)
61,465 Customer had an email address in SOP
   185 email addresses are in the file more than once 
     1 PROMOs have duplicates (MYFX-QDN7 is in the file twice)
     
Promo       EmailAddress
Group	    QTY
=========   =======
Flat100	    3315
Flat75	    6991
Flat84	    5054
Free100	    3304
Free52	    5005
Free75	    7004
Free84	    5056
Gift100	    3371
Gift75	    7039
Percent10	3340
Percent75	7006
Percent84	4980     



       