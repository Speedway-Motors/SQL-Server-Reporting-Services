-- SMIHD-20322 Shipping Quote Data Summary report
/*
Summary report to find bad/out of date shipping information (No hurry on this)

Location : dw.speedway2.com
Procedure : [spUtilShippingDataSummary]
Parameters can be null or ignored.

Email Once a month: rmdesimone@speedwaymotors.com; avboellstorff@speedwaymotors.com

Columns:
sColor: Use to change the color on the row, Only choices are RED, YELLOW, <EmptyString>
iStatus , iSortPosition, iRanking : Used for sorting
iStatus desc, iSortPosition, iRanking

The other columns just display
*/
    
EXEC spUtilShippingDataSummary -- 323
