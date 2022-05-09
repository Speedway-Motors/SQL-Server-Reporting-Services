-- Case 22171  - known gift-card prefixes that have been used

/*     !!!!
  The DB only contains cards that have been ISSUED.
  Therefore it is possible that a batch of cards has been printed, but not yet issued.
  Because of that, Markeing/Merchandising needs to:
  
  MAKE SURE make sure the card company (Able Card) VERIFIES 
  that they have not used the new prefix for us previously !!!


                "Hey Jess, I don’t show any gift cards that have been issued starting with 8503.  
                 As always though, you would want Able Card to verify they haven’t printed any for us with that prefix."

*/  
 
SELECT DISTINCT SUBSTRING(ixGiftCard, 1, 4) AS Prefix 
     , COUNT(DISTINCT ixGiftCard) AS Cnt 
FROM tblGiftCardMaster 
WHERE SUBSTRING(ixGiftCard, 1, 4) LIKE '[0-9][0-9][0-9][0-9]'
GROUP BY SUBSTRING(ixGiftCard, 1, 4)
ORDER BY Prefix, Cnt DESC 

-- 

select * from tblGiftCardMaster
where dtDateIssued >= '10/09/2014'

