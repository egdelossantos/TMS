select ca.SuburbId, s.SuburbName
into #tmpSuburb
from CallAddress ca
inner join Suburb s
on ca.SuburbId = s.Id
group by ca.SuburbId, s.SuburbName
having count(1) between 9 and 12
order by 2

declare @suburbId int, @callGroupId int
select @suburbId = 0

while (@suburbId is not null)
begin
	select @suburbId = min(suburbid) from #tmpSuburb where SuburbId > @suburbId
	if (@suburbId is not null)
	begin
		insert into CallGroup (CallGroupName, GroupCode)
		select SuburbName, SuburbName from #tmpSuburb where SuburbId = @suburbId
		select @callGroupId = @@IDENTITY

		update CallAddress set CallGroupId = @callGroupId where SuburbId = @suburbId
	end
end

drop table #tmpSuburb