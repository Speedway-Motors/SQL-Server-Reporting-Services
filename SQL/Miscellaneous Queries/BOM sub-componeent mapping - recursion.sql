-- BOM sub-componeent mapping - recursion

/* CONCLUSIONS

The processes used in SOP for BOMs are too convoluted to find an effective way to handle the recursion issue.
I tracked sub-components down through 15 TIERS and over 100 SKUs were STILL LEADING TO MORE TIERS OF SUB-COMPONENTS!

In addition the templates are not mapped correctly.  Al looked up several BOMs in SOP to verify I was mapping through
the tiers correctly.  He kept finding BOMs that were mapped to discontinued parts or he would find a sub-component that was
replaced by another SKU (and the template not corrected) when going to that SKU, he would find that it had been replaced
by yet another SKU and so on.   


*/



select * from vwDataFreshness
where sTableName like '%BOMTemp%'
order by sTableName, DaysOld

/* ALL data refreshed and deleted SOP records flagged 
for tblBOMTemplateDetail and tblBOMTemplateMaster

   sTableName	Records	DaysOld
tblBOMTemplateDetail	82085	   <=1
tblBOMTemplateMaster	13456	   <=1
*/

select distinct ixFinishedSKU
from tblBOMTemplateDetail
where dtDateLastSOPUpdate < '08/01/2019'
and flgDeletedFromSOP = 0


select distinct ixFinishedSKU
from tblBOMTemplateMaster
where dtDateLastSOPUpdate < '08/01/2019'
and flgDeletedFromSOP = 0

SELECT distinct TM.ixFinishedSKU, TM.ixCreateUser, TM.ixUpdateUser
from tblBOMTemplateMaster TM -- 12,071 templates for finished parts that are not discontinued
    left join tblSKU S on TM.ixFinishedSKU = S.ixSKU       
where TM.flgDeletedFromSOP = 0
    and S.flgDeletedFromSOP = 0
    and S.flgActive = 1
    and TM.ixFinishedSKU in (select distinct TD.ixFinishedSKU
                             from tblBOMTemplateDetail TD
                                    left join tblBOMTemplateMaster TM on TD.ixFinishedSKU = TM.ixFinishedSKU
                                    left join tblSKU S on TD.ixSKU = S.ixSKU    
                                    left join tblSKU S2 on TM.ixFinishedSKU = S2.ixSKU 
                             where S.flgActive = 0
                                and S2.flgActive = 1)
   


/* 
AS OF 8-1-2019

13,494 BOM Templates 
12,071 are NOT discontinued
 1,130 BOM Templates contain discontinued SKUs as componenets even though the BOMs they belong to are NOT discontinued


        # of
  BOMs  sublevels
======  ==========
11,868  1+
 4,530  2+
 2,112  3+
   870  4+
   269  5+
    23  6+
     6  7+
     .
     .
     .
     6  15+

*/
-- mapping to 15 levels
SELECT TM.ixFinishedSKU, 
    ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription',
    TM.ixCreateUser 'CreatedBy', FORMAT(D1.dtDate,'yyyy.MM.dd') as 'Created',
    TM.ixUpdateUser 'UpdatedBy', FORMAT(D2.dtDate,'yyyy.MM.dd') as 'Updated',
    FORMAT(LS.LastSold,'yyyy.MM.dd') as 'LastSold',
    S.mPriceLevel1,
    TD1.ixSKU 'SubLvl1', TD1.iQuantity 'SubLvl1Qty', -- 297,817
    TD2.ixSKU 'SubLvl2', TD2.iQuantity 'SubLvl2Qty',
    TD3.ixSKU 'SubLvl3', TD3.iQuantity 'SubLvl3Qty',
    TD4.ixSKU 'SubLvl4', TD4.iQuantity 'SubLvl4Qty',
    TD5.ixSKU 'SubLvl5', TD5.iQuantity 'SubLvl5Qty',
    TD6.ixSKU 'SubLvl6', TD6.iQuantity 'SubLvl6Qty',
    TD7.ixSKU 'SubLvl7', TD7.iQuantity 'SubLvl7Qty',
    TD8.ixSKU 'SubLvl8', TD8.iQuantity 'SubLvl8Qty',
    TD9.ixSKU 'SubLvl9', TD9.iQuantity 'SubLvl9Qty',                      
    TD10.ixSKU 'SubLvl10', TD10.iQuantity 'SubLvl10Qty',
    TD11.ixSKU 'SubLvl11', TD11.iQuantity 'SubLvl11Qty',
    TD12.ixSKU 'SubLvl12', TD12.iQuantity 'SubLvl12Qty',
    TD13.ixSKU 'SubLvl13', TD13.iQuantity 'SubLvl13Qty',   
    TD14.ixSKU 'SubLvl14', TD14.iQuantity 'SubLvl14Qty',
    TD15.ixSKU 'SubLvl15', TD15.iQuantity 'SubLvl15Qty'                
