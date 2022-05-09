-- Quantity of BOMs that can be built based on QAV (Top level only)
select ixFinishedSKU, ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription', count(*) ComponentSKUs
into #BOMNumberofComponents
from tblBOMTemplateDetail TD
    left join tblSKU S on TD.ixFinishedSKU = S.ixSKU
WHERE S.flgDeletedFromSOP = 0
    and S.flgActive = 1
    and S.flgIntangible = 0
    and S.mPriceLevel1 > 0
group by ixFinishedSKU, ISNULL(S.sWebDescription, S.sDescription)
order by count(*) desc

select * from #BOMNumberofComponents
order by ComponentSKUs desc

select * from tblBOMTemplateDetail
where ixFinishedSKU = '94610006-NE'

select TD.ixFinishedSKU, TD.ixSKU, TD.iQuantity, SL.iQAV, NC.SKUDescription
from tblBOMTemplateDetail TD
    left join #BOMNumberofComponents NC on TD.ixFinishedSKU = NC.ixFinishedSKU
    left join tblSKULocation SL on SL.ixSKU = TD.ixSKU and SL.ixLocation = 99
WHERE NC.ComponentSKUs = 3
   AND TD.iQuantity > 1
   AND SL.iQAV >= 0
ORDER BY TD.ixFinishedSKU

ixFinished
SKU	        ixSKU	        iQuantity	iQAV    SKUDescription	                                                        MAX pos
350018	    350018.1	    2	        329     G-Comp Rear Trailing Arm Steel U-Bolts, 10 Inches	                    
350018	    HZ2SFW-SAE-.75	4	        18      G-Comp Rear Trailing Arm Steel U-Bolts, 10 Inches	                    4
350018	    HZ5HNF-.75	    4	        63      G-Comp Rear Trailing Arm Steel U-Bolts, 10 Inches	                    

91015840-SS	91015840-2	    4	        1	    1949-53 St. Steel Flathead Ford/Mercury V8 Radiator Hose Dress-Up Kit
91015840-SS	91015840-SS1	2	        4	    1949-53 St. Steel Flathead Ford/Mercury V8 Radiator Hose Dress-Up Kit   0
91015840-SS	915604-020	    8	        494	    1949-53 St. Steel Flathead Ford/Mercury V8 Radiator Hose Dress-Up Kit

91633010	91633010-1	    2	        0	    Plain Model T thru 1934 U-Bolts
91633010	HZ2SFW-SAE-.44	4	        3513	Plain Model T thru 1934 U-Bolts                                         0
91633010	HZ5NLNF-.44	    4	        187	    Plain Model T thru 1934 U-Bolts

92610569	92612862	    6	        303	    Replacement Complete Front Spoiler Hardware Kit for 1967-69 Camaro
92610569	92614361	    6	        2285	Replacement Complete Front Spoiler Hardware Kit for 1967-69 Camaro      0
92610569	92618408	    5	        0	    Replacement Complete Front Spoiler Hardware Kit for 1967-69 Camaro

94517802	617412	        10	        364	    EMI® Tank to Filter Line
94517802	6174225	        2	        40	    EMI® Tank to Filter Line                                                20
94517802	94601	        5	        1031	EMI® Tank to Filter Line

97080100	HZ5TNLN-SAE-.25	6	        1578	Henchcraft® Nose Wing Bolt Kit
97080100	HZ8HCSF-.25-.50	2	        170	    Henchcraft® Nose Wing Bolt Kit                                          24
97080100	HZ8HCSF-.25-.75	4	        97	    Henchcraft® Nose Wing Bolt Kit


-- Quantity of BOMs that can be built based on QAV
SELECT TM.ixFinishedSKU, MIN(QP.QtyPos) 'MaxPossibleBasedOnComponentQAV'
FROM tblBOMTemplateMaster TM
    LEFT JOIN (-- QtyPos for ALL component SKUs
                SELECT TD.ixFinishedSKU, TD.ixSKU, 
                    --TD.iQuantity, SL.iQAV, 
                    (SL.iQAV/TD.iQuantity) 'QtyPos'
                FROM tblBOMTemplateDetail TD
                    left join tblSKU S on TD.ixSKU = S.ixSKU
                    left join tblSKULocation SL on SL.ixSKU = TD.ixSKU and SL.ixLocation = 99
                WHERE S.flgDeletedFromSOP = 0
                    and S.flgIntangible = 0
                ) QP on TM.ixFinishedSKU = QP.ixFinishedSKU
WHERE TM.ixFinishedSKU in ('9106123')
GROUP BY TM.ixFinishedSKU
/*
ixFinished  MaxPossibleBasedOn
SKU	        ComponentQAV
350018	    4
91015840-SS	0
91633010	0
92610569	0
94517802	20
97080100	24

RESULTS MATCH UP!
*/




select TD.ixFinishedSKU, TD.ixSKU, TD.iQuantity, SL.iQAV, 
(SL.iQAV/TD.iQuantity) 'QtyPos'
from tblBOMTemplateDetail TD
    left join tblSKULocation SL on SL.ixSKU = TD.ixSKU and SL.ixLocation = 99
--WHERE TD.ixFinishedSKU in ('350018') -- '91015840-SS','91633010','92610569','94517802','97080100'
ORDER BY TD.ixFinishedSKU


(-- QtyPos for ALL component SKUs
select TD.ixFinishedSKU, TD.ixSKU, TD.iQuantity, SL.iQAV, 
    (SL.iQAV/TD.iQuantity) 'QtyPos'
from tblBOMTemplateDetail TD
    left join tblSKU S on TD.ixSKU = S.ixSKU
    left join tblSKULocation SL on SL.ixSKU = TD.ixSKU and SL.ixLocation = 99
WHERE S.flgDeletedFromSOP = 0
    and S.flgIntangible = 0
and TD.ixFinishedSKU in ('91034342-3') -- '91015840-SS','91633010','92610569','94517802','97080100'
)
/*
ixFinishedSKU	    ixSKU	iQuantity	iQAV	QtyPos
9106123	            91061230	1	    -15	        -15
9106123	            910641931	2	    87	        43
9106123	            INSTRUCT	1	    6332	    6332

91533383	91533383.1	1	-20	-20
91533383	91533383.2	1	-20	-20

*/

select ixSKU, ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription'
from tblSKU S
where ixSKU in ('91533383.1','91533383.2')





