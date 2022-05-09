-- Case 25366 - create email list for Street and Race opt-outs

select distinct ixMarket from  tblMailingOptIn
/*
2B
AD
R
SM
SR
*/

select distinct sOptInStatus from tblMailingOptIn
N
UK
Y

/******************   STREET    *********************/
    -- DROP TABLE  [SMITemp].dbo.PJC_25366_StreetOptouts
    select distinct C.ixCustomer, MO.ixMarket, MO.sOptInStatus, C.sEmailAddress -- 3,785
    into [SMITemp].dbo.PJC_25366_StreetOptouts
    from tblMailingOptIn MO
    join tblCustomer C on C.ixCustomer = MO.ixCustomer
        and MO.ixMarket = 'SR'
        and sOptInStatus = 'N'
        and C.sEmailAddress is NOT NULL
        and C.flgDeletedFromSOP = 0 -- 3800
        and C.sEmailAddress NOT like '%SPEEDWAYMOTORS.COM'
        --AND C.sEmailAddress LIKE '%NONE%'
    order by sEmailAddress

    select COUNT(ixCustomer) Cust, COUNT(distinct(sEmailAddress)) DistEmail
    from [SMITemp].dbo.PJC_25366_StreetOptouts
    /*
    Cust	DistEmail
    3785	3779
    */

select * from  [SMITemp].dbo.PJC_25366_StreetOptouts

/******************   RACE    *********************/
-- temp table for Race opt-outs
-- DROP TABLE [SMITemp].dbo.PJC_25366_RaceOptouts
    select distinct C.ixCustomer, MO.ixMarket, MO.sOptInStatus, C.sEmailAddress -- 9,654
    into [SMITemp].dbo.PJC_25366_RaceOptouts
    from tblMailingOptIn MO
    join tblCustomer C on C.ixCustomer = MO.ixCustomer
        and MO.ixMarket = 'R'
        and sOptInStatus = 'N'
        and C.sEmailAddress is NOT NULL
        and C.flgDeletedFromSOP = 0 -- 3800
        and C.sEmailAddress NOT like '%SPEEDWAYMOTORS.COM'
        --AND C.sEmailAddress LIKE '%NONE%'
    order by sEmailAddress

    select COUNT(ixCustomer) Cust, COUNT(distinct(sEmailAddress)) DistEmail
    from [SMITemp].dbo.PJC_25366_RaceOptouts
    /*
    Cust	DistEmail
    9654	9636
    */

select * from  [SMITemp].dbo.PJC_25366_RaceOptouts


