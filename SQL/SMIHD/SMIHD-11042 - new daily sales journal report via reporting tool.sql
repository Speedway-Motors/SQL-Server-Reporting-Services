-- SMIHD-11042 - new daily sales journal report via reporting tool


/* from Jeff Scales
I get a daily sales journal for our various brands: Longacre, AFCO, PRO. 
Would it be possible to have these files as reporting tool files, searchable by day, 
same fields, but add a gross margin percentage calculation? 

We have to do this manually now---read the reports, look for margin problems, then research. 
Excel based
add GM% field

conditional formatting in the gross margin % column: 
>45% green, 
35-45% yellow
15-35 orange 
<15% red 



LONGACRE DAILY SALES JOURNAL FOR 05/25/18

ORD#    CUST    SHP      Order INV.DATE                 CUST#   NAME            MoP         COST OF     MDSE    SHIP    TAXES   CREDIT  NET     
        LEV     DAT      Taker (same as orderdate?)                                         GOODS.      TOTAL   CHGS    
834810  1       05/25/18 5AAW  05/25/18                 62732   KENNEDY (LA)    PP-AUCTION  24.19       155.87  7.93    0.00    0.00    163.80

select * from tblOrder where ixOrder = '834809'
select * from tblOrderLine where ixOrder = '834809'

select distinct ixOrder from tblOrderLine where ixOrderDate > 18408
and ixSKU like '52-%'
and ixOrder NOT LIKE '%-%'
and ixOrder NOT LIKE 'Q%'
order by ixOrder

SELECT * from tblOrderLine 
where ixOrder in ('823351','827365','827366','833986','834120','834123','834841','834842','834844','834845','834846','834847','834848','834849','834852','834856','834857','834858','834859','834860','834861','834862','834864','834866','834867','834869','834870','834871','834873','834878','834879','834880','834882','834883','834884','834887','834890','834891','834895','834900','834903','834907','834912','834916','834922','834923','834924','834926','834931','834937','834938','834939','834940','834941','834943','834944','834945','834946','834947','834948','834950','834952','834966','834970','834974','834989','834991','834993','834994','834996','834999','835001','835004','835006','835009','835010','835011','835012','835015','835016','835017','835019','835025','835027','835028','835029','835030','835032','835036','835039','835040','835047','835050','835053','835054','835055','835057','835063','835068','835076','835079','835080','835083','835084','835088','835089','835093','835094','835096','835104','835106','835107','835108','835128','835134','835135','835136','835137','835138','835139','835140','835141','835145','835148','835149','835151','835152','835153','835161','835170','835171','835174','835175','835181','835186','835198','835199','835200','835210','835211','835212','835213','835214','835215','835216','835217','835218','835219','835220','835221','835222','835223','835224','835225','835227','835234','835236','835238','835239','835241','835242','835243','835244','835245','835249','835251','835258','835259','835261','835262','835263','835271','835273','835277','835293','835303','835304','835310','835313','835316','835320','835322','835323','835324','835325','835327','835328','835329','835331','835334','835335','835338','835342','835343','835345','835346','835347','835348','835363','835367','835368','835369','835371','835373','835374','835375','835376','835378','835380','835381','835382','835383','835385','835386','835387','835389','835392','835393','835394','835395','835396','835397','835398','835399','835401','835402','835409','835413','835415','835419','835427','835428','835429','835430','835431','835433','835435','835436','835437','835443','835444','835453','835460','835462','835466','835468','835470','835473','835474','835475','835478','835479','835481','835485','835486','835490','835491','835496','835497','835508','835509','835511','835513','835517','835523','835532','835535','835536','835537','835538','835539','835545','835546','835547','835551','835552','835555','835559','835560','835572','835573','835575','835578','835584','835587','835589','835593','835597','835598','835599','835601','835602','835603','835606','835607','835625','835633','835638','835640','835642','835646','835654','835655','835656','835668','835679','835680','835684','835687','835688','835690','835695','835696','835704','835706','835710','835711','835712','835714','835717','835718','835726','835727','835728','835729','835731','835741','835748','835750','835751','835762','835768','835775','835776','835779','835780','835782','835783','835784','835789','835794','835797','835798','835799','835804','835810','835811','835813','835814','835816','835819','835822','835823','835825','835826','835831','835832','835834','835836','835838','835843','835845','835846','835850','835852','835853','835855','835864','835865','835867','835869','835871','835872','835875','835876','835881','835882','835890','835892','835893','835894','835897','835898','835899','835901','835902','835910','835912','835914','835915','835919','835920','835921','835928','835929','835931','835932','835933','835939','835943','835944','835957','835962','835971','835973','835974','835975','835979','835986','835996','835997','835998','835999','836000','836001','836005','836009','836011','836017','836018','836025','836028','836029','836033','836037','836039','836040','836049','836051','836056','836062','836064','836074','836079','836081','836086','836087','836090','836092','836093','836096','836097','836099','836102','836108','836110','836111','836115','836117','836118','836120','836121','836127','836129','836138','836143','836149','836151','836152','836156','836157','836159','836165','836166','836168','836170','836173','836175','836176','836177','836179','836180','836182','836186','836187','836188','836189','836190','836191','836208','836211','836216','836220','836222','836231','836232','836236','836237','836243','836245','836249','836253','836263','836264','836265','836267','836268','836272','836273','836276','836285','836288','836291','836293','836301','836303','836307','836313','836314','836315','836319','836330','836331','836332','836334','836335','836340','836341','836342','836343','836345','836355','836356','836360','836364','836370','836371','836372','836373','836374','836375','836383','836386','836388','836394','836398','836400','836402','836410','836418','836425','836426','836427','836428','836429','836435','836443','836447','836453','836454','836455','836459','836465','836466','836469','836470','836471','836473','836474','836476','836477','836481','836482','836486','836487','836488','836489','836490','836492','836493','836497','836498','836499','836507','836510','836515','836516','836517','836522','836527','836531','836535','836536','836538','836547','836550','836551','836553','836560','836561','836565','836566','836567','836571','836572','836576','836578','836580','836588','836592','836594','836598','836605','836607','836611','836618','836619','836620','836621','836622','836623','836624','836625','836627','836629','836630','836631','836632','836634','836638','836649','836658','836663','836666','836670','836671','836674','836676','836682','836684','836686','836687','836693','836698','836700','836709','836712','836715','836720','836729','836734','836737','836744','836745','836746','836748','836751','836753','836755','836756','836757','836758','836759','836760','836762','836763','836765','836766','836775','836781','836783','836784','836789','836792','836800','836802','836818','836833','836835','836841','836842','836843','836849','836851','836852','836853','836864','836868','836870','836871','836872','836874','836877','836881','836884','836885','836900','836902','836914','836915','836916','836917','836918','836919','836922','836923','836924','836925','836926','836931','836935','836939','836943','836949','836955','836959','836960','836963','836968','836975','836978','836986','836989','836991','836993','836994','836997','836999','837001','837006','837011','837015','837018','837020','837027','837029','837032','837033','837034','837051','837052','837055','837056','837057','837062','837063','837073','837074','837082','837084','837087','837088','837089','837090','837092','837093','837096','837097','837099','837101','837103','837104','837107','837116','837119','837122','837128','837130','837132','837135','837137','837138','837139','837142','837147','837156','837159','837160','837165','837166','837169','837171','837173','837183','837184','837185','837187','837191','837202','837204','837212','837213','837218','837219','837220','837223','837225','837228','837229','837246','837255','837257','837258','837262','837264','837265','837268','837270','837271','837272','837273','837274','837275','837276','837277','837278','837279','837280','837281','837282','837283','837286','837287','837288','837291','837292','837293','837294','837295','837296','837297','837298','837299','837300','837301','837302','837305','837307','837308','837309','837323','837324','837327','837329','837330','837331','837332','837334','837335','837337','837346','837349','837352','837357','837358','837360','837364','837373','837386','837387','837393','837394','837396','837397','837398','837399','837400','837409','837410','837411','837412','837413','837414','837415','837418','837419','837420','837421','837422','837425','837426','837430','837433','837435','837443','837444','837445','837446','837447','837448','837450','837452','837459','837464','837470','837472','837476','837477','837480','837481','837484','837485','837491','837494','837495','837499','837502','837504','837506','837507','837511','837518','837520','837537','837542','837551','837553','837563','837568','837569','837573','837575','837578','837587','837588','837589','837591','837593','837594','837595','837596','837597','837605','837609','837612','837615','837616','837619','837620','837622','837648','837649','837650','837654','837655','837657','837658','837659','837667','837668','837676','837677','837687','837691','837692','837695','837697','837698','837699','837703','837704','837708','837711','837715','837718','837722','837723','837727','837728','837729','837731','837734','837735','837738','837739','837740','837743','837745','837746','837747','837756','837757','837761','837763','837775','837780','837781','837790','837791','837793','837797','837814','837820','837821','837822','837824','837825','837827','837830','837831','837836','837839','837840','837841','837842','837843','837845','837855','837859','837860','837871','837889','837891','837892','837893','837896','837898','837899','837900','837902','837903','837904','837914','837928','837929','837931','837932','837935','837936','837938','837940','837941','837943','837944','837945','837946','837952','837954','837956','837961','837962','837963','837965','837968','837970','837972','837975','837976','837988','837992','837996','837997','837999','838004','838008','838011','838012','838015','838018','838019','838020','838024','838027','838028','838029','838031','838041','838043','838044','838047','838048','838052','838057','838058','838065','838068','838073','838088','838095','838096','838097','838098','838101','838104','838107','838112','838116','838117','838118','838120','838121','838125','838135','838137','838139','838141','838144','838149','838150','838154','838158','838160','838163','838164','838166','838167','838168','838170','838171','838173','838176','838184','838187','838190','838192','838196','838197','838200','838202','838209','838213','838214','838215','838218','838219','838220','838221','838224','838226','838231','838241','838248','838250','838251','838252','838255','838259','838265','838268','838270','838271','838272','838273','838279','838280','838281','838287','838288','838289','838290','838295','838296','838298','838308','838309','838314','838316','838318','838322','838333','838334','838335','838336','838338','838339','838340','838342','838343','838346','838348','838349','838350','838352','838353','838360','838365','838367','838368','838369','838370','838371','838373','838375','838377','838379','838380','838381','838382','838386','838394','838399','838410','838411','838412','838415','838416','838417','838420','838422','838423','838425','838427','838428','838431','838432','838433','838434','838435','838442','838445','838448','838457','838458','838469','838470','838472','838473','838474','838477','838479','838481','838486','838487','838488','838489','838490','838492','838493','838494','838497','838501','838502','838504','838506','838507','838508','838510','838513','838515','838521','838522','838523','838528','838534','838536','838537','838547','838549','838550','838552','838553','838554','838556','838558','838559','838561','838562','838563','838564','838565','838567','838572','838573','838576','838577','838578','838579','838580','838582','838585','838591','838599','838600','838603','838605','838625','838632','838635','838637','838639','838640','838658','838663','838670','838673','838674','838679','838683','838685','838687','838691','838694','838696','838700','838701','838706','838710','838715','838716','838723','838725','838726','838728','838731','838733','838734','838737','838743','838745','838750','838751','838752','838753','838754','838756','838758','838761','838786','838789','838790','838791','838793','838798','838802','838803','838806','838809','838810','838813','838815','838820','838824','838826','838829','838834','838837','838841','838843','838853','838856','838858','838860','838862','838866','838873','838875','838877','838880','838887','838894','838897','838906','838908','838909','838911','838912','838913','838914','838917','838919','838926','838929','838939','838945','838946','838949','838952','838953','838955','838956','838958','838961','838962','838963','838966','838970','838971','838974','838975','838976','838977','838979','838982','838983','838984','838985','838990','838991','838992','838993','838995','839011','839014','839015','839029','839036','839038','839043','839045','839047','839048','839050','839058','839060','839061','839064','839065','839066','839067','839068','839075','839077','839078','839079','839080','839081','839084','839089','839096','839098','839100','839112','839122','839123','839124','839126','839131','839136','839138','839139','839140','839141','839149','839151','839153','839154','839158','839160','839164','839171','839175','839176','839181','839184','839185','839202','839203','839204','839205','839206','839207','839216','839218','839222','839224','839234','839235','839236','839241','839242','839245','839249','839251','839253','839254','839260','839261','839262','839263','839266','839268','839270','839271','839274','839275','839277','839278','839279','839280','839284','839286','839287','839288','839293','839295','839297','839299','839300','839302','839305','839308','839317','839320','839323','839325','839326','839327','839330','839336','839337','839338','839343','839344','839347','839348','839353','839357','839362','839364','839369','839370','839371','839372','839373','839376','839377','839380','839382','839384','839386','839390','839393','839398','839399')
and ixSKU NOT IN ('PLONLY','AFCO2018','CATFF','LAWEB','RULESFF')
and ixSKU NOT LIKE '52%'
and mExtendedPrice > 0
order by ixOrder, ixSKU


