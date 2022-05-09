-- flgIntabible validating tangible vs intantible SKUs

select DB_NAME() AS 'DB          '
    ,CONVERT(varchar, GETDATE(), 110) 'As of   '
    ,count(*) Qty
    ,flgIntangible
from tblSKU
where flgDeletedFromSOP = 0
group by 
 flgIntangible
order by flgIntangible 
/*
DB          	As of   	Qty	    flgIntangible
AFCOReporting	06-19-2015	50,797	0
AFCOReporting	06-19-2015	333	    1

SMI Reporting	06-19-2015	263,184	0
SMI Reporting	06-19-2015	89	    1
*/



select * from tblSKU where ixSKU in ('DLR','DROPDLR')

-- details for SKUs currently flagged as intangible
select ixSKU, sDescription, mPriceLevel1, mAverageCost, ixPGC, flgActive, dWeight, iLength, iWidth, iHeight, ixCreator, sSEMACategory, ixCAHTC
from tblSKU where flgIntangible = 1
and flgDeletedFromSOP = 0
order by dWeight

-- SKUs that probably should be flagged as intangible
select ixSKU, sDescription, mPriceLevel1, mAverageCost, ixPGC, flgActive, dWeight, iLength, iWidth, iHeight, ixCreator--, sSEMACategory, ixCAHTC
from tblSKU
where ixPGC = 'ZZ'
and flgIntangible = 0
and flgDeletedFromSOP = 0
and mPriceLevel1 = 0
    AND mAverageCost = 0
    AND dWeight < 0.01
    and iLength = 0
    and iWidth = 0
    and iHeight = 0
    and flgActive = 1
    and ixCAHTC is NULL      
    and UPPER(sDescription) NOT LIKE '%PART%'
    and UPPER(sDescription) NOT LIKE '%HREW%'    
    and UPPER(sDescription) NOT LIKE '% OD X%'
    and UPPER(sDescription) NOT LIKE '%ALLUM%'
    and UPPER(sDescription) NOT LIKE '%ALUM%'    
    and UPPER(sDescription) NOT LIKE '%PEDAL%'        
    and UPPER(sDescription) NOT LIKE '%BAR%'   -- 850
    and UPPER(sDescription) NOT LIKE '%HEX%'     
    and UPPER(sDescription) NOT LIKE '%ENGINE%'     
    and UPPER(sDescription) NOT LIKE '%PLATING%' -- 781
    and UPPER(sDescription) NOT LIKE '%MAGAZ%'           
    and UPPER(sDescription) NOT LIKE '%CLAMP%'           
    and UPPER(sDescription) NOT LIKE '%GO CART%' -- 742
    and UPPER(sDescription) NOT LIKE '%PLATE%' 
    and UPPER(sDescription) NOT LIKE '%ASSEMBLY%' 
    and UPPER(sDescription) NOT LIKE '%SCREW%' -- 221
    and UPPER(sDescription) NOT LIKE '%INSERT%' -- 
    and UPPER(sDescription) NOT LIKE '%BOLT%' -- 
    and UPPER(sDescription) NOT LIKE '%BRACKET%' -- 207        
    and UPPER(sDescription) NOT LIKE '%ARM%'
    and UPPER(sDescription) NOT LIKE '%LEFT%'
    and UPPER(sDescription) NOT LIKE '%RIGHT%'          
    and UPPER(sDescription) NOT LIKE '%TOP%'    
    and UPPER(sDescription) NOT LIKE '%BOTTOM%'    
    and UPPER(sDescription) NOT LIKE '%BLACK%' -- 175       
    and UPPER(sDescription) NOT LIKE '%AXLE%'     
    and UPPER(sDescription) NOT LIKE '%PISTON%'     
    and UPPER(sDescription) NOT LIKE '%COIL%'     
    and UPPER(sDescription) NOT LIKE '%SPRING%'               
    and UPPER(sDescription) NOT LIKE '%TUBE%'         
    and UPPER(sDescription) NOT LIKE '%ROD%'         
    and UPPER(sDescription) NOT LIKE '%SPACER%'                                      
    and ixSKU NOT LIKE 'M2%'
    and ixSKU NOT LIKE 'M3%'
    and ixSKU NOT LIKE 'M4%'
    and ixSKU NOT LIKE 'M5%'
    and ixSKU NOT LIKE 'M6%'
    and ixSKU NOT LIKE 'M7%'         
    and ixSKU NOT LIKE 'MUSEUM%'                       
--    and UPPER(sDescription) NOT LIKE '% X %'           
    and UPPER(sDescription) NOT LIKE '%PLATING%' 
    and ixSKU in (Select distinct ixSKU from tblOrderLine where flgLineStatus = 'Shipped' and dtShippedDate >= '01/01/2010')                                                    
order by ixSKU, sDescription    
/*
ixSKU	sDescription	mPriceLevel1	mAverageCost	ixPGC	flgActive	dWeight	iLength	iWidth	iHeight	ixCreator	sSEMACategory	ixCAHTC
DLR	    DEALER ORDER	0.00	        0.00	        ZZ	    1	        0.001	0	        0	    0	KDL	        NULL	        NULL
DROPDLR	DROPSHIP	    0.00	        0.00	        ZZ	    1	        0.001	0	        0	    0	KDL	        NULL	        NULL
*/
     
