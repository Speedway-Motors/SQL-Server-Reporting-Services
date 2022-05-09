-- tblTrack and TrackType Bank Surface 
--SELECT TOP 10 * FROM tblTrack

SELECT DISTINCT T.ixTrack
     , T.sName AS TrackName 
     , A.sCountry AS Country
     , A.sState AS State 
     , A.sCity AS City
     , A.sPostalCode AS ZipCode
     , A.sAdr1 AS StreetAddress
     , T.sDisplayLength
     , S.sName AS SurfaceType
     , TT.sTypeName AS TrackType 
     , B.sDescription AS BankType
     , P.sPhoneNumber      
     , T.sWebsite
FROM tblTrack T 
LEFT JOIN tblAddress A ON A.ixAddress = T.ixPhysicalAddress
LEFT JOIN tblPhoneNumber P ON P.ixPhoneNumber = T.ixPhoneNumber
LEFT JOIN tblSurface S ON S.ixSurface = T.ixSurface
LEFT JOIN tblTrackType TT ON TT.ixTrackType = T.ixTrackType 
LEFT JOIN tblBank B ON B.ixBank = T.ixBank
WHERE sCountry = 'United States'
  AND sPostalCode IS NOT NULL 
  AND sAdr1 IS NOT NULL
  AND flgVerified = 1
  AND sState = 'Wyoming'
ORDER BY ixTrack