SELECT O.Date,
       O.MBSCode   SourceCode,
       ISNULL(ICE.QTY, 0)       Shipped,        
       ISNULL(XORD.QTY, 0)      Cancelled,
       ISNULL(PIC.QTY, 0)       Opened

FROM (select distinct sSourceCodeGiven MBSCode
           , dtOrderDate Date
        from tblOrder
        WHERE sOrderChannel = 'COUNTER' 
        and dtOrderDate BETWEEN '01/01/12' AND '10/04/12'
     ) O
        
    left join (select dtOrderDate Date, sSourceCodeGiven,ISNULL (count(ixOrder),0) QTY 
                 FROM tblOrder
                 WHERE sOrderChannel = 'COUNTER' 
                    and dtOrderDate BETWEEN '01/01/12' AND '10/04/12'
                    and sOrderStatus = 'Cancelled' 
                 GROUP by dtOrderDate, sSourceCodeGiven
               ) XORD on XORD.sSourceCodeGiven  = O.MBSCode
                 and XORD.Date = O.Date
    left join (select dtOrderDate Date, sSourceCodeGiven, count(ixOrder) QTY 
                 FROM tblOrder
                 WHERE sOrderChannel = 'COUNTER' 
                    and dtOrderDate BETWEEN '01/01/12' AND '10/04/12'
                    and sOrderStatus = 'Open'  
                 GROUP by dtOrderDate, sSourceCodeGiven
               ) PIC on PIC.sSourceCodeGiven  = O.MBSCode
                 and PIC.Date = O.Date
    left join (select dtOrderDate Date, sSourceCodeGiven, count(ixOrder) QTY 
                 FROM tblOrder
                 WHERE sOrderChannel = 'COUNTER' 
                    and dtOrderDate BETWEEN '01/01/12' AND '10/04/12'
                    and sOrderStatus = 'Shipped'  
                 GROUP by dtOrderDate, sSourceCodeGiven
               ) ICE on ICE.sSourceCodeGiven  = O.MBSCode
                 and ICE.Date = O.Date
order by O.Date, O.MBSCode
