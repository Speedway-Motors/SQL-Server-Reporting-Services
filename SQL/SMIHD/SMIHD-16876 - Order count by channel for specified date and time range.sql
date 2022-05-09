-- SMIHD-16876 - Order count by channel for specified date and time range

how many orders were submitted into SOP last Monday, 2/17/20, through from Midnight to 11:30am 
and how many of those were through the WEB channel?

We will probably ask for another run of the same data from last week, just a different end-time, to take another reading on how this day is looking compared to last week.


We made a change to the call flow that is requiring customers to make a choice out of three options before they will be able to reach a live person. 
 We have seen about a 30% drop in call volume compared to last Monday through 11:30am and I want to see if that has affected the number of orders we are keying in (non-web).




 select ixOrder, sOrderChannel--, count(*)
 from tblOrder O
 where O.dtOrderDate = '02/17/2020'
     and O.ixOrderTime between 0 and 61200 -- midnight and 5:00 pm
     and O.ixOrder not LIKE 'Q%'
     and O.ixOrder not LIKE 'PC%'
 order by ixOrder  -- 842

select * from tblTime where chTime = '17:00:00' order by ixTime


-- for spreadsheet
 select sOrderChannel, count(ixOrder) Orders--, sOrderChannel--, count(*)
 from tblOrder O
 where O.dtOrderDate = '02/24/2020'
     and O.ixOrderTime between 0 and 61200 -- midnight and 5:00 pm
     and O.ixOrder not LIKE 'Q%'
     and O.ixOrder not LIKE 'PC%'
group by sOrderChannel
order by count(ixOrder) desc, sOrderChannel

-- for spreadsheet
 select sOrderChannel, count(ixOrder) Orders--, sOrderChannel--, count(*)
 from tblOrder O
 where O.dtOrderDate = '02/17/2020'
     and O.ixOrderTime between 0 and 61200 -- midnight and 5:00 pm
     and O.ixOrder not LIKE 'Q%'
     and O.ixOrder not LIKE 'PC%'
group by sOrderChannel
order by count(ixOrder) desc, sOrderChannel


-- prev monday
 select sOrderChannel, count(ixOrder) Orders--, sOrderChannel--, count(*)
 from tblOrder O
 where O.dtOrderDate = '02/10/2020'
     and O.ixOrderTime between 0 and 61200 -- midnight and 5:00 pm
     and O.ixOrder not LIKE 'Q%'
     and O.ixOrder not LIKE 'PC%'
group by sOrderChannel
order by count(ixOrder) desc, sOrderChannel

