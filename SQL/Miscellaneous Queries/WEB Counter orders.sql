-- WEB Counter orders

select iShipMethod, sOrderChannel, sOrderTaker, sOrderType, 
    CONVERT(VARCHAR,dtOrderDate, 1) AS 'OrderDate', ixOrder, sWebOrderID,  sShipToCOLine, sShipToStreetAddress1, sOrderStatus
from tblOrder 
where dtOrderDate >= '05/13/2018'  -- went live 05/10
and sOrderChannel = 'WEB' -- NOT IN ('COUNTER', 'PHONE')
AND iShipMethod = 1
and ixOrder NOT LIKE 'Q%'
and ixOrder NOT LIKE 'P%'
order by dtOrderDate, sOrderTaker


select ixOrder, sOrderChannel
from tblOrder 
where dtOrderDate = '05/10/2018'
    AND sOrderChannel = 'WEB'
AND iShipMethod = 1
order by sShipToStreetAddress1

select iShipMethod, count(*) 
from tblOrder
where ixOrder like 'Q%'
and dtOrderDate >= '05/01/2018'
group by iShipMethod



select iShipMethod, count(ixOrder) 'Orders' --, sOrderChannel, sOrderTaker, sOrderType, iShipMethod, sShipToStreetAddress1
from tblOrder 
where dtOrderDate = '05/10/2018'
    AND sOrderChannel = 'WEB'
    AND ixOrder NOT LIKE 'Q%'
    AND ixOrder NOT LIKE 'P%'
GROUP BY iShipMethod
order by iShipMethod


select sOrderChannel, count(ixOrder) 'Orders' --, sOrderChannel, sOrderTaker, sOrderType, iShipMethod, sShipToStreetAddress1
from tblOrder 
where dtOrderDate = '05/10/2018'
    AND iShipMethod = 1
    AND ixOrder NOT LIKE 'Q%'
    AND ixOrder NOT LIKE 'P%'
GROUP BY sOrderChannel
order by sOrderChannel


select *
from tblOrder 
where dtOrderDate = '05/10/2018'
    AND sOrderChannel = 'WEB'
    and iShipMethod is NULL

select * from tblShipMethod




SELECT * FROM tblOrder where sWebOrderID in ('E2156910','E2156911','E2156927')

select sWebOrderID, ixOrder, sOrderChannel, iShipMethod
from tblOrder 
where dtOrderDate = '05/10/2018'
    AND sOrderChannel = 'WEB'
    and sWebOrderID LIKE 'E21569%'
order by iShipMethod

SELECT * FROM tblEmployee
where flgCurrentEmployee = 1 and sLastname in ('BEASLEY','STEWART','HENNING')

Beasley – not a current employee
Philip Stewart – Properties
Kent Henning – Properties but a salaried employee

/*
CBB147	BEASLEY	CHRISTOPHER	68	1
KEH	    HENNING	KENT	    90	1
PJS	    STEWART	PHILIP	    90	1
*/

SELECT E.ixEmployee, E.sLastname, E.sFirstname, E.ixDepartment, D.sDescription
FROM tblEmployee E
    left join tblDepartment D on E.ixDepartment = D.ixDepartment
where flgCurrentEmployee =1
    and E.ixDepartment in (9,90)
order by E.ixDepartment, ixEmployee

