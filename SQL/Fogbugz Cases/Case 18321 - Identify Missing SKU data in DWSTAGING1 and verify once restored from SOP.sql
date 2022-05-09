-- Case 18321 - Identify Missing SKU data in DWSTAGING1 and verify once restored from SOP

/**** RUN ON LNK-DWSTAGING1  ****/




-- SKU TRANS DETAILS
select ST.* 
from tblSKUTransaction ST
    join [SMITemp].dbo.PJC_BiffedSKUsToRestore BS on ST.ixSKU = BS.ixSKU 
where (ST.ixDate = 16538                            -- Thursday 04/11/2013   418 Transactions
      OR (ST.ixDate = 16539  and ST.ixTime < 32400) -- Fri 04/11/2013 before 9AM     
AND sTransactionType NOT IN 
    ('XXX','XXX','XXX','XXX','XXX',
     'XXX','XXX','XXX','XXX','XXX',
--     'XXX','XXX','XXX','XXX','XXX',     
--     'XXX','XXX','XXX','XXX','XXX',     
--     'XXX','XXX','XXX','XXX','XXX',     
     )   
order by sTransactionType, ixDate, ixTime





-- COUNTS by Trans Type of what is remaining
select ST.sTransactionType, count(*) TransCount
from tblSKUTransaction ST
    join [SMITemp].dbo.PJC_BiffedSKUsToRestore BS on ST.ixSKU = BS.ixSKU 
where (ST.ixDate = 16538                            -- Thursday 04/11/2013   418 Transactions
      OR (ST.ixDate = 16539  and ST.ixTime < 32400) -- Fri 04/11/2013 before 9AM              
       )                                                                            
AND sTransactionType NOT IN 
    ('BOMC','BXFER','FHC','MISC','OC','OR','ORB','QHC','UQHC'
--     'XXX','XXX','XXX','XXX','XXX',   
--     'XXX','XXX','XXX','XXX','XXX',     
--     'XXX','XXX','XXX',  
     )   
group by ST.sTransactionType                                                                                   
order by TransCount desc

/***** output

Trans   Trans
Type	Count
I	    48
T	    30
PC	    8
ICS	    7
M	    6
BOM	    5
QC	    2
R	    2
IB	    2
IS	    1
P	    1
PQRUP	1
RSTKCC	1

*/



          

                                                      