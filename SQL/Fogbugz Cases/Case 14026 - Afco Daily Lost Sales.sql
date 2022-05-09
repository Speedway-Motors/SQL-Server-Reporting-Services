SELECT DISTINCT S.ixSKU AS SKU
     , S.sDescription AS Description 
     , S.mPriceLevel1 AS Retail
     , S.mAverageCost AS Cost
     , S.mPriceLevel1 - S.mAverageCost AS GP
     , SUM(ISNULL(OL.iQuantity,0)) AS QtyLost 
     , (CASE WHEN S.flgActive = '1' THEN 'Y'
             ELSE 'N'
        END) AS Active 
     , (ISNULL(S.mPriceLevel1,0) - ISNULL(S.mAverageCost,0)) * (SUM(ISNULL(OL.iQuantity,0))) AS LostGP
     , SL.sPickingBin AS PickBin --IF THE PART IS STORED IN MULTIPLE BINS IT IS SHOWING UP MULTIPLE TIMES 
     , SL.iQOS AS QOS 
     , ISNULL(SL.iQOS,0) - ISNULL(SL.iQAV,0) AS QtyComtd 
     -- ADD in PO Report 
     , O.sOrderTaker 
     , O.ixOrder --?? not on request 
     , O.dtOrderDate
     , O.sOrderStatus 
FROM tblOrderLine OL 
LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU      
--LEFT JOIN tblBinSku BS ON BS.ixSKU = S.ixSKU 
                      --  AND BS.ixLocation = '99'
LEFT JOIN tblSKULocation SL ON SL.ixSKU = S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
                           AND SL.ixLocation = '99'
LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder 
WHERE OL.flgLineStatus = 'Lost'
  AND OL.dtOrderDate BETWEEN @StartDate AND @EndDate --DATEADD(dd, -365, GETDATE()) AND GETDATE() --
  --AND S.flgActive = '1' --??
GROUP BY S.ixSKU 
       , S.sDescription
       , S.mPriceLevel1        
       , S.mAverageCost
       , S.mPriceLevel1 - S.mAverageCost 
       , (CASE WHEN S.flgActive = '1' THEN 'Y'
             ELSE 'N'
          END)       
       , SL.sPickingBin
       , SL.iQOS
       , ISNULL(SL.iQOS,0) - ISNULL(SL.iQAV,0)
       , O.sOrderTaker 
       , O.ixOrder
       , O.dtOrderDate
       , O.sOrderStatus
ORDER BY S.ixSKU


/*
Create a subreport with the query below 
that will provided the most recent date
the SKU was received and the qty that 
was received to help determine whether
the lost sale was accurately recorded
*/ 


SELECT ST.ixSKU 
     , D.dtDate AS RcvdDate 
     , SUM(ST.iQty) AS QtyRcvd 
FROM tblSKUTransaction ST 
LEFT JOIN tblDate D ON D.ixDate = ST.ixDate 
LEFT JOIN tblTime T ON T.ixTime = ST.ixTime 
WHERE sTransactionType = 'T' --Intra Transfer 
  AND ixSKU = @ixSKU --'201SX'
  AND D.dtDate IN (SELECT MAX(D.dtDate)
				   FROM tblSKUTransaction ST 
				   LEFT JOIN tblDate D ON D.ixDate = ST.ixDate 
				   WHERE sTransactionType = 'T' --Intra Transfer 
					 AND ixSKU = @ixSKU --'201SX'
				   ) 
GROUP BY ST.ixSKU
       , D.dtDate
       
       

       
SELECT *
FROM tblSKUTransaction ST 
WHERE sTransactionType = 'T'     
  AND ST.iQty = '28160'      