CREATE PROCEDURE GetMapActivity
	@fromDate date,
	@toDate date
AS
BEGIN
	SELECT ROW_NUMBER() OVER (PARTITION BY [CallGroupId]
								ORDER BY [CallGroupId]
								) AS RowNum
			,[CallGroupId]
			,[GroupCode]
			,[CallGroupName] + ' (' + [GroupCode] + ')' as MapName  
			,convert(nvarchar(50), [DateReleased], 105) 
			 + '  to ' 
			 + isnull(convert(nvarchar(50), [DateReturned], 105), 'UnReturned')
			 + '  >  '  + [Name] as Details
			,[DateReleased]
			,[DateReturned]
			,[Name] as PublisherName
			,9999 as ActivityCount
	into #TempTable
	from (
	select ca.CallGroupId, cg.CallGroupName, cg.GroupCode, ca.DateReleased, ca.DateReturned, p.Name
	from CallActivity ca
	inner join CallGroup cg on ca.CallGroupId = cg.Id
	inner join Publisher p on ca.ReleasedToPublisherId = p.Id
	where ca.DateReleased between @fromDate and @toDate) tmp

	update tmp set ActivityCount = t.Num
	from #TempTable tmp
	inner join
	(select CallGroupId, Max(RowNum) as Num from #TempTable group by CallGroupId) t on tmp.CallGroupId = t.CallGroupId
 
	select * from #TempTable order by ActivityCount desc, GroupCode, RowNum

	drop table #TempTable
END
GO
