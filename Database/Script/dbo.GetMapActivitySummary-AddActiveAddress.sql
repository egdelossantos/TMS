ALTER PROCEDURE [dbo].[GetMapActivitySummary]
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

	--declare @Result table(
	--	TotalActiveMap int,
	--	TotalNumberOfMap int,
	--	TotalCompletedMap int,
	--	NumberOfTimesDone int,
	--	TotalNotDoneMap int,
	--	CurrentCycle int,
	--	CycleUndoneMap int
	--)
	--select * from @Result

    --create temp table for result
	create table #Result(
		TotalActiveMap int,
		TotalNumberOfMap int,
		TotalCompletedMap int,
		NumberOfTimesDone int,
		TotalNotDoneMap int,
		CurrentCycle int,
		CycleUndoneMap int,
		TotalNumberOfActiveAddress int,
		TotalNumberOfNewAddress int
	)

	create table #tmpCG(
		CallGroupId int,
		IsActive bit
	)

	declare @count int
	declare @activeAddressCount int
	declare @newAddressCount int

	-- get number of active address
	select @activeAddressCount = COUNT(1) from CallAddress where IsValid = 1 AND CallGroupId IS NOT NULL

	-- get number of new address
	select @newAddressCount = COUNT(1) from CallAddress where IsValid = 1 AND CallGroupId IS NULL

	--get all active maps
	insert into #tmpCG (CallGroupId, IsActive)
	select Id as CallGroupId, 1 as IsActive
	from CallGroup where IsActive = 1

	--get current inactive maps but active map during the selected period 
	insert into #tmpCG (CallGroupId, IsActive)
	select cg.Id, 0 from CallGroup cg
	inner join CallActivity ca on cg.LastAssignCallActivityId = ca.Id
	where IsActive = 0 and ca.DateReleased between @dateFrom and @dateTo

	--get current inactive maps but active map and not assigned
	insert into #tmpCG (CallGroupId, IsActive)
	select cg.Id, 0 
	from CallGroup cg
      where cg.IsActive = 0 and cg.DateAdded <= @dateTo 
	  and cg.Id not in (select CallGroupId from #tmpCG)
	  and cg.Id not in (select CallGroupId from CallActivity)

	select @count = count(1) from #tmpCG where IsActive = 1
	insert into #Result (TotalActiveMap,
		TotalNumberOfMap,
		TotalCompletedMap,
		NumberOfTimesDone,
		TotalNotDoneMap,
		TotalNumberOfActiveAddress,
		TotalNumberOfNewAddress)
	select @count, 0, 0, 0, 0, @activeAddressCount, @newAddressCount

	--get map with activity
	select cg1.CallGroupId, cg3.CallGroupName, cg3.GroupCode, cg2.ActivityCount, cg1.IsActive  
	into #temp
	from #tmpCG cg1
	inner join CallGroup cg3 on cg1.CallGroupId = cg3.Id
	left outer join
	(
	select ca.CallGroupId, cg.CallGroupName, 'ActivityCount' = count(1)
	from CallActivity ca
	inner join CallGroup cg on ca.CallGroupId = cg.Id
	where ca.DateReleased between @dateFrom and @dateTo
	group by ca.CallGroupId, cg.CallGroupName 
	) cg2 on cg1.CallGroupId = cg2.CallGroupId
	
	update #Result set TotalNumberOfMap = (select count(1) from #temp)
	update #Result set TotalNotDoneMap = (select count(1) from #temp where ActivityCount is null)
	update #Result set TotalCompletedMap = (select count(1) from #temp where ActivityCount is not null)
	update #Result set NumberOfTimesDone = (select sum(ActivityCount) from #temp where ActivityCount is not null)

    declare @currentCycleId int, @currentCyle int, @undonecycle int
	select @currentCycleId = [CurrentCycleId], @currentCyle = [CurrentCycleNumber] from [dbo].[SystemReference]
	select @undonecycle = count(1) from CallGroup cg left outer join (
		select ca.Id, cy.Id as CycleId, cy.CycleNumber from CallActivity ca inner join Cycle cy on ca.CycleId = cy.Id
	) ca on cg.LastAssignCallActivityId = ca.Id
	where cg.IsActive = 1 and cg.CurrentAssignCallActivityId is null and (cg.LastAssignCallActivityId is null or ca.CycleNumber < @currentCyle)

	update #Result set CurrentCycle = @currentCyle, CycleUndoneMap = @undonecycle

	select * from #Result

	drop table #tmpCG
	drop table #temp
	drop table #Result
END

