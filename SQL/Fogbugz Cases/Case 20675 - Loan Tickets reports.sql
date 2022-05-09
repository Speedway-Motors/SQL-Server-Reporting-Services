-- case 20675 - Loan Tickets reports

--tblLoanTicketMaster
ixLoanTicket varchar(10),
ixCreator varchar(10),
ixCreateDate smallint,
dtCreateDate datetime,
ixCreateTime int, 
dtDateLastSOPUpdate datetime, 
ixTimeLastSOPUpdate int
?Type - QC or ?

--tblLoanTicketDetail
ixLoanTicket varchar(10),
ixSKU varchar(30),
iQuantity (smallint),
iOrdinality (smallint)
dtDateLastSOPUpdate datetime, 
ixTimeLastSOPUpdate int


--tblLoanTicketScans
ixGUID varchar(40), 
ixEmployee varchar(10), 
ixScanDate smallint, 
dtScanDate datetime, 
ixScanTime int, 
ixLoanTicket varchar(10), 
ixIP varchar(15), 
dtDateLastSOPUpdate datetime, 
ixTimeLastSOPUpdate int



192.168.174.6	LNK-QC-10A	Outisde QC Lab	QC
192.168.174.77	LNK-QC-01A	Outside Larkins Office	QC


select * from tblIPAddress
where ixIP like '%.174.%'
order by sGroup


