select top 1 dtAccountCreateDate from tblCustomer						   -- 2006-09-12 00:00:00.000
--																				CONVERTS TO
select top 1 convert(varchar(12),dtAccountCreateDate,101) from tblCustomer -- 09/12/2006

/*
W/Out century (yy)	W/ century (yyyy)	Standard		Input/Output** 
- 0 or 100 (*)							Default			mon dd yyyy hh:miAM (or PM) 
1					101					USA				mm/dd/yy 
2					102					ANSI			yy.mm.dd 
3					103					British/French	dd/mm/yy 
4					104					German			dd.mm.yy 
5					105					Italian			dd-mm-yy 
6					106					-				dd mon yy 
7					107					-				Mon dd, yy 
8					108					-				hh:mm:ss 
-					9 or 109 (*)		Default + milliseconds mon dd yyyy hh:mi:ss:mmmAM (or PM) 
10					110					USA				mm-dd-yy 
11					111					JAPAN			yy/mm/dd 
12					112					ISO				yymmdd 
-					13 or 113 (*)		Europe default + milliseconds dd mon yyyy hh:mm:ss:mmm(24h) 
14					114					-				hh:mi:ss:mmm(24h) 
-					20 or 120 (*)		ODBC canonical	yyyy-mm-dd hh:mi:ss(24h) 
-					21 or 121 (*)		ODBC canonical (with milliseconds) yyyy-mm-dd hh:mi:ss.mmm(24h) 
-					126(***)			ISO8601			yyyy-mm-dd Thh:mm:ss.mmm(no spaces) 
-					130*				Hijri****		dd mon yyyy hh:mi:ss:mmmAM 
-					131*				Hijri****		dd/mm/yy hh:mi:ss:mmmAM 
