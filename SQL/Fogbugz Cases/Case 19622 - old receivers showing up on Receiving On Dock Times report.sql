-- Case 19622 - old receivers showing up on Receiving On Dock Times report


select * from tblReceiver 
where ixReceiver in 
    ('9752','9953','9998','10056','10520','10753','10967','11099','11330','11581',
    '11596','11616','11617','11657','11841','11848','11875','11891','12055','12107',
    '12708','12901','13136','13771','14022','14540')
    
    


select * from tblPOMaster where ixPO in 
    ('10022','10079','10279','10462','10650','10773','10932','11081','11246','11307',
    '11321','11324','11404','11463','11506','11632','11669','11780','12551','12776',
    '13096','13422','13518','7980','9074','9997')    
    
    
select count(*) from tblReceiver    --  23,147              6,693
select count(*) from tblReceiver where   ixLastUpdateDate < 16128 -- 16,453




  select * 
into [AFCOTemp].dbo.tblReciever_BU08192013
from tblReceiver

-- drop table [AFCOTemp].dbo.tblReciever_BU08192013 


SELECT count(*) from tblReceiver where dtDateLastSOPUpdate is NULL
SELECT count(*) from tblReceiver where dtDateLastSOPUpdate is NOT NULL

-- update tblReceiver set flgDeletedFromSOP = 1

select count(*) from tblReceiver where dtDateLastSOPUpdate is NULL
and flgDeletedFromSOP = 0

select count(*) from tblReceiver where dtDateLastSOPUpdate is NOT NULL
and flgDeletedFromSOP = 1

select max(ixLastUpdateDate) from tblReceiver where flgDeletedFromSOP = 1 -- should be about ixDate of 16128


select * from tblReceiver where 