-- SMIHD-10450 - guaranteed shipping success rate by trailer

-- SUMMARY BY DAY OF WEEK
-- used to populate columns A thru M on initial results xls file
select D.sDayOfWeek, COUNT(*) total 
from tblOrder O
    join tblDate D on D.ixDate = O.ixOrderDate    
where O.flgDeliveryPromiseMet = '1'  -- RUN QUERY AGAIN BUT SWAP FLAG VALUE
    and O.ixOrderDate between 17727 and 18322 -- '17697'
group by D.sDayOfWeek
order by D.sDayOfWeek 


-- SUMMARY BY DAY OF WEEK AND TRAILER
-- used to populate columns P thru U on initial results xls file
select D.sDayOfWeek, P.ixTrailer, COUNT(Distinct O.ixOrder) OrderCnt 
from tblOrder O
    join tblDate D on D.ixDate = O.ixOrderDate
    join tblPackage P on O.ixOrder = P.ixOrder   
where O.flgDeliveryPromiseMet = '1'  -- RUN QUERY AGAIN BUT SWAP FLAG VALUE
    and O.ixOrderDate between 17727 and 18322 -- '17697'
group by D.sDayOfWeek, P.ixTrailer
order by D.sDayOfWeek, P.ixTrailer 


-- SUMMARY BY TRAILER
-- used to populate SUMMARY values for columns P thru U on initial results xls file
select P.ixTrailer, COUNT(Distinct O.ixOrder) OrderCnt
from tblOrder O
    join tblDate D on D.ixDate = O.ixOrderDate
    join tblPackage P on O.ixOrder = P.ixOrder   
where O.flgDeliveryPromiseMet = '1'  -- RUN QUERY AGAIN BUT SWAP FLAG VALUE
    and O.ixOrderDate between 18351 and 18357 -- 03/29/2018-04/04/2018
group by P.ixTrailer
order by P.ixTrailer 


