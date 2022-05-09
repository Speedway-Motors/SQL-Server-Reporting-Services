-- Case 17650 - AFCO mailing addresses for Proshock accounts
select distinct C.ixCustomer -- 273 just for C.ixSourceCode check... only 2 additional for O.C275
from tblCustomer C
where C.ixSourceCode in ('PRO13','PRO513')
  OR C.ixCustomer in (select distinct ixCustomer from tblOrder 
                      where sSourceCodeGiven in ('PRO13','PRO513')
                        OR  sMatchbackSourceCode in ('PRO13','PRO513')
                      )

-- SEE IF JULIE WANTS THE TWO CUSTOMERS BELOW TO BE INCLUDED IN THE LIST OF ADDRESSES
-- THEN SEND THE CUSTOMER NUMBERS TO CHRIS AND ASK HIM TO GENERATE THE FILE
select * from tblCustomer
where ixCustomer in ('11050', '33730')
-- Per Julie, add 33730 to the list