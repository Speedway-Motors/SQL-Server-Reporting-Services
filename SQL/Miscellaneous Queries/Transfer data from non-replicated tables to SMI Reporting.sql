-- Transfer data from non-replicated tables to SMI Reporting

-- SAVED:
CSTCustSummary
tblCSTCustSummary_Rollup
TAB_2014ALLCatalogOffers
TAB_2014CatalogOffers
TAB_Tmp_All2014Offers
TAB_TwoYearPromoAnalysis
TableauCustomerOffers



-- DELETED:
TAB_BlackFridayOrders
TAB_CyberMondayOrders
TAB_GiftCardRedeemOrders
tblMicroSprintCustomer


-- MOVED to SMITemp:
PJC_23844_DualHolidayCustomers   
PJC_Table1_Example              



INSERT INTO [SMI Reporting].dbo.CSTCustSummary
SELECT * FROM [SMIReportingLiveRecover].dbo.CSTCustSummary

INSERT INTO [SMI Reporting].dbo.tblCSTCustSummary_Rollup
SELECT * FROM [SMIReportingLiveRecover].dbo.tblCSTCustSummary_Rollup

INSERT INTO [SMI Reporting].dbo.TAB_2014ALLCatalogOffers
SELECT * FROM [SMIReportingLiveRecover].dbo.TAB_2014ALLCatalogOffers

INSERT INTO [SMI Reporting].dbo.TAB_2014CatalogOffers
SELECT * FROM [SMIReportingLiveRecover].dbo.TAB_2014CatalogOffers

INSERT INTO [SMI Reporting].dbo.TAB_Tmp_All2014Offers
SELECT * FROM [SMIReportingLiveRecover].dbo.TAB_Tmp_All2014Offers

INSERT INTO [SMI Reporting].dbo.TAB_TwoYearPromoAnalysis
SELECT * FROM [SMIReportingLiveRecover].dbo.TAB_TwoYearPromoAnalysis

INSERT INTO [SMI Reporting].dbo.TableauCustomerOffers
SELECT * FROM [SMIReportingLiveRecover].dbo.TableauCustomerOffers

