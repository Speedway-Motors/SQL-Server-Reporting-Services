SELECT
    FK.TABLE_NAME       'K_Table',
    CU.COLUMN_NAME      'FK_Column',
    PK.TABLE_NAME       'PK_Table',
    PT.COLUMN_NAME      'PK_Column',
    C.CONSTRAINT_NAME   'Constraint_Name'
FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS C
    INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS FK ON C.CONSTRAINT_NAME = FK.CONSTRAINT_NAME
    INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS PK ON C.UNIQUE_CONSTRAINT_NAME = PK.CONSTRAINT_NAME
    INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE CU ON C.CONSTRAINT_NAME = CU.CONSTRAINT_NAME
    INNER JOIN (SELECT i1.TABLE_NAME, i2.COLUMN_NAME
                FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS i1
                INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE i2 ON i1.CONSTRAINT_NAME = i2.CONSTRAINT_NAME
                WHERE i1.CONSTRAINT_TYPE = 'PRIMARY KEY'
                ) PT ON PT.TABLE_NAME = PK.TABLE_NAME
---- optional:
--WHERE PK.TABLE_NAME='something'
--WHERE FK.TABLE_NAME='something'
--WHERE PK.TABLE_NAME IN ('one_thing', 'another')
--WHERE FK.TABLE_NAME IN ('one_thing', 'another')
ORDER BY
1,2,3,4
