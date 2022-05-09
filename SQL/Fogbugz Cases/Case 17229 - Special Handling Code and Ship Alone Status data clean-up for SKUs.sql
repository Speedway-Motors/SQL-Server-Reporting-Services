-- Case 17229 - Special Handling Code and Ship Alone Status data clean-up for SKUs

SELECT SKU.sHandlingCode as HCode, 
    HC.sDescription,
    SKU.flgShipAloneStatus as SAflag,
    COUNT(*) Qty
FROM tblSKU SKU
    left join tblHandlingCode HC on HC.ixHandlingCode = SKU.sHandlingCode
WHERE --SKU.sHandlingCode is not null
        flgDeletedFromSOP = 0
    and flgActive = 1
    --and flgShipAloneStatus = 0
GROUP BY SKU.sHandlingCode,HC.sDescription, SKU.flgShipAloneStatus
ORDER BY SKU.sHandlingCode,SKU.flgShipAloneStatus
	
	
/*
HCode	sDescription	                            SAflag	Qty
NULL	NULL	                                    0	    81960
3A	    OS3 Ship Alone  (UPS Lg. Pkg. Surcharge)	1	    115
3N	    OS3 Ship Nested (UPS Lg. Pkg. Surcharge)	0	    53
DA	    Dimensional Weight, Ship Alone	            1	    3430
DN	    Dimensional Weight, Ship Nested	            0	    673
DW	    Dimensional Weight Charge	                0	    6199
OA	    NULL	                                    1	    3
ON	    NULL	                                    0	    2
OS	    NULL	                                    0	    1
SA	    Ship Alone	                                1	    1616
SN	    Ship Nested	                                0	    402
TR	    Truck	                                    0	    324
*/

-- give the 6 skus that belong to HCode O%
select SKU.ixSKU,
       SKU.sDescritpion,
       SKU.flgShipAloneStatus,
       SKU.sHandlingCOde,
       S.
from tblSKU
WHERE sHandlingCode like 'O%'
     and   flgDeletedFromSOP = 0
    and flgActive = 1



ixSKU, sDescription, L W H Wt, SemaPart, sPickBin



select SKU.ixSKU, SKU.sDescription, SKU.flgShipAloneStatus, SKU.sHandlingCode,
    SKU.iLength, SKU.iWidth, SKU.iHeight, SKU.dWeight, 
    SKU.sSEMAPart,
    SKUL.sPickingBin AS 'Picking Bin'
from tblSKU SKU
    left join tblSKULocation SKUL on SKU.ixSKU = SKUL.ixSKU --and BS.ixLocation = '99'
where SKU.flgDeletedFromSOP = 0
    --and SKU.sHandlingCode like 'O%'-- ('
    and SKU.flgActive = 1
    and SKU.flgShipAloneStatus = 0
    and SKUL.ixLocation = 99
order by sHandlingCode, SKU.sSEMAPart, SKU.ixSKU




-- all RADIATOR SKUs and their Ship Alone Status
select ixSKU, -- 2,949
    mPriceLevel1, 
    --sSEMACategory, sSEMASubCategory, 
    --sSEMAPart,
    flgShipAloneStatus
from tblSKU
where upper(sSEMAPart) = 'RADIATOR'
    and flgDeletedFromSOP = 0
    and flgActive = 1
    --and flgShipAloneStatus = 1
    and (dtDiscontinuedDate is NULL 
         or dtDiscontinuedDate > getdate())         
order by mPriceLevel1, sSEMAPart      


-- count of RADIATORS by Ship Alone Status
select flgShipAloneStatus,
    COUNT(*) SKUQty
from tblSKU
where upper(sSEMAPart) = 'RADIATOR'
    and flgDeletedFromSOP = 0
    and flgActive = 1
    --and flgShipAloneStatus = 1
GROUP BY flgShipAloneStatus
--ORDER BY       

select CAST(iLength AS decimal(10,2))
from tblSKU
where iLength is NOT NULL
  and iLength between 1 and 10
  
  isnumeric(iLength) = 1




