/*
Order by date desc, default the date to 30 days ago.
And if possible just to save me remoting into SMI can you setup Matt Stublefield and I for a subscription. Mon & Fri mornings.

*/

exec [dw.speedway2.com].dw.dbo.sp_WebShippingServiceVsSOP '03/13/2018'  @StartDate -- '03/13/2018' - 32 ROWS

exec [dw.speedway2.com].dw.dbo.sp_WebShippingServiceVsSO DATEADD(mm, -1, getdate()) 
-- SELECT DATEADD(mm, -1, getdate()) 


exec [dw.speedway2.com].dw.dbo.sp_WebShippingServiceVsSOP @StartDate

select * 
from 
(exec [dw.speedway2.com].dw.dbo.sp_WebShippingServiceVsSOP '03/13/2018') X -- @StartDate)



