-- SMIHD-14013 - EMI BOM Inventory - calculate labor minutes
-- 1) Qty on Open BOM Transfers
SELECT ABTM.ixFinishedSKU, SUM(ABTM.QtyRemaining) 'QtyOnOpenBOMTransfers'
into #OpenQtyByFinishedPart
FROM (-- ALL Open BOM Transfers
        SELECT BTM.ixFinishedSKU,
        (BTM.iQuantity-isnull(BTM.iCompletedQuantity,0))   QtyRemaining
        from tblBOMTransferMaster BTM
        where BTM.flgReverseBOM = 0
        and BTM.dtCanceledDate is NULL
        and isnull(BTM.iCompletedQuantity,0) < BTM.iQuantity
    ) ABTM
GROUP BY ABTM.ixFinishedSKU

    -- 2) Mins needed per BOM Transfer/Component SKU
    SELECT OQ.ixFinishedSKU 'FinishedSKU', 
            BTD.ixSKU 'CompSKU',
            BTD.iQuantity 'Qty',
            OQ.QtyOnOpenBOMTransfers 'QtyOnOpenBOMs',
            BTD.iQuantity * OQ.QtyOnOpenBOMTransfers 'MinsNeeded'
    into #MinsNeeded
    FROM #OpenQtyByFinishedPart OQ
        left join tblBOMTemplateDetail BTD on OQ.ixFinishedSKU =BTD.ixFinishedSKU
    WHERE BTD.ixSKU in ('94600-ASSEMBLE','94600-BEND','94600-COPE','94600-CUT','94600-GRIND','94600-LATHE','94600-SETUP','94600-WELD','94601','94605')
    ORDER BY OQ.ixFinishedSKU 

        -- 3) Total Mins needed by Labor SKU
        SELECT CompSKU, SUM(MinsNeeded) 'TotMinsNeeded'
        from #MinsNeeded
        group by CompSKU
        order by CompSKU
        /*              TotMins
        CompSKU	        Needed
        94600-BEND	    200
        94600-CUT	    8119
        94600-GRIND	    100
        94600-WELD	    7552
        94601	        9432
        */

select * FROM tblBOMTemplateDetail
where ixFinishedSKU = '98610003'
/*
DROP TABLE #OpenQtyByFinishedPart
DROP TABLE #MinsNeeded
*/
select ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription' from tblSKU S where ixSKU IN ('94600-ASSEMBLE','94600-BEND','94600-COPE','94600-CUT','94600-GRIND','94600-LATHE','94600-SETUP','94600-WELD','94601','94605')
