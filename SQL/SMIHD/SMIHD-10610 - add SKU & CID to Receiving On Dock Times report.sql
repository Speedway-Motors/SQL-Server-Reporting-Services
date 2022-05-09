-- Receivers - Closed and not Posted
-- ver 18.42.1

SELECT ST.ixReceiver 'Receiver', 
    ST.ixSKU 'SKU', 
    ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription',
    --sToLocation,	sWarehouse,	sToWarehouse,	sToBin,sToCID,sToGID,sGID,flgBinScanned,ST.ixJob, sTransactionInfo, -- = Receiver+'*'+PO
    ST.sCID 'CID',	
    POM.sPaymentTerms 'PmtTerms',
    SUBSTRING(sTransactionInfo, 8, 5) 'PO',			
    ST.sBin 'Bin'
FROM tblSKUTransaction ST
    LEFT JOIN tblPOMaster POM on SUBSTRING(sTransactionInfo, 8, 5) COLLATE SQL_Latin1_General_CP1_CI_AS = POM.ixPO COLLATE SQL_Latin1_General_CP1_CI_AS
    LEFT JOIN tblSKU S on S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = ST.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE ixReceiver COLLATE SQL_Latin1_General_CP1_CI_AS IN (-- Closed receivers
                                                         select ixReceiver COLLATE SQL_Latin1_General_CP1_CI_AS
                                                         from tblReceiver 
                                                         where flgStatus = 'Closed'
                                                            and flgDeletedFromSOP = 0
                                                         )
    --and POM.ixIssueDate >= 18187
ORDER BY POM.sPaymentTerms, POM.ixPO, ST.ixReceiver, ST.ixSKU, ST.sCID




/*
select sPaymentTerms, count(*)
from tblPOMaster
where flgIssued = 1
and ixIssueDate >= 18187
group by sPaymentTerms



SELECT * 
FROM tblSKUTransaction
where ixReceiver = '256818'

select count(*)
from tblReceiver 
where flgStatus = 'Closed'
and flgDeletedFromSOP = 0 -- 55   <-- matches the # of Closed Receivers on the Receiving on Doc Times report
*/
