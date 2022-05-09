-- MP-6743 Follow up - non-buyers decelerating list
-- truncate table [SMITemp].dbo.PJC_MP6743_Covid_nonbuyers_decelerating 
SELECT NB.*, C.sEmailAddress
FROM [SMITemp].dbo.PJC_MP6743_Covid_nonbuyers_decelerating NB-- 42,707
    left join tblCustomer C on C.ixCustomer = NB.customerid
ORDER BY covidscore, customerid



