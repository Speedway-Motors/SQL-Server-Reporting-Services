SELECT * --8580 ROWS
FROM dbo.ASC_SweepstakesEntrants
WHERE flgMatchingPhone IS NULL 
 AND flgMatchingEmail IS NULL 
 AND sMatchbackCustomer IS NULL

SELECT * --941 ROWS
FROM dbo.ASC_SweepstakesEntrants
WHERE flgMatchingPhone IS NOT NULL 
 AND flgMatchingEmail IS NULL 
-- AND sMatchbackCustomer IS NULL
ORDER BY flgOrderedWithin48MO DESC

SELECT * --4808 ROWS
FROM dbo.ASC_SweepstakesEntrants
WHERE flgMatchingPhone IS NULL 
 AND flgMatchingEmail IS NOT NULL 
-- AND sMatchbackCustomer IS NULL
ORDER BY flgOrderedWithin48MO DESC

SELECT * --7613 ROWS
FROM dbo.ASC_SweepstakesEntrants
WHERE flgMatchingPhone IS NOT NULL 
 AND flgMatchingEmail IS NOT NULL 
-- AND sMatchbackCustomer IS NULL
ORDER BY flgOrderedWithin48MO DESC


-- ALL 
SELECT * 
FROM dbo.ASC_SweepstakesEntrants
ORDER BY flgOrderedWithin48MO DESC
