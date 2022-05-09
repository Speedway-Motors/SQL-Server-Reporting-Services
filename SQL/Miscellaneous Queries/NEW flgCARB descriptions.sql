-- NEW flgCARB descriptions
CASE WHEN flgCARB = 0 THEN 'NoCB'
    WHEN flgCARB = 1 THEN 'CARB'
    WHEN flgCARB = 2 THEN 'DEAD'
    WHEN flgCARB = 3 THEN 'OEM'
    WHEN flgCARB = 4 THEN 'NSAL'
    WHEN flgCARB = 99 THEN 'NEW'
    WHEN flgCARB is NULL THEN 'Not Reviewed'
    ELSE '?'
END


SELECT DISTINCT  flgCARB, (CASE WHEN flgCARB = 0 THEN 'NoCB'
            WHEN flgCARB = 1 THEN 'CARB'
            WHEN flgCARB = 2 THEN 'DEAD'
            WHEN flgCARB = 3 THEN 'OEM'
            WHEN flgCARB = 4 THEN 'NSAL'
            WHEN flgCARB = 99 THEN 'NEW'
            WHEN flgCARB is NULL THEN 'Not Reviewed'
         ELSE '?'
         END) 'flgCARB'
FROM tblSKU
where flgDeletedFromSOP = 0
/*
NULL = Not Reviewed
0 = NoCB
1 = CARB
2 = DEAD
3 = OEM (Orig Eqpmnt Manufctr)
4 = NSAL (No Sales to CA)
99 = NEW
*/
