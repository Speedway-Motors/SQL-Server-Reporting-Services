-- SMIHD-3585 - Add 3 new fields to tblBOMTemplateMaster

-- Scripts to add field to tables

-- run on DWSTAGING ONLY!!!!
BEGIN TRAN
    ALTER TABLE [SMI Reporting].dbo.tblBOMTemplateMaster
         ADD ixLastCostUpdateDate smallint NULL,
             ixLastCostUpdateTime int NULL,
             ixLastCostUpdateUser varchar(10) NULL
ROLLBACK TRAN

BEGIN TRAN
    ALTER TABLE [AFCOReporting].dbo.tblBOMTemplateMaster
         ADD ixLastCostUpdateDate smallint NULL,
             ixLastCostUpdateTime int NULL,
             ixLastCostUpdateUser varchar(10) NULL
ROLLBACK TRAN



/* TESTING

-- SMI
    SELECT TOP 10 * FROM [SMI Reporting].dbo.tblBOMTemplateMaster 
    
    select TOP 100 * from [SMI Reporting].dbo.tblBOMTemplateMaster 
    where dtDateLastSOPUpdate = '04/22/2016'

    select * from [SMI Reporting].dbo.tblBOMTemplateMaster 
    WHERE ixFinishedSKU in ('101-5/16','1012006201','101AR239','101AR255','101AR302','102713002','102713124','106-BASE','106-MONO','106-TT','106100207','10610140A','10610141A','106101421','10610142A','106101431','10610143A','10610144A','10610145A','10610146A','10610146DS','10610160','106101651','10610185','10610188','10610300','10610301','10610302','10610400','10610490','10610506','1061060-BLK','1061060-CHR','1061170','1061170T','1061180','1061190','106169','10618290L','10618290R','10618294L','10618294R','10618295L','10618295R','10618300L','10618300R','10619509','10619510','10619511','10619512','10619513','10619514','10619515','10619516','10619517','10619518','10619519','10619520','10619522','10619523','10619527','10619537','10620021L','10620021R','10620047','10620048','10620049','10620050','10620051','106200511','10620053','10620054','10620055','10620056','10620057','10620062','10620063','10620064','10620090','10620095','106201371','106201742','106201743','106201744','10620176S','10620185','106201851','10620187','106202202','10620235','106202361','106202362','10620243','10620244','106202441','10620246','10620247','10620248','106202481','10620265')
    order by dtDateLastSOPUpdate 

    SELECT count(*) 'Qty',
        ixLastCostUpdateDate, ixLastCostUpdateUser
    FROM [SMI Reporting].dbo.tblBOMTemplateMaster 
    GROUP BY ixLastCostUpdateDate,  ixLastCostUpdateUser
    ORDER BY ixLastCostUpdateDate,  ixLastCostUpdateUser
    /*
    	    ixLastCost  ixLastCost
    Qty     UpdateDate	UpdateUser
    1791	NULL	    NULL
    6309	17645	    PSG
    */

    SELECT * FROM [SMI Reporting].dbo.tblBOMTemplateMaster  where ixLastCostUpdateDate is NOT NULL OR ixLastCostUpdateTime is NOT NULL OR ixLastCostUpdateUser is NOT NULL
    
    SELECT * FROM [SMI Reporting].dbo.tblBOMTemplateMaster
    where ixFinishedSKU = '2010201'
    
    SELECT * FROM [SMI Reporting].dbo.tblBOMTemplateMaster  where dtDateLastSOPUpdate < '04/29/2016' and flgDeletedFromSOP = 0
    
--    SELECT TOP 6000 * FROM [SMI Reporting].dbo.tblBOMTemplateMaster  where ixCreator is NULL order BY NEWID()
    
    SELECT * from [SMI Reporting].dbo.tblBOMTemplateMaster 
    where ixLastCostUpdateDate is NOT NULL OR ixLastCostUpdateTime is NOT NULL OR ixLastCostUpdateUser is NOT NULL

-- AFCO
    SELECT TOP 10 * FROM [AFCOReporting].dbo.tblBOMTemplateMaster 
    
    select TOP 100 * from [AFCOReporting].dbo.tblBOMTemplateMaster 
    where dtDateLastSOPUpdate between '04/11/2016' and '04/22/2016'
    
    select * from [AFCOReporting].dbo.tblBOMTemplateMaster 
    where dtDateLastSOPUpdate = '04/11/2016'

    select * from [AFCOReporting].dbo.tblBOMTemplateMaster 
    WHERE ixFinishedSKU in ('0000015','0000019','0000019.00','0000019.01','0000020','0000020.01','0000021','0000021.01','0000022','0000022.01','0000023','0000023.01','0000024','0000024.01','0000038','0000038B','0000039','0000039R','0000040','0000041','0000044','0000044.01','0000045','0000045.01','0000046','0000050','0000051','0000051.01','0000056','0000067','0000068','0000069','0000070','0000071','0000072','0000073','0000076','0000085','0000086','0000087','0000088','0000089','0000090','0000091','0000092','0000093','0000096','0000097','0000098','0000099','0000100','0000101','0000101.01','0000102','0000102.01','0000102B','0000103','0000103B','0000110','0000111','0000112','0000112.01','0000113','0000113.01','0000117.06','0000117.07','0000117.08','0000117.09','0000117.50','0000117.60','0000117.70','0000117.80','0000117.90','0000118.05','0000118.06','0000118.062','0000118.07','0000118.08','0000118.082','0000118.09','0000118.50','0000118.60','0000118.62','0000118.70','0000118.80','0000118.82','0000118.90','0000120','0000121','0000122','0000123','0000124','0000127','0000128','0000129','0000130','0000131','0000132','0000133','0000135')
    order by dtDateLastSOPUpdate 

    SELECT count(*) 'Qty',
        ixLastCostUpdateDate, ixLastCostUpdateTime, ixLastCostUpdateUser
    FROM [AFCOReporting].dbo.tblBOMTemplateMaster 
    GROUP BY ixLastCostUpdateDate, ixLastCostUpdateTime, ixLastCostUpdateUser
    ORDER BY ixLastCostUpdateDate, ixLastCostUpdateTime, ixLastCostUpdateUser
    /*
    	    ixLastCost  ixLastCost  ixLastCost
    Qty     UpdateDate	UpdateTime	UpdateUser
    22990	NULL	    NULL	    NULL
    */
    
    SELECT * FROM [AFCOReporting].dbo.tblBOMTemplateMaster  where ixLastCostUpdateDate is NOT NULL OR ixLastCostUpdateTime is NOT NULL OR ixLastCostUpdateUser is NOT NULL

    SELECT count(*) from [AFCOReporting].dbo.tblBOMTemplateMaster -- 22,990


select dtDateLastSOPUpdate, count(*)
from [AFCOReporting].dbo.tblBOMTemplateMaster 
where dtDateLastSOPUpdate >= '04/11/2016'
group by dtDateLastSOPUpdate
order by group by dtDateLastSOPUpdate


*/