FROM tblBOMTemplateMaster TM
    left join tblBOMTemplateDetail TD1 on TM.ixFinishedSKU = TD1.ixFinishedSKU
    left join tblBOMTemplateDetail TD2 on TD2.ixFinishedSKU = TD1.ixSKU
    left join tblBOMTemplateDetail TD3 on TD3.ixFinishedSKU = TD2.ixSKU    
    left join tblBOMTemplateDetail TD4 on TD4.ixFinishedSKU = TD3.ixSKU        
    left join tblBOMTemplateDetail TD5 on TD5.ixFinishedSKU = TD4.ixSKU            
    left join tblBOMTemplateDetail TD6 on TD6.ixFinishedSKU = TD5.ixSKU                
    left join tblBOMTemplateDetail TD7 on TD7.ixFinishedSKU = TD6.ixSKU                    
    left join tblBOMTemplateDetail TD8 on TD8.ixFinishedSKU = TD7.ixSKU
    left join tblBOMTemplateDetail TD9 on TD9.ixFinishedSKU = TD8.ixSKU
    left join tblBOMTemplateDetail TD10 on TD10.ixFinishedSKU = TD9.ixSKU
    left join tblBOMTemplateDetail TD11 on TD11.ixFinishedSKU = TD10.ixSKU
    left join tblBOMTemplateDetail TD12 on TD12.ixFinishedSKU = TD11.ixSKU
    left join tblBOMTemplateDetail TD13 on TD13.ixFinishedSKU = TD12.ixSKU
    left join tblBOMTemplateDetail TD14 on TD14.ixFinishedSKU = TD13.ixSKU
    left join tblBOMTemplateDetail TD15 on TD15.ixFinishedSKU = TD14.ixSKU                    
    left join tblSKU S on TM.ixFinishedSKU = S.ixSKU     
    LEFT JOIN (-- LAST SOLD
        SELECT OL.ixSKU
                ,MAX(dtOrderDate) 'LastSold'
        FROM tblOrderLine OL 
                left join tblDate D on D.dtDate = OL.dtOrderDate 
        WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
        GROUP BY OL.ixSKU
        ) LS on LS.ixSKU = S.ixSKU
    left join tblDate D1 on D1.ixDate = TM.ixCreateDate     
    left join tblDate D2 on D2.ixDate = TM.ixUpdateDate                   
    left join tblSKU S1 on TD1.ixSKU = S1.ixSKU                               
    left join tblSKU S2 on TD2.ixSKU = S2.ixSKU                                   
    left join tblSKU S3 on TD3.ixSKU = S3.ixSKU                                   
    left join tblSKU S4 on TD4.ixSKU = S4.ixSKU                                   
    left join tblSKU S5 on TD5.ixSKU = S5.ixSKU                                   
    left join tblSKU S6 on TD6.ixSKU = S6.ixSKU                                                   
    left join tblSKU S7 on TD7.ixSKU = S7.ixSKU                                       
    left join tblSKU S8 on TD8.ixSKU = S8.ixSKU   
    left join tblSKU S9 on TD9.ixSKU = S9.ixSKU                                           
    left join tblSKU S10 on TD10.ixSKU = S10.ixSKU                                               
    left join tblSKU S11 on TD11.ixSKU = S11.ixSKU                        
    left join tblSKU S12 on TD12.ixSKU = S12.ixSKU                        
    left join tblSKU S13 on TD13.ixSKU = S13.ixSKU                        
    left join tblSKU S14 on TD14.ixSKU = S14.ixSKU                        
    left join tblSKU S15 on TD15.ixSKU = S15.ixSKU                        
