-- SMIHD-20208 - Unpulled CID Transfers report

-- report showing CIDs transferred 3 weeks ago 
-- to a non-99 location 
-- that didn't get put away


/*** CIDS transferred 3 weeks ago to a non-99 location
        that didn't get put away                     ***/
select ixOrder 'Order', iOrdinality, 
        sCIDRestockType 'CIDRestockType', 
        dtCreated 'Created', ixCreatedUser 'CreatedBy', dtLastChanged 'LastChanged', ixLastChangedUser 'LastChangedBy',
        ixSKU 'SKU',	iQuantityRequested 'QtyRequested', iQuantityPulled 'QtyPulled',	sPullType 'PullType', sCID 'CID',
        ixFromLocation 'FromLoc',	ixToLocation 'ToLoc',
        sPullStatus 'PullStatus', flgArchived --	dtDateLastSOPUpdate	ixTimeLastSOPUpdate
from tblRestockTransactions
where ixToLocation <> 99
    and dtCreated between '09/23/2021' and '09/30/2021'   --< '09/27/21' -- 3+ weeks old.   Check with Korth does he want 3+ weeks or a range like 3-4 weeks old.
    and sPullType = 'CID'
    and sPullStatus NOT IN ('AS','PL') -- Auto-Skip, Pulled.  Currently excludes NULL
 -- and sCIDRestockType in ?
 -- and iQuantityPulled < iQuantityRequested    <- Not needed because sPullStatus would be 'PL' if they are equal right?
order by ixOrder, iOrdinality



select distinct sPullType
from tblRestockTransactions
where ixToLocation <> 99
    --CID
    --Pick

select distinct sCIDRestockType
from tblRestockTransactions
where ixToLocation <> 99
    and sPullType = 'CID' -- 65k

NULL
AZ2
AZD
AZN
AZU
IN8
ING
INN
WVM
WVN
WVW

select sCIDRestockType, count(*)
from tblRestockTransactions
group by sCIDRestockType


select distinct sPullStatus
from tblRestockTransactions
where ixToLocation <> 99
    --AS
    --PL
    --SB
    --SK

