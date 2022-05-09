-- DSOTHER-16 - Phone Orders that have Shipped

-- looking for commonality for orders involving failure of email confirmation 
select * from tblOrder where ixOrder in ('5347247',
'5375440',
'5346547',
'5367246',
'5348147')

select * from tblOrderLine where ixOrder in ('5347247',
'5375440',
'5346547',
'5367246',
'5348147')

-- SKUs from above orders
select * from tblSKU
where ixSKU in ('DLR', '582SM300C', '91043800', '91631949', '91031520', '6178515', '91104015', '91132056', '6178520', '7024853', '6178516', 
    '91015616', '6178513', '6178525', '91134001', '91089408', '9105246-POL', '91631991', '91031428', '91031435', '91070057', '91631903', '91065390', 
    '91031035-L', '91031035-R', '8352300542', '9193382', '912TLM11949', '91031071', '6178568', '6173513', '91031311', '910616004', '91088356-99', 
    '91002006', '91033323-1', '91632029', '91635000', '91645110', '91032104', '91031942', 'TECHELP-BLK', 'HC5HCSF-.50-2.50', 'HC8HLNF-.50', 
    'HCTHFW-USS-.44', '91635062', '91033027', '665280EA', '91017134', '665279A', 'INS1099', '91036095', '91036096', '91046221')



-- DETAILED INFO TO GIVE TO KARA
-- Wednesday
select O.ixOrder, -- 25 Orders
    CONVERT(VARCHAR, O.dtOrderDate, 101)  'OrderDate',
    T.chTime 'OrderTime', 
    C.sEmailAddress
    ,O.sShipToCountry
    ,O.iShipMethod
    ,O.sMethodOfPayment
    ,O.mMerchandise
    ,O.sOrderStatus
    ,O.sOrderChannel
    ,CONVERT(VARCHAR, O.dtShippedDate, 101) 'ShippedDate'
    ,(Case 
        when ixOrderType = 'MRR' then ixOrderType
        when ixOrderType = 'PRS' then ixOrderType
        else 'Retail'
      end  ) 'OrderType'
from tblOrder O
    join tblCustomer C on O.ixCustomer = C.ixCustomer
    join tblTime T on O.ixOrderTime = T.ixTime
where O.dtOrderDate >= '12/12/2013'
and O.ixOrderTime > 43200 -- noon                 64800 -- 6PM
and O.sOrderStatus = 'Shipped'
and O.sOrderChannel = 'PHONE'
and O.iShipMethod <> 1 -- excluding Counter orders
and C.sEmailAddress is NOT NULL

UNION 

-- Tues placed 6PM+
select O.ixOrder, -- 25 Orders
    CONVERT(VARCHAR, O.dtOrderDate, 101)  'OrderDate',
    T.chTime 'OrderTime', 
    C.sEmailAddress
    ,O.sShipToCountry
    ,O.iShipMethod
    ,O.sMethodOfPayment
    ,O.mMerchandise
    ,O.sOrderStatus
    ,O.sOrderChannel    
    ,CONVERT(VARCHAR, O.dtShippedDate, 101) 'ShippedDate'
    ,(Case 
        when ixOrderType = 'MRR' then ixOrderType
        when ixOrderType = 'PRS' then ixOrderType
        else 'Retail'
      end  ) 'OrderType'
from tblOrder O
    join tblCustomer C on O.ixCustomer = C.ixCustomer
    join tblTime T on O.ixOrderTime = T.ixTime
where O.dtOrderDate = '12/10/2013'
and O.ixOrderTime > 64800 -- 6PM
and O.sOrderStatus = 'Shipped'
and O.sOrderChannel <> 'PHONE'
and O.iShipMethod <> 1 -- excluding Counter orders
and C.sEmailAddress is NOT NULL
/*
group by O.ixOrder, -- 25 Orders
    O.dtOrderDate, 
    T.chTime, 
    C.sEmailAddress
*/    

order by O.dtOrderDate, T.chTime



C.sEmailAddress




select * from tblTime where chTime like '12:00%'


select * from tblOrderLine where ixOrder = '5316746'

