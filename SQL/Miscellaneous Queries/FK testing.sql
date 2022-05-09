SELECT
      fk.name AS ForeignKey,OBJECT_NAME(fk.parent_object_id) AS TableName
     ,c.name AS ColumnName,OBJECT_NAME(fk.referenced_object_id) AS ReferencedTableName
     ,rc.name AS ReferencedColumnName
  FROM    sys.foreign_keys AS fk
  INNER JOIN sys.foreign_key_columns AS fc
  ON  fk.object_id = fc.constraint_object_id
  INNER JOIN sys.columns AS c
  ON  fc.parent_object_id = c.object_id
      AND fc.parent_column_id = c.column_id
  INNER JOIN sys.columns AS rc
  ON  fc.referenced_object_id = rc.object_id
      AND fc.referenced_column_id = rc.column_id




select top 100 *
into PJC_tblOrder_FKTest
from tblOrder
where dtShippedDate > '01/01/2011'
order by newID()
-- SELECT * FROM PJC_tblOrder_FKTest

select *
into PJC_tblOrderLine_FKTest
from tblOrderLine
where ixOrder in (select ixOrder from PJC_tblOrder_FKTest)



 ALTER TABLE PJC_tblOrderLine_FKTest
 ADD CONSTRAINT FK_ixOrder
 FOREIGN KEY (ixOrder) REFERENCES PJC_tblOrder_FKTest (ixOrder)



insert into PJC_tblOrderLine_FKTest
select '4889700',
NULL,NULL,NULL,
NULL,NULL,NULL,
NULL,NULL,NULL,
NULL,NULL,NULL,
NULL,99,NULL,
NULL,NULL


select * from PJC_tblOrderLine_FKTest where ixOrder = '4889700'