[USE AFCOReporting]

SELECT S.ixSKU
      ,S.sDescription
      ,S.ixPGC
 --    ,S.iQAV --AS 'tblSKU'
 --    ,S.iQOS --AS 'tblSKU'
 --     ,SL.ixLocation
 --     ,SL.iQOS --AS 'tblSKULoc.'
      ,SL.iQAV --AS 'tblSKULoc.'
FROM tblSKU S
JOIN tblSKULocation SL ON SL.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE SL.ixLocation = '99' --ixLocation '68' is not needed because this is SMI inventory counts
ORDER BY S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS

