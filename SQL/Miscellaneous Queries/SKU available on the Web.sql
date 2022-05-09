(-- available on the Web
              SELECT ixSOPSKU
               FROM openquery([TNGREADREPLICA], '
                            select s.ixSOPSKU 
                            from tblskubase AS b
                                inner JOIN tblskuvariant s ON b.ixSKUBase = s.ixSKUBase
                                inner JOIN tblproductpageskubase ppsb ON b.ixSKUBase = ppsb.ixSKUBase
                                inner JOIN tblproductpage AS pp ON ppsb.ixProductPage = pp.ixProductPage
                            WHERE b.flgWebPublish = 1
                                AND s.flgPublish = 1
                                AND pp.flgActive = 1
                                AND fn_isProductSaleable(s.flgFactoryShip, s.flgDiscontinued, s.flgBackorderable, s.iTotalQAV, s.flgMTO) = 1
                             '
               ) TNG 