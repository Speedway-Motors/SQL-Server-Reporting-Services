-- SMIHD-7038  SSRS report to view MetaDescription for shop pages

/*Need a new folder (if you don't already have one for SEO stuff).

Title: MetaDescription Export or something along those lines

3 report prompts:
Export Type: <Values come from a stored procedure>, have to choose one
Include Missing MetaDescription: True/False Default true
Only Missing MetaDescription: True/False Default true
*/
Stored Procedure returns the following fields:
vCurrentFunction - Use this as the title for the next field, hide in report
ObjectName 
ContentType
Skey
SiteUrl - Use this value and append sKey to it
SmiNetUrl - Use this value and append sKey to it
sTitle
sMetaDescription

Report should be setup to be able to generate a nice excel spreadsheet

How to get the data for it, the stored procedure exists in tngLive.
CALL spGetMissingMetaDescription('Options',0,0); - Returns the options for the ExportType field

CALL spGetMissingMetaDescription('Brand',1,1);  -- only show missing metadescription
CALL spGetMissingMetaDescription('Brand',1,0); -- Show all metadescription and missing ones
CALL spGetMissingMetaDescription('Brand',0,0); -- only ones with metadesription 

I believe we already have a report or two out there that call a stored procedure so we should be able to use that to figure out how to call the stored procedure with parameters.

Please feel free to rename anything if you have a better name or standard.

If I did this right I should be able to add more types of exports and not have to bother you again on the report.

Chad & K Mathison will need to get access to this also. Chad and I can walk her through training on how to use SSRS and subscriptions.


SELECT * 
FROM openquery([TNGREADREPLICA],' 
       
        CALL spGetMissingMetaDescription(''Options'',0,0)
')
/*
Options
Market-Part Type
Brand
*/

SELECT * 
FROM openquery([TNGREADREPLICA],' 
       
        CALL spGetMissingMetaDescription(''Brand'',0,0)
')
/* 
vCurrentFunction	ObjectName	ContentType	sKey	SiteUrl	SmiNetUrl	sTitle	sMetaDescription
-- 466 records
*/


SELECT * 
FROM openquery([TNGREADREPLICA],' 
       
        CALL spGetMissingMetaDescription(''Brand'',1,1)
')
-- 50 records

SELECT * 
FROM openquery([TNGREADREPLICA],' 
       
        CALL spGetMissingMetaDescription(''Brand'',0,1)
')



SELECT * from tblBin where ixBin like 'B%'