ALTER FUNCTION [dbo].[PJC_NumberOFWorkDays] (@StartDate datetime, @EndDate datetime)
RETURNS int
AS
BEGIN
     
     SET @StartDate = DATEADD(dd, DATEDIFF(dd, 0, @StartDate), +1) -- starts counting the day after order is taken 
     SET @EndDate = DATEADD(dd, DATEDIFF(dd, 0, @EndDate), 0) 
          
     DECLARE @WORKDAYS INT
     SELECT @WORKDAYS = (DATEDIFF(dd, @StartDate, @EndDate) + 1)
	               -(DATEDIFF(wk, @StartDate, @EndDate) * 2)
   		       -(CASE WHEN DATENAME(dw, @StartDate) = 'Sunday' THEN 1 ELSE 0 END)
		       -(CASE WHEN DATENAME(dw, @EndDate) = 'Saturday' THEN 1 ELSE 0 END)
  
     RETURN @WORKDAYS
END


                                                            -- DAYS
select dbo.PJC_NumberOFWorkDays ('09/01/2014','09/05/2014') -- 4 
select dbo.PJC_NumberOFWorkDays ('09/05/2014','09/08/2014') -- 4
select dbo.PJC_NumberOFWorkDays ('09/01/2014','09/07/2014') -- 4
select dbo.PJC_NumberOFWorkDays ('09/01/2014','09/08/2014') -- 5

select dbo.PJC_NumberOFWorkDays ('09/05/2014','09/08/2014') -- 1
select dbo.PJC_NumberOFWorkDays ('09/06/2014','09/08/2014') -- 1
select dbo.PJC_NumberOFWorkDays ('09/07/2014','09/08/2014') -- 1
select dbo.PJC_NumberOFWorkDays ('09/08/2014','09/08/2014') -- 0