select count(C.ixCustomer) CustCount,SCT.sDescription 'SC Type'
from tblSourceCodeType SCT
    left join tblSourceCode SC on SC.sSourceCodeType = SCT.ixSourceCodeType
    left join tblCustomer C on C.ixSourceCode = SC.ixSourceCode
--where C.dtAccountCreateDate >= '02/01/2006'
group by SCT.sDescription
order by CustCount desc    




select SC.sSourceCodeType, SCT.sDescription, count(SC.ixSourceCode) SCcount
from tblSourceCodeType SCT
    left join tblSourceCode SC on SC.sSourceCodeType = SCT.ixSourceCodeType
group by SC.sSourceCodeType,SCT.sDescription
/*
sSourceCodeType      sDescription                                       SCcount
-------------------- -------------------------------------------------- -----------
CAT-E                Catalog @ Event                                    585
CAT-H                Catalog House                                      2032
CAT-P                Catalog Prospect                                   190
CAT-R                Catalog Request                                    51
NULL                 Email @ Event                                      0
EMAIL-H              Email House                                        153
EMAIL-P              Email Prospect                                     3
NULL                 Flyer Email                                        0
FLY-H                Flyer House                                        144
FLY-P                Flyer Prospect                                     9
OTHER                Other                                              537
PIP-H                Package Insert                                     52
NULL                 Package Insert Prospect                            0
AD-PRINT             Print Ad                                           1912
WEB-H                Web House                                          53
WEB-P                Web Prospect                                       92
*/
 
 
select * from tblSourceCodeType 





Email @ Event,Flyer Email,Package Insert Prospect


EMAIL-E              Email @ Event


SCType	sDescription
EMAIL-E	Email @ Event
FLY-E	Flyer Email
PIP-P	Package Insert Prospect