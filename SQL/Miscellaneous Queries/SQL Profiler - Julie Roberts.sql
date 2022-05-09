-- SQL Profiler - Julie Roberts

/* TABLES
    [SMITemp].dbo.JulieRoberts11202014
    [SMITemp].dbo.JulieRoberts11212014
    [SMITemp].dbo.JulieRoberts11252014    
    [SMITemp].dbo.JulieRoberts12012014      
*/  
select * 
from [SMITemp].dbo.JulieRoberts11262014
where 
    Reads is NOT NULL 
   -- and (TextData like 'S%' or TextData like 's%')
    -- and RowNumber >= 52  
order by StartTime desc -- 29 rows

select * 
from [SMITemp].dbo.AmandaLittle11262014
where Reads is NOT NULL 
    
-- Exec [Util].dbo.usp_who5 X,NULL,jmroberts,NULL,NULL     
/*
	@Filter   : Limit the result set by passing one or more values listed below (can be combined in any order)
		A - Active sessions only
		B - Blocked sessions only
		C - Exclude "SQL_Statement_Batch", "SQL_Statement_Current", "Batch_Pct", and "Query_Plan_XML" columns from the output (less resource-intensive)
		X - Exclude system reserved SPIDs (1-50)
	@SPID     : Limit the result set to a specific session
	@Login    : Limit the result set to a specific Windows user name (if populated, otherwise by SQL Server login name)
	@Database : Limit the result set to a specific database
	@SQL_Text : Limit the result set to SQL statements containing specific text (ignored when "@Filter" parameter contains "C")
*/
-- DROP table [SMITemp].dbo.JulieRoberts11262014


/*  queries run by Julie 11/18/14 to 11/20/14
select  *  from  dbo.tblVendorSKU  where  dbo.tblVendorSKU.ixVendor = '5302'
select  *  from  tblSKU
select  *  from  tblOrder
select  *  from  tblOrder  where  tblOrder.dtOrderDate between '01/04/14' and '11/19/14'
select  *  from  tblOrderLine  where  tblOrderLine.dtOrderDate between '01/04/14' and '11/19/14'  and  tblOrderLine.flgLineStatus = 'backorder'   -- INVALID
select  *  from  tblOrderLine  where  tblOrderLine.dtOrderDate between '01/04/14' and '11/19/14'  and  tblOrderLine.flgLineStatus = 'backordered'  -- INVALID
select  *  from  tblOrderLine  where  tblOrderLine.dtOrderDate between '01/04/14' and '11/19/14'    
select  *  from  tblOrderLine  where  tblOrderLine.dtOrderDate between '01/04/14' and '11/19/14'  and  tblOrderLine.flgLineStatus = 'Backordered'  
select  *  from  tblOrderLine  where  tblOrderLine.dtOrderDate between '01/04/14' and '11/19/14'  and  tblOrderLine.flgLineStatus = 'Shipped'  
select  *  from  tblOrderLine  where  tblOrderLine.dtOrderDate between '01/04/14' and '11/19/14'  and  tblOrderLine.flgLineStatusin 'Shipped'  -- INVALID
select  *  from  tblOrderLine  where  tblOrderLine.dtOrderDate between '01/04/14' and '11/19/14'  and  tblOrderLine.flgLineStatus in 'Shipped'  
select  *  from  tblOrderLine  where  tblOrderLine.dtOrderDate between '01/04/14' and '11/19/14'  and  tblOrderLine.flgLineStatus in 'Backordered'  -- INVALID 
select  *  from  tblOrderLine  where  tblOrderLine.dtOrderDate between '01/04/14' and '11/19/14'  and  tblOrderLine.flgLineStatus in ('Backordered')  
select  *  from  tblOrder  where  tblOrder.dtOrderDate between '01/04/14' and '11/19/14'   
select  *  from  dbo.tblVendorSKU  where  dbo.tblVendorSKU.ixVendor = '5181'
+
18 queries like the following....
    select   tblSKU.ixSKU as 'SKU',   tblSKU.sDescription as 'Description',   tblSKU.ixPGC as 'Product Group Code',   sum(tblOrderLine.iQuantity) as 'Quantity Sold',   
    sum(tblOrderLine.mExtendedPrice) as 'Extended Price',   sum(tblOrderLine.mExtendedCost) as 'Extended Cost'  
    from   tblOrderLine   right join tblSKU on tblOrderLine.ixSKU = tblSKU.ixSKU   left join tblOrder on tblOrderLine.ixOrder = tblOrder.ixOrder   
    left join tblSourceCode on tblOrder.sSourceCodeGiven = tblSourceCode.ixSourceCode  
    where....   
                tblSKU.ixPGC = 'FC'   
                tblSKU.ixPGC = 'EC'                                   
                tblSKU.ixSKU like '66%'   and  tblSKU.ixPGC = 'EM'    
                tblSKU.ixPGC = 'FC'                                   
                tblSKU.ixPGC = 'EC'                                   
                tblSKU.ixSKU like '66%'   and   tblSKU.ixPGC = 'EM'  
                tblSKU.ixPGC = 'FC'                                   
                tblSKU.ixPGC = 'EC'                                   
                tblSKU.ixSKU like '66%'   and   tblSKU.ixPGC = 'EM' 
                tblSKU.ixPGC = 'FC'                                   
                tblSKU.ixPGC = 'EC'                                   
                tblSKU.ixSKU like '66%'   and   tblSKU.ixPGC = 'EM'  
                tblSKU.ixPGC = 'FC'                                   
                tblSKU.ixPGC = 'EC'                                   
                tblSKU.ixPGC = 'ec'                                   
                tblSKU.ixPGC = 'EC'          
                tblSKU.ixPGC = 'Jq'   
    and   tblOrderLine.flgLineStatus = 'Shipped' 
    and   tblOrderLine.dtShippedDate between <date> and <date>
    AND tblOrderLine.flgLineStatus IN ('Shipped', 'Dropshipped')
    group by   tblSKU.ixSKU,   tblSKU.sDescription,   tblSKU.ixPGC 

11-24-2014
select  *  from  dbo.tblCreditMemoMaster  where  dbo.tblCreditMemoMaster.dtCreateDate = '11/23/14'  
select  *  from  tblOrder  where  tblOrder.dtShippedDate between '03/07/14' and '11/21/14'  
select  *  from  tblCustomer  
select  *  from  tblOrder  where  tblOrder.ixOrder = '742571'  
select  *  from  tblOrder  where  tblOrder.ixOrder = '742569'  
select  *  from  tblOrder  where  tblOrder.ixOrder = '742572'  
select  *  from  tblOrder  where  tblOrder.ixOrder = '742574'  
select  *  from  tblOrder  where  tblOrder.ixOrder = 'q178416'  
select  *  from  tblOrder  where  tblOrder.ixOrder = '742567'  
select    *  from  tblSKU  


11-25-2014
select  *  from  tblOrderLine  where  tblOrderLine.ixOrder = '742571'
select  *  from  tblOrderLine  where  tblOrderLine.ixOrder = '742569'
select  *  from  tblOrderLine  where  tblOrderLine.ixOrder = '742572'
select  *  from  tblOrderLine  where  tblOrderLine.ixOrder = '742574'
select  *  from  tblOrderLine  where  tblOrderLine.ixOrder = 'Q178416'
select  *  from  tblOrderLine  where  tblOrderLine.ixOrder = '742567'
select  *  from  tblOrderLine  where  tblOrderLine.ixOrder = '742567'
select  *  from  dbo.tblCreditMemoMaster  where  dbo.tblCreditMemoMaster.dtCreateDate = '11/24/14'  
select  *  from  tblOrder  where  tblOrder.dtShippedDate = '11/24/14'  
select  *  from  tblCustomer  
SELECT S.ixSKU        ,S.sDescription        ,S.ixPGC  --    ,SL.ixLocation  --    ,SL.iQOS --AS 'QOStblSKULoc.'        ,SL.iQAV --AS 'QAVtblSKULoc.'  FROM tblSKU S      JOIN tblSKULocation SL ON SL.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS= S.ixSKU  COLLATE SQL_Latin1_General_CP1_CS_AS  WHERE SL.ixLocation = '99' --ixLocation '68' not needed (SMI inventory counts)   ORDER BY S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS    
select  *  from  tblSKU
select  *  from  tblOrderLine  where  tblOrderLine.ixOrder = '742844'
SELECT S.ixSKU        ,S.sDescription        ,S.ixPGC  --    ,SL.ixLocation  --    ,SL.iQOS --AS 'QOStblSKULoc.'        ,SL.iQAV --AS 'QAVtblSKULoc.'  FROM tblSKU S      JOIN tblSKULocation SL ON SL.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS= S.ixSKU  COLLATE SQL_Latin1_General_CP1_CS_AS  WHERE SL.ixLocation = '99' --ixLocation '68' not needed (SMI inventory counts)   ORDER BY S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS  

11-26-2014
select    *  from  tblSKU  


*/





/*
                                    Non-IT
            Aprox                   Users with
            Emps    Sales           SQL access
            =====   ===========     ==========
AFCO        80                      1-3?
SPEEDWAY    350     6-7 x Afco's     0
*/