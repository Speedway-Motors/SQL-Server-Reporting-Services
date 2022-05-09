-- SMIHD-1924 - List of SKUs with Pick Bins and Zones  
select * from tblBinSku  
  
  
  
select * from tblLocation  
  
select COUNT(*)
from tblBinSku
where ixLocation = 


SELECT S.ixSKU, 
    COUNT(distinct BS.sPickingBin) Bin 
from tblSKU S 
left join tblBinSku BS ON BS.ixSKU = S.ixSKU
WHERE S.flgDeletedFromSOP = 0
AND S.flgIntangible = 0
AND BS.ixLocation = 99

group by S.ixSKU
order by COUNT(distinct BS.sPickingBin) desc

select SUBSTRING(sPickingBin,1,1) as 'Zone',
    COUNT(BS.ixSKU) SKUs
from tblSKU S 
left join tblBinSku BS ON BS.ixSKU = S.ixSKU
WHERE S.flgDeletedFromSOP = 0
AND S.flgIntangible = 0
AND BS.ixLocation = 99
AND BS.iSKUQuantity > 0
GROUP BY SUBSTRING(sPickingBin,1,1)
ORDER BY  SUBSTRING(sPickingBin,1,1)

NULL	7516
!	52
`	12
~	47
    3	5561
    4	9921
    5	10614
9	111743
    A	40831
    B	22335
C	5
E	917
I	17
R	1195
S	2785
V	9800
W	220
    X	17263
    Y	2116
    Z	21562

NULL	7516
!	44
`	7
~	26
3	5271
4	9559
5	10541
9	67
A	4697
B	17483
C	4
E	111
I	17
R	1172
S	2168
V	4365
W	139
X	15727
Y	2077
Z	4876

3/4/5/X/Y/Z/A/B



E, R, S, V, W

select SUBSTRING(ixBin,1,1), COUNT(*)
from tblBinSku
--where SUBSTRING(ixBin,1,1) in ('E', 'R', 'S', 'V', 'W')
where ixLocation = 99
group by SUBSTRING(ixBin,1,1)
order by COUNT(*) desc

9	111706
    A	60042
    B	21269
    Z	19370
    X	13240
V	8830
O	5861
    4	5451
    5	5143
    3	3775
R	3087
S	2830
C	1298
I	925
E	901
    Y	887
L	490
W	223
!	131
~	54
Q	49
D	24
G	20
`	12

SELECT S.ixSKU 'SKU', 
    BS.iSKUQuantity 'Qty', 
    ixLocation 'Location',
    --sPickingBin 'PickingBin',
    ixBin 'Bin',
    SUBSTRING(ixBin,1,1) as 'Zone'
from tblSKU S 
     join tblBinSku BS ON BS.ixSKU = S.ixSKU
WHERE S.flgDeletedFromSOP = 0
    AND S.flgIntangible = 0
--AND BS.ixLocation = 99 -- all loactions per JEF
    AND BS.iSKUQuantity > 0
ORDER BY SUBSTRING(ixBin,1,1), S.ixSKU

SELECT * FROM tblSKULocation
where iQAV > 0





SELECT SKU, Weight, Length, Width, Height, COUNT(*) BinsWithQty from (

    SELECT S.ixSKU 'SKU', 
        S.dWeight 'Weight',
        S.iLength 'Length',
        S.iWidth 'Width',
        S.iHeight 'Height',
        BS.iSKUQuantity 'Qty', 
        ixLocation 'Location',
        --sPickingBin 'PickingBin',
        ixBin 'Bin',
        SUBSTRING(ixBin,1,1) as 'Zone',
        sPickingBin
    from tblSKU S 
         join tblBinSku BS ON BS.ixSKU = S.ixSKU
    WHERE S.flgDeletedFromSOP = 0
        AND S.flgIntangible = 0
    --AND BS.ixLocation = 99 -- all loactions per JEF
        AND BS.iSKUQuantity > 0
    --ORDER BY SUBSTRING(ixBin,1,1), S.ixSKU

) X
group by SKU, Weight, Length, Width, Height
having COUNT(*) > 1
order by COUNT(*) desc



SELECT SKU, Description, Location, 
SUM(TotCubicFt) 'TotCubicFt'
FROM (

SELECT BS.ixSKU 'SKU',
    S.sDescription'Description',
    BS.ixLocation 'Location',
    BS.ixBin 'Bin',
    B.sBinType 'BinType', 
    BS.iSKUQuantity 'SKUQty',
    BS.sPickingBin 'PickBin',
    S.sSEMACategory 'SEMACat',
    S.sSEMASubCategory 'SEMASubCat',
    S.sSEMAPart 'SEMAPart',
    S.dWeight 'Weight',
    S.iLength 'Length',
    S.iWidth 'Width',
    S.iHeight 'Height'
    --(S.iLength*S.iWidth*S.iHeight) 'SKU LxWxH',
    --((S.iLength*S.iWidth*S.iHeight)*BS.iSKUQuantity) 'TotCubicInches',
    --((S.iLength*S.iWidth*S.iHeight)*BS.iSKUQuantity)/1728 'TotCubicFt' 
FROM tblBinSku BS
    left join tblBin B on BS.ixBin = B.ixBin
                      and BS.ixLocation = B.ixLocation
    left join tblSKU S on BS.ixSKU = S.ixSKU                      
where S.flgDeletedFromSOP = 0
        AND S.flgIntangible = 0
    --AND BS.ixLocation = 99 -- all loactions per JEF
        AND BS.iSKUQuantity > 0
        AND B.sBinType in ('R', 'P', 'SL') --<> 'R'
    -- AND BS.ixSKU = '92511925'
 --and BS.ixBin = BS.sPickingBin
 --AND S.ixSKU NOT LIKE 'BOX-%'
--order by  ((S.iLength*S.iWidth*S.iHeight)*BS.iSKUQuantity)  desc
   -- B.sBinType 
   ORDER BY
   BS.ixSKU, BS.ixLocation, BS.ixBin
  
    
    ) X
    
    
GROUP BY SKU, Description, Location    
ORDER BY SUM(TotCubicFt) Desc






select distinct sBinType
from tblBin

select top 10 * from tblBin
