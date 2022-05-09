-- Time difference from order entry to release

        SELECT O.ixOrder,  -- 24,666
            FORMAT((TNG.dtOrderDate AT TIME ZONE 'UTC'  AT TIME ZONE 'Central Standard Time'),'yyyy.MM.dd HH:MM:ss') TNGOrderDate,
            (dtWebRejectReleaseDate+ T1.chTime) 'WebRejectRelease',
            (dtWebHeldReleaseDate+ T2.chTime) 'WebHeldRelease' --, sWebHeldReleaseUser,
        INTO #WebRejOrHeld  -- DROP TABLE #WebRejOrHeld
        FROM tblOrder O
            left join tblTime T1 on O.ixWebRejectReleaseTime = T1.ixTime
            left join tblTime T2 on O.ixWebHeldReleaseTime = T2.ixTime
            left join [DW].tng.tblorder TNG on O.ixOrder = TNG.ixSopOrderNumber
        WHERE O.dtOrderDate between '06/01/2021' and '09/10/2021' -- 25,731
            AND O.ixOrder NOT like 'P%'
            AND O.ixOrder NOT like 'Q%'
            AND (dtWebRejectReleaseDate is NOT NULL
                or ixWebRejectReleaseTime is NOT NULL
                or sWebRejectReleaseUser is NOT NULL
                or dtWebHeldReleaseDate is NOT NULL
                or ixWebHeldReleaseTime is NOT NULL
                or sWebHeldReleaseUser is NOT NULL)
        --WHERE O.ixOrder = '10279661'

SELECT ROH.ixOrder, TNGOrderDate, WebRejectRelease, WebHeldRelease, 
    RR.sRejectReason,
    (CASE WHEN sRejectReason like 'AFCO dropship for SKU%' then 'AFCO dropship for SKU #X'
          WHEN sRejectReason like 'Backorder status for SKU%' THEN 'Backorder status for SKU #X'
          WHEN sRejectReason like 'CUST record locked since%' THEN 'CUST record locked' -- example: CUST record locked since 08/26/21 at 15:36:59 - please try again
          WHEN sRejectReason like 'Item price different for SKU%' THEN 'Item price different for SKU #X'
          WHEN sRejectReason like 'Shipping charge difference%' THEN 'Shipping charge difference (web $X/ calc $X)'  -- example:  Shipping charge difference (web $100.58 / calc $155.37)
          WHEN sRejectReason like 'Shipping method not valid for BATTERY item%' THEN 'Shipping method not valid for BATTERY item #X'
          WHEN sRejectReason like 'Shipping method not valid for LIMITED QTY item%' THEN 'Shipping method not valid for LIMITED QTY item #X'
          WHEN sRejectReason like 'This order may be a duplicate%' THEN 'This order may be a duplicate of #OrderNum'
          WHEN sRejectReason like 'WEIGHT%EXCEEDS MAX (9)%' THEN 'WEIGHT X EXCEEDS MAX (9)'
          WHEN sRejectReason like 'SKU%is on this order%' THEN 'SKU #X is on this order' -- example:  SKU 910133-2.50 is on this order
          WHEN sRejectReason like 'LENGTH+GIRTH%EXCEEDS MAX%' THEN 'LENGTH+GIRTH (##) EXCEEDS MAX (##)' -- example:   LENGTH+GIRTH (133) EXCEEDS MAX (108)
          --WHEN sRejectReason like '%' THEN ''
          ELSE sRejectReason
     END) 'RejectReason',
    DATEDIFF (minute, TNGOrderDate , WebRejectRelease ) 'MinProcReject',
    DATEDIFF (minute, TNGOrderDate , WebHeldRelease ) 'MinProcHeld' 
INTO #RejectReasons -- DROP TABLE #RejectReasons
FROM #WebRejOrHeld ROH
   left join tblWebOrderRejectReason RR on ROH.ixOrder = RR.ixOrder
where WebRejectRelease is NOT NULL -- 8,496
   --WebHeldRelease is NOT NULL
-- where ixOrder = '10279661'
order by RR.sRejectReason

select RejectReason, FORMAT(count(ixOrder),'###,###') 'OrdersAffected'
from #RejectReasons
GROUP BY RejectReason
ORDER BY count(ixOrder) DESC
   -- RejectReason





SELECT COUNT(*) -- 303,659
FROM tblOrder O
        WHERE O.dtOrderDate between '06/01/2021' and '09/10/2021' -- 25,731
            AND O.ixOrder NOT like 'P%'
            AND O.ixOrder NOT like 'Q%'

select top 10 * from tblWebOrderRejectReason


10000058
10000149
10000254
10000553