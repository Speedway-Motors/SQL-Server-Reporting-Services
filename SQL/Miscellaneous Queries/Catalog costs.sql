select ixCatalog    'Cat',
    sDescription    'Description',
    sMarket         'Market',
    CONVERT(VARCHAR(10), dtStartDate, 101) AS 'Start',
    CONVERT(VARCHAR(10), dtEndDate, 101) AS 'End',
    iQuantityPrinted 'Qty Printed',
    iPages          'Pages',
    mPrintingCost   'Printing Cost',
    mPreparationCost 'Prep Cost',
    mPostageCost    'Postage Cost'
from tblCatalogMaster    
where dtStartDate >= '01/01/2010'
    --and (iQuantityPrinted is NULL
    --     or iQuantityPrinted = 0
    --     or iPages = 0
    --     or mPrintingCost =0
    --     or mPreparationCost = 0
    --     or mPostageCost = 0)
and ixCatalog like '4%'         
order by ixCatalog desc



exec spGetDataDictionary 'tblBin'

select flgAvailableOrders, count(*)
from tblBin
group by flgAvailableOrders