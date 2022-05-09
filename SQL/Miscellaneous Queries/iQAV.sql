select SKU.ixSKU, SKU.iQAV, sum(SL.iQAV) TotSLiQAV
from tblSKU SKU
	left join tblSKULocation SL on SKU.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS = SL.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS -- 583 2:33PM 9-27-11
group by SKU.ixSKU, SKU.iQAV
having sum(SL.iQAV) <> SKU.iQAV 
order by sum(SL.iQAV)








select	SKU.ixSKU,	-- 4,114 SKUs with non-matching totals
		SKU.iQAV	'tblSKU.iQAV', 
		Loc99.iQAV	'tblSKULoc99iQAV', 
		Loc68.iQAV	'tblSKULoc68iQAV'
from tblSKU SKU
	join (select ixSKU, iQAV
          from tblSKULocation
		  where ixLocation = 99
		  ) Loc99 on SKU.ixSKU = Loc99.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS
	join (select ixSKU, iQAV
		  from tblSKULocation
		  where ixLocation = 68
		  ) Loc68 on SKU.ixSKU = Loc68.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS			
WHERE -- totals not matching
	SKU.ixSKU in (
				  select SKU.ixSKU
				  from tblSKU SKU
					left join tblSKULocation SL on SKU.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS = SL.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS -- 583 2:33PM 9-27-11
				  group by SKU.ixSKU, SKU.iQAV
				  having sum(SL.iQAV) <> SKU.iQAV 
				  )
