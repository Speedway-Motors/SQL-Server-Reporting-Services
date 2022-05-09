-- Get all existing indexes, but NOT the primary keys
DECLARE cIX CURSOR FOR
   SELECT OBJECT_NAME(SI.Object_ID), SI.Object_ID, SI.Name, SI.Index_ID
      FROM sys.indexes SI 
         LEFT JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS TC ON SI.Name = TC.CONSTRAINT_NAME AND OBJECT_NAME(SI.Object_ID) = TC.TABLE_NAME
      WHERE TC.CONSTRAINT_NAME IS NULL
         AND OBJECTPROPERTY(SI.Object_ID, 'IsUserTable') = 1
      ORDER BY OBJECT_NAME(SI.Object_ID), SI.Index_ID

DECLARE @IxTable sysname
DECLARE @IxTableID INT
DECLARE @IxName sysname
DECLARE @IxID INT

-- Loop through all indexes
OPEN cIX
FETCH NEXT FROM cIX INTO @IxTable, @IxTableID, @IxName, @IxID
WHILE (@@FETCH_STATUS = 0)
BEGIN
   DECLARE @IXSQL NVARCHAR(4000) 
--SET @PKSQL = ''
   SET @IXSQL = 'CREATE '

   -- Check if the index is unique
   IF (INDEXPROPERTY(@IxTableID, @IxName, 'IsUnique') = 1)
      SET @IXSQL = @IXSQL + 'UNIQUE '
   -- Check if the index is clustered
   IF (INDEXPROPERTY(@IxTableID, @IxName, 'IsClustered') = 1)
      SET @IXSQL = @IXSQL + 'CLUSTERED '

   SET @IXSQL = @IXSQL + 'INDEX ' + @IxName + ' ON [' + @IxTable + '] ('

   -- Get all columns of the index
   DECLARE cIxColumn CURSOR FOR 
      SELECT SC.Name,IC.[is_included_column],IC.is_descending_key 
      FROM sys.index_columns IC
         JOIN sys.columns SC ON IC.Object_ID = SC.Object_ID AND IC.Column_ID = SC.Column_ID
      WHERE IC.Object_ID = @IxTableID AND Index_ID = @IxID
      ORDER BY IC.Index_Column_ID,IC.is_included_column

   DECLARE @IxColumn sysname
   DECLARE @IxIncl bit
   DECLARE @Desc bit
   DECLARE @IxIsIncl bit set @IxIsIncl = 0
   DECLARE @IxFirstColumn BIT SET @IxFirstColumn = 1

   -- Loop throug all columns of the index and append them to the CREATE statement
   OPEN cIxColumn
   FETCH NEXT FROM cIxColumn INTO @IxColumn, @IxIncl, @Desc
   WHILE (@@FETCH_STATUS = 0)
   BEGIN

      IF (@IxFirstColumn = 1)
                BEGIN
         SET @IxFirstColumn = 0
                END
      ELSE
                BEGIN
                        --check to see if it's an included column
                        IF ((@IxIsIncl = 0) AND (@IxIncl = 1))
                        BEGIN
                         SET @IxIsIncl = 1
                         SET @IXSQL = @IXSQL + ') INCLUDE ('
                        END
                        ELSE
                        BEGIN
                         SET @IXSQL = @IXSQL + ', '
                        END
                END

      SET @IXSQL = @IXSQL + '[' + @IxColumn + ']'
                --check to see if it's DESC
                IF @Desc = 1
                        SET @IXSQL = @IXSQL + ' DESC'

      FETCH NEXT FROM cIxColumn INTO @IxColumn, @IxIncl, @Desc
   END
   CLOSE cIxColumn
   DEALLOCATE cIxColumn

   SET @IXSQL = @IXSQL + ')'
   -- Print out the CREATE statement for the index
   PRINT @IXSQL

   FETCH NEXT FROM cIX INTO @IxTable, @IxTableID, @IxName, @IxID
END

CLOSE cIX
DEALLOCATE cIX

-- DEALLOCATE  cIX