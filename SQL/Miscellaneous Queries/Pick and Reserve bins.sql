-- Pick and Reserve bins

select top 10 * from tblBinSku


select top 10 * from tblBin

select sBinType, count(*)
from tblBin
group by sBinType
order by count(*) desc

SELECT ixBin, sBinType, sAisle, dtDateLastSOPUpdate -- 101,395 bins... 46,083 of which are empty!?!
into #PRBins -- DROP table #PRBins
from tblBin
where sBinType in ('P','R')
    and flgTrack = 1
    and flgDeletedFromSOP = 0
    and ixLocation = 99

SELECT PR.ixBin 'Bin', PR.sBinType 'BinType', PR.sAisle 'Aisle',
     SUM(ISNULL(BS.iSKUQuantity,0))
FROM #PRBins PR
    left join tblBinSku BS on PR.ixBin = BS.ixBin
                                and BS.ixLocation = 99
GROUP BY PR.ixBin, PR.sBinType, PR.sAisle
HAVING SUM(ISNULL(BS.iSKUQuantity,0)) <= 0 -- wth do some have negative quantities!?!
ORDER BY SUM(ISNULL(BS.iSKUQuantity,0))

SELECT * from tblBinSku
where ixBin in ('5F18H2','5E27E2','4E16A1','5C03A1','4F34B2','V76BC4','4D05G2','5D02J2')
and ixLocation = 99



select * from tblBinSku
where ixBin in ('V12BC5','5F11G1','BG36C1','X39GR')
    and ixLocation = 99
ORDER BY dtDateLastSOPUpdate desc

SELECT BS.ixBin, BS.ixSKU, BS.iSKUQuantity,BS.ixLocation
, B.sBinType
from tblBinSku BS
    left join tblBin B on BS.ixBin = B.ixBin
where iSKUQuantity < 0
  and flgTrack = 1
order by ixLocation




select flgTrack, count(1)
from tblBin
group by flgTrack
