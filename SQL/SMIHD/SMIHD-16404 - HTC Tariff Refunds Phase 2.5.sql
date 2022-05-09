-- SMIHD-16404 - HTC Tariff Refunds Phase 2.5

/****************       SMI     ****************************/
SELECT IR.ixSKU, S.ixHarmonizedTariffCode, IR.ixPO, POM.ixVendor, IR.iQuantityReceived, D.dtDate 'DateReceived', IR.ixReceiver 
    -- IR.ixReceiptPointer, IR.flgPost          <-- NULL on all
    -- IR.ixLocation    <-- all were 99
INTO #ReceivedHistory -- DROP table #ReceivedHistory
FROM tblInventoryReceipt IR
    left join tblPOMaster POM on IR.ixPO = POM.ixPO
    left join tblDate D on IR.ixCreateDate = D.ixDate
    left join tblSKU S on IR.ixSKU = S.ixSKU
WHERE IR.ixCreateDate >= 18172 --  '10/01/2017'
    and POM.ixVendor in ('0099','1154','1363','2304','2404','2895','3238','3290','3415','3895','3896')
    and IR.ixSKU in ('91031039','91065400','94031065','91064043','91016259','91065390','91031067','91031070','91031908','91031027','91031034','91031068','91031906','91067434','91067435','91031905','91031061','91031001','91031002','94031064','94031066','91031043','91031064','91067440','91067437','91031063','94031062','91031066','94031068','91066258','91031065') -- 31 SKUs



    SELECT * FROM #ReceivedHistory -- 76

    SELECT DISTINCT ixSKU from #ReceivedHistory -- 25 SKUs

    SELECT DISTINCT ixPO from #ReceivedHistory -- 12 POs

    SELECT RH.ixSKU, SUM(iQuantityReceived) 'TotalRcvd', S.mAverageCost 
        -- (SUM(iQuantityReceived)* S.mAverageCost) 'EstExtCost'
    from #ReceivedHistory RH
        left join tblSKU S on RH.ixSKU = S.ixSKU
    group by RH.ixSKU, S.mAverageCost
    order by SUM(iQuantityReceived) desc



-- select * from tblDate where dtDate = '10/01/2017'    18172




/****************       AFCO     ****************************/
SELECT IR.ixSKU, S.ixHarmonizedTariffCode, IR.ixPO, POM.ixVendor, IR.iQuantityReceived, D.dtDate 'DateReceived', IR.ixReceiver 
    -- IR.ixReceiptPointer, IR.flgPost          <-- NULL on all
    -- IR.ixLocation    <-- all were 99
INTO #AFCOReceivedHistory -- DROP table #AFCOReceivedHistory
FROM tblInventoryReceipt IR
    left join tblPOMaster POM on IR.ixPO = POM.ixPO COLLATE SQL_Latin1_General_CP1_CI_AS
    left join tblDate D on IR.ixCreateDate = D.ixDate
    left join tblSKU S on IR.ixSKU = S.ixSKU
WHERE IR.ixCreateDate >= 18172 --  '10/01/2017'
    and POM.ixVendor in ('5023','5118','5558','5631','5727','5918','6125','6167','6361','6379','6458','6687','7448','7462','7484','7522','7551','7552','7556','7558','7561','7572','7573','7577','7582','7595','7615','7623','7624','7626','7628','7652','7657','7658','7668','7680','7692','7709','7711','7713','7717','7719','7766','8085')
    and IR.ixSKU in ('52-902395','52-901451','52-905509','52-904237','0000973.02','52-904348','52-900318','52-903780','52-904773','52-901452','0000973.04','52-905034','52-901360','52-900313','52-905431','52-902358','52-903026','A901040009X','52-905804','52-905325','52-900090','80101X-1','52-905130','A901040007X','52-905319','52-904797','52-902103','52-904349','52-905618','1001205','52-905322','80101X-7','52-905165','52-905166','52-902848','52-905084','52-904399','7242-2904-X','52-905186','80101X-2','52-901361','52-905891','80101X10','52-904693','7242-2903-X','52-905892','52-904692','52-900663','52-902394','52-903265','52-903341','80168X-1','0000973.03','52-905085','52-904350','52-905698','0000973.01','52-901483') -- 58 SKUs provided by Richard



    SELECT * FROM tblSKU where ixSKU in ('52-902395','52-901451','52-905509','52-904237','0000973.02','52-904348','52-900318','52-903780','52-904773','52-901452','0000973.04','52-905034','52-901360','52-900313','52-905431','52-902358','52-903026','A901040009X','52-905804','52-905325','52-900090','80101X-1','52-905130','A901040007X','52-905319','52-904797','52-902103','52-904349','52-905618','1001205','52-905322','80101X-7','52-905165','52-905166','52-902848','52-905084','52-904399','7242-2904-X','52-905186','80101X-2','52-901361','52-905891','80101X10','52-904693','7242-2903-X','52-905892','52-904692','52-900663','52-902394','52-903265','52-903341','80168X-1','0000973.03','52-905085','52-904350','52-905698','0000973.01','52-901483')
    
    SELECT * FROM #AFCOReceivedHistory

    SELECT DISTINCT ixSKU from #AFCOReceivedHistory -- 58 SKUs

    SELECT DISTINCT ixPO from #AFCOReceivedHistory -- 98 POs


    SELECT RH.ixSKU, SUM(iQuantityReceived) 'TotalRcvd', S.mAverageCost 
        -- (SUM(iQuantityReceived)* S.mAverageCost) 'EstExtCost'
    from #AFCOReceivedHistory RH
        left join tblSKU S on RH.ixSKU = S.ixSKU
    group by RH.ixSKU, S.mAverageCost
    order by SUM(iQuantityReceived) desc