                     select OL.ixCustomer,
                            count(distinct OL.ixOrder) OrdCount,
                            SUM(OL.iQuantity*CAST(OL.mUnitPrice as Money)) Sales,
                            SUM(OL.mExtendedCost) Cost,
                            SUM((OL.mUnitPrice-OL.mCost)* CAST(OL.iQuantity as Money)) GP
                     from tblOrder O 
                        join tblOrderLine OL on OL.ixOrder = O.ixOrder 
                                and OL.flgLineStatus IN ('Shipped','Dropshipped')
                                and OL.dtShippedDate >= '01/01/2011' -- @StartDate
                                and OL.dtShippedDate < '02/01/2011'  --(@EndDate+1)
                                and flgKitComponent = 0
                        left join tblDate D on D.dtDate = OL.dtShippedDate 
                        left join tblCustomer C on C.ixCustomer = OL.ixCustomer
                        where C.ixAccountManager in ('DMH','GGL') -- (@AccountManager)
                     group by OL.ixCustomer
                     order by OL.ixCustomer


                     select O.ixCustomer,
                            count(distinct O.ixOrder)                OrdCount,
                            SUM(O.mMerchandise)                      Sales,
                            SUM(O.mMerchandiseCost)                  Cost,
                            SUM(O.mMerchandise-O.mMerchandiseCost)   GP
                     from   tblOrder O 
                        left join tblDate D on D.dtDate = O.dtShippedDate 
                        left join tblCustomer C on C.ixCustomer = O.ixCustomer
                     where    C.ixAccountManager in ('DMH','GGL') -- (@AccountManager)
                        and O.sOrderStatus = 'Shipped' 
                        and O.dtShippedDate >= '01/01/2011' -- @StartDate
                        and O.dtShippedDate < '02/01/2011'  --(@EndDate+1)
                     group by O.ixCustomer
                     order by O.ixCustomer




select * from tblOrder O
where O.ixCustomer = '670779'
                        and O.dtShippedDate >= '01/01/2011' -- @StartDate
                        and O.dtShippedDate < '02/01/2011'  --(@EndDate+1)


