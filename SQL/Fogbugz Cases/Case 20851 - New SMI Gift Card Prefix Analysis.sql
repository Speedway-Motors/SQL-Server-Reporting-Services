SELECT DISTINCT SUBSTRING(ixGiftCard, 1, 4) AS Prefix 
     , COUNT(DISTINCT ixGiftCard) AS Cnt 
FROM tblGiftCardMaster 
WHERE SUBSTRING(ixGiftCard, 1, 4) LIKE '[0-9][0-9][0-9][0-9]'
GROUP BY SUBSTRING(ixGiftCard, 1, 4)
ORDER BY Prefix, Cnt DESC 