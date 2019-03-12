select ca.SuburbId, s.SuburbName, count(1)
from CallAddress ca
inner join Suburb s
on ca.SuburbId = s.Id
where ca.CallGroupId is null
group by ca.SuburbId, s.SuburbName
order by 3 desc

select * from vwAddress where 
SuburbId = 49 order by Street

select * from calladdress where CallGroupId is not null