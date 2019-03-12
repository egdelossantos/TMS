USE [Territory]
GO

/****** Object:  StoredProcedure [dbo].[GetMapCallActivity]    Script Date: 25/07/2014 8:14:59 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetMapCallActivity]
	@fromDate date,
	@toDate date
AS
BEGIN
	DECLARE @cols NVARCHAR(MAX),
		@query NVARCHAR(MAX),
		@queryUpdate NVARCHAR(MAX),
		@rowNumber INT,
		@rowCounter INT = 1

	SELECT ROW_NUMBER() OVER (PARTITION BY [CallGroupId]
								ORDER BY [CallGroupId]
								) AS RowNum
			,[CallGroupId]
			,'Column' + cast([CallGroupId] as varchar(50)) as ColumnName
			,'Map' + [GroupCode] + ' (' + [CallGroupName] + ')' as MapName  
			,convert(nvarchar(50), [DateReleased], 105) 
			 + '  to ' 
			 + isnull(convert(nvarchar(50), [DateReturned], 105), 'UnReturned')
			 + '  >  '  + [Name] as Details
			,[DateReleased]
			,[DateReturned]
			,[Name] as PublisherName
	into ##TempTable
	from (
	select ca.CallGroupId, cg.CallGroupName, cg.GroupCode, ca.DateReleased, ca.DateReturned, p.Name
	from CallActivity ca
	inner join CallGroup cg on ca.CallGroupId = cg.Id
	inner join Publisher p on ca.ReleasedToPublisherId = p.Id
	where ca.DateReleased between @fromDate and @toDate) tmp

	select @rowNumber = max(RowNum) from ##TempTable
 
	select @cols = STUFF((SELECT ',' + QUOTENAME(MapName) + ' NVARCHAR(MAX)'
						from (select distinct MapName from ##TempTable) TempTable
						group by MapName
						order by MapName
				FOR XML PATH(''), TYPE
				).value('.', 'NVARCHAR(MAX)')
			,1,1,'')
 
	set @query = 'CREATE TABLE ##tmpMapReport(Id INT,' + @cols + ',)'
 
	exec sp_executesql @query;
 
	while (@rowCounter <= @rowNumber)
	begin
			insert into ##tmpMapReport(Id)
			select @rowCounter
 
			select @queryUpdate = STUFF((SELECT ';' + 'UPDATE tmp SET ' + QUOTENAME(MapName) + ' = Details FROM ##tmpMapReport tmp INNER JOIN ##TempTable vw ON tmp.Id = vw.RowNum and MapName = ''' +  MapName + ''''
						from (select distinct MapName from ##TempTable) TempTable
						group by MapName
						order by MapName
				FOR XML PATH(''), TYPE
				).value('.', 'NVARCHAR(MAX)')
			,1,1,'')
 
			exec sp_executesql @queryUpdate;
			print @queryUpdate
 
			select @rowCounter = @rowCounter + 1
	end
 
	select * from ##tmpMapReport
 
	drop table ##tmpMapReport
	drop table ##TempTable
END

GO


