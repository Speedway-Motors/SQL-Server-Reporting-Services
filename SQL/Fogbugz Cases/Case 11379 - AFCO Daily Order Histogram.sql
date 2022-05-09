--Qtr. 1

SELECT D.dtDate as 'Ship Date',
       T.iHour as 'Hour Shipped (24)',
       P.sTrackingNumber as '# of Packages'
       
FROM tblPackage P

left join tblDate D on D.ixDate = P.ixShipDate
left join tblTime T on T.ixTime = P.ixShipTime

WHERE D.dtDate >= '01/01/11'
  and D.dtDate < '04/01/11'
     
GROUP BY T.iHour,
         D.dtDate ,
         P.sTrackingNumber

ORDER BY D.dtDate,
         T.iHour


--Qtr. 2      
         
SELECT D.dtDate as 'Ship Date',
       T.iHour as 'Hour Shipped (24)',
       P.sTrackingNumber as '# of Packages'
       
FROM tblPackage P

left join tblDate D on D.ixDate = P.ixShipDate
left join tblTime T on T.ixTime = P.ixShipTime

WHERE D.dtDate >= '04/01/11'
  and D.dtDate < '07/01/11'
     
GROUP BY T.iHour,
         D.dtDate,
         P.sTrackingNumber

ORDER BY D.dtDate,
         T.iHour


--Qtr. 3

SELECT D.dtDate as 'Ship Date',
       T.iHour as 'Hour Shipped (24)',
       P.sTrackingNumber as '# of Packages'
       
FROM tblPackage P

left join tblDate D on D.ixDate = P.ixShipDate
left join tblTime T on T.ixTime = P.ixShipTime

WHERE D.dtDate >= '07/01/11'
  and D.dtDate < '10/01/11'
     
GROUP BY T.iHour,
         D.dtDate,
         P.sTrackingNumber 

ORDER BY D.dtDate,
         T.iHour
         
         
--Qtr. 4   

SELECT D.dtDate as 'Ship Date',
       T.iHour as 'Hour Shipped (24)',
       --COUNT (P.sTrackingNumber) as '# of Packages'
       P.sTrackingNumber as '# of Packages'
       
FROM tblPackage P

left join tblDate D on D.ixDate = P.ixShipDate
left join tblTime T on T.ixTime = P.ixShipTime

WHERE D.dtDate >= '10/01/11'
  and D.dtDate < '01/01/12'
     
GROUP BY T.iHour,
         D.dtDate,
         P.sTrackingNumber

ORDER BY D.dtDate,
         T.iHour
               