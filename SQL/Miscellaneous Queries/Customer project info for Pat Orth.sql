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


select top 100 *
from tblCustomerProject
order by ixCustomerProject desc



select distinct iVehicleYear, sVehicleMakeName, sVehicleModelName, count(*)
from tblCustomerProject
group by iVehicleYear, sVehicleMakeName, sVehicleModelName
order by count(*) desc --iVehicleYear, sVehicleMakeName, sVehicleModelName



SELECT distinct ixWeakCustomer, iVehicleYear, sVehicleMakeName, sVehicleModelName -- 64,073    61,887 unique
from tblCustomerProject
select 

SELECT distinct ixWeakCustomer -- 52,135
from tblCustomerProject CP
join tblCustomer C on CP.ixWeakCustomer = C.ixCustomer -- 52,135   481
where C.flgDeletedFromSOP = 0                          -- 481 counts were merged




select ixBrand, ixProductLine from tblSKU where ixSKU = '1011001403'

select * from tblBrand where ixBrand = '10114'
select * from tblProductLine where ixProductLine = '2429'
