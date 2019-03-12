use Territory
go

CREATE PROCEDURE GetMapActivitySummary
				@dateFrom date = null,
				@dateTo date = null
AS
BEGIN
	if (@dateFrom is null)
	begin
		select @dateFrom = '1900-01-01'
	end

	if (@dateTo is null)
	begin
		select @dateTo = '2999-12-31'
	end

    --create temp table for result
	create table #Result(
		TotalActiveMap int,
		TotalNumberOfMap int,
		TotalCompletedMap int,
		NumberOfTimesDone int,
		TotalNotDoneMap int 
	)

	declare @count int

	--get all active maps
	select @count = count(1) from CallGroup where IsActive = 1

	insert into #Result (TotalActiveMap,
		TotalNumberOfMap,
		TotalCompletedMap,
		NumberOfTimesDone,
		TotalNotDoneMap)
	select @count, @count, 0, 0, 0

	--get active map during the selected period and add it to totalmaps
	select @count = count(1) from CallGroup cg
	inner join CallActivity ca on cg.LastAssignCallActivityId = ca.Id
	where IsActive = 0 and ca.DateReleased between @dateFrom and @dateTo

	update #Result set TotalNumberOfMap = TotalNumberOfMap + @count

	--get map with activity
	select cg1.Id, cg1.CallGroupName, cg1.GroupCode, cg2.ActivityCount 
	into #temp
	from CallGroup cg1
	left outer join
	(
	select ca.CallGroupId, cg.CallGroupName, 'ActivityCount' = count(1)
	from CallActivity ca
	inner join CallGroup cg on ca.CallGroupId = cg.Id
	where cg.IsActive = 1 and ca.DateReleased between @dateFrom and @dateTo
	group by ca.CallGroupId, cg.CallGroupName 
	) cg2 on cg1.Id = cg2.CallGroupId
	where cg1.IsActive = 1

	update #Result set TotalNotDoneMap = (select count(1) from #temp where ActivityCount is null)
	update #Result set TotalCompletedMap = (select count(1) from #temp where ActivityCount is not null)
	update #Result set NumberOfTimesDone = (select sum(ActivityCount) from #temp where ActivityCount is not null)

	select * from #Result

	drop table #temp
	drop table #Result
END
GO
