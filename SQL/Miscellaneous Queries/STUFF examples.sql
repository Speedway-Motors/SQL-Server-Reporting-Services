-- STUFF examples


SELECT STUFF((SELECT ',' + [HeroName]
			  FROM @Heroes
			  ORDER BY [HeroName]
			  FOR XML PATH('')), 1, 1, '') AS [Output]
			  
			  
			  
	  
/*
ixMarket	sDescription
2B	        TBucket
AD	        AFCO/Dynatech
B	        BothRaceStreet
G	        Generic
Other	    Other
PC	        PedalCar
R	        Race
SC	        SportCompact
SE	        Safety Equipment
SM	        SprintMidget
SR	        StreetRod
TE	        Tools&Equip
UK	        Unknown
*/


SELECT STUFF((SELECT ', ' + ixMarket + ' - ' + sDescription 
              FROM tblMarket
              ORDER BY ixMarket
               FOR XML PATH('')), 1, 1, '') AS 'MarketList'
               
               
               
SELECT * FROM tblMarket		
               
SELECT * FROM tblMethodOfPayment        

SELECT * FROM tblShipMethod      
               
2B - TBucket,AD - AFCO/Dynatech,B - BothRaceStreet,G - Generic,Other - Other,PC - PedalCar,R - Race,SC - SportCompact,SE - Safety Equipment,SM - SprintMidget,SR - StreetRod,TE - Tools&amp;Equip,UK - Unknown               

SELECT * FROM tblCanadianProvince
SELECT * FROM tblEvent
SELECT * FROM tblHandlingCode
SELECT * FROM tblLocation
SELECT * FROM tblMarket
SELECT * FROM tblMethodOfPayment
SELECT * FROM tblOrderChannel
SELECT * FROM tblOrderType
SELECT * FROM tblPriceChangeReasonCode
SELECT * FROM tblShipMethod
SELECT * FROM tblSourceCodeType
SELECT * FROM tblTrailer

SELECT DISTINCT sOrderType from tblOrder

select * from tblTableSizeLog
where dtDate = '05/09/2014'
order by sRowCount

select top 10 * from tblOrder
where dtOrderDate = '05/09/14'
order by NEWID()

select distinct sMethodOfPayment
from tblOrder
