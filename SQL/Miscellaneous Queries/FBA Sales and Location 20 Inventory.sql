-- FBA Sales and Location 20 Inventory

SELECT * 
FROM vwDailyOrdersTakenWithBU_TEMPFBA
WHERE SubBU = 'Amazon FBA'
ORDER BY dtDate desc

SELECT FORMAT(SUM(DailySales),'$###,###') 'Sales ', 
    FORMAT(SUM(DailyProductMargin),'$###,###') 'Prouct Margin', 
    FORMAT(SUM(DailyNumOrds),'###,###') 'Orders', 
    FORMAT(GETDATE(),'yyyy.MM.dd') 'As of' 
FROM vwDailyOrdersTakenWithBU_TEMPFBA
WHERE SubBU = 'Amazon FBA'
/*   
    FBA YTD         
    
            Prouct
Sales 	    Margin	    Orders	As of
=======     =======     ======  ==========
$17,987     $10,676	    332	    2020.03.24
*/

    
    
                    
SELECT min(dtDate) 'Start', max(dtDate) 'End',
    SUM(DailyNumOrds) 'Orders',
    SUM(DailySales) 'Sales' 
FROM vwDailyOrdersTakenWithBU_TEMPFBA
WHERE SubBU = 'Amazon FBA'



select ixSKU, flgDeletedFROMSOP
FROM tblSKU
WHERE ixSKU like 'FBA%'

select *
FROM tblSKULocation
WHERE ixLocation = 20
and iQOS >0


SELECT BU.sBusinessUnit 'BU   ', count(*) 'OrderCnt'
FROM tblOrder O
    left join tblBusinessUnit BU on O.ixBusinessUnit = BU.ixBusinessUnit
WHERE sSourceCodeGiven = 'AMAZONFBA' --and ixBusinessUnit 
group by BU.sBusinessUnit
order by BU.sBusinessUnit
/*
        Order
BU      Count
====    =====
NULL	285
MKT	    32
*/
select * FROM tblBusinessUnit
109	MKT
110	PHONE

select ixOrder, sSourceCodeGiven, BU.sBusinessUnit 'BU ',  sOrderStatus,
    FORMAT(dtOrderDate,'yyyy.MM.dd') as 'OrderDate',
    FORMAT(dtShippedDate,'yyyy.MM.dd') 'ShippedDate',
    FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastFedFROMSOP',
    ixTimeLastSOPUpdate
FROM tblOrder O
    left join tblBusinessUnit BU on O.ixBusinessUnit = BU.ixBusinessUnit
WHERE sSourceCodeGiven = 'AMAZONFBA'
--and O.ixBusinessUnit <> 109
order by sOrderStatus
/*              Order                           LastFed
ixOrder	BU 	    Status	OrderDate	ShippedDate	FROMSOP	    TimeLastSOPUpdate
9422815	PHONE	Shipped	2020.03.20	2020.03.23	2020.03.23	46863
9422816	PHONE	Shipped	2020.03.20	2020.03.23	2020.03.23	46864
*/
select ixOrder, sSourceCodeGiven, ixBusinessUnit
FROM tblOrder
WHERE ixOrder in ('9656907','9665904','9813101')

SELECT BU.sBusinessUnit 'BU   ', count(*) 'OrderCnt'
FROM tblOrder O
    left join tblBusinessUnit BU on O.ixBusinessUnit = BU.ixBusinessUnit
WHERE sOrderStatus = 'Cancelled'--sSourceCodeGiven = 'AMAZONFBA' --and ixBusinessUnit 
group by BU.sBusinessUnit
order by BU.sBusinessUnit





select ixOrder FROM tblOrder WHERE sSourceCodeGiven = 'AMAZONFBA' 
