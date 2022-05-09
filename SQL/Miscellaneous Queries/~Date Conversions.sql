SELECT convert(varchar,DATEADD(YEAR,-1,DATEADD(MONTH,DATEDIFF(MONTH,0,getdate()),0)),101),'First Day of This Month Last Year'
UNION
SELECT convert(varchar,DATEADD(YEAR,-1,DATEADD(MONTH,0,getdate())),101),'Today Last Year'
UNION
SELECT convert(varchar,DATEADD(YEAR,-1,DATEADD(MONTH,DATEDIFF(MONTH,-1,getdate()),-1)),101),'Last Day of This Month Last Year'
UNION
SELECT convert(varchar,DATEADD(MONTH,-1,DATEADD(MONTH,DATEDIFF(MONTH,0,getdate()),0)),101),'First Day of Last Month'
UNION
SELECT convert(varchar,DATEADD(MONTH,-1,getdate()),101),'This Time Last Month'
UNION
SELECT convert(varchar,DATEADD(MONTH,DATEDIFF(MONTH,0,getdate()),-1),101),'Last Day of Last Month'
UNION
SELECT convert(varchar,DATEADD(MONTH,DATEDIFF(MONTH,0,getdate()),0),101),'First Day of This Month'
UNION
SELECT convert(varchar,getdate(),101),'Today'
UNION
SELECT convert(varchar,DATEADD(MONTH,DATEDIFF(MONTH,-1,getdate()),-1),101),'Last Day of This Month'
UNION
SELECT convert(varchar,DATEADD(MONTH,DATEDIFF(MONTH,-1,getdate()),0),101),'First Day of Next Month'
UNION
SELECT convert(varchar,DATEADD(MONTH,+1,getdate()),101),'This Time Next Month'
UNION
SELECT convert(varchar,DATEADD(MONTH,+1,DATEADD(MONTH,DATEDIFF(MONTH,-1,getdate()),-1)),101),'Last Day of Next Month'