-- LABOR SKUs... currently flgIntangible = 0
select ixSKU, sDescription, mPriceLevel1, mAverageCost, ixPGC, flgActive, dWeight, iLength, iWidth, iHeight, ixCreator, dtCreateDate--, sSEMACategory, ixCAHTC
from tblSKU
where ixPGC = 'ZZ'
and flgIntangible = 0
and flgDeletedFromSOP = 0
and mPriceLevel1 = 0
AND mAverageCost = 0
AND dWeight < 0.01
and iLength = 0
and iWidth = 0
and iHeight = 0
and flgActive = 1
and ixCAHTC is NULL      
and UPPER(sDescription) LIKE '%LABOR%' 
and ixSKU in (select distinct ixSKU from tblOrderLine 
            where ixShippedDate >= 16803
            and flgLineStatus = 'Shipped')

select * from tblSKU where ixPGC = 'ZZ'
and flgDeletedFromSOP = 0
and flgActive = 1
and flgIntangible = 0
and iLength = 0
and mAverageCost = 0
and sDescription like '%LABOR%'
--and UPPER(sDescription) LIKE '%HELP%' 


-- AFCO currently flgIntangible = 0
select ixSKU, sDescription, mPriceLevel1, mAverageCost, ixPGC, flgActive, dWeight, iLength, iWidth, iHeight, ixCreator, dtCreateDate--, sSEMACategory, ixCAHTC
from tblSKU
where --ixPGC = 'ZZ'
 flgIntangible = 0
and flgDeletedFromSOP = 0
and mPriceLevel1 = 0
AND mAverageCost = 0
AND dWeight < 0.01
and iLength = 0
and iWidth = 0
and iHeight = 0
and flgActive = 1
and ixCAHTC is NULL      
and ixSKU NOT IN (select ixSKU from [AFCOTemp].dbo.PJC_25994_PosIntangibleSKU_DueToPV)



-- AFCO possible intangible SKUs based on Primary Vendor
-- DROP TABLE [AFCOTemp].dbo.PJC_25994_PosIntangibleSKU_DueToPV
select S.ixSKU, S.sDescription, S.ixPGC, S.dWeight, S.iLength, S.iWidth, S.iHeight, S.mPriceLevel1, S.mLatestCost, S.dtDiscontinuedDate, S.flgMadeToOrder, S.flgIntangible
--into [AFCOTemp].dbo.PJC_25994_PosIntangibleSKU_DueToPV
from tblSKU S
left join tblVendorSKU VS on S.ixSKU = VS.ixSKU
where S.flgDeletedFromSOP = 0
and VS.iOrdinality = 1
and VS.ixVendor = '0010' -- 297   per Jean most(or all) of the SKUs that have this primary vendor should be intangible
and S.flgIntangible = 0  -- 269
and S.dtDiscontinuedDate > '06/11/2015'
order by dWeight





-- COUNT by SKU... sold YTD but no weight
select OL.ixSKU, SKU.sDescription, COUNT(OL.ixSKU)
from tblOrderLine OL
left join tblSKU SKU on OL.ixSKU = SKU.ixSKU
where OL.ixShippedDate > = 17168
  and SKU.flgDeletedFromSOP = 0
  and dWeight < 0.01
  and flgIntangible = 0
  and sDescription NOT LIKE '%CATALOG%'
group by OL.ixSKU, SKU.sDescription, SKU.flgIntangible
order by COUNT(OL.ixSKU) desc

-- DETAIL sold YTD but no weight
select distinct S.ixSKU, S.sDescription, S.ixPGC, S.dWeight, S.iLength, S.iWidth, S.iHeight, S.mPriceLevel1, S.mLatestCost, S.dtDiscontinuedDate, S.flgMadeToOrder, S.flgIntangible
from tblOrderLine OL
left join tblSKU S on OL.ixSKU = S.ixSKU
where OL.ixShippedDate > = 17168
  and S.flgDeletedFromSOP = 0
  and dWeight < 0.01
  and flgIntangible = 0
  and sDescription NOT LIKE '%CATALOG%'
and S.ixSKU NOT IN (select ixSKU from [AFCOTemp].dbo.PJC_25994_PosIntangibleSKU_DueToPV)


-- AFCO
SELECT ixSKU, sDescription, dtDateLastSOPUpdate, ixTimeLastSOPUpdate, flgIntangible
from tblSKU where ixSKU in ('PLONLY','SHOCKTICKET','READNOTE','MANAGERAPPROVAL','WEBORDER','HALFFRT','NOEMAIL','COUNTERORDER','HEADERTICKET','EXPEDITE','SPECIALTERMSNET60','WIRE','DYNO','SPECIALTERMS','90021','90007','90057','100151','HOLD','PROMOHALFOFF','200041','VETDISC','SEENOTE','A550100101X','100042','LIT-137','NDA')
order by dtDateLastSOPUpdate, ixTimeLastSOPUpdate


-- intangible SKUs (that are flagged INCORRECTLY) are being backordered
SELECT S.ixSKU, S.sDescription, OL.flgLineStatus, OL.flgOverride, count(OL.ixSKU) --dtDateLastSOPUpdate, ixTimeLastSOPUpdate, flgIntangible
from tblSKU S
JOIN tblOrderLine OL on S.ixSKU = OL.ixSKU
where S.ixSKU in ('PLONLY','SHOCKTICKET','READNOTE','MANAGERAPPROVAL','WEBORDER','HALFFRT','NOEMAIL','COUNTERORDER','HEADERTICKET','EXPEDITE','SPECIALTERMSNET60','WIRE','DYNO','SPECIALTERMS','90021','90007','90057','HOLD','PROMOHALFOFF','200041','VETDISC','SEENOTE','100042','LIT-137','NDA')
and OL.flgLineStatus NOT IN ('Cancelled', 'Cancelled Quote', 'Lost','Quote')
and OL.ixOrderDate >= 17300
GROUP BY S.ixSKU, S.sDescription, OL.flgLineStatus , OL.flgOverride
order by  OL.flgLineStatus