select 
    CONVERT(VARCHAR(10), dtUpdate, 101) as 'Date Attributes Modified', 
    ixSKU, 
    count(*) '# of Attributes Modified'
from SKUAttribute
where dtUpdate >= '01/01/2011'
    and ixSKU not like '%.GS' -- 
group by CONVERT(VARCHAR(10), dtUpdate, 101), ixSKU
order by count(*) desc




select 
    ixSKU, 
    count(distinct ixSKUAttributeId) 'Attributes Modified'
from SKUAttribute
where CAST  (CONVERT(VARCHAR(10), dtUpdate, 101) as DATETIME) between '03/19/2013' and '03/19/2013' -- must convert & cast because the field is datetime
    and ixSKU not like 'UP%'  --
    and ixSKU not like '%.GS' --
group by ixSKU
order by count(distinct ixSKUAttributeId) desc,
    ixSKU



/*
Syntax for CAST:
CAST ( expression AS data_type [ ( length ) ] )

Syntax for CONVERT:
CONVERT ( data_type [ ( length ) ] , expression [ , style ] )

*/


select *




select * from SKUAttribute
where ixSKU = '10680137-P-DB-Y'
and dtUpdate between '03/15/2013' and '03/16/2013'

/*
Ryan mentioned that there are also attribute types 
which could allow us to exclude a bunch of attributes based on type.

note: after writing the query, see how many "attribute types" there are, see if there is the potential 
to make an @AttributeType drop-down that defaults to all, but lets them narrow down if needed?
*/


select * from AttributeType
/*
Text
Yes/No
Quantity
Dropdown Box
Measurement/Size/Length/...
Weight
Electric Current
Temperature
Luminous Intensity
Frequency
Energy/Torque
Power
Force
Pressure
Electric Charge
Electric Potential
Electric Resistance
Area
Volume
Speed
Time
Angle
Angular Velocity
Sound
*/


select * from TemplateAttribute



select min(dtUpdate) from SKUAttribute -- 2011-07-18 11:40:20.373


select * from SKUAttribute
where ixSKU like '%GS'
and ixSKU not like '%.GS'

