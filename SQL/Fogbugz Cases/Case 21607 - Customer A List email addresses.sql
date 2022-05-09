-- Case 21607 - Customer A List email addresses


/* Markets needed

2B	TBucket
B	BothRaceStreet
R	Race
SM	SprintMidget
SR	StreetRod

*/

/* RUN each individually... 
   put results in Excel, 
   dedupe, 
   then pull email address
*/   
 EXEC spCSTSegmentPull 12,'1','6000','R','R' -- 1,704 @3-11-14   
 EXEC spCSTSegmentPull 12,'1','6000','SR','SR' -- 2,394   
 EXEC spCSTSegmentPull 12,'1','6000','B','B'    
 EXEC spCSTSegmentPull 12,'1','6000','SM','SM'    
 EXEC spCSTSegmentPull 12,'1','6000','2B','2B'    
    
 
 
select * from [SMITemp].dbo.PJC_21607_AListCustomers WHERE sEmailAddress is not NULL

UPDATE A 
set sEmailAddress = C.sEmailAddress -- 4,439
from [SMITemp].dbo.PJC_21607_AListCustomers A
 join tblCustomer C on A.ixCustomer = C.ixCustomer
