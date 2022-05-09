-- Case 23639 - analysis on initial data for Mispulls

SELECT COUNT(OL.ixOrder) OLs, iMispullQuantity
from tblOrderLine OL
    join tblOrder O on O.ixOrder = OL.ixOrder
    left join tblSKU SKU on OL.ixSKU = SKU.ixSKU
where O.dtShippedDate >= '08/19/14'
    and SKU.flgIntangible = 0    
    and O.sOrderStatus = 'Shipped'
    and OL.flgLineStatus = 'Shipped'
group by iMispullQuantity
/*
OLs	iMispullQuantity
39796	0
429	1
77	2
10	3
19	4
3	5
2	6
3	8
3	10
1	12
1	16
3	20
1	21
*/

DECLARE @StartDate DATETIME,
       @EndDate DATETIME

SELECT @StartDate = '09/02/2014',
       @EndDate = '09/02/2014'       
       
-- Mispull Details <-- send daily until report layout finalized
select OL.ixOrder, OL.ixSKU, SKU.sDescription,                  -- for 9/2/14 96
    OL.ixPicker, OL.iQuantity, OL.iMispullQuantity,
    PB.sPickingBin as 'PickBin'
from tblOrderLine OL
    join tblOrder O on O.ixOrder = OL.ixOrder
    left join tblSKU SKU on OL.ixSKU = SKU.ixSKU
    left join (-- Getting Picking Bin
               Select distinct ixSKU, sPickingBin
               from tblBinSku where ixLocation = '99'
               ) PB on SKU.ixSKU = PB.ixSKU 
where O.dtShippedDate between @StartDate and @EndDate -- '09/01/2014' 
    and O.sOrderStatus = 'Shipped'
    and OL.flgLineStatus = 'Shipped'   
    and SKU.flgIntangible = 0  
    and OL.iMispullQuantity > 0
  -- AND O.ixOrder in ('5135586','5173585') 
  -- AND PB.sPickingBin like 'Y%'
  -- AND SKU.ixSKU in ('258521-BLK-2','91073072-POL')
order by PB.sPickingBin, OL.ixPicker, O.ixOrder


DECLARE @StartDate DATETIME,
       @EndDate DATETIME

SELECT @StartDate = '09/02/2014',
       @EndDate = '09/02/2014'   
-- Counts of all eligible OLs & count of mispulled OLs
select count(OL.ixOrder) OLcount,  -- for 9/2/14  8,412 
    SUM(Case when iMispullQuantity > 0 then 1
        else 0
        end) OLMispulls
from tblOrderLine OL
    join tblOrder O on O.ixOrder = OL.ixOrder
    left join tblSKU SKU on OL.ixSKU = SKU.ixSKU
    left join -- Getting Picking Bin
        (Select distinct ixSKU, sPickingBin
         from tblBinSku where ixLocation = '99'
         ) PB on SKU.ixSKU = PB.ixSKU 
where  O.dtShippedDate between @StartDate and @EndDate
    and O.sOrderStatus = 'Shipped'
    and OL.flgLineStatus = 'Shipped'   
    and SKU.flgIntangible = 0  




/*
            Tot         OrderLines
Date        OrderLines  with mispulls   Accuracy
08-19-14    6,901       55              99.2%
08-20-14    5,421       74              98.6%
08-21-14    






*/


select * from tblEmployee where ixEmployee IN ('AMP','RJF')

select * from tblBinSku where ixBin = 'SMITEMP'
order by ixLocation desc

select * from tblSKU where ixSKU in ('94011115','91001106','1503012-LH','91017161','91064017','1750115','4259776','582C330')


select OL.ixPicker, count(OL.ixOrder)   -- 
from tblOrderLine OL
    join tblOrder O on O.ixOrder = OL.ixOrder
    left join tblSKU SKU on OL.ixSKU = SKU.ixSKU
where  SKU.flgIntangible = 0    
    and O.sOrderStatus = 'Shipped'
    and OL.flgLineStatus = 'Shipped'   
    and O.dtShippedDate >= '08/01/14' 
