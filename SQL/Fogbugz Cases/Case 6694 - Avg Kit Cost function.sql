select ixKitSKU,ixSKU,iQtyRequired from tblKit
where ixKitSKU = '9107199'
/*
ixKitSKU	ixSKU	    iQtyRequired
9107199	    210432	    1
9107199	    910712	    1
9107199	    910719	    1
9107199 	91072355	1
*/

select * from tblSKU
where ixSKU like '210432%' -- 57 indexed parts

select * from tblSKU
where ixSKU like '910712%' -- 127 indexed parts

select * from tblSKU 
where ixSKU like '910719%'-- 123 indexed parts

select * from tblSKU
where ixSKU like '91072355%' -- 13 indexed parts