WHERE TM.flgDeletedFromSOP = 0    
    and (S.dtDiscontinuedDate >  '08/01/2019' or S.dtDiscontinuedDate is NULL)
    and (S1.dtDiscontinuedDate >  '08/01/2019' or S1.dtDiscontinuedDate is NULL)
    and (S2.dtDiscontinuedDate >  '08/01/2019' or S2.dtDiscontinuedDate is NULL)
    and (S3.dtDiscontinuedDate >  '08/01/2019' or S3.dtDiscontinuedDate is NULL)
    and (S4.dtDiscontinuedDate >  '08/01/2019' or S4.dtDiscontinuedDate is NULL)
    and (S5.dtDiscontinuedDate >  '08/01/2019' or S5.dtDiscontinuedDate is NULL)
    and (S6.dtDiscontinuedDate >  '08/01/2019' or S6.dtDiscontinuedDate is NULL)
    and (S7.dtDiscontinuedDate >  '08/01/2019' or S7.dtDiscontinuedDate is NULL)
    and (S8.dtDiscontinuedDate >  '08/01/2019' or S8.dtDiscontinuedDate is NULL)
    and (S9.dtDiscontinuedDate >  '08/01/2019' or S9.dtDiscontinuedDate is NULL)
    and (S10.dtDiscontinuedDate >  '08/01/2019' or S10.dtDiscontinuedDate is NULL)
    and (S11.dtDiscontinuedDate >  '08/01/2019' or S11.dtDiscontinuedDate is NULL)
    and (S12.dtDiscontinuedDate >  '08/01/2019' or S12.dtDiscontinuedDate is NULL)
    and (S13.dtDiscontinuedDate >  '08/01/2019' or S13.dtDiscontinuedDate is NULL)
    and (S14.dtDiscontinuedDate >  '08/01/2019' or S14.dtDiscontinuedDate is NULL)
    and (S15.dtDiscontinuedDate >  '08/01/2019' or S15.dtDiscontinuedDate is NULL)
    AND TD15.ixSKU is NOT NULL -- 1,948
ORDER BY TM.ixFinishedSKU, TD1.ixSKU, TD2.ixSKU, TD3.ixSKU, TD4.ixSKU, TD5.ixSKU, TD6.ixSKU, TD7.ixSKU, TD8.ixSKU



SELECT TM.ixFinishedSKU,
    TD.ixSKU 'SubLvl1', TD.iQuantity 'SubLvl1Qty' -- 297,817
FROM tblBOMTemplateMaster TM
    left join tblBOMTemplateDetail TD on TM.ixFinishedSKU = TD.ixFinishedSKU
WHERE TM.flgDeletedFromSOP = 0    
ORDER BY TD.flgDeletedFromSOP desc





SELECT TM.ixFinishedSKU,
    TD1.ixSKU 'SubLvl1', TD1.iQuantity 'SubLvl1Qty', -- 297,817
    TD2.ixSKU 'SubLvl2', TD2.iQuantity 'SubLvl2Qty',
    TD3.ixSKU 'SubLvl3', TD3.iQuantity 'SubLvl3Qty',
    TD4.ixSKU 'SubLvl4', TD4.iQuantity 'SubLvl4Qty',
    TD5.ixSKU 'SubLvl5', TD5.iQuantity 'SubLvl5Qty',
    TD6.ixSKU 'SubLvl6', TD6.iQuantity 'SubLvl6Qty',
    TD7.ixSKU 'SubLvl7', TD7.iQuantity 'SubLvl7Qty'/*,
    TD8.ixSKU 'SubLvl8', TD8.iQuantity 'SubLvl8Qty',
    TD9.ixSKU 'SubLvl9', TD9.iQuantity 'SubLvl9Qty',                      
    TD10.ixSKU 'SubLvl10', TD10.iQuantity 'SubLvl10Qty',
    TD11.ixSKU 'SubLvl11', TD11.iQuantity 'SubLvl11Qty',
    TD12.ixSKU 'SubLvl12', TD12.iQuantity 'SubLvl12Qty',
    TD13.ixSKU 'SubLvl13', TD13.iQuantity 'SubLvl13Qty',   
    TD14.ixSKU 'SubLvl14', TD14.iQuantity 'SubLvl14Qty',
    TD15.ixSKU 'SubLvl15', TD15.iQuantity 'SubLvl15Qty'                
    */