group by OL.ixPicker
order by OL.ixPicker -- OL.iMispullQuantity 


-- total order lines by picker
select OL.ixPicker, count(OL.ixOrder)
from tblOrderLine OL
    join tblOrder O on O.ixOrder = OL.ixOrder
    left join tblSKU SKU on OL.ixSKU = SKU.ixSKU
where  SKU.flgIntangible = 0    
    and O.sOrderStatus = 'Shipped'
    and OL.flgLineStatus = 'Shipped'   
    and O.dtShippedDate >= '08/01/14' 
group by OL.ixPicker
order by count(OL.ixOrder) desc





/********************* Special request from Judson *********************/
        select * from tblOrder
        where dtShippedDate >= '08/23/2014'
        and ixOrder like '%5580'

        select OL.ixOrder, OL.ixSKU, SKU.sDescription, 
            OL.ixPicker, OL.iQuantity, OL.iMispullQuantity,
            PB.sPickingBin as 'PickBin' -- B-side SKUs have Pick Bins starting with "B"
        from tblOrderLine OL
            join tblOrder O on O.ixOrder = OL.ixOrder
            left join tblSKU SKU on OL.ixSKU = SKU.ixSKU
            left join -- Getting Picking Bin
                (Select distinct ixSKU, sPickingBin
                 from tblBinSku where ixLocation = '99'
                 ) PB on SKU.ixSKU = PB.ixSKU b     
        where  --O.dtShippedDate = '08/26/2014' -- = '08/25/14' --  
           -- and 
            O.sOrderStatus = 'Shipped'
            and OL.flgLineStatus = 'Shipped'   
            and SKU.flgIntangible = 0  
           -- and OL.iMispullQuantity > 0
           AND O.ixOrder in ('5112980','5161886','5140982','5165984')

--           AND O.ixOrder in ('5101783','5102884','5103783','5104783','5109787','5113786','5115789','5116788','5117789','5118787','5118789','5119789','5121789','5122789','5123785','5123787','5124783','5124786','5124787','5126788','5126789','5127784','5128788','5129787','5130788','5131780','5133781','5133783','5133785','5133787','5133789','5136784','5136785','5136789','5137782','5137787','5139782','5139784','5140785','5140787','5142781','5142784','5142785','5142786','5143783','5143784','5145782','5145784','5145785','5145788','5146787','5147783','5148789','5149784','5149786','5152784','5153784','5172785','5174781','5174784','5174788','5174789','5176784','5176786','5177782','5178784','5178786','5179789','5180782','5180784','5180789','5181786','5182683','5183683','5185780','5188789','5191789','5194780','5194785','5194789','5195787','5195789','5196788','5196789','5197780','5198688','5198782','5198787','5198788','5198789')
           --AND O.ixOrder in ('5135586','5173585','5118580','5121582','5117585','5118585','5121589','5121587','5121583','5123580','5103581','5103587','5105587','5109583','5110583','5113581','5117588','5128589','5198485','5101580','5127580','5193482','5123585','5195480','5125582','5102581','5127582','5126586','5100589','5106581','5106589','5124587','5176589','5175585','5170588','5175582','5170585','5174582','5176584','5178582','5176580','5172586','5174585','5176588','5177583','5172584','5177587','5104587','5150582','5150583','5154583','5154589','5155589','5157583','5158587','5195487','5149589','5150587','5158584','5152589','5157581','5151587','5103684','5101681','5101689','5196582','5100689','5104688','5100684','5198582','5197586','5198585','5104680','5198587','5199585','5172583','5197587','5107680','5104681','5108681','5106686','5112688','5105682','5113681','5109682','5106687','5114682','5109683','5111680','5114681','5108687','5111689','5152582')
           --AND PB.sPickingBin like 'Y%'
          --  AND SKU.ixSKU in ('258521-BLK-2','91073072-POL')
        order by PB.sPickingBin --O.ixOrder,
