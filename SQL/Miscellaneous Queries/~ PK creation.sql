/* 
Table          PK created
=============  ==========
*/


select count(*)                  from tblVendor
select count(distinct ixVendor)  from tblVendor
select *                         from tblVendor where ixVendor is NULL

select count(*)                     from tblDepartment
select count(distinct ixDepartment) from tblDepartment
select *                            from tblVendor where ixVendor is NULL

select count(*)                  from tblCatalogMaster
select count(distinct ixCatalog) from tblCatalogMaster
select *                         from tblCatalogMaster where ixCatalog is NULL


-- VERIFY AND CODE FOR CURRENT EXISTING COLLATION!!!!!!
ALTER TABLE tblCatalogMaster ALTER COLUMN ixCatalog Varchar(10) NOT NULL


select count(*) from tblOrderLine where dtOrderDate < '01/01/2008'  -- 10.3m out of 16M total   64%
select count(*) from tblOrder where dtOrderDate < '01/01/2008'      --  2.7m out of  4M total   67%
/******************* REMAINING ************************************/
ALTER TABLE tblOrderLine ADD PRIMARY KEY (ixOrder,ixOrdinality);
ALTER TABLE tblSKUTransaction ADD PRIMARY KEY (ixSKU, sTransactionType,iSeq,ixDate,ixTime);
/*******************************************************************/


ALTER TABLE tblSKULocation
  ADD CONSTRAINT FK_INV_NO_REFERENCE
  FOREIGN KEY(IM_INV_NO, DEPARTMENT_CODE)

ALTER TABLE tblSKUTransaction
   


SELECT * FROM tblVendor V
      join tblVendorSKU VS on V.ixVendor = VS.ixVendor

SELECT * FROM tblCatalogMaster CM
      join tblCatalogDetail CD on CD.ixCatalog = CM.ixCatalog





/* Employee */
select *
into tblEmployeeTEMP
from tblEmployee

select * from tblEmployeeTEMP
-- save scripts for index to re-run after rebuilding table
drop table tblEmployee 

select * into tblEmployee
from tblEmployeeTEMP

ALTER TABLE tblEmployee ALTER COLUMN ixEmployee
            varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 

select * from tblEmployee E
join tblJobClock JC on JC.ixEmployee = E.ixEmployee


/* Vendor */
select *
into tblVendorTEMP
from tblVendor

select * from tblVendorTEMP

-- save scripts for index to re-run after rebuilding table
drop table tblVendor 

select * into tblVendor
from tblVendorTEMP

ALTER TABLE tblVendor ALTER COLUMN ixVendor
            varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 

select * from tblVendor V
join tblVendorSKU VS on VS.ixVendor = V.ixVendor

/* Department */
select *
into tblDepartmentTEMP
from tblDepartment

select * from tblDepartmentTEMP

-- save scripts for index to re-run after rebuilding table
drop table tblDepartment 

select * into tblDepartment
from tblDepartmentTEMP

ALTER TABLE tblDepartment ALTER COLUMN ixDepartment
            varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 

select * from tblDepartment D
join tblEmployee E on E.ixDepartment = D.ixDepartment


/* CatalogMaster */
select *
into tblCatalogMasterTEMP
from tblCatalogMaster

select * from tblCatalogMasterTEMP

-- save scripts for index to re-run after rebuilding table
drop table tblCatalogMaster 

select * into tblCatalogMaster
from tblCatalogMasterTEMP

ALTER TABLE tblCatalogMaster ALTER COLUMN ixCatalog
            varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 

select * from tblCatalogMaster CM
join tblCatalogDetail CD on CD.ixCatalog = CM.ixCatalog