FROM tblBOMTemplateMaster TM
    left join tblBOMTemplateDetail TD1 on TM.ixFinishedSKU = TD1.ixFinishedSKU
    left join tblBOMTemplateDetail TD2 on TD2.ixFinishedSKU = TD1.ixSKU
    left join tblBOMTemplateDetail TD3 on TD3.ixFinishedSKU = TD2.ixSKU    
    left join tblBOMTemplateDetail TD4 on TD4.ixFinishedSKU = TD3.ixSKU        
    left join tblBOMTemplateDetail TD5 on TD5.ixFinishedSKU = TD4.ixSKU            
    left join tblBOMTemplateDetail TD6 on TD6.ixFinishedSKU = TD5.ixSKU                
    left join tblBOMTemplateDetail TD7 on TD7.ixFinishedSKU = TD6.ixSKU                    
/*
    left join tblBOMTemplateDetail TD8 on TD8.ixFinishedSKU = TD7.ixSKU
    left join tblBOMTemplateDetail TD9 on TD9.ixFinishedSKU = TD8.ixSKU
    left join tblBOMTemplateDetail TD10 on TD10.ixFinishedSKU = TD9.ixSKU
    left join tblBOMTemplateDetail TD11 on TD11.ixFinishedSKU = TD10.ixSKU
    left join tblBOMTemplateDetail TD12 on TD12.ixFinishedSKU = TD11.ixSKU
    left join tblBOMTemplateDetail TD13 on TD13.ixFinishedSKU = TD12.ixSKU
    left join tblBOMTemplateDetail TD14 on TD14.ixFinishedSKU = TD13.ixSKU
    left join tblBOMTemplateDetail TD15 on TD15.ixFinishedSKU = TD14.ixSKU                    
*/
    left join tblSKU S on TM.ixFinishedSKU = S.ixSKU                           
    left join tblSKU S1 on TD1.ixSKU = S1.ixSKU                               
    left join tblSKU S2 on TD2.ixSKU = S2.ixSKU                                   
    left join tblSKU S3 on TD3.ixSKU = S3.ixSKU   
    left join tblSKU S4 on TD4.ixSKU = S4.ixSKU                                   
    left join tblSKU S5 on TD5.ixSKU = S5.ixSKU                                   
    left join tblSKU S6 on TD6.ixSKU = S6.ixSKU                                                   
    left join tblSKU S7 on TD7.ixSKU = S7.ixSKU                                       
