-- Survey Feedback from LNK-WEB2
select 
    sr.sComments as 'Request Comment', 
    fc.sComment as 'John Comment', 
    fpna.sSpeedwayPartNumber as 'SKU #', 
    srt.sRequestType as 'Service Request Type',
    u.sFirstName as 'First Name', 
    u.sLastName as 'Last Name',
    f.dtDateSubmitted as 'Request submit date'
from [LNK-WEB2\SQLEXPRESS].SMI_360.dbo.Feedback f
    join [LNK-WEB2\SQLEXPRESS].SMI_360.dbo.ServiceRequest sr on f.ixFeedbackId = sr.ixFeedbackId
    join [LNK-WEB2\SQLEXPRESS].SMI_360.dbo.ServiceRequestType srt on sr.ixRequestType = srt.ixRequestType
    left join [LNK-WEB2\SQLEXPRESS].SMI_360.dbo.FeedbackPartNumberAssociation fpna on f.ixFeedbackId = fpna.ixFeedbackId
    left join [LNK-WEB2\SQLEXPRESS].SMI_360.dbo.FollowupComment fc on f.ixFeedbackId = fc.ixFeedbackId
    left join [LNK-WEB2\SQLEXPRESS].SMI_360.dbo.Users u on fc.ixUserId = u.ixUserId
where srt.sRequestType = 'Race Tech' 
and u.sUserName = 'jwwulbern'
and f.dtDateSubmitted > '01/01/2015'
order by f.dtDateSubmitted desc;