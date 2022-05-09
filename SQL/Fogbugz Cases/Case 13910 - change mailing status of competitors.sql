Case 13910 - change mailing status of competitors

ixCustomer, sMailingStatus
from tblCustomer
where sEmailAddress like '%@YMOTORSPORTS.COM'
    or sEmailAddress like '%@JCWHITNEY.COM'
    or sEmailAddress like '%@JEGS.COM'
    or sEmailAddress like '%@JRMOTORSPORTS.COM'
    or sEmailAddress like '%@PITSTOPUSA.COM'
    or sEmailAddress like '%@SAFERACER.COM'
    or sEmailAddress like '%@SMILEYS.COM'
    or sEmailAddress like '%@SOUTHERNRODS.COM'
    or sEmailAddress like '%@SUMMIT.COM'
    or sEmailAddress like '%@TCI.COM'
    or sEmailAddress like '%@YEARONE.COM'
    or sEmailAddress like '%@YOGIS.COM'
    or sMailingStatus = 7