/* 
    left join tblSKU S8 on TD8.ixSKU = S8.ixSKU   
    left join tblSKU S9 on TD9.ixSKU = S9.ixSKU                                           
    left join tblSKU S10 on TD10.ixSKU = S10.ixSKU                                               
    left join tblSKU S11 on TD11.ixSKU = S11.ixSKU                        
    left join tblSKU S12 on TD12.ixSKU = S12.ixSKU                        
    left join tblSKU S13 on TD13.ixSKU = S13.ixSKU                        
    left join tblSKU S14 on TD14.ixSKU = S14.ixSKU                        
    left join tblSKU S15 on TD15.ixSKU = S15.ixSKU                        
*/
WHERE TM.flgDeletedFromSOP = 0    
and (S.dtDiscontinuedDate >  '08/01/2019' or S.dtDiscontinuedDate is NULL)
and (S1.dtDiscontinuedDate >  '08/01/2019' or S1.dtDiscontinuedDate is NULL)
and (S2.dtDiscontinuedDate >  '08/01/2019' or S2.dtDiscontinuedDate is NULL)
and (S3.dtDiscontinuedDate >  '08/01/2019' or S3.dtDiscontinuedDate is NULL)
and (S4.dtDiscontinuedDate >  '08/01/2019' or S4.dtDiscontinuedDate is NULL)
and (S5.dtDiscontinuedDate >  '08/01/2019' or S5.dtDiscontinuedDate is NULL)
and (S6.dtDiscontinuedDate >  '08/01/2019' or S6.dtDiscontinuedDate is NULL)
and (S7.dtDiscontinuedDate >  '08/01/2019' or S7.dtDiscontinuedDate is NULL)
/*
and (S8.dtDiscontinuedDate >  '08/01/2019' or S8.dtDiscontinuedDate is NULL)
and (S9.dtDiscontinuedDate >  '08/01/2019' or S9.dtDiscontinuedDate is NULL)
and (S10.dtDiscontinuedDate >  '08/01/2019' or S10.dtDiscontinuedDate is NULL)
and (S11.dtDiscontinuedDate >  '08/01/2019' or S11.dtDiscontinuedDate is NULL)
and (S12.dtDiscontinuedDate >  '08/01/2019' or S12.dtDiscontinuedDate is NULL)
and (S13.dtDiscontinuedDate >  '08/01/2019' or S13.dtDiscontinuedDate is NULL)
and (S14.dtDiscontinuedDate >  '08/01/2019' or S14.dtDiscontinuedDate is NULL)
and (S15.dtDiscontinuedDate >  '08/01/2019' or S15.dtDiscontinuedDate is NULL)
*/
    AND TD1.ixSKU is NULL -- 1,948
ORDER BY TM.ixFinishedSKU, TD1.ixSKU, TD2.ixSKU, TD3.ixSKU, TD4.ixSKU, TD5.ixSKU, TD6.ixSKU
, TD7.ixSKU, TD8.ixSKU




-- The first BOM is a regular BOM
-- The second BOM is a REVERSE BOM
-- It does NOT MAKE SENSE that they are both sub-components of each other!
SELECT * FROM tblBOMTemplateDetail
where ixFinishedSKU = '4658583893'

SELECT * FROM tblBOMTemplateDetail
where ixFinishedSKU = '46583898'

SELECT ixSKU, ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription'  
FROM tblSKU S
where S.ixSKU in ('4658583893','46583898')
/*
46583898 "K&N 083898 Replacement Sprint Filter Clips for Box Air Filters" (template says it's 6 of 4658583893)
4658583893 "K&N 85-83893 Air Cleaner Spring Clips, 6 Pack, .750 x 5.99 Inch" (template says it's 6 of 46583898)

Kevin says the 2nd BOMTemplate is for RBOMs
*/


SELECT distinct BTM.ixFinishedSKU 
from tblBOMTemplateMaster BTM
left join tblSKU S on BTM.ixFinishedSKU = S.ixSKU
WHERE S.flgDeletedFromSOP = 0 -- 13,488
and flgActive = 1 -- 12,097

SELECT * 
from tblBOMTemplateMaster BTM
left join tblBOMTemplateDetail BTD on BTM.ixFinishedSKU = BTD.ixFinishedSKU
WHERE S.flgDeletedFromSOP = 0 -- 13,488
and flgActive = 1 -- 12,097




SELECT count(distinct BTM.ixFinishedSKU) -- 13,456 Total BOMs
from tblBOMTemplateMaster BTM
where BTM.flgDeletedFromSOP = 0 

select count(distinct BTD.ixFinishedSKU) -- 13,076 have sub-componenets that are NOT BOMs
from tblBOMTemplateDetail BTD
where BTD.flgDeletedFromSOP = 0
    and ixSKU NOT IN (SELECT ixFinishedSKU 
                      from tblBOMTemplateMaster BTM
                      WHERE  BTM.flgDeletedFromSOP = 0
                      ) -- 5,208 BOMs 

select count(distinct BTD.ixFinishedSKU) -- 5,201
from tblBOMTemplateDetail BTD
where BTD.flgDeletedFromSOP = 0
    and ixSKU IN (SELECT ixFinishedSKU 
                      from tblBOMTemplateMaster BTM
                      WHERE  BTM.flgDeletedFromSOP = 0
                      ) -- 13,076 BOMs have sub-componenets that are NOT BOMs
