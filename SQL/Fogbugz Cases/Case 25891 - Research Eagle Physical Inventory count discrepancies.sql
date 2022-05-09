-- Case 25891 - Research Eagle Physical Inventory count discrepancies

select * from PJC_DW_EMI_Qoh_03032015 -- 1,156

SELECT * FROM PJC_EMI_PhysicalInventoryCount -- 592

SELECT distinct ixSKU from PJC_EMI_PhysicalInventoryCount -- 591

select * from PJC_EMI_PhysicalInventoryCount
where ixSKU in (
                select ixSKU from PJC_EMI_PhysicalInventoryCount
                group by ixSKU
                having COUNT(*) > 1
                )

-- manual CORRECTIONS provided by Jason
    select * from PJC_EMI_PhysicalInventoryCount
    where EMIPhysCount = ''


    UPDATE PJC_EMI_PhysicalInventoryCount
    SET EMIPhysCount = 0
    where EMIPhysCount = ''


    DELETE FROM PJC_EMI_PhysicalInventoryCount
    WHERE ixSKU = '940133'
    and EMIPhysCount = 0



    SELECT *-- DELETE 
    FROM PJC_EMI_PhysicalInventoryCount
    WHERE ixSKU = '5504490'
    and EMIPhysCount = 4

    UPDATE PJC_EMI_PhysicalInventoryCount
    SET EMIPhysCount = 21
    WHERE ixSKU = '5504490'



    SELECT *-- DELETE 
    FROM PJC_EMI_PhysicalInventoryCount
    WHERE ixSKU = '9161660'
    and EMIPhysCount = 40

    UPDATE PJC_EMI_PhysicalInventoryCount
    SET EMIPhysCount = 79
    WHERE ixSKU = '9161660'


    SELECT *-- DELETE 
    FROM PJC_EMI_PhysicalInventoryCount
    WHERE ixSKU = '91637015'
    and EMIPhysCount = 10


    SELECT *-- DELETE 
    FROM PJC_EMI_PhysicalInventoryCount
    WHERE ixSKU = '91637037'
    and EMIPhysCount = 89


    SELECT *-- DELETE 
    FROM PJC_EMI_PhysicalInventoryCount
    WHERE ixSKU = '91637050'
    and EMIPhysCount = 10

    UPDATE PJC_EMI_PhysicalInventoryCount
    SET EMIPhysCount = 59
    WHERE ixSKU = '91637050'



    SELECT *-- set rowcount 1 DELETE 
    FROM PJC_EMI_PhysicalInventoryCount
    WHERE ixSKU = '94611230'
    and EMIPhysCount = 89

    set rowcount 0


    SELECT *-- set rowcount 1 DELETE  
    FROM PJC_EMI_PhysicalInventoryCount
    WHERE ixSKU = '94611233'
    and EMIPhysCount = 10

    UPDATE PJC_EMI_PhysicalInventoryCount
    SET EMIPhysCount = 27
    WHERE ixSKU = '94611233'



    SELECT *-- DELETE 
    FROM PJC_EMI_PhysicalInventoryCount
    WHERE ixSKU = '94611262'
    and EMIPhysCount = 0



    set rowcount 0

    SELECT *--  set rowcount 1 DELETE 
    FROM PJC_EMI_PhysicalInventoryCount
    WHERE ixSKU = '94612250'

    UPDATE PJC_EMI_PhysicalInventoryCount
    SET EMIPhysCount = 154
    WHERE ixSKU = '94612250'



    SELECT *--  set rowcount 1 DELETE 
    FROM PJC_EMI_PhysicalInventoryCount
    WHERE ixSKU = '95611250'
    and EMIPhysCount = 13



    SELECT *--  set rowcount 1 DELETE 
    FROM PJC_EMI_PhysicalInventoryCount
    WHERE ixSKU = '95612302'
    and EMIPhysCount = 0


    SELECT *--  set rowcount 1 DELETE 
    FROM PJC_EMI_PhysicalInventoryCount
    WHERE ixSKU = '95612302'
    and EMIPhysCount = 0



    UPDATE PJC_EMI_PhysicalInventoryCount
    SET ixSKU = '94612912'
    WHERE ixSKU = '91637068'
    and EMIPhysCount = 19



select ISNULL(DW.ixSKU, EMI.ixSKU) as SKU,
isNULL(DWQty,0) 'SOP Qty',
isNULL(EMIPhysCount,0) 'EMI Phys Count'
from PJC_DW_EMI_Qoh_03032015 DW -- 1,156
FULL OUTER JOIN PJC_EMI_PhysicalInventoryCount EMI ON DW.ixSKU = EMI.ixSKU