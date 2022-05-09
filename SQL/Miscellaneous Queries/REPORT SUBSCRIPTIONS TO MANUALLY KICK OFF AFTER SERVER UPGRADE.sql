-- REPORT SUBSCRIPTIONS TO MANUALLY KICK OFF AFTER SERVER UPGRADE
exec Util.[dbo].[spUtil_FindSSRSSubscription] [Yesterday's Out of Stock SKUs Not Available for Backorder]



-- DOT
exec msdb.dbo.sp_start_job  [33D879E9-77F2-434E-BAEE-389BEF26EE2D]

-- Free Shipping Problem Orders
exec msdb.dbo.sp_start_job  [9D0C00A0-096E-4E1B-BF9C-932974DBB246]

-- MDC Dropship Invoices
exec msdb.dbo.sp_start_job  [42B5A562-0CB1-427E-9ACC-EDA315D192FE]
exec msdb.dbo.sp_start_job  [A3783ACC-2675-428D-ADDD-5C057963C6EE]

-- Orders that did not meet Guaranteed Delivery Date
exec msdb.dbo.sp_start_job  [87BA406D-CB3A-4B86-92DB-0E82FAC14EDE]

-- Qty Verification for Recent Out of Stock SKUs
exec msdb.dbo.sp_start_job  [59445570-F2B5-47B4-8D3B-CE329B59B3BB]

-- Survey Customer Appreciation Gift Recipients
exec msdb.dbo.sp_start_job  [47919200-F76D-44AA-B21C-D7E9166214A7]

-- Yesterday's Out of Stock SKUs
exec msdb.dbo.sp_start_job  [20290F05-71CD-4899-A0B8-BC16E5C2FEDE]

-- Yesterday's Out of Stock SKUs Not Available for Backorder
exec msdb.dbo.sp_start_job  [16718DE7-2FB7-47FC-A2D2-0F1A6E7ED4C4]