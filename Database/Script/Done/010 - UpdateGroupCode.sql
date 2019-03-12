select *, Right('000000' + CONVERT(NVARCHAR, ROW_NUMBER() OVER(ORDER BY CallGroupName)), 4)  AS Code
into #tmp from CallGroup order by CallGroupName

update cg set GroupCode = t.Code 
from CallGroup cg
inner join #tmp t on cg.Id = t.Id

select * from CallGroup

drop table #tmp