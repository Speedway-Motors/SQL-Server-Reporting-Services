-- SMIHD-4971 - Package Level Detail (PLD) Report for USPS

SELECT -- LINCOLN DATA 
    --SM.sDescription 'SERVICE'
    P.sTrackingNumber,
    '68528' as 'ORIGIN' -- 68528 = lnk     47601 = Boonville
    ,O.sShipToZip 'DESTZIP'    
    ,P.dActualWeight 'ACTUALWT'  
    ,P.dLength 'LENGTH'
    ,P.dWidth 'WIDTH'
    ,P.dHeight 'HEIGHT'
FROM tblPackage P                                                  
    left join tblOrder O on P.ixOrder = O.ixOrder                   
    left join tblShipMethod SM on O.iShipMethod = SM.ixShipMethod
WHERE P.ixShipDate between 17564 and 17653                      --   205,975      + ??? for Afco         <-- Feb-Apr 2016 
    and O.iShipMethod IN (2,3,4,5,6,9,13,14,15,18,32)           --   203,233      + ??? for Afco         <-- list provided by CCC
    and P.flgCanceled = 0 
    and P.flgReplaced = 0                                       
    and O.sShipToCountry = 'US'                                 --   203,219      + ??? for Afco
    and dLength is NOT NULL
    and dWidth is NOT NULL
    and dHeight is NOT NULL                                     --   180,992    22k (11%) are missing package dimensions!?!
-- and (P.dActualWeight is NULL OR P.dActualWeight = 0)  


-- UNION ALL  can't do this.... COLLATION!

SELECT -- BOONEVILL DATA 
    --SM.sDescription 'SERVICE'
    '47601' as 'ORIGIN' -- 68528 = lnk     47601 = Boonville
    ,O.sShipToZip 'DESTZIP'    
    ,P.dActualWeight 'ACTUALWT'  
    ,P.dLength 'LENGTH'
    ,P.dWidth 'WIDTH'
    ,P.dHeight 'HEIGHT'
FROM [AFCOReporting].dbo.tblPackage P                                                  
    left join [AFCOReporting].dbo.tblOrder O on P.ixOrder = O.ixOrder                   
    left join [AFCOReporting].dbo.tblShipMethod SM on O.iShipMethod = SM.ixShipMethod
WHERE P.ixShipDate between 17564 and 17653                      --   205,975      + ??? for Afco         <-- Feb-Apr 2016 
    and O.iShipMethod IN (2,3,4,5,6,9,13,14,15,18,32)           --   203,233      + ??? for Afco         <-- list provided by CCC
    and P.flgCanceled = 0 
    and P.flgReplaced = 0                                       
    and O.sShipToCountry = 'US'                                 --   203,219      + ??? for Afco
    and dLength is NOT NULL
    and dWidth is NOT NULL
    and dHeight is NOT NULL                                     --   180,992    22k (11%) are missing package dimensions!?!    
-- and (P.dActualWeight is NULL OR P.dActualWeight = 0)  

  
/*
FROM CCC:
it needs to be packages shipping methods 2,3,4,5,6,9,13,14,15,18,32 
months of Feb through April. 
file should only contain destination zip, origination zip, actual package weight, length, width

FROM UPS:
Critical fields needed:
Destination ZIP Code
Actual Weight –Billed Weight
Current Service Level
Origin ZIP Code(s)
Length, Width, Height measurements by average weight of the packag-ing used (box and or poly indicated)
    