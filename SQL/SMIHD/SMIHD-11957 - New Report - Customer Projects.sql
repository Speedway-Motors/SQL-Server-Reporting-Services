-- SMIHD-11957 - New Report - Customer Projects

select top 10 * from [dbo].[tblCustomerProject]
select top 10 * from tng.tblcustomerproject -- tng version
select top 10 * from tng.tblvehicle_make -- tng version
select top 10 * from tng.tblvehicle_model -- tng version
select top 10 * from tng.tblengine_subfamily
select top 10 * from tng.tblwebuser



    select
        --CP.ixWebUser,
        WU.ixSopCustomer,
        dtCreate 'ProjCreateDate',
        dtUpdate 'ProjUpdate',
        --CP.ixCustomerProject,
        --ixWeakCustomer 'Customer', -- ixWeakCustomer "sop customer. Week just means no FK."
        CP.sDescription 'ProjDescription',
        CP.sName,
        CP.ixYear 'Year',
        VMK.sVehicleMakeName 'Make',
        VMD.sVehicleModelName 'Model',
        SB.sSanctioningBody 'SanctioningBody',
        C.sChassisName 'Chassis',
        EF.sEngineFamilyName 'EngineFamily',
        ESF.sEngineSubfamilyName 'EngineSubFamily',
        TF.sTransmissionFamilyName 'TransmissionFamily',
        RAF.sRearAxleFamily 'RearAxleFamily'
    from tng.tblcustomerproject CP
        --left join tng.tblcus
        left join tng.tblvehicle_make VMK  on CP.ixMake = VMK.ixVehicleMake
        left join tng.tblvehicle_model VMD  on CP.ixModel= VMD.ixVehicleModel
        left join tng.tblsanctioning_body SB on SB.ixSanctioningBody = CP.ixSanctioningBody
        left join tng.tblchassis C on C.ixChassis = CP.ixChassis
        left join tng.tblengine_subfamily ESF on ESF.ixEngineSubfamily = CP.ixEngineSubFamily
        left join tng.tblengine_family EF on EF.ixEngineFamily = ESF.ixEngineFamily
        left join tng.tbltransmission_family TF on TF.ixTransmissionFamily = CP.ixTransmissionFamily
        left join tng.tblrearaxle_family RAF on RAF.ixRearAxleFamily = CP.ixRearAxleFamily
        left join tng.tblwebuser WU on WU.ixWebUser = CP.ixWebUser
    -- where convert(varchar, dtCreate, 101) between '09/01/2018' and '09/30/2018'
    --    OR convert(varchar, dtUpdate, 101) between '09/01/2018' and '09/30/2018'
    where dtUpdate between '09/01/2018' and '09/30/2018' -- the update date will always be >= the create date
        /*
        and CP.ixSanctioningBody is NOT NULL
        and CP.ixRearAxleFamily is NOT NULL
        and CP.ixChassis is NOT NULL
        and CP.ixEngineSubFamily is NOT NULL
        and CP.ixMake is NOT NULL
        and CP.ixModel is NOT NULL
        and CP.sDescription is NOT NULL
        */
    order by dtUpdate desc -- CP.ixCustomerProject desc


 ixCustomerProject,
    ixWeakCustomer 'Customer', -- ixWeakCustomer "sop customer. Week just means no FK."
    sDescription 'ProjDescription',
    sName,
    iVehicleYear 'Year',
    --sVehicleMakeName 'Make',
    --sVehicleModelName 'Model',
    --sSanctioningBody 'SanctioningBody',
    --sChassisName 'Chassis',
    sEngineFamilyName 'EngineFamily',
    --sEngineSubFamilyName 'EngineSubFamily',
    --sTransmissionFamilyName 'TransmissionFamily',
    --sRearAxleFamilyName 'RearAxleFamily'



select * from tblCustomerProject;  -- Smi Reporting
select top 10 * from tng.tblcustomerproject -- tng version

select top 10 * from tng.tblvehicle_make

dtAwsTransferTimeUtc	    dtAwsQueueDateTimeUtc
2018-10-29 07:10:50.257	    2018-10-29 07:00:14.910



select ixCustomerProject,
    -- Customer#
    sDescription 'ProjDescription',
    convert(varchar, dtCreate, 101) 'ProjCreateDate',
    convert(varchar, dtUpdate, 101) 'ProjUpdate'

from tng.tblcustomerproject
where --convert(varchar, dtCreate, 101) between '10/26/2018' and  '10/26/2018' -- 46
   -- OR
      convert(varchar, dtUpdate, 101) between '10/26/2018' and  '10/26/2018' -- 57
ORDER BY ixCustomerProject DESC

68078

ixCustomerProject

 (varchar, getdate(), 101)