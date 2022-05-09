-- SMIHD-19539 - Identify SKUs with Web Price Changes that occured 12-1-20 for Jason Danely

-- RUN ON dw.speedway2.com

select ixSOPSku 'SKU', dtStartEffectiveDate 'StartDate', mWebPrice 'NewPrice', iQAV 'QAV' 
from [dbo].[vwSkuVariantWebSnapshotPrice] -- 8,928
where dtStartEffectiveDate = '12/01/2020'

-- get the NEW and OLD web prices
select OLD.ixSOPSku 'ixSKU', NEW.dtStartEffectiveDate 'StartDate', OLD.mPreviousWebPrice 'OldWebPrice', NEW.mWebPrice 'NewWebPrice', NEW.iQAV 'QAV' 
into #SKUsWithPriceChanges -- DROP table #SKUsWithPriceChanges
from [dbo].[vwSkuVariantWebSnapshotPrice] NEW -- 8,928
    left join vwSkuVariantWebSnapshotPriceWithEndDate OLD on NEW.ixSOPSku = OLD.ixSOPSku 
where NEW.dtStartEffectiveDate = '12/01/2020'
    and OLD.dtStartEffectiveDate = '12/01/2020'
    and OLD.ixSKU NOT LIKE 'NS%'
-- and OLD.ixSOPSKU = '1060000565.90'



select * --ixSKU, ',', OldPrice
from #SKUsWithPriceChanges



select top 10 * from tblSkuVariantWebSnapshot

select top 10 * from WebSnapshot.PreviousPrice


select * from vwSkuVariantWebSnapshotPriceWithEndDate -- 
where --dtEndEffectiveDate is NOT NULL
dtStartEffectiveDate = '12/01/2020'

order by dtEndEffectiveDate desc





select top 10 * from [dbo].[vwSkuVariantWebSnapshotPrice]
where dtStartEffectiveDate = '11/30/2020'

select top 10 * from [dbo].[vwSkuVariantWebSnapshotPrice]
where dtStartEffectiveDate = '12/02/2020'


