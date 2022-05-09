-- Test values for spSkuVariant_ReportYMMInfo

/* returns 101 SKUs (mostly UP)

BRAND:          Speedway Motors
PRODUCT LINE:   Speedway Performance Torque Converters
SEMA CAT:       Transmission
SEMA SUB-CAT:   Automatic Transmission Parts
SEMA PART:      Torque Converters
YEAR:   1966
MAKE;   Buick
MODEL:  Skylark
*/

exec DW.dbo.[spSkuVariant_ReportYMMInfo] 'Speedway Motors', 'Transmission', 'Automatic Transmission Parts', 'Torque Converters', 'Speedway Performance Torque Converters', 1966, 'Buick', 'Skylark'
exec DW.dbo.[spSkuVariant_ReportYMMInfo] NULL, 'Transmission', NULL, NULL, NULL, 1966, 'Buick', 'Skylark' -- @0:11 374 rows
exec DW.dbo.[spSkuVariant_ReportYMMInfo] NULL, NULL, NULL, NULL, NULL, 1966, 'Buick', 'Skylark' -- <1 min    rows 1602
exec DW.dbo.[spSkuVariant_ReportYMMInfo] NULL, NULL, NULL, NULL, NULL, NULL, 'Buick', 'Skylark' -- <1 min 34,817 rows 
exec DW.dbo.[spSkuVariant_ReportYMMInfo] 'Speedway Motors', 'Transmission', 'Automatic Transmission Parts', 'Torque Converters', 'Speedway Performance Torque Converters', NULL, NULL, NULL  -- < min 100k limit 

exec DW.dbo.[spSkuVariant_ReportYMMInfo] 'Speedway Motors', NULL, NULL, NULL, NULL, NULL, NULL, NULL -- 3 min 200k limit 
exec DW.dbo.[spSkuVariant_ReportYMMInfo] NULL, 'Transmission', NULL, NULL, NULL, NULL, NULL, NULL -- 2 min 200k limit 
exec DW.dbo.[spSkuVariant_ReportYMMInfo] NULL, NULL, 'Automatic Transmission Parts', NULL, NULL, NULL, NULL, NULL -- 1 min 100k limit 
exec DW.dbo.[spSkuVariant_ReportYMMInfo] NULL, NULL, NULL, 'Torque Converters', NULL, NULL, NULL, NULL -- 1 min 100k limit 
exec DW.dbo.[spSkuVariant_ReportYMMInfo] NULL, NULL, NULL, NULL, 'Speedway Performance Torque Converters', NULL, NULL, NULL -- 2 min 60k limit 
exec DW.dbo.[spSkuVariant_ReportYMMInfo] NULL, NULL, NULL, NULL, NULL, 1986, NULL, NULL -- 2 min 200k limit
exec DW.dbo.[spSkuVariant_ReportYMMInfo] NULL, NULL, NULL, NULL, NULL, NULL, 'Buick', NULL -- 1 min 100k limit
exec DW.dbo.[spSkuVariant_ReportYMMInfo] NULL, NULL, NULL, NULL, NULL, NULL, 'Ford', NULL -- 3 min 100k limit 
exec DW.dbo.[spSkuVariant_ReportYMMInfo] NULL, NULL, NULL, NULL, NULL, NULL, 'Ferrari', NULL -- 22 sec 502 rows
exec DW.dbo.[spSkuVariant_ReportYMMInfo] NULL, NULL, NULL, NULL, NULL, NULL, 'BMW', NULL -- 26 sec 15,977 rows 
                                                                                                                                                              

