-- SMIHD-4881 - research why BOX SKUs are throwing SQL errors

-- CAUSE/SOLUTION - All of the errors were due to Scott Harrifeld trying to issue POs. He did not have execute privileges on SMI Reporting. He does now.



-- tblSKU Errors for BOX SKUs 

    SELECT *      
    from tblErrorLogMaster
    where dtDate >=  '06/01/2016' --DATEADD(month, -1, getdate()) -- past X months
        and ixErrorCode = 1163   
        and sError like '%BOX-%'     
        
    SELECT *      
    from tblErrorLogMaster
    where sUser = 'SAHARRIFELD'
        
SELECT  sUser, COUNT(*)
    from tblErrorLogMaster
    GROUP BY sUser
    ORDER BY COUNT(*) desc
    
    

    
SELECT * FROM tblErrorCode        
       
SELECT D.dtDate, E.sFirstname, E.sLastname, ST.ixSKU, ST.iQty, ST.sTransactionType, ST.sTransactionInfo 
,ST.sUser--, ST.*
from tblSKUTransaction ST
JOIN tblDate D on ST.ixDate = D.ixDate
JOIN tblEmployee E on ST.sUser = E.ixEmployee
where ixSKU like '%BOX-1%'
and D.dtDate >= '06/01/2016'
and ST.sUser = 'SAH'
ORDER BY D.dtDate

/*
17690	BPH	QC	INV ADJ
17700	SAH	P	B0403
17701	DNL	R	194296*B0403
17701	DNL	R	194296*B0403
17701	DNL	R	194296*B0403
17701	JLW	T	Cid Putaway
17701	JLW	T	Cid Putaway
17701	JLW	T	Cid Putaway
17701	JLW	T	Putaway
17701	JLW	T	Putaway
17701	DNL	PQRUP	194296
17705	LMV	T	Putaway
17711	BPH	QC	INV ADJ
*/
ixDate	sUser	sTransactionType	sTransactionInfo
17690	BPH	QC	INV ADJ
17700	SAH	P	B0403
17701	DNL	R	194296*B0403
17701	DNL	R	194296*B0403
17701	DNL	R	194296*B0403
17701	JLW	T	Cid Putaway
17701	JLW	T	Cid Putaway
17701	JLW	T	Cid Putaway
17701	JLW	T	Putaway
17701	JLW	T	Putaway
17701	DNL	PQRUP	194296
17705	LMV	T	Putaway
17711	BPH	QC	INV ADJ

SELECT * from tblTransactionType

SELECT * from tblPOMaster
where ixIssuer = 'SAH'
OR ixBuyer = 'SAH'
ORDER BY ixPODate