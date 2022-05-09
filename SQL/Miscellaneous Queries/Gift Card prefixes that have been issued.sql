-- Gift Card prefixes that have been issued

-- this only gives visibility to prefixes on cards THAT HAVE BEEN ISSSUED! 
--   if we ordered a batch that hasn't had any issued yet, 
-- SQL has no way to tell
SELECT SUBSTRING(ixGiftCard,1,4) 'GC Prefix'
    --, ixGiftCard
    , FORMAT(COUNT(*),'###,###') 'GCIssued'
FROM tblGiftCardMaster
WHERE ixGiftCard like '85%'
GROUP BY SUBSTRING(ixGiftCard,1,4)
ORDER BY SUBSTRING(ixGiftCard,1,4) 

