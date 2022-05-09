/*
USE [SPEEDWAY]

sql server = LNK-WEB3\SQLEXPRESS
data base = SPEEDWAY

*/

SELECT distinct PT.sPerceptionText  Type,
   POS.PosCount,
   NEG.NegCount
FROM
(SELECT distinct sPerceptionText -- 74
 FROM Perception) PT
-- Positive
left join (select P.ixParentId,sPerceptionText, count(fp.ixFeedbackPerceptionId) as PosCount
            from Perception p
            left join FeedbackPerception fp on p.ixPerceptionId = fp.ixPerceptionId
            where fp.iPerceptionValue > 0
            group by P.ixParentId,p.sPerceptionText) POS on PT.sPerceptionText = POS.sPerceptionText
-- Negative
left join (select P.ixParentId,sPerceptionText, count(fp.ixFeedbackPerceptionId) as NegCount
            from Perception p
            left join FeedbackPerception fp on p.ixPerceptionId = fp.ixPerceptionId
            where fp.iPerceptionValue < 0
            group by P.ixParentId,p.sPerceptionText) NEG on PT.sPerceptionText = NEG.sPerceptionText


/*
select fbt.sTypeDescription Type, sPerceptionText, count(fp.iPerceptionValue) as PosCount  -- 51
             from Perception p
            left join FeedbackPerception fp on p.ixPerceptionId = fp.ixPerceptionId
            left join Feedback fb on fp.ixFeedbackId = fb.ixFeedbackId
            left join FeedbackType fbt ON fb.ixType = fbt.ixType
            where fp.iPerceptionValue > 0
            group by fbt.sTypeDescription,p.sPerceptionText



select distinct ixPerceptionId, sPerceptionText
from Perception




*/
SELECT distinct PARENT.sPerceptionText as       Parent,
       isnull(COMBO.Child,0)           Child,
       isnull(COMBO.PosCount,0)        PosCount,
       isnull(COMBO.NegCount,0)        NegCount
FROM
   (select distinct ixParentId, sPerceptionText
    from Perception
   ) PARENT
   -- combined ratings
   left join 
   (SELECT distinct isNULL(POS.ixParentId,NEG.ixParentId) ixParentId,   -- 68 ROWS
      isNUll(POS.sPerceptionText,NEG.sPerceptionText)  Child,
      POS.PosCount,
      NEG.NegCount
    FROM
            -- Positive ratings
            (select P.ixParentId,sPerceptionText, count(fp.ixFeedbackPerceptionId) as PosCount
               from Perception p
               left join FeedbackPerception fp on p.ixPerceptionId = fp.ixPerceptionId
               where fp.iPerceptionValue > 0
               group by P.ixParentId,p.sPerceptionText
            ) POS
            -- Negative ratings
    FULL join (select P.ixParentId,sPerceptionText, count(fp.ixFeedbackPerceptionId) as NegCount
               from Perception p
               left join FeedbackPerception fp on p.ixPerceptionId = fp.ixPerceptionId
               where fp.iPerceptionValue < 0
               group by P.ixParentId,p.sPerceptionText
            ) NEG on POS.sPerceptionText = NEG.sPerceptionText
                 and POS.ixParentId = NEG.ixParentId
   ) COMBO on --COMBO.ixParentId = PARENT.ixParentId
           COMBO.Child = PARENT.sPerceptionText
Where Child is NOT null
order by sPerceptionText


select sPerceptionText
from Perception where ixParentId = 12

select * from Perception