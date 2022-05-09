-- Inventory by Location
select ixLocation, FORMAT(count(*),'###,###') SKUs, FORMAT(getdate(),'yyyy.MM.dd HH:mm') 'AsOf'
from tblSKULocation
--where iQAV > 0
group by ixLocation
/*
Loc	SKUs	AsOf
=== ======= ================
47	452,267 2019.08.26 08:42
85	452,267
97	452,267
98	452,267
99	452,267

*/

select top 111000 * from tblSKULocation 
where ixLocation = 99
and ixSKU NOT IN (select ixSKU from tblSKULocation where ixLocation = 47)
--and ixSKU NOT LIKE 'UP%'
order by dtDateLastSOPUpdate

-- SKUs with QAV
select L.sDescription,
   -- FORMAT(sum(iQOS),'###,###') 'TotQOS', 
    FORMAT(count(distinct SL.ixSKU),'###,###') 'TangibleSKUsWithInv',
    FORMAT(sum(SL.iQAV),'###,###') 'TotQAV',
     FORMAT(getdate(),'yyyy.MM.dd HH:mm') 'AsOf'
from tblSKULocation SL
    LEFT JOIN tblLocation L on SL.ixLocation = L.ixLocation
    LEFT JOIN tblSKU S on SL.ixSKU = S.ixSKU
where (SL.iQAV > 0 or  SL.iQOS > 0)
    and S.flgIntangible = 0 -- don't forget to check for intangible if those SKUs need their QAV cleared!
group by L.sDescription
order by L.sDescription
/*          TangibleSKUs
Description	WithInv	        TotQAV      AsOf
=========== ============    ==========  ================
Boonville	262	            2,097       2019.08.26 08:46
Eagle	    1,270	        752,452
Lincoln	    77,745	        8,739,405
TSS        	1,331	        2,670

Boonville	244 	        2,142       
Eagle	    1,265	        749,961
Lincoln	    77,728	        8,708,911
TSS     	1,355	        2,712      2019.08.19
*/

select * from tblLocation
/*
Loc	St	sDescription
=== ==  ==========================
47	IN	Boonville
85	AZ	Tolleson
96	IN	CSI
97	NE	Trackside Support Services
98	NE	Eagle
99	NE	Lincoln
*/

-- Trackside Support Inventory
-- TANGIBLE SKUs
SELECT S.ixSKU 'SKU',
    ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription', 
    --SL.iQOS, 
    SMIInv.iQAV 'SMIQAV',
    SL.iQAV 'TSSQAV', 
    ' ' 'QTYFound',
    --S.mAverageCost,
    (S.mAverageCost * SL.iQAV) 'InvValue',
    -- SL.iQC, SL.iQCB, SL.iQCBOM, SL.iQCXFER, <-- all were zeros as of 8-21-19
    --SL.sPickingBin, -- all picking bins were "TSS"
    S.sSEMACategory 'Category', S.sSEMASubCategory 'Sub-Category', S.sSEMAPart 'Part'
    , S.dtDiscontinuedDate
FROM tblSKU S
    left join tblSKULocation SL on S.ixSKU = SL.ixSKU and SL.ixLocation = 97
    left join (select ixSKU, iQAV
               from tblSKULocation
               where ixLocation = 99
               ) SMIInv on SMIInv.ixSKU = S.ixSKU
WHERE S.flgDeletedFromSOP = 0
    AND S.flgIntangible = 0
    AND (SL.iQOS > 0         OR SL.iQAV > 0         OR SL.iQC > 0         OR SL.iQCB > 0         OR SL.iQCBOM > 0         OR SL.iQCXFER > 0 )
   -- and SL.iQOS <> SL.iQAV all matched 100% as of 8-21-19
Order by SMIInv.iQAV -- (S.mAverageCost * SL.iQAV) desc



/*
insert into tblSKULocation
select TOP 10000 TS.ixSKU, 85, 0,0,0,0,0,0,0,0, NULL, NULL, NULL, NULL, NULL
from #TollesonSKUsToLoad TS
WHERE ixSKU NOT IN (select ixSKU from tblSKULocation where ixLocation = 85)


SELECT * 
INTO [SMIArchive].dbo.BU_tblSKULocation_20190820
from tblSKULocation -- 1,804,639


-- DROP TABLE #TollesonSKUsToLoad
*/


