-- Case 19270 - LNK-DW1 missing Door Swipe data

select COUNT(*)     
from tblDoorEvent  

/*
ROW
COUNT   DB              Date
 10K    LNK-DW1         07/15/2013
107,634 LNK-DWSTAGING1  07/15/2013

 20,074 LNK-DW1         07/16/2013
108,480 LNK-DWSTAGING1  07/16/2013

109,355 LNK-DW1         07/17/2013
109,355 LNK-DWSTAGING1  07/17/2013
