CREATE TABLE PJC_DUPES_TEST (sFirstName varchar (30), sLastName varchar (30))
-- DROP TABLE PJC_DUPES_TEST
GO
INSERT INTO PJC_DUPES_TEST
SELECT 'Joe', 'Momma'
UNION ALL
SELECT 'Nunya', 'Business' 
UNION ALL
SELECT 'Johnny', 'Blaze' 
UNION ALL
SELECT 'Clark', 'Savage'
UNION ALL
SELECT 'Joe', 'Momma' --duplicate
UNION ALL
SELECT 'Johnny', 'Blaze' --duplicate
GO
select * from PJC_DUPES_TEST order by sFirstName
/*
sFirstName	sLastName
Clark	      Savage
Joe	      Momma
Joe	      Momma
Johnny	   Blaze
Johnny	   Blaze
Nunya	      Business
*/

/* Delete Duplicate records */
WITH CTE (sFirstName,sLastName, DuplicateCount)
AS
(
SELECT sFirstName,sLastName,
ROW_NUMBER() OVER(PARTITION BY sFirstName,sLastName ORDER BY sFirstName) AS DuplicateCount
FROM PJC_DUPES_TEST
)
DELETE
FROM CTE
WHERE DuplicateCount > 1

select * from PJC_DUPES_TEST order by sFirstName
/*
sFirstName	sLastName
Clark	      Savage
Joe	      Momma
Johnny	   Blaze
Nunya	      Business
*/