select distinct (ixCreditMemo)  -- 42  (F10121 to F-10164 except F-10163 and F-10156)
from [AFCOTemp].dbo.PJC_17569_AFCO_CreditMemoSNAFU


select distinct (ixOrder) -- 108  (F10121 to F-10164 except F-10163 and F-10156)
from [AFCOTemp].dbo.PJC_17569_AFCO_OrderSNAFU

select * from [AFCOReporting].dbo.tblOrder O
    join [AFCOTemp].dbo.PJC_17569_AFCO_OrderSNAFU JUNK on O.ixOrder collate Latin1_General_CS_AS = JUNK.ixOrder collate Latin1_General_CS_AS
    

select * from [AFCOReporting].dbo.tblOrderLine O
    join [AFCOTemp].dbo.PJC_17569_AFCO_OrderSNAFU JUNK on O.ixOrder collate Latin1_General_CS_AS = JUNK.ixOrder collate Latin1_General_CS_AS
    


select sum(mMerchandise) -- 108 Orders with $198,937.29 Total Sales
from [AFCOReporting].dbo.tblOrder O
    join [AFCOTemp].dbo.PJC_17569_AFCO_OrderSNAFU JUNK on O.ixOrder collate Latin1_General_CS_AS = JUNK.ixOrder collate Latin1_General_CS_AS   

select sum(mMerchandise) -- $55,062.50 of the orders are to account 34795 'SPEEDWAY MOTORS INC.'
from [AFCOReporting].dbo.tblOrder O
    join [AFCOTemp].dbo.PJC_17569_AFCO_OrderSNAFU JUNK on O.ixOrder collate Latin1_General_CS_AS = JUNK.ixOrder collate Latin1_General_CS_AS   
where O.ixCustomer = '34795' 

select * from [AFCOReporting].dbo.tblCustomer where ixCustomer = '34795'


select sum(mMerchandise) -- 42 Credit Memos $45,001.12 Total Credits
    from [AFCOReporting].dbo.tblCreditMemoMaster CMM
    join [AFCOTemp].dbo.PJC_17569_AFCO_CreditMemoSNAFU JUNKCM on CMM.ixCreditMemo collate Latin1_General_CS_AS = JUNKCM.ixCreditMemo collate Latin1_General_CS_AS   

select sum(mMerchandise) -- $66.26 of the Credit Memos are to account 34795 'SPEEDWAY MOTORS INC.'
    from [AFCOReporting].dbo.tblCreditMemoMaster CMM
    join [AFCOTemp].dbo.PJC_17569_AFCO_CreditMemoSNAFU JUNKCM on CMM.ixCreditMemo collate Latin1_General_CS_AS = JUNKCM.ixCreditMemo collate Latin1_General_CS_AS        
where CMM.ixCustomer = '34795'     
    



select O.* -- 198,937.29 Total Sales
from [AFCOReporting].dbo.tblOrder O
    join [AFCOTemp].dbo.PJC_17569_AFCO_OrderSNAFU JUNK on O.ixOrder collate Latin1_General_CS_AS = JUNK.ixOrder collate Latin1_General_CS_AS   
    
select O.sSourceCodeGiven, count(O.ixOrder)
from [AFCOReporting].dbo.tblOrder O
    join [AFCOTemp].dbo.PJC_17569_AFCO_OrderSNAFU JUNK on O.ixOrder collate Latin1_General_CS_AS = JUNK.ixOrder collate Latin1_General_CS_AS       
group by O.sSourceCodeGiven

select O.sSourceCodeGiven, count(O.ixOrder) OrdCount
from [AFCOReporting].dbo.tblOrder O
    where O.ixOrder collate Latin1_General_CS_AS in (select ixOrder from [AFCOTemp].dbo.PJC_17569_AFCO_OrderSNAFU)       
group by O.sSourceCodeGiven
/*
AFAB12	5
PRO13	51
PRO513	52
*/


select * from [AFCOReporting].dbo.tblSourceCode
where ixSourceCode in ('AFAB12','PRO13','PRO513')

select CMM.* -- 45,001.12 Total Credits
    from [AFCOReporting].dbo.tblCreditMemoMaster CMM
    join [AFCOTemp].dbo.PJC_17569_AFCO_CreditMemoSNAFU JUNKCM on CMM.ixCreditMemo collate Latin1_General_CS_AS = JUNKCM.ixCreditMemo collate Latin1_General_CS_AS 
   
   
   
        
[AFCOTemp].dbo.PJC_17569_AFCO_CreditMemoSNAFU 
[AFCOTemp].dbo.PJC_17569_AFCO_OrderSNAFU 