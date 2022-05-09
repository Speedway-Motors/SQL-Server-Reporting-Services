select SL.iQOS, SL.iQC, SL.iQCB, SL.iQCBOM, SL.iQCXFER, (SL.iQOS -SL.iQC -SL.iQCB -SL.iQCBOM -SL.iQCXFER) QAVcalc, SL.iQAV
from tblSKULocation SL
    join tblSKU SKU on SL.ixSKU = SKU.ixSKU
where SL.ixLocation = '99'
and (SL.iQOS -SL.iQC -SL.iQCB -SL.iQCBOM -SL.iQCXFER) <> SL.iQAV
and SKU.flgDeletedFromSOP = 0

and iQC > 0
and iQCB > 0
--and iQCXFER > 0
and iQCBOM > 0
order by iQC desc


select SL.ixSKU, SL.iQOS, SL.iQC, SL.iQCB, SL.iQCBOM, SL.iQCXFER, (SL.iQOS -SL.iQC -SL.iQCB -SL.iQCBOM -SL.iQCXFER) QAVcalc, SL.iQAV
from tblSKULocation SL
    join tblSKU SKU on  SL.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS = SKU.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS
where SL.ixLocation = '99'
and (SL.iQOS -SL.iQC -SL.iQCB -SL.iQCBOM -SL.iQCXFER) = SL.iQAV --COLLATE SQL_Latin1_General_CP1_CI_AS
and SKU.flgDeletedFromSOP = 0 
and SL.iQC = 0
and SL.iQCB = 0 
and SL.iQCBOM = 0
and SL.iQCXFER = 0

8300 88000

