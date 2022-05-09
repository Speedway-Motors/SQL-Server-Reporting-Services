USE [SPEEDWAY]

SELECT distinct isNULL(POS.ixParentId,NEG.ixParentId) ixParentId,   -- 68 ROWS
  isNUll(POS.sPerceptionText,NEG.sPerceptionText)  Child,
  isNull(POS.ixPerceptionId,NEG.ixPerceptionId) ixPerceptionId,
  POS.PosCount,
  NEG.NegCount
FROM
        -- Positive ratings
        (select p.ixParentId,p.ixPerceptionId,sPerceptionText, count(fp.ixFeedbackPerceptionId) as PosCount
           from Perception p
           left join FeedbackPerception fp on p.ixPerceptionId = fp.ixPerceptionId
           where fp.iPerceptionValue > 0
           group by p.ixParentId,p.ixPerceptionId,p.sPerceptionText
        ) POS

        -- Negative ratings
FULL outer join (select p.ixParentId,p.ixPerceptionId,p.sPerceptionText, count(fp.ixFeedbackPerceptionId) as NegCount
           from Perception p
           left join FeedbackPerception fp on p.ixPerceptionId = fp.ixPerceptionId
           where fp.iPerceptionValue < 0
           group by P.ixParentId,p.ixPerceptionId,p.sPerceptionText
        ) NEG on POS.sPerceptionText = NEG.sPerceptionText
             and POS.ixParentId = NEG.ixParentId
             and POS.ixPerceptionId = NEG.ixPerceptionId
             
Order By ixPerceptionId