SELECT  [TableName] = so.name, 
        [RowCount] = MAX(si.rows),
        getdate() asOf
FROM sysobjects so, 
     sysindexes si 
WHERE so.xtype = 'U'  
    AND si.id = OBJECT_ID(so.name) 
GROUP BY so.name 
ORDER BY 2 DESC

/*  TOP 10

TableName	                    RowCount	asOf
tblOrderLine	                13063731	2010-09-28 15:00:33.087
tblOrder	                    3672972	    2010-09-28 15:00:33.087
tblSnapshotSKU	                2939149	    2010-09-28 15:00:33.087
tblSKUTransaction	            2581006	    2010-09-28 15:00:33.087
tblCatalogDetail	            1057399	    2010-09-28 15:00:33.087
tblCustomer	                    1041301	    2010-09-28 15:00:33.087
tblSnapAdjustedMonthlySKUSales	543303	    2010-09-28 15:00:33.087
tblPODetail	                    508562	    2010-09-28 15:00:33.087
tblCreditMemoDetail	            334084	    2010-09-28 15:00:33.087
tblCustomerOffer	            300826	    2010-09-28 15:00:33.087
                                ======
                                26,042,333 

TableName	                    RowCount	asOf
tblOrderLine	                14729727	2010-12-14 13:20:07.663
tblCustomerOffer	            9565862	    2010-12-14 13:20:07.663
tblSnapshotSKU	                8061598	    2010-12-14 13:20:07.663
tblSKUTransaction	            5763232	    2010-12-14 13:20:07.663
tblOrder	                    3735887	    2010-12-14 13:20:07.663
tblCatalogDetail	            1087538	    2010-12-14 13:20:07.663
tblCustomer	                    1061988	    2010-12-14 13:20:07.663
tblSnapAdjustedMonthlySKUSales	596114	    2010-12-14 13:20:07.663
tblPODetail	                    520051	    2010-12-14 13:20:07.663
tblCreditMemoDetail	            339934	    2010-12-14 13:20:07.663
                                ======
                                45,461,931
total rows in the DW =          47,362,851 

*/

SELECT  sum(X.RowCnt)
FROM (SELECT  [TableName] = so.name, 
              MAX(si.rows) RowCnt
      FROM sysobjects so, 
            sysindexes si 
      WHERE so.xtype = 'U'  
           AND si.id = OBJECT_ID(so.name) 
      GROUP BY so.name) X  
