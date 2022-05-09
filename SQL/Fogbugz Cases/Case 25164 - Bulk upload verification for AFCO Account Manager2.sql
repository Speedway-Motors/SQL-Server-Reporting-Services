-- Case 25164 - Bulk upload verification for AFCO Account Manager2

-- run this check after AL updates them in SOP to make sure everything matches.

select * from PJC_25164_AFCO_AccountManager2ValuesToLoad

select AM2.*,ixAccountManager2 'CurrentAM2' -- 709
from PJC_25164_AFCO_AccountManager2ValuesToLoad AM2
left join [AFCOReporting].dbo.tblCustomer C on AM2.ixCustomer = C.ixCustomer
where AM2.LoadAM2 =C.ixAccountManager2
  or C.ixAccountManager2 is NULL
  
  
  
