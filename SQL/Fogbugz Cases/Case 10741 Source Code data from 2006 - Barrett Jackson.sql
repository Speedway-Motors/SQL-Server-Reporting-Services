select
      SourceCodeList.ixCatalog,
      CAT.sDescription as 'CatDesc',
      --tblOrder.sMatchbackSourceCode, 
      SourceCodeList.ixSourceCode,
      SourceCodeList.sDescription as 'SCDesc',     
      sum(isnull(O.mMerchandise,0)) as 'Merch Total', 
      sum(isnull(O.mMerchandiseCost,0)) as 'Merch Cost',
      count(distinct(SUBSTRING(O.ixOrder, 1, 7))) as '# Orders',
      count(distinct(O.ixCustomer)) as '# Customers'
from
	  (select ixCatalog,ixSourceCode,sDescription 
      from tblSourceCode
      where ixSourceCode in ('5564','5565')
        )SourceCodeList
      left join [SMIArchive].dbo.tblOrderArchive O on O.sMatchbackSourceCode COLLATE SQL_Latin1_General_CP1_CS_AS = SourceCodeList.ixSourceCode COLLATE SQL_Latin1_General_CP1_CS_AS 
      left join tblCatalogMaster CAT on SourceCodeList.ixCatalog = CAT.ixCatalog
where
     --O.sMatchbackSourceCode in (@SourceCode)
     --and
     ((O.dtOrderDate >= '05/01/2005') OR O.dtOrderDate is NULL)
     and
     (O.sOrderStatus not in ('Cancelled', 'Pick Ticket') or O.sOrderStatus is NULL)
     and
     (O.sOrderChannel <> 'INTERNAL' or O.sOrderChannel is NULL)
     and
     (O.mMerchandise > 0 OR O.mMerchandise is NULL)
   --  and CAT.dtStartDate >= @CatalogStartDate
group by
     SourceCodeList.ixCatalog,
     CAT.sDescription,
     SourceCodeList.ixSourceCode,
     SourceCodeList.sDescription
order by
    SourceCodeList.ixCatalog,
    SourceCodeList.ixSourceCode

/*
PRE-2008
ixCatalog  CatDesc              ixSourceCode    SCDesc                                                  Merch Total            Merch Cost    # Orders # Customers
---------- -------------------- --------------- --------------------------------------------- --------------------- --------------------- ----------- -----------
240        2006 STREET          5564            BARRET/JACK 06                                              6621.90              3455.376          33          19
240        2006 STREET          5565            BARRET/JACK 06                                              4207.02              2009.156          23          18

2008 TO CURRENT
ixCatalog  CatDesc              ixSourceCode    SCDesc                                                  Merch Total            Merch Cost    # Orders # Customers
---------- -------------------- --------------- --------------------------------------------- --------------------- --------------------- ----------- -----------
240        2006 STREET          5564            BARRET/JACK 06                                              1224.90               543.955           5           5
240        2006 STREET          5565            BARRET/JACK 06                                              2419.84               1171.13           8           8


*/
select
      SourceCodeList.ixCatalog,
      CAT.sDescription as 'CatDesc',
      --tblOrder.sMatchbackSourceCode, 
      SourceCodeList.ixSourceCode,
      SourceCodeList.sDescription as 'SCDesc',     
      sum(isnull(O.mMerchandise,0)) as 'Merch Total', 
      sum(isnull(O.mMerchandiseCost,0)) as 'Merch Cost',
      count(distinct(SUBSTRING(O.ixOrder, 1, 7))) as '# Orders',
      count(distinct(O.ixCustomer)) as '# Customers'
from
	  (select ixCatalog,ixSourceCode,sDescription 
      from tblSourceCode
      where ixSourceCode in ('5564','5565')
        )SourceCodeList
      left join tblOrder O on O.sMatchbackSourceCode COLLATE SQL_Latin1_General_CP1_CS_AS = SourceCodeList.ixSourceCode COLLATE SQL_Latin1_General_CP1_CS_AS 
      left join tblCatalogMaster CAT on SourceCodeList.ixCatalog = CAT.ixCatalog
where
     --O.sMatchbackSourceCode in (@SourceCode)
     --and
     ((O.dtOrderDate >= '05/01/2005') OR O.dtOrderDate is NULL)
     and
     (O.sOrderStatus not in ('Cancelled', 'Pick Ticket') or O.sOrderStatus is NULL)
     and
     (O.sOrderChannel <> 'INTERNAL' or O.sOrderChannel is NULL)
     and
     (O.mMerchandise > 0 OR O.mMerchandise is NULL)
   --  and CAT.dtStartDate >= @CatalogStartDate
group by
     SourceCodeList.ixCatalog,
     CAT.sDescription,
     SourceCodeList.ixSourceCode,
     SourceCodeList.sDescription
order by
    SourceCodeList.ixCatalog,
    SourceCodeList.ixSourceCode
