-- SUB-QUERY FOR Materials Planning Report - Next expected PO Date
SELECT POD.ixSKU, POM.ixPO 
                , SUM(POD.iQuantity - ISNULL(POD.iQuantityReceivedPending,0) - ISNULL(POD.iQuantityPosted,0)) AS POQty -- outstanding PO Qty
                , MIN(D.dtDate) AS ExpectedDelivery
                , MIN(D2.dtDate) AS NotifyDate
		   FROM tblPODetail POD 
		   LEFT JOIN tblDate D ON D.ixDate = POD.ixExpectedDeliveryDate 
		   JOIN tblPOMaster POM ON POM.ixPO COLLATE SQL_Latin1_General_CP1_CS_AS = POD.ixPO COLLATE SQL_Latin1_General_CP1_CS_AS
                        AND POM.flgIssued = 1
                        AND POM.flgOpen = 1
		   LEFT JOIN tblDate D2 ON D2.ixDate = POM.ixNotifyDate  
-- where POD.ixSKU = '23150CR'   -- '1493-5X' -- 	-- 	                         
GROUP BY POD.ixSKU , POM.ixPO
HAVING SUM(POD.iQuantity - ISNULL(POD.iQuantityReceivedPending,0) - ISNULL(POD.iQuantityPosted,0))      > 0
           ORDER BY ixSKU


-- modified report
SELECT POD.ixSKU 
                , SUM(POD.iQuantity - ISNULL(POD.iQuantityReceivedPending,0) - ISNULL(POD.iQuantityPosted,0)) AS POQty -- outstanding PO Qty
                , MIN(D.dtDate) AS ExpectedDelivery
                , MIN(D2.dtDate) AS NotifyDate
		   FROM tblPODetail POD 
		   LEFT JOIN tblDate D ON D.ixDate = POD.ixExpectedDeliveryDate 
		   JOIN tblPOMaster POM ON POM.ixPO COLLATE SQL_Latin1_General_CP1_CS_AS = POD.ixPO COLLATE SQL_Latin1_General_CP1_CS_AS
                        AND POM.flgIssued = 1
                        AND POM.flgOpen = 1
		   LEFT JOIN tblDate D2 ON D2.ixDate = POM.ixNotifyDate                        
           GROUP BY POD.ixSKU 
           HAVING SUM(POD.iQuantity - ISNULL(POD.iQuantityReceivedPending,0) - ISNULL(POD.iQuantityPosted,0)) > 0 -- added 12/6/2016 so that Open POs with that SKU do not appear when that specific SKU has been 100% filled
           ORDER BY ixSKU
           
           
           
           

ixSKU	ixPO	POQty	ExpectedDelivery	NotifyDate
23150CR	33157	10	    2016-12-09      	NULL        -- Date shows 12/9/16 
1493-5X	33130	50	    2017-02-10                      -- Date shows 2/10/17 


-- For each SKU in the report, All POs containing that SKU that are open and have been issued are searched.  If there are multiple PO's, it returns the soonest expected delivery date out of the PO's that have outstanding QTY.


select * from tblPOMaster 33100

select * from tblDate where ixDate in (17876)

select POM.*, POD.*
from tblPOMaster POM
    join tblPODetail POD on POM.ixPO = POD.ixPO
                         and  POD.ixSKU = '23150CR'
where (POD.iQuantity - ISNULL(POD.iQuantityReceivedPending,0) - ISNULL(POD.iQuantityPosted,0))      > 0
order by POM.ixIssueDate desc

