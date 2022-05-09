select
	tblOrder.sMatchbackSourceCode,
	tblOrder.dtOrderDate,
	(case 
		when (tblOrder.sMatchbackSourceCode in ('MRR','MRRWEB','PRS','PRSWEB','PRS212','PRS1299','PRS2699','PRS99','311D','293MRR','268D','269D','273D','287D','290D','292D','293D') or 
			  tblOrder.sMatchbackSourceCode = 'VEND' or
			  tblOrder.sMatchbackSourceCode like 'MRR%' or tblOrder.sMatchbackSourceCode like 'PRS%') then 'Wholesale'
		when (tblOrder.sMatchbackSourceCode like 'BUD%' or tblOrder.sMatchbackSourceCode like '%BUDY' or tblOrder.sMatchbackSourceCode in ('BP10')) then 'Budy'
		when (tblOrder.sMatchbackSourceCode in ('2888','2899','4088','4999','5099')) then 'Other'
		when (tblOrder.sMatchbackSourceCode = '29388') then 'Catalog'
		when (tblOrder.sMatchbackSourceCode like '%88' or tblOrder.sMatchbackSourceCode like '%99' or tblOrder.sMatchbackSourceCode like 'PIP%'
	          or tblOrder.sMatchbackSourceCode in ('24866','24966','25066','25566','25666','25766','240L','242L','243L','246L','247L','249L','BW139','201B','212P','213P','219P','240X',
	          '241C','241L','242X','243X','AFCOREQ','BD04R','BD0866','BD01B','BD07L','BD0899','BD0999','BD0977','CCSR')) then 'RIP/PIP'
		when (tblOrder.sMatchbackSourceCode like '248_' or tblOrder.sMatchbackSourceCode like '249_' or tblOrder.sMatchbackSourceCode like '250_' or
		  tblOrder.sMatchbackSourceCode like '251_' or tblOrder.sMatchbackSourceCode like '252_' or tblOrder.sMatchbackSourceCode like '253_' or
		  tblOrder.sMatchbackSourceCode like '254_' or tblOrder.sMatchbackSourceCode like '255_' or tblOrder.sMatchbackSourceCode like '256_' or
		  tblOrder.sMatchbackSourceCode like '257_' or tblOrder.sMatchbackSourceCode like '258_' or tblOrder.sMatchbackSourceCode like '259_' or 
		  tblOrder.sMatchbackSourceCode like '260_' or tblOrder.sMatchbackSourceCode like '261_' or tblOrder.sMatchbackSourceCode like '262_' or
		  tblOrder.sMatchbackSourceCode like '263_' or tblOrder.sMatchbackSourceCode like '264_' or tblOrder.sMatchbackSourceCode like '265_' or
		  tblOrder.sMatchbackSourceCode like '266_' or tblOrder.sMatchbackSourceCode like '267_' or tblOrder.sMatchbackSourceCode like '268_' or
		  tblOrder.sMatchbackSourceCode like '269_' or tblOrder.sMatchbackSourceCode like '270_' or tblOrder.sMatchbackSourceCode like '271_' or
		  tblOrder.sMatchbackSourceCode like '272_' or tblOrder.sMatchbackSourceCode like '273_' or tblOrder.sMatchbackSourceCode like '274_' or
		  tblOrder.sMatchbackSourceCode like '275_' or tblOrder.sMatchbackSourceCode like '276_' or tblOrder.sMatchbackSourceCode like '277_' or
		  tblOrder.sMatchbackSourceCode like '278_' or tblOrder.sMatchbackSourceCode like '279_' or tblOrder.sMatchbackSourceCode like '280_' or
		  tblOrder.sMatchbackSourceCode like '281_' or tblOrder.sMatchbackSourceCode like '282_' or tblOrder.sMatchbackSourceCode like '283_' or
		  tblOrder.sMatchbackSourceCode like '284_' or tblOrder.sMatchbackSourceCode like '285_' or tblOrder.sMatchbackSourceCode like '286_' or
		  tblOrder.sMatchbackSourceCode like '287_' or tblOrder.sMatchbackSourceCode like '288_' or tblOrder.sMatchbackSourceCode like '289_' or
		  tblOrder.sMatchbackSourceCode like '290_' or tblOrder.sMatchbackSourceCode like '291_' or tblOrder.sMatchbackSourceCode like '292_' or
		  tblOrder.sMatchbackSourceCode like '293_' or tblOrder.sMatchbackSourceCode like '294_' or tblOrder.sMatchbackSourceCode like '295_' or
		  tblOrder.sMatchbackSourceCode like '296_' or tblOrder.sMatchbackSourceCode like '297_' or tblOrder.sMatchbackSourceCode like '298_' or
		  tblOrder.sMatchbackSourceCode like '299_' or tblOrder.sMatchbackSourceCode like '300_' or tblOrder.sMatchbackSourceCode like '301_' or
		  tblOrder.sMatchbackSourceCode like '302_' or tblOrder.sMatchbackSourceCode like '303_' or tblOrder.sMatchbackSourceCode like '304_' or
		  tblOrder.sMatchbackSourceCode like '305_' or tblOrder.sMatchbackSourceCode like '306_' or tblOrder.sMatchbackSourceCode like '307_' or
		  tblOrder.sMatchbackSourceCode like '308_' or tblOrder.sMatchbackSourceCode like '309_' or tblOrder.sMatchbackSourceCode like '310_' or
		  tblOrder.sMatchbackSourceCode like '311_' or tblOrder.sMatchbackSourceCode in ('IMCA 50','IMCA 51','IMCA 52','IMCA 53','IMCA 54',
		  'IMCA 55','IMCA01','IMCA08','IMCA09','IMCA14','IMCA16','IMCA19','IMCA22','IMCA23','IMCA24',
		  'IMCA25','IMCA26','IMCA33','IMCA34','IMCA38','IMCA56','IMCA57','IMCA58','IMCA59','IMCA63','IMCA64',
		  'IMCA65','IMCA66','IMCA67','IMCA68','IMCA69','IMCA74','IMCA80','IMCAROOK','IMCATV','IMCATV71',
		  '1088','2099','2299','3199','3288','3299','3688','3888','3988','3999','4088','4188','4199',
		  '4999','5099','5199','5388','5588','5688','5699','5799','5888','5899','222','223','224','225','226','227','228','229','236','237','244','2121','2211','2212','2214',
		  '2326','2470')) then 'Other'
	when tblOrder.sMatchbackSourceCode like 'CTR%' or tblOrder.sMatchbackSourceCode = '0' then 'Counter'
	when tblOrder.sMatchbackSourceCode in ('2190','2191','2192','2193','2194','EBAY','BDNET','BDNET_06','BDNET2007','BD2193','NET','NET06','NET7','TC01','WCR2','WCR3','WCR4','WCR5','WCR6','WCR7','WCR9','WCR22','WWW','GGL') 
	      or tblOrder.sMatchbackSourceCode like 'WG7%' or tblOrder.sMatchbackSourceCode like 'WY7%' or tblOrder.sMatchbackSourceCode like 'WJJ%' or tblOrder.sMatchbackSourceCode like 'WGB%' or tblOrder.sMatchbackSourceCode like 'WHH%'
	      or tblOrder.sMatchbackSourceCode like 'WP4%' then 'Web'	
    when (tblOrder.sMatchbackSourceCode in ('1179','2595','5004','5297','5653','5704','RCB9','293N','256HR','257HR','261KR','262KR','264RR','264BP','262BCSM','232F',
          '1052','1053','2636','3684','3719','5034','5158','5190','5502','5607','5676','5737','5738','232A','232F','243G','243GK','BDNSRA00','BDYORK','CB8','CBS8') 
			or tblOrder.sMatchbackSourceCode like '%AM7'
			or tblOrder.sMatchbackSourceCode like '%ASCS'
			or tblOrder.sMatchbackSourceCode like '%B50'
			or tblOrder.sMatchbackSourceCode like '%BASH'
			or tblOrder.sMatchbackSourceCode like '%BN'
			or tblOrder.sMatchbackSourceCode like '%BSN'
			or tblOrder.sMatchbackSourceCode like '%CAR'
			or tblOrder.sMatchbackSourceCode like '%CB'
			or tblOrder.sMatchbackSourceCode like '%CNA'
			or tblOrder.sMatchbackSourceCode like '%DRAG'
			or tblOrder.sMatchbackSourceCode like '%ESRN'
			--or tblOrder.sMatchbackSourceCode like '%F'
			or tblOrder.sMatchbackSourceCode like '%FF'
			or tblOrder.sMatchbackSourceCode like '%GA'
			or tblOrder.sMatchbackSourceCode like '%GC'
			or tblOrder.sMatchbackSourceCode like '%GD'
			or tblOrder.sMatchbackSourceCode like '%GG%'
			or tblOrder.sMatchbackSourceCode like '%GH'
			or tblOrder.sMatchbackSourceCode like '%GL'
			or tblOrder.sMatchbackSourceCode like '%GN'
			or tblOrder.sMatchbackSourceCode like '%GNR'
			or tblOrder.sMatchbackSourceCode like '%GP'
			or tblOrder.sMatchbackSourceCode like '%GR'
			or tblOrder.sMatchbackSourceCode like '%GT'
			or tblOrder.sMatchbackSourceCode like '%HCP'
			or tblOrder.sMatchbackSourceCode like '%HPA'
			or tblOrder.sMatchbackSourceCode like '%HRN'
			or tblOrder.sMatchbackSourceCode like '%HRR'
			or tblOrder.sMatchbackSourceCode like '%HRT'
			or tblOrder.sMatchbackSourceCode like '%IMCA'
			or tblOrder.sMatchbackSourceCode like '%IMCA42'
			or tblOrder.sMatchbackSourceCode like '%IMIS'
			or tblOrder.sMatchbackSourceCode like '%K360'
			or tblOrder.sMatchbackSourceCode like '%KKOA'
			or tblOrder.sMatchbackSourceCode like '%KN'
			or tblOrder.sMatchbackSourceCode like '%LR'
			or tblOrder.sMatchbackSourceCode like '%LSM'
			or tblOrder.sMatchbackSourceCode like '%MN7'
			or tblOrder.sMatchbackSourceCode like '%MRA'
			or tblOrder.sMatchbackSourceCode like '%MRAG'
			or tblOrder.sMatchbackSourceCode like '%NN'
			or tblOrder.sMatchbackSourceCode like '%NSRA'
			or tblOrder.sMatchbackSourceCode like '%PP'
			or tblOrder.sMatchbackSourceCode like '%PRI'
			or tblOrder.sMatchbackSourceCode like '%PT8'
			or tblOrder.sMatchbackSourceCode like '%PWR'
			or tblOrder.sMatchbackSourceCode like '%RK'
			or tblOrder.sMatchbackSourceCode like '%RS'
			or tblOrder.sMatchbackSourceCode like '%RSRN'
			or tblOrder.sMatchbackSourceCode like '%SCCA'
			or tblOrder.sMatchbackSourceCode like '%SRN'
			or tblOrder.sMatchbackSourceCode like '%SSRN'
			or tblOrder.sMatchbackSourceCode like '%TBN'
			or tblOrder.sMatchbackSourceCode like '%TRP'
			or tblOrder.sMatchbackSourceCode like '%VX'
			or tblOrder.sMatchbackSourceCode like '%W100'
			or tblOrder.sMatchbackSourceCode like '%WE'
			or tblOrder.sMatchbackSourceCode like '%WIS'
			or tblOrder.sMatchbackSourceCode like '%WW%'
			or tblOrder.sMatchbackSourceCode like '%XV'
			or tblOrder.sMatchbackSourceCode like 'GG%'
			or tblOrder.sMatchbackSourceCode like 'IMCA%'
			or tblOrder.sMatchbackSourceCode like 'NATS%'
			or tblOrder.sMatchbackSourceCode like 'PP0%'
			or tblOrder.sMatchbackSourceCode like 'PPED%'
			or tblOrder.sMatchbackSourceCode like 'RCB%'
			or tblOrder.sMatchbackSourceCode like 'RR%') then 'Event'
	when (tblOrder.sMatchbackSourceCode like '248%' or tblOrder.sMatchbackSourceCode like '247%'
			or tblOrder.sMatchbackSourceCode like '249%'
			or tblOrder.sMatchbackSourceCode like '250%'
	  		or tblOrder.sMatchbackSourceCode like '251%'
	  		or tblOrder.sMatchbackSourceCode like '252%'
	  		or tblOrder.sMatchbackSourceCode like '253%'
	  		or tblOrder.sMatchbackSourceCode like '254%'
	  		or tblOrder.sMatchbackSourceCode like '255%'
	  		or tblOrder.sMatchbackSourceCode like '256%'
	  		or tblOrder.sMatchbackSourceCode like '257%'
	  		or tblOrder.sMatchbackSourceCode like '258%'
	  		or tblOrder.sMatchbackSourceCode like '259%'
	  		or tblOrder.sMatchbackSourceCode like '260%'
	  		or tblOrder.sMatchbackSourceCode like '261%'
	  		or tblOrder.sMatchbackSourceCode like '262%'
	  		or tblOrder.sMatchbackSourceCode like '263%'
	  		or tblOrder.sMatchbackSourceCode like '264%'
	  		or tblOrder.sMatchbackSourceCode like '265%'
	  		or tblOrder.sMatchbackSourceCode like '268%'
	  		or tblOrder.sMatchbackSourceCode like '269%'
	  		or tblOrder.sMatchbackSourceCode like '270%'
	  		or tblOrder.sMatchbackSourceCode like '271%'
	  		or tblOrder.sMatchbackSourceCode like '272%'
	  		or tblOrder.sMatchbackSourceCode like '273%'
	  		or tblOrder.sMatchbackSourceCode like '274%'
	  		or tblOrder.sMatchbackSourceCode like '275%'
	  		or tblOrder.sMatchbackSourceCode like '276%'
	  		or tblOrder.sMatchbackSourceCode like '277%'
	  		or tblOrder.sMatchbackSourceCode like '278%'
	  		or tblOrder.sMatchbackSourceCode like '279%'
	  		or tblOrder.sMatchbackSourceCode like '280%'
	  		or tblOrder.sMatchbackSourceCode like '281%'
	  		or tblOrder.sMatchbackSourceCode like '282%'
	  		or tblOrder.sMatchbackSourceCode like '283%'
	  		or tblOrder.sMatchbackSourceCode like '284%'
	  		or tblOrder.sMatchbackSourceCode like '285%'
	  		or tblOrder.sMatchbackSourceCode like '286%'
	  		or tblOrder.sMatchbackSourceCode like '287%'
	  		or tblOrder.sMatchbackSourceCode like '288%'
	  		or tblOrder.sMatchbackSourceCode like '289%'
	  		or tblOrder.sMatchbackSourceCode like '290%'
	  		or tblOrder.sMatchbackSourceCode like '291%'
	  		or tblOrder.sMatchbackSourceCode like '292%'
	  		or tblOrder.sMatchbackSourceCode like '293%'
	  		or tblOrder.sMatchbackSourceCode like '294%'
	  		or tblOrder.sMatchbackSourceCode like '295%'
	 		or tblOrder.sMatchbackSourceCode like '296%'
	  		or tblOrder.sMatchbackSourceCode like '297%'
	  		or tblOrder.sMatchbackSourceCode like '298%'
	  		or tblOrder.sMatchbackSourceCode like '299%'
	  		or tblOrder.sMatchbackSourceCode like '300%'
	  		or tblOrder.sMatchbackSourceCode like '301%'
	  		or tblOrder.sMatchbackSourceCode like '302%'
	  		or tblOrder.sMatchbackSourceCode like '303%'
	  		or tblOrder.sMatchbackSourceCode like '304%'
	  		or tblOrder.sMatchbackSourceCode like '305%'
	  		or tblOrder.sMatchbackSourceCode like '306%'
	  		or tblOrder.sMatchbackSourceCode like '307%'
	  		or tblOrder.sMatchbackSourceCode like '308%'
	  		or tblOrder.sMatchbackSourceCode like '309%'
	  		or tblOrder.sMatchbackSourceCode like '310%'
	  		or tblOrder.sMatchbackSourceCode like '311%'
	  		or tblOrder.sMatchbackSourceCode like '312%'
	  		or tblOrder.sMatchbackSourceCode like '313%'
	  		or tblOrder.sMatchbackSourceCode like '314%'
	  		or tblOrder.sMatchbackSourceCode like '315%'
	  		or tblOrder.sMatchbackSourceCode like '316%'
	  		or tblOrder.sMatchbackSourceCode like '317%'
	  		or tblOrder.sMatchbackSourceCode like '318%'
	  		or tblOrder.sMatchbackSourceCode like '319%'
	  		or tblOrder.sMatchbackSourceCode like '320%'
	  		or tblOrder.sMatchbackSourceCode like '321%'
	  		or tblOrder.sMatchbackSourceCode like 'BW135'
	  		or tblOrder.sMatchbackSourceCode like 'BW136'
	  		or tblOrder.sMatchbackSourceCode like 'BW137'
	  		or tblOrder.sMatchbackSourceCode like 'BW138'
	  		or tblOrder.sMatchbackSourceCode like '%CAT'
	  		or tblOrder.sMatchbackSourceCode like '%NO' 
	  		or tblOrder.sMatchbackSourceCode like '20_' or tblOrder.sMatchbackSourceCode like '21_'
	  		or tblOrder.sMatchbackSourceCode like '23_' or tblOrder.sMatchbackSourceCode like '24_'
	  		or tblOrder.sMatchbackSourceCode like '20_B' or tblOrder.sMatchbackSourceCode like '212_'
	  		or tblOrder.sMatchbackSourceCode like '213_' or tblOrder.sMatchbackSourceCode like '219_'
	  		or tblOrder.sMatchbackSourceCode like '221_' or tblOrder.sMatchbackSourceCode like '232_'
	  		or tblOrder.sMatchbackSourceCode like '90_' or tblOrder.sMatchbackSourceCode like '91_'
	  		or tblOrder.sMatchbackSourceCode like '93_' or tblOrder.sMatchbackSourceCode like '94_'
	  		or tblOrder.sMatchbackSourceCode like '95_' or tblOrder.sMatchbackSourceCode like '96_'
	  		or tblOrder.sMatchbackSourceCode like '97_' or tblOrder.sMatchbackSourceCode like '98_'
	  		or tblOrder.sMatchbackSourceCode like '99_' or tblOrder.sMatchbackSourceCode like 'BD0%'
	  		or tblOrder.sMatchbackSourceCode like 'BD210_' or tblOrder.sMatchbackSourceCode like 'BD8_'	
	  		or tblOrder.sMatchbackSourceCode in ('220','221','2082','209D','209F','209I','209M','216H','216L','216R','220L','220A',
	  		    '230A','230R','231A','231R','231L','240A','240B','240C','240F','240R','240Y','241A','241F','241J','241K','241R','241W',
	  		    '242A','242B','242F','242W','243A','243B','246C','246P','246Q','246S','89','94','205B','205C','205L','205I','205R',
	  		    '206B','206I','206J','206K','206S','206M','233A','233L')) then 'Catalog'	
	else 'Other'
	end) as 'Order Type',
    sum(tblOrder.mMerchandise) as 'Merch',
    sum(tblOrder.mCredits) as 'Credits',
    sum(case when tblOrder.ixOrder like ('%-%') THEN 0 ELSE 1 END) as '# Orders'
from tblOrder
where
	--tblOrder.dtOrderDate >= '10/01/09' and tblOrder.dtOrderDate <='09/30/10'
	tblOrder.dtOrderDate >= '07/01/10' and tblOrder.dtOrderDate <='06/30/11'
	and 
	tblOrder.sOrderChannel <> 'INTERNAL'
    and
    tblOrder.sOrderStatus not in ('Cancelled','Pick Ticket')
    and
    tblOrder.sMatchbackSourceCode not in ('RETURN','RETURNS','INTERNAL','CWS','JDS')
group by 
  tblOrder.sMatchbackSourceCode,
  tblOrder.dtOrderDate,
	(case 
		when (tblOrder.sMatchbackSourceCode in ('MRR','MRRWEB','PRS','PRSWEB','PRS212','PRS1299','PRS2699','PRS99','311D','293MRR','268D','269D','273D','287D','290D','292D','293D') or 
			  tblOrder.sMatchbackSourceCode = 'VEND' or
			  tblOrder.sMatchbackSourceCode like 'MRR%' or tblOrder.sMatchbackSourceCode like 'PRS%') then 'Wholesale'
		when (tblOrder.sMatchbackSourceCode like 'BUD%' or tblOrder.sMatchbackSourceCode like '%BUDY' or tblOrder.sMatchbackSourceCode in ('BP10')) then 'Budy'
		when (tblOrder.sMatchbackSourceCode in ('2888','2899','4088','4999','5099')) then 'Other'
		when (tblOrder.sMatchbackSourceCode = '29388') then 'Catalog'
		when (tblOrder.sMatchbackSourceCode like '%88' or tblOrder.sMatchbackSourceCode like '%99' or tblOrder.sMatchbackSourceCode like 'PIP%'
	          or tblOrder.sMatchbackSourceCode in ('24866','24966','25066','25566','25666','25766','240L','242L','243L','246L','247L','249L','BW139','201B','212P','213P','219P','240X',
	          '241C','241L','242X','243X','AFCOREQ','BD04R','BD0866','BD01B','BD07L','BD0899','BD0999','BD0977','CCSR')) then 'RIP/PIP'
		when (tblOrder.sMatchbackSourceCode like '248_' or tblOrder.sMatchbackSourceCode like '249_' or tblOrder.sMatchbackSourceCode like '250_' or
		  tblOrder.sMatchbackSourceCode like '251_' or tblOrder.sMatchbackSourceCode like '252_' or tblOrder.sMatchbackSourceCode like '253_' or
		  tblOrder.sMatchbackSourceCode like '254_' or tblOrder.sMatchbackSourceCode like '255_' or tblOrder.sMatchbackSourceCode like '256_' or
		  tblOrder.sMatchbackSourceCode like '257_' or tblOrder.sMatchbackSourceCode like '258_' or tblOrder.sMatchbackSourceCode like '259_' or 
		  tblOrder.sMatchbackSourceCode like '260_' or tblOrder.sMatchbackSourceCode like '261_' or tblOrder.sMatchbackSourceCode like '262_' or
		  tblOrder.sMatchbackSourceCode like '263_' or tblOrder.sMatchbackSourceCode like '264_' or tblOrder.sMatchbackSourceCode like '265_' or
		  tblOrder.sMatchbackSourceCode like '266_' or tblOrder.sMatchbackSourceCode like '267_' or tblOrder.sMatchbackSourceCode like '268_' or
		  tblOrder.sMatchbackSourceCode like '269_' or tblOrder.sMatchbackSourceCode like '270_' or tblOrder.sMatchbackSourceCode like '271_' or
		  tblOrder.sMatchbackSourceCode like '272_' or tblOrder.sMatchbackSourceCode like '273_' or tblOrder.sMatchbackSourceCode like '274_' or
		  tblOrder.sMatchbackSourceCode like '275_' or tblOrder.sMatchbackSourceCode like '276_' or tblOrder.sMatchbackSourceCode like '277_' or
		  tblOrder.sMatchbackSourceCode like '278_' or tblOrder.sMatchbackSourceCode like '279_' or tblOrder.sMatchbackSourceCode like '280_' or
		  tblOrder.sMatchbackSourceCode like '281_' or tblOrder.sMatchbackSourceCode like '282_' or tblOrder.sMatchbackSourceCode like '283_' or
		  tblOrder.sMatchbackSourceCode like '284_' or tblOrder.sMatchbackSourceCode like '285_' or tblOrder.sMatchbackSourceCode like '286_' or
		  tblOrder.sMatchbackSourceCode like '287_' or tblOrder.sMatchbackSourceCode like '288_' or tblOrder.sMatchbackSourceCode like '289_' or
		  tblOrder.sMatchbackSourceCode like '290_' or tblOrder.sMatchbackSourceCode like '291_' or tblOrder.sMatchbackSourceCode like '292_' or
		  tblOrder.sMatchbackSourceCode like '293_' or tblOrder.sMatchbackSourceCode like '294_' or tblOrder.sMatchbackSourceCode like '295_' or
		  tblOrder.sMatchbackSourceCode like '296_' or tblOrder.sMatchbackSourceCode like '297_' or tblOrder.sMatchbackSourceCode like '298_' or
		  tblOrder.sMatchbackSourceCode like '299_' or tblOrder.sMatchbackSourceCode like '300_' or tblOrder.sMatchbackSourceCode like '301_' or
		  tblOrder.sMatchbackSourceCode like '302_' or tblOrder.sMatchbackSourceCode like '303_' or tblOrder.sMatchbackSourceCode like '304_' or
		  tblOrder.sMatchbackSourceCode like '305_' or tblOrder.sMatchbackSourceCode like '306_' or tblOrder.sMatchbackSourceCode like '307_' or
		  tblOrder.sMatchbackSourceCode like '308_' or tblOrder.sMatchbackSourceCode like '309_' or tblOrder.sMatchbackSourceCode like '310_' or
		  tblOrder.sMatchbackSourceCode like '311_' or tblOrder.sMatchbackSourceCode in ('IMCA 50','IMCA 51','IMCA 52','IMCA 53','IMCA 54',
		  'IMCA 55','IMCA01','IMCA08','IMCA09','IMCA14','IMCA16','IMCA19','IMCA22','IMCA23','IMCA24',
		  'IMCA25','IMCA26','IMCA33','IMCA34','IMCA38','IMCA56','IMCA57','IMCA58','IMCA59','IMCA63','IMCA64',
		  'IMCA65','IMCA66','IMCA67','IMCA68','IMCA69','IMCA74','IMCA80','IMCAROOK','IMCATV','IMCATV71',
		  '1088','2099','2299','3199','3288','3299','3688','3888','3988','3999','4088','4188','4199',
		  '4999','5099','5199','5388','5588','5688','5699','5799','5888','5899','222','223','224','225','226','227','228','229','236','237','244','2121','2211','2212','2214',
		  '2326','2470')) then 'Other'
	when tblOrder.sMatchbackSourceCode like 'CTR%' or tblOrder.sMatchbackSourceCode = '0' then 'Counter'
	when tblOrder.sMatchbackSourceCode in ('2190','2191','2192','2193','2194','EBAY','BDNET','BDNET_06','BDNET2007','BD2193','NET','NET06','NET7','TC01','WCR2','WCR3','WCR4','WCR5','WCR6','WCR7','WCR9','WCR22','WWW','GGL') 
	      or tblOrder.sMatchbackSourceCode like 'WG7%' or tblOrder.sMatchbackSourceCode like 'WY7%' or tblOrder.sMatchbackSourceCode like 'WJJ%' or tblOrder.sMatchbackSourceCode like 'WGB%' or tblOrder.sMatchbackSourceCode like 'WHH%'
	      or tblOrder.sMatchbackSourceCode like 'WP4%' then 'Web'	
    when (tblOrder.sMatchbackSourceCode in ('1179','2595','5004','5297','5653','5704','RCB9','293N','256HR','257HR','261KR','262KR','264RR','264BP','262BCSM','232F',
          '1052','1053','2636','3684','3719','5034','5158','5190','5502','5607','5676','5737','5738','232A','232F','243G','243GK','BDNSRA00','BDYORK','CB8','CBS8') 
			or tblOrder.sMatchbackSourceCode like '%AM7'
			or tblOrder.sMatchbackSourceCode like '%ASCS'
			or tblOrder.sMatchbackSourceCode like '%B50'
			or tblOrder.sMatchbackSourceCode like '%BASH'
			or tblOrder.sMatchbackSourceCode like '%BN'
			or tblOrder.sMatchbackSourceCode like '%BSN'
			or tblOrder.sMatchbackSourceCode like '%CAR'
			or tblOrder.sMatchbackSourceCode like '%CB'
			or tblOrder.sMatchbackSourceCode like '%CNA'
			or tblOrder.sMatchbackSourceCode like '%DRAG'
			or tblOrder.sMatchbackSourceCode like '%ESRN'
			--or tblOrder.sMatchbackSourceCode like '%F'
			or tblOrder.sMatchbackSourceCode like '%FF'
			or tblOrder.sMatchbackSourceCode like '%GA'
			or tblOrder.sMatchbackSourceCode like '%GC'
			or tblOrder.sMatchbackSourceCode like '%GD'
			or tblOrder.sMatchbackSourceCode like '%GG%'
			or tblOrder.sMatchbackSourceCode like '%GH'
			or tblOrder.sMatchbackSourceCode like '%GL'
			or tblOrder.sMatchbackSourceCode like '%GN'
			or tblOrder.sMatchbackSourceCode like '%GNR'
			or tblOrder.sMatchbackSourceCode like '%GP'
			or tblOrder.sMatchbackSourceCode like '%GR'
			or tblOrder.sMatchbackSourceCode like '%GT'
			or tblOrder.sMatchbackSourceCode like '%HCP'
			or tblOrder.sMatchbackSourceCode like '%HPA'
			or tblOrder.sMatchbackSourceCode like '%HRN'
			or tblOrder.sMatchbackSourceCode like '%HRR'
			or tblOrder.sMatchbackSourceCode like '%HRT'
			or tblOrder.sMatchbackSourceCode like '%IMCA'
			or tblOrder.sMatchbackSourceCode like '%IMCA42'
			or tblOrder.sMatchbackSourceCode like '%IMIS'
			or tblOrder.sMatchbackSourceCode like '%K360'
			or tblOrder.sMatchbackSourceCode like '%KKOA'
			or tblOrder.sMatchbackSourceCode like '%KN'
			or tblOrder.sMatchbackSourceCode like '%LR'
			or tblOrder.sMatchbackSourceCode like '%LSM'
			or tblOrder.sMatchbackSourceCode like '%MN7'
			or tblOrder.sMatchbackSourceCode like '%MRA'
			or tblOrder.sMatchbackSourceCode like '%MRAG'
			or tblOrder.sMatchbackSourceCode like '%NN'
			or tblOrder.sMatchbackSourceCode like '%NSRA'
			or tblOrder.sMatchbackSourceCode like '%PP'
			or tblOrder.sMatchbackSourceCode like '%PRI'
			or tblOrder.sMatchbackSourceCode like '%PT8'
			or tblOrder.sMatchbackSourceCode like '%PWR'
			or tblOrder.sMatchbackSourceCode like '%RK'
			or tblOrder.sMatchbackSourceCode like '%RS'
			or tblOrder.sMatchbackSourceCode like '%RSRN'
			or tblOrder.sMatchbackSourceCode like '%SCCA'
			or tblOrder.sMatchbackSourceCode like '%SRN'
			or tblOrder.sMatchbackSourceCode like '%SSRN'
			or tblOrder.sMatchbackSourceCode like '%TBN'
			or tblOrder.sMatchbackSourceCode like '%TRP'
			or tblOrder.sMatchbackSourceCode like '%VX'
			or tblOrder.sMatchbackSourceCode like '%W100'
			or tblOrder.sMatchbackSourceCode like '%WE'
			or tblOrder.sMatchbackSourceCode like '%WIS'
			or tblOrder.sMatchbackSourceCode like '%WW%'
			or tblOrder.sMatchbackSourceCode like '%XV'
			or tblOrder.sMatchbackSourceCode like 'GG%'
			or tblOrder.sMatchbackSourceCode like 'IMCA%'
			or tblOrder.sMatchbackSourceCode like 'NATS%'
			or tblOrder.sMatchbackSourceCode like 'PP0%'
			or tblOrder.sMatchbackSourceCode like 'PPED%'
			or tblOrder.sMatchbackSourceCode like 'RCB%'
			or tblOrder.sMatchbackSourceCode like 'RR%') then 'Event'
	when (tblOrder.sMatchbackSourceCode like '248%' or tblOrder.sMatchbackSourceCode like '247%'
			or tblOrder.sMatchbackSourceCode like '249%'
			or tblOrder.sMatchbackSourceCode like '250%'
	  		or tblOrder.sMatchbackSourceCode like '251%'
	  		or tblOrder.sMatchbackSourceCode like '252%'
	  		or tblOrder.sMatchbackSourceCode like '253%'
	  		or tblOrder.sMatchbackSourceCode like '254%'
	  		or tblOrder.sMatchbackSourceCode like '255%'
	  		or tblOrder.sMatchbackSourceCode like '256%'
	  		or tblOrder.sMatchbackSourceCode like '257%'
	  		or tblOrder.sMatchbackSourceCode like '258%'
	  		or tblOrder.sMatchbackSourceCode like '259%'
	  		or tblOrder.sMatchbackSourceCode like '260%'
	  		or tblOrder.sMatchbackSourceCode like '261%'
	  		or tblOrder.sMatchbackSourceCode like '262%'
	  		or tblOrder.sMatchbackSourceCode like '263%'
	  		or tblOrder.sMatchbackSourceCode like '264%'
	  		or tblOrder.sMatchbackSourceCode like '265%'
	  		or tblOrder.sMatchbackSourceCode like '268%'
	  		or tblOrder.sMatchbackSourceCode like '269%'
	  		or tblOrder.sMatchbackSourceCode like '270%'
	  		or tblOrder.sMatchbackSourceCode like '271%'
	  		or tblOrder.sMatchbackSourceCode like '272%'
	  		or tblOrder.sMatchbackSourceCode like '273%'
	  		or tblOrder.sMatchbackSourceCode like '274%'
	  		or tblOrder.sMatchbackSourceCode like '275%'
	  		or tblOrder.sMatchbackSourceCode like '276%'
	  		or tblOrder.sMatchbackSourceCode like '277%'
	  		or tblOrder.sMatchbackSourceCode like '278%'
	  		or tblOrder.sMatchbackSourceCode like '279%'
	  		or tblOrder.sMatchbackSourceCode like '280%'
	  		or tblOrder.sMatchbackSourceCode like '281%'
	  		or tblOrder.sMatchbackSourceCode like '282%'
	  		or tblOrder.sMatchbackSourceCode like '283%'
	  		or tblOrder.sMatchbackSourceCode like '284%'
	  		or tblOrder.sMatchbackSourceCode like '285%'
	  		or tblOrder.sMatchbackSourceCode like '286%'
	  		or tblOrder.sMatchbackSourceCode like '287%'
	  		or tblOrder.sMatchbackSourceCode like '288%'
	  		or tblOrder.sMatchbackSourceCode like '289%'
	  		or tblOrder.sMatchbackSourceCode like '290%'
	  		or tblOrder.sMatchbackSourceCode like '291%'
	  		or tblOrder.sMatchbackSourceCode like '292%'
	  		or tblOrder.sMatchbackSourceCode like '293%'
	  		or tblOrder.sMatchbackSourceCode like '294%'
	  		or tblOrder.sMatchbackSourceCode like '295%'
	 		or tblOrder.sMatchbackSourceCode like '296%'
	  		or tblOrder.sMatchbackSourceCode like '297%'
	  		or tblOrder.sMatchbackSourceCode like '298%'
	  		or tblOrder.sMatchbackSourceCode like '299%'
	  		or tblOrder.sMatchbackSourceCode like '300%'
	  		or tblOrder.sMatchbackSourceCode like '301%'
	  		or tblOrder.sMatchbackSourceCode like '302%'
	  		or tblOrder.sMatchbackSourceCode like '303%'
	  		or tblOrder.sMatchbackSourceCode like '304%'
	  		or tblOrder.sMatchbackSourceCode like '305%'
	  		or tblOrder.sMatchbackSourceCode like '306%'
	  		or tblOrder.sMatchbackSourceCode like '307%'
	  		or tblOrder.sMatchbackSourceCode like '308%'
	  		or tblOrder.sMatchbackSourceCode like '309%'
	  		or tblOrder.sMatchbackSourceCode like '310%'
	  		or tblOrder.sMatchbackSourceCode like '311%'
	  		or tblOrder.sMatchbackSourceCode like '312%'
	  		or tblOrder.sMatchbackSourceCode like '313%'
	  		or tblOrder.sMatchbackSourceCode like '314%'
	  		or tblOrder.sMatchbackSourceCode like '315%'
	  		or tblOrder.sMatchbackSourceCode like '316%'
	  		or tblOrder.sMatchbackSourceCode like '317%'
	  		or tblOrder.sMatchbackSourceCode like '318%'
	  		or tblOrder.sMatchbackSourceCode like '319%'
	  		or tblOrder.sMatchbackSourceCode like '320%'
	  		or tblOrder.sMatchbackSourceCode like '321%'
	  		or tblOrder.sMatchbackSourceCode like 'BW135'
	  		or tblOrder.sMatchbackSourceCode like 'BW136'
	  		or tblOrder.sMatchbackSourceCode like 'BW137'
	  		or tblOrder.sMatchbackSourceCode like 'BW138'
	  		or tblOrder.sMatchbackSourceCode like '%CAT'
	  		or tblOrder.sMatchbackSourceCode like '%NO' 
	  		or tblOrder.sMatchbackSourceCode like '20_' or tblOrder.sMatchbackSourceCode like '21_'
	  		or tblOrder.sMatchbackSourceCode like '23_' or tblOrder.sMatchbackSourceCode like '24_'
	  		or tblOrder.sMatchbackSourceCode like '20_B' or tblOrder.sMatchbackSourceCode like '212_'
	  		or tblOrder.sMatchbackSourceCode like '213_' or tblOrder.sMatchbackSourceCode like '219_'
	  		or tblOrder.sMatchbackSourceCode like '221_' or tblOrder.sMatchbackSourceCode like '232_'
	  		or tblOrder.sMatchbackSourceCode like '90_' or tblOrder.sMatchbackSourceCode like '91_'
	  		or tblOrder.sMatchbackSourceCode like '93_' or tblOrder.sMatchbackSourceCode like '94_'
	  		or tblOrder.sMatchbackSourceCode like '95_' or tblOrder.sMatchbackSourceCode like '96_'
	  		or tblOrder.sMatchbackSourceCode like '97_' or tblOrder.sMatchbackSourceCode like '98_'
	  		or tblOrder.sMatchbackSourceCode like '99_' or tblOrder.sMatchbackSourceCode like 'BD0%'
	  		or tblOrder.sMatchbackSourceCode like 'BD210_' or tblOrder.sMatchbackSourceCode like 'BD8_'	
	  		or tblOrder.sMatchbackSourceCode in ('220','221','2082','209D','209F','209I','209M','216H','216L','216R','220L','220A',
	  		    '230A','230R','231A','231R','231L','240A','240B','240C','240F','240R','240Y','241A','241F','241J','241K','241R','241W',
	  		    '242A','242B','242F','242W','243A','243B','246C','246P','246Q','246S','89','94','205B','205C','205L','205I','205R',
	  		    '206B','206I','206J','206K','206S','206M','233A','233L')) then 'Catalog'	
	else 'Other'
	end) 