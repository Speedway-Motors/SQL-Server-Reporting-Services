-- Case 16667 - Invalid users showing up in tblSOPFeedLog


select * from tblSOPFeedLog
where ixTime between 24001 and 25000
and ixUser pc
order by ixDate desc, ixTime desc



select E.sFirstname,
       E.sLastname,
       FL.ixUser, 
       count(FL.dtDate) TransCount
from tblSOPFeedLog FL
    left join tblEmployee E on FL.ixUser = E.ixEmployee
where dtDate >= '10/01/2012'
group by E.sFirstname,
       E.sLastname,
       FL.ixUser
       


