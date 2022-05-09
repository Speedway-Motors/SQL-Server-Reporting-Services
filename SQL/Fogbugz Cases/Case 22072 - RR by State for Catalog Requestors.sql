-- Case 22072 - RR by State for Catalog Requestors

select ixSourceCode 'SCode', ixCatalog 'Cat', sDescription 'SourceCodeDescription          ', 
    iQuantityPrinted 'QtyPrinted', iExpectedNumberOfOrders 'OrdsExpected'
from tblSourceCode 
where ixSourceCode in ('37370','37371','37372','37373')
/*
SCode	Cat	SourceCodeDescription	            QtyPrinted	OrdExpected
37370	373	12M Requestors 50% Gift Card	    23500	    125
37371	373	12M Requestors $7.99 FR Shipping    23600	    150
37372	373	18M Requestors 50% Gift Card	    13388	    150
37373	373	18M Requestors $7.99 FR Shipping	13368	    150
*/


-- SENT
select ixSourceCode, count(*) QtySent
from tblCustomerOffer
where ixSourceCode in ('37370','37371','37372','37373')
group by ixSourceCode
Order by ixSourceCode

/*
Source  Qty
Code	Sent
37370	24972
37371	24972
37372	14248
37373	14249LOL
*/
    -- SENT BY STATE
    SELECT C.sMailToState, CO.ixSourceCode, count(*) QtySent
    from tblCustomerOffer CO
        join tblCustomer C on CO.ixCustomer = C.ixCustomer
        join tblStates S on S.ixState = C.sMailToState
    where CO.ixSourceCode in ('37370','37371','37372','37373')
        and S.flgMilitary = 0
        and S.flgUSTerritory = 0
    group by CO.ixSourceCode,C.sMailToState
    Order by CO.ixSourceCode,C.sMailToState


-- Cust count based on Matchback SC 
-- EVEN IF they didn't receicve the offer!
select  C.sMailToState,O.sMatchbackSourceCode SC_MB,-- sMatchbackSourceCode, 
    count(distinct O.ixCustomer) CustCount
from tblOrder O
        join tblCustomer C on O.ixCustomer = C.ixCustomer
        join tblStates S on S.ixState = C.sMailToState
where sMatchbackSourceCode in ('37370','37371','37372','37373')
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
group by sMatchbackSourceCode,C.sMailToState
order by sMatchbackSourceCode,C.sMailToState
/*
37370	276
37371	365
37372	92
37373	96
*/


-- Cust count based on Matchback SC
-- ONLY IF they receicved the offer!
select sMatchbackSourceCode SC_MB,-- sMatchbackSourceCode, 
    count(distinct O.ixCustomer) CustCount
from tblOrder O
    join tblCustomerOffer CO on O.ixCustomer = CO.ixCustomer and CO.ixSourceCode = O.sMatchbackSourceCode
        join tblCustomer C on CO.ixCustomer = C.ixCustomer
        join tblStates S on S.ixState = C.sMailToState    
where sMatchbackSourceCode in ('37370','37371','37372','37373')
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
group by sMatchbackSourceCode
order by sMatchbackSourceCode

    -- ONLY IF they receicved the offer!
    -- BY STATE
    select C.sMailToState, 
        O.sMatchbackSourceCode SC_MB,-- sMatchbackSourceCode, 
        count(distinct O.ixCustomer) CustCount
    from tblOrder O
        join tblCustomerOffer CO on O.ixCustomer = CO.ixCustomer and CO.ixSourceCode = O.sMatchbackSourceCode
    where sMatchbackSourceCode in ('37370','37371','37372','37373')
        and O.sOrderStatus = 'Shipped'
        and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
        and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
        and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    group by sMatchbackSourceCode
    order by sMatchbackSourceCode

/*
-- Cust count based on SC Given
select sSourceCodeGiven SC_Given,-- sMatchbackSourceCode, 
    count(distinct ixCustomer) CustCount
from tblOrder O
where sSourceCodeGiven in ('37370','37371','37372','37373')
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
group by sSourceCodeGiven
order by sSourceCodeGiven
/*
SC_Given CustCount
37370	152
37371	218
37372	60
37373	53
*/
*/