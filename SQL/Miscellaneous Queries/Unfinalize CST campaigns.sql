-- Unfinalize CST campaigns

/*********************************** 
    SERVER: LNK-WEB2\SQLEXPRESS
    DB:     CustomerSegmentationDB
    TABLE:  tblCampaign
 ***********************************/
/*
flgStatus 
    values
        0= New Campaign
        1= In-Progress (a count has been done)
        2= finalized
        3= nothing (but this will prevent them from displaying anywhere on the Campaigns screen)
*/
/********************* UN-FINALIZE A CAMPAIGN **************************************/

/****   1) Reset status flag to 1(in progress)  ****/
    UPDATE tblCampaign
    set flgStatus = 1
    where ixCampaign in (129)

/**** 2) DELETE THE File on Server  ****/
    
    Use shared folder "CST finalized campaigns" that points to \\LNK-WEB2\finalized_campaigns
    to locate and delete the original output file.
    
    -- RDC to LNK-WEB2 and go to PATH = C:\finalized_campaigns if you have permissions.

    -- filename = <ixCampaign>-<incrimental file counter>.txt
    -- may copy the files elsewhere as a backup if needed

/************************************************************************************/
 




-- To HIDE campaigns(won't show on the finalized, in-progress, or new campaign lists)  
-- campaigns that are no longer needed (junk/tests etc)
    UPDATE tblCampaign
    set flgStatus = 3
    where ixCampaign in (100,22,20,18,17,16,13,7,6,5,4,1)
    --(99,78,77,76,75,63,42,26,21,100,22)
            
            
            
-- Most recent campaigns
SELECT ixCampaign, sName, sDescription, flgStatus, sMarket,
   -- dtCreateDate, dtUpdateDate, dtCountDate, dtFinalizeDate,
    CONVERT(VARCHAR, dtCreateDate, 100)   AS 'Create_Date',
    CONVERT(VARCHAR, dtUpdateDate, 100)   AS 'Update_Date',
    CONVERT(VARCHAR, dtCountDate, 100)   AS 'Count_Date',
    CONVERT(VARCHAR, dtFinalizeDate, 100)   AS 'Finalize_Date',        
    sCountTimeSpan, iTotalCount,  iTotalExcluded 
FROM tblCampaign
WHERE flgStatus in (2) --(0,1,2) -- 2=finalized
/*      0= New Campaign
        1= In-Progress (a count has been done)
        2= finalized
        3= nothing (but this will prevent them from displaying anywhere on the Campaigns screen)
*/
/*and (UPPER(sName) like '%TEST%'
     or
     UPPER(sDescription) like '%TEST%')
and (UPPER(sName) like '%2012%'
     or
     UPPER(sDescription) like '%2012%')     
*/     
ORDER BY dtCountDate desc, CONVERT(VARCHAR, dtUpdateDate, 100)
/*
ix                                          flg                                                                                                             Count       iTotal  iTotal
Campgn	sName	sDescription	            Status	Mrkt	Create_Date	            Update_Date	            Count_Date	            Finalize_Date	        TimeSpan	Count	Excluded
======  =====   =========================== ======  ====    ===================     ===================     ===================     ===================     ========    ======= ========
120     5002	#501 Street Version         2	    SR	    Dec  2 2014  9:32AM	    Dec  2 2014  9:32AM	    Dec  3 2014  6:19PM	    Dec  3 2014  6:19PM	    00:37.10	403422	0
119	    3000	Race Test Campaign	        1	    R	    Nov 26 2014 10:35AM	    Nov 26 2014 10:35AM	    Nov 26 2014 11:45AM	    NULL	                08:10.05	275418	0
114	    600	    2015 Sprint Winter	        1	    SM	    Nov 24 2014  3:35PM	    Nov 24 2014  3:35PM	    Dec  3 2014  7:46PM	    NULL	                00:03.28	47238	0
113	    405	    2015 Race Early Summer	    1	    R	    Nov 24 2014  2:51PM	    Nov 24 2014  2:51PM	    Nov 24 2014  3:51PM	    NULL	                17:44.03	207477	7200
112	    503	    2015 Street Late Spring	    1	    SR	    Nov 24 2014 12:57PM	    Nov 24 2014 12:57PM	    Nov 25 2014  5:08PM	    NULL	                29:04.62	366070	0
111	    404	    2015 Race Late Spring	    1	    R	    Nov 24 2014 12:28PM	    Nov 24 2014 12:28PM	    Nov 24 2014 12:56PM	    NULL	                18:32.00	206899	6839
110	    502	    Street 2015 Spring	        2	    SR	    Nov 21 2014  3:15PM	    Nov 21 2014  3:15PM	    Dec  5 2014  2:51PM	    Dec  5 2014  2:51PM	    00:47.98	488120	0
109	    2000	Test Campaign	            1	    R	    Nov 21 2014 10:45AM	    Nov 21 2014 10:45AM	    Nov 26 2014  2:54PM	    NULL	                06:29.57	361518	0
108	    403	    2015 Race Spring	        2	    R	    Nov 20 2014  5:02PM	    Nov 20 2014  5:02PM	    Dec  4 2014  5:05PM	    Dec  4 2014  5:05PM	    00:26.41	324131	0
107	    501	    2015 Street Early Spring	1	    SR	    Nov 19 2014  4:36PM	    Nov 19 2014  4:36PM	    Nov 25 2014 11:32AM	    NULL	                36:02.29	441108	0
106	    4020	#402 Race 2015 Early Spring	2	    R	    Nov 19 2014  3:35PM	    Nov 19 2014  3:35PM	    Dec  4 2014  4:32PM	    Dec  4 2014  4:32PM	    00:27.15	297621	0
105	    5000	#500 2015 Winter Street	    1	    SR	    Nov 19 2014  3:05PM	    Nov 19 2014  3:05PM	    Dec  3 2014  2:29PM	    NULL	                00:40.75	433332	0
104	    400	    2015 Race Master List	    2	    R	    Nov 17 2014  3:30PM	    Nov 17 2014  3:30PM	    Nov 17 2014  4:24PM	    Nov 17 2014  4:24PM	    04:52.68	304335	0
103	    500	    2015 Street Winter	        2	    SR	    Nov 17 2014  2:02PM	    Nov 17 2014  2:02PM	    Nov 17 2014  4:40PM	    Nov 17 2014  4:40PM	    05:51.92	430451	0
*/




SELECT ixCampaign, sName, sDescription, flgStatus, sMarket,
   -- dtCreateDate, dtUpdateDate, dtCountDate, dtFinalizeDate,
    CONVERT(VARCHAR, dtCreateDate, 100)   AS 'Create_Date',
    CONVERT(VARCHAR, dtUpdateDate, 100)   AS 'Update_Date',
    CONVERT(VARCHAR, dtCountDate, 100)   AS 'Count_Date',
    CONVERT(VARCHAR, dtFinalizeDate, 100)   AS 'Finalize_Date',        
    sCountTimeSpan, iTotalCount,  iTotalExcluded 
FROM tblCampaign
ORDER BY sName


-- to rename a campaign
update tblCampaign
set sName = '501E',
    sDescription = 'Email Campaign'
where sName = '9000'





