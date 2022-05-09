-- verify the value does not already exist before inserting 
SELECT * 
FROM tblapplication
WHERE UPPER(sApplicationValue) LIKE '%ZEPH%';

-- insert the value into the table. the ixApplication is auto incrementing and therefore does not need to be specified 
INSERT INTO tblapplication (sApplicationValue, sApplicationGroup) 
VALUES ('1974-76 Ford Elite', 'Cars'); 

INSERT INTO tblapplication (sApplicationValue, sApplicationGroup) 
VALUES ('1967-70 Mercury Cougar', 'Cars'); 

INSERT INTO tblapplication (sApplicationValue, sApplicationGroup) 
VALUES ('1968-69 Mercury Montego', 'Cars'); 

INSERT INTO tblapplication (sApplicationValue, sApplicationGroup) 
VALUES ('1978 Mercury Zephyr', 'Cars'); 

INSERT INTO tblapplication (sApplicationValue, sApplicationGroup) 
VALUES ('1973-74 Buick Apollo', 'Cars'); 

INSERT INTO tblapplication (sApplicationValue, sApplicationGroup) 
VALUES ('1968-74 Chevy Concours', 'Cars'); 


SELECT * 
FROM tblapplication
ORDER BY ixApplication DESC;
