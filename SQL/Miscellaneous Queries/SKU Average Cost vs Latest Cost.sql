-- SKU Average Cost vs Latest Cost

select iQAV, mAverageCost, mLatestCost
from vwSKUMultiLocation SKUM
where iQAV > 0
    --and flgDeletedFromSOP = 0
    and (mAverageCost > 0
        or mLatestCost > 0
        )
    and flgIntangible = 0
    --and flgActive = 1  
    
    
/* Ran in SMI Reporting and AFCO Reporting 8-31-2017
  Put the raw data in Excel and calculated the Extended Cost for both fields
  Total Combined Extended Cost for SKUs with QAV > 0
   varied < %2 between the two cost fields
*/


     