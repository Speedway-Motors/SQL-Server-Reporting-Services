-- SMIHD-4537 - AFCO Order Transfer times

 
 select * from tblOrderRouting 
 where  ixOrder = '776003'
 -- ixOrder = '776278'
 
 
 
 -- finding example order to follow SKU flow
  select OL.ixOrder, OL.ixSKU, S.sDescription
 from tblOrderLine OL
 join tblSKU S on OL.ixSKU = S.ixSKU
 where flgLineStatus = 'Shipped'
 and ixShippedDate = 17671
 and UPPER(S.sDescription) like '%RADIATOR%'
 /*
ixOrder	ixSKU	        sDescription
776003	80110MC	        RADIATOR MATERIAL CHARGE
776003	80008-NA	    CUSTOM RADIATOR DOUBLE PASS
776003	RADIATORTICKET	RADIATOR BUILD TICKET
*/
 
select * from tblOrder where ixOrder = '776003'
select * from tblOrderLine where ixOrder = '776003'

 select D.dtDate, T.chTime, 
    ST.sUser, ST.iSeq, 
    ST.sTransactionType, TT.sDescription 'TransDescr', ST.ixSKU, ST.iQty, ST.sTransactionInfo,
    ST.sWarehouse, ST.sToWarehouse, ST.sBin, ST.sToBin, ST.sCID, ST.sGID, ST.sToGID
 from tblSKUTransaction ST
    join tblDate D on ST.ixDate = D.ixDate
    join tblTime T on ST.ixTime = T.ixTime
    join tblTransactionType TT on TT.ixTransactionType = ST.sTransactionType
 where ST.ixDate between 17669 and 17671-- order 776003 placed on 17669  shipped 17671
     and ixSKU = '80008-NA' -- in ('80110MC','80008-NA')
 --    and sTransactionInfo like '%776003%'
 order by D.dtDate, T.chTime

 

 SELECT * FROM tblTransactionType
 where ixTransactionType in ('FHC','QHC','I','OR')

