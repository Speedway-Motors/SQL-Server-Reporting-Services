    --SOP Customer Offer Load Times 
    -- run this query a few times throughout the loading process to make sure records are updating at a reasonable pace
    select count(CO.ixCustomer) CustCnt
        ,getdate() as 'RunTime'
        ,(T.ixTime - min(CO.ixTimeLastSOPUpdate)) as SecRun
        --  (count(CO.ixCustomer) / (T.ixTime - min(CO.ixTimeLastSOPUpdate)) )*60 as 'Rec/Min',
        ,(CONVERT(DECIMAL(10,2),count(CO.ixCustomer)))
           /(CONVERT(DECIMAL(10,2),T.ixTime) 
                - CONVERT(DECIMAL(10,2),min(CO.ixTimeLastSOPUpdate))) 
                    *60.00 
                        as 'Rec/Min'
        ,(CONVERT(DECIMAL(10,2),count(CO.ixCustomer)))
           /(CONVERT(DECIMAL(10,2),T.ixTime) 
                - CONVERT(DECIMAL(10,2),min(CO.ixTimeLastSOPUpdate))) 
                    *3600.00 
                        as 'Rec/Hour'                        
    from [SMI Reporting].dbo.tblSourceCode SC 
        left join [SMI Reporting].dbo.tblCustomerOffer CO on CO.ixSourceCode = SC.ixSourceCode
        left join [SMI Reporting].dbo.tblTime T on T.chTime = CONVERT(VARCHAR(8), GETDATE(), 108)
    where SC.ixCatalog = '373'
    group by T.ixTime, T.chTime
    /* 328,438 total offers to load
    CustCnt	RunTime	                SecRun	Rec/Min	    Rec/Hr
    ======= ======================= ======  =======     ======
    7637	2014-01-02 14:02:31.743	1151	398	        23,886
    14935	2014-01-02 14:21:41.153	2301	389     	23,366
    82888	2014-01-02 18:02:15.197	15535   320         19,208
    82888	2014-01-02 22:03:51.297	30031	165.6048749625384000	9936.2924977523040000
    83034	2014-01-03 01:07:29.330	30
    87066	2014-01-03 01:16:22.260	563
    94197	2014-01-03 06:55:30.633	20911  <-- stuck again!  Looks like only about 30 mins after I started the 2nd file
    109766	2014-01-03 07:44:49.867	23870  -- 5.2 rec/sec
    139784	2014-01-03 08:56:02.130	28143
    169397	2014-01-03 10:06:43.857	32384
    217700	2014-01-03 12:05:49.213	39530
    266450	2014-01-03 14:06:05.700	46746
    311192	2014-01-03 15:57:18.963	53419
    327878	2014-01-03 16:38:52.247	55913

    Recs    Secs    rec/sec
    ======  ====    ====
    37665   5385    6.9 
    40690   6026    6.7
    24821   3697    6.7
    24223   3622    6.7
    20519   3051    6.7
    
    remaining   ETA
    =========   =======
    111K        4:45 PM
     17K        4:45 PM

*/
