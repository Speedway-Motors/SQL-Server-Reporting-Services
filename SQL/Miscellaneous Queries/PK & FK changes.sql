ALTER TABLE tblPromotionalInventory ADD PRIMARY KEY (ixSKU)  -- comma separate columns if making a Composite PK. 

SELECT name  
FROM sysobjects  
WHERE id IN ( SELECT id FROM syscolumns WHERE upper(name) = 'IXSTATE' ) 
ORDER BY name 


ALTER TABLE EmergencyContact
3> ADD CONSTRAINT FK_EmergencyContact_Employee
4> FOREIGN KEY (EID)
5> REFERENCES Employee (ID)




ALTER TABLE tblBrand                ADD PRIMARY KEY (ixBrand)
ALTER TABLE tblCustomer             ADD PRIMARY KEY (ixCustomer)
ALTER TABLE tblCustomer             ADD PRIMARY KEY (ixCustomer)
ALTER TABLE tblCustomer             ADD PRIMARY KEY (ixCustomer)
ALTER TABLE tblCustomerOffer        ADD PRIMARY KEY (ixCustomer,ixCustomerOffer)
ALTER TABLE tblCustomerOffer        ADD PRIMARY KEY (ixCustomer,ixCustomerOffer)
ALTER TABLE tblDate                 ADD PRIMARY KEY (ixDate)
ALTER TABLE tblDropship             ADD PRIMARY KEY (ixDropship)
ALTER TABLE tblPromoCodeDetail      ADD PRIMARY KEY (ixCustomer)
ALTER TABLE tblPromoCodeMaster      ADD PRIMARY KEY (ixCustomer)
ALTER TABLE tblPromotionalInventory ADD PRIMARY KEY (ixSKU) 
ALTER TABLE tblReceivingWorksheet   ADD PRIMARY KEY (ixReceivingWorksheet)
ALTER TABLE tblReceiver             ADD PRIMARY KEY (ixReceiver)
ALTER TABLE tblSnapAdjustedMonthlySKUSales   ADD PRIMARY KEY (ixSKU,  iYearMonth)
ALTER TABLE tblSourceCode           ADD PRIMARY KEY (ixSourceCode)
ALTER TABLE tblStates               ADD PRIMARY KEY (ixStateid)
ALTER TABLE tblCatalogDetail        ADD PRIMARY KEY (ixCatalog, ixSKU)
ALTER TABLE tblCatalogMaster        ADD PRIMARY KEY (ixCatalog)
ALTER TABLE tblVendor               ADD PRIMARY KEY (ixVendor)

ALTER TABLE tblTime                 ADD PRIMARY KEY (ixTime)
ALTER TABLE tblTime                 ADD PRIMARY KEY (ixTime)
ALTER TABLE tblTime                 ADD PRIMARY KEY (ixTime)
ALTER TABLE tblTime                 ADD PRIMARY KEY (ixTime)
ALTER TABLE tblTime                 ADD PRIMARY KEY (ixTime)


select ixCatalog, ixSKU, count(*)
from tblCatalogDetail
group by ixCatalog, ixSKU
having count(*) > 1

set rowcount 0

delete from tblCatalogDetail
where ixCatalog = 'PRS'
and ixSKU = '91673059-44'

select * from tblPOMaster where ixPO = '73584'


select ixState, count(*)
from tblStates
group by ixState
having count(*) > 1

select * from tblStates where ixState = 'AE'

select ixState, count(*)
from tblZipCode where ixState like 'AE%' 
group by ixState

select * from tblInsert

select max(len(ixKitSKU))
from tblKit