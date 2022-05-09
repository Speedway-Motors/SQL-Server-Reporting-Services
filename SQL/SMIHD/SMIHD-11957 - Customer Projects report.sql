-- SMIHD-11957 - Customer Projects report

/* Per Ron, 
    tblCustomerProject is populated weekly by tng
    "It currently wipes everything out and reloads it."
    There is a create/update time on the original table -- need to add a date/time stamp to tblCustomerProject (create date NOT SOPUpdate)
    Re: ixWeakCustomer "Should be to sop customer. Week just means no FK."


from Pat Orth:
    create a report based on the information Don Romisch is inputting into SMInet
    have the customer number and the customer's info on their vehicle/project.
    recipients: Jesse Cowles, Josh Sullivan, Jeff Karls, Greg Nicol, Pat Orth

*/


SELECT ixCustomerProject,
    ixWeakCustomer 'Customer', -- ixWeakCustomer "sop customer. Week just means no FK."
    sDescription 'ProjDescription',
    iVehicleYear 'Year',
    sVehicleMakeName 'Make',
    sVehicleModelName 'Model',
    sSanctioningBody 'SanctioningBody',
    sChassisName 'Chassis',
    sEngineFamilyName 'EngineFamily',
    sEngineSubFamilyName 'EngineSubFamily',
    sTransmissionFamilyName 'TransmissionFamily',
    sRearAxleFamilyName 'RearAxleFamily'
from tblCustomerProject CP
    left join tblCustomer C on CP.ixWeakCustomer = C.ixCustomer
where C.ixCustomer is NOT NULL
    and C.flgDeletedFromSOP = 0
order by ixCustomerProject desc

select count(distinct ixCustomerProject) from tblCustomerProject -- 65,075



select distinct sVehicleMakeName, sVehicleModelName, count(*) -- iVehicleYear, 
from tblCustomerProject
group by sVehicleMakeName, sVehicleModelName -- iVehicleYear,
order by-- sVehicleMakeName, sVehicleModelName--, 
    count(*) desc



SELECT distinct ixWeakCustomer, iVehicleYear, sVehicleMakeName, sVehicleModelName -- 64,073    61,887 unique
from tblCustomerProject
select 

SELECT distinct ixWeakCustomer -- 52,135
from tblCustomerProject CP
join tblCustomer C on CP.ixWeakCustomer = C.ixCustomer -- 52,135   481
where C.flgDeletedFromSOP = 0                          -- 481 counts were merged



SELECT ixWeakCustomer, count(CP.ixCustomerProject) -- 52,135
from tblCustomerProject CP
join tblCustomer C on CP.ixWeakCustomer = C.ixCustomer -- 52,135   481
where C.flgDeletedFromSOP = 0  
group by ixWeakCustomer
having count(CP.ixCustomerProject) > 1
order by count(CP.ixCustomerProject) desc



select ixBrand, ixProductLine from tblSKU where ixSKU = '1011001403'

select * from tblBrand where ixBrand = '10114'
select * from tblProductLine where ixProductLine = '2429'
