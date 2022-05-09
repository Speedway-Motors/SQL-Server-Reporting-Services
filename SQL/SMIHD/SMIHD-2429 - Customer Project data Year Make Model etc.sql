-- SMIHD-2429 Customer Project data Year Make Model etc
-- DATA FROM TNG
select *
from tblcustomerproject CP -- 29,937
  left join tblvehicle_make MK ON MK.ixVehicleMake = CP.ixMake
  left join tblvehicle_model MD ON MD.ixVehicleModel = CP.ixModel
  left join tblvehicle_year YR ON CP.ixCustomerProject = YR.ixVehicleYear
  left join tblchassis CH ON CH.ixChassis = CP.ixChassis
  left join tblvehicle_model_type MT ON MT.ixVehicleModelType = MD.ixVehicleModelType 
  left join tblsanctioning_body SB ON SB.ixSanctioningBody = CP.ixSanctioningBody 
  


/*
Year	Make	Model	Customer Count
1969	Chevrolet	Camaro	550
1968	Chevrolet	Camaro	400
	
*/
select 
  ixYear 'Year',
  sVehicleMakeName 'Make',
  sVehicleModelName 'Model',
  count(CP.ixCustomerProject) 'ProjectCount' -- count(distinct CP.ixWebUser)
from tblcustomerproject CP -- 29,937
  left join tblvehicle_make MK ON MK.ixVehicleMake = CP.ixMake
  left join tblvehicle_model MD ON MD.ixVehicleModel = CP.ixModel
  left join tblvehicle_year YR ON CP.ixCustomerProject = YR.ixVehicleYear
  left join tblchassis CH ON CH.ixChassis = CP.ixChassis
group by ixYear, sVehicleMakeName, sVehicleModelName
order by count(CP.ixCustomerProject) desc -- count(distinct CP.ixWebUser)




/*
			
Type	Chassis	Series	Customer Count
Midget	Spike	POWRi	320
Sprint Car		ASCS	7,000
Modified	Harris		
*/

select sName 'Type', sChassisName 'Chassis', sSanctioningBody 'Series',
count(CP.ixCustomerProject) 'ProjectCount'
from tblcustomerproject CP -- 29,937
  left join tblvehicle_make MK ON MK.ixVehicleMake = CP.ixMake
  left join tblvehicle_model MD ON MD.ixVehicleModel = CP.ixModel
  left join tblvehicle_year YR ON CP.ixCustomerProject = YR.ixVehicleYear
  left join tblchassis CH ON CH.ixChassis = CP.ixChassis
  left join tblvehicle_model_type MT ON MT.ixVehicleModelType = MD.ixVehicleModelType 
  left join tblsanctioning_body SB ON SB.ixSanctioningBody = CP.ixSanctioningBody 
-- where CH.sChassisName is NOT NULL  -- = 'Spike' 
group by sName, sChassisName, sSanctioningBody
order by count(CP.ixCustomerProject) desc
  
  
  