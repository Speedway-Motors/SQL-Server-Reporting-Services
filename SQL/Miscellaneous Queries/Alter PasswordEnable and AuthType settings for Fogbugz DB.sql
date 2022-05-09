-- Alter PasswordEnable and AuthType settings for Fogbugz DB
SELECT * 
FROM Setting
WHERE sKey in('fPasswordEnable','iAuthType')
/*    BEFORE UPDATES 
ixSetting	sKey			sValue
14			fPasswordEnable	0
46			iAuthType		1
*/

--UPDATE Setting SET sValue = '0' WHERE sKey = 'fPasswordEnable';    <-- WAS ALREADY SET TO 0
UPDATE Setting SET sValue = '0' WHERE sKey = 'iAuthType';

SELECT * 
FROM Setting
WHERE sKey in('fPasswordEnable','iAuthType')
/*   AFTER UPDATES 
ixSetting	sKey			sValue
14			fPasswordEnable	0
46			iAuthType		0
*/



