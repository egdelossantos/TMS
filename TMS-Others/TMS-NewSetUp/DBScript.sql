USE <database name>
GO
/****** Object:  StoredProcedure [dbo].[DeactivateCallAddress]    Script Date: 4/03/2017 10:18:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[DeactivateCallAddress] 
	@callAddressId int, 
	@approvedDate datetime,
	@approvedBy int
AS
BEGIN
	declare @callGroupId int, @newId int, @callActivityId int
	select @callGroupId = CallGroupId from CallAddress where id = @callAddressId

    -- store last callgroup in a table
	insert into InactiveCallAddress (CallAddressId, CallGroupId, CallStatus, DateDeactivated, ApprovedDate, ApprovedBy)
	select Id, CallGroupId, LastCallActivityStatusId, LastCallDate, @approvedDate, @approvedBy from CallAddress where id = @callAddressId

	select @newId = @@IDENTITY

	select @callActivityId = max(ca.CallActivityId) 
	from CallActivityAddress ca 
	inner join [dbo].[CallAddress] cd on ca.CallAddressId = cd.Id and ca.CallActivityStatusId = cd.LastCallActivityStatusId
	inner join InactiveCallAddress inc on inc.CallAddressId = cd.Id and inc.CallStatus = ca.CallActivityStatusId and inc.DateDeactivated = cd.LastCallDate
	where cd.Id = @callAddressId and inc.Id = @newId

	update InactiveCallAddress set LastCallActivityId = @callActivityId where Id = @newId

	-- remove callgroupid on inactive address
	update CallAddress set IsValid = 0, CallGroupId = null where id = @callAddressId

	-- reorder route
	;with address as(
	select *, ROW_NUMBER() OVER(PARTITION BY CallGroupId ORDER BY CallGroupId, RouteOrderFromKh) AS SortOrder 
	from CallAddress ca where isvalid = 1 and CallGroupId = @callGroupId
	)
	update a2 set RouteOrderFromKh = a1.SortOrder
	from address a1
	inner join CallAddress a2 on a1.id = a2.id
END

GO
/****** Object:  StoredProcedure [dbo].[GetMapActivity]    Script Date: 4/03/2017 10:18:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetMapActivity]
	@fromDate date,
	@toDate date
AS
BEGIN
	--declare @TempTable table(
	--	RowNum int,
	--	CallGroupId int,
	--	GroupCode nvarchar(50),
	--	MapName nvarchar(500),
	--	Details nvarchar(500),
	--	DateReleased datetime,
	--	DateReturned datetime,
	--	PublisherName nvarchar(500),
	--	ActivityCount int
	--)

	--select * from @TempTable

	SELECT cast(ROW_NUMBER() OVER (PARTITION BY [CallGroupId]
								ORDER BY [CallGroupId]
								) as int) AS RowNum
			,[CallGroupId]
			,[GroupCode]
			,[CallGroupName] + ' - ' + [GroupCode] as MapName  
			,convert(nvarchar(50), [DateReleased], 105) 
			 + '  to ' 
			 + isnull(convert(nvarchar(50), [DateReturned], 105), 'UnReturned')
			 + '  >  '  + [Name] as Details
			,[DateReleased]
			,[DateReturned]
			,[Name] as PublisherName
			,9999 as ActivityCount
			,case when DateReturned is null then 1 else 0 end as IsReturned
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
 
	select * from #TempTable order by IsReturned, ActivityCount desc, cast(DateReleased as datetime), GroupCode, RowNum

	drop table #TempTable
END

GO
/****** Object:  StoredProcedure [dbo].[GetMapActivitySummary]    Script Date: 4/03/2017 10:18:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetMapActivitySummary]
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
		CycleUndoneMap int
	)

	create table #tmpCG(
		CallGroupId int,
		IsActive bit
	)

	declare @count int

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
		TotalNotDoneMap)
	select @count, 0, 0, 0, 0

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

GO
/****** Object:  StoredProcedure [dbo].[GetUnReturnedCallAddress]    Script Date: 4/03/2017 10:18:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUnReturnedCallAddress]
	@publisherId int = -1
AS
BEGIN
	declare @topRole nvarchar(256), @filterPublisherId int
	select @filterPublisherId = @publisherId

	if (@publisherId > 0)
	begin
		select @topRole = dbo.UserTopRole(@publisherId)

		if (@topRole in ('Admin', 'TerritoryOverseer', 'Elder', 'AssistantBrother'))
		begin
			select @filterPublisherId = -1
		end
		else
		begin
			select @filterPublisherId = @publisherId
		end
	end

	select 
		ca.Id,
		ca.CallTypeId,
		ct.CallTypeName,
		ca.CallGroupId,
		'CallGroupName' = cg.CallGroupName + ' - ' + cg.GroupCode,
		cad.Id as CallActivityAddressId,
		cad.CallAddressId,
		cad.CallActivityStatusId,
		cad.Note,
		cas.Status as CallActivityStatus,
		cd.Address,
		ca.DateReleased,
		ca.ReleasedToPublisherId,
		p.Name,
		p.PhoneNumber,
		p.EmailAddress,
		'DaysOut' = datediff(day, DateReleased, getdate()),
		'WarningSeverity' = isnull(cw.WarningSeverity, 0),
		'WarningColour' = isnull(cw.WarningColour, 'success'),
		cy.CycleName,
		cd.RouteOrderFromKh,
		cd.MelwayRefNo,
		cd.LastCallDate,
		ca.ReleasedByUserId
	into #Result
	from CallActivity ca
		inner join CallActivityAddress cad on ca.Id = cad.CallActivityId		
		inner join vwAddress cd on cad.CallAddressId = cd.Id
		inner join CallGroup cg on ca.CallGroupId = cg.Id
		inner join CallType ct on ca.CallTypeId = ct.Id
		inner join Publisher p on ca.ReleasedToPublisherId = p.Id		
		inner join Cycle cy on ca.CycleId = cy.Id
		left outer join CallActivityStatus cas on cad.CallActivityStatusId = cas.Id
		left outer join CallActivityWarning cw on ca.CallTypeId = cw.CallTypeId and datediff(day, DateReleased, getdate()) between cw.FromNumberOfDays and cw.ToNumberOfDays
	where ca.DateReturned is null and (@filterPublisherId = -1 or ca.ReleasedToPublisherId = @filterPublisherId)
	
	if (@topRole in ('Elder', 'AssistantBrother'))
	begin		
		select * from #Result where ReleasedByUserId = @publisherId or ReleasedToPublisherId = @publisherId order by DateReleased, Name, Id, RouteOrderFromKh
	end
	else
	begin
		select * from #Result order by DateReleased, Name, Id, RouteOrderFromKh
	end
END


GO
/****** Object:  StoredProcedure [dbo].[GetUnreturnedMap]    Script Date: 4/03/2017 10:18:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[GetUnreturnedMap]
	@publisherId int = -1
AS
BEGIN
	--declare @Result table(
	--		Id int not null,
	--		CallTypeId int not null,
	--		CallTypeName nvarchar(max) not null,
	--		CallGroupId int not null,
	--		CallGroupName nvarchar(max) not null,
	--		DateReleased datetime not null,
	--		ReleasedToPublisherId int not null, 
	--		PublisherName nvarchar(max) not null,
	--		EmailAddress nvarchar(500),
	--		ReleasedByUserId int not null,
	--		ReleasedBy nvarchar(max) not null,
	--		CycleName nvarchar(max) not null,		
	--		IsComplete int not null,
	--		DaysOut int not null,
	--		WarningSeverity int not null,
	--		WarningColour nvarchar(max) not null
	--)
	--select * from @Result
	--return

	declare @topRole nvarchar(256), @filterPublisherId int
	select @filterPublisherId = @publisherId

	if (@publisherId > 0)
	begin
		select @topRole = dbo.UserTopRole(@publisherId)

		if (@topRole in ('Admin', 'TerritoryOverseer', 'Elder', 'AssistantBrother'))
		begin
			select @filterPublisherId = -1
		end
		else
		begin
			select @filterPublisherId = @publisherId
		end
	end

	select	ca.Id,
			ca.CallTypeId,
			ct.CallTypeName,
			ca.CallGroupId,
			'CallGroupName' = cg.CallGroupName + ' - ' + cg.GroupCode,
			ca.DateReleased,
			ca.ReleasedToPublisherId, 
			p.Name as PublisherName,
			p.EmailAddress,
			ca.ReleasedByUserId,
			p2.Name as ReleasedBy,
			cy.CycleName,		
			'IsComplete' = case when (select count(1) from CallActivityAddress where CallActivityId = ca.Id and DateFinished IS NULL) > 0 then 0 else 1 end,
			'DaysOut' = datediff(day, DateReleased, getdate()),
			'WarningSeverity' = isnull(cw.WarningSeverity, 0),
			'WarningColour' = isnull(cw.WarningColour, 'success')	
	into #Result	
	from CallActivity ca inner join
	CallType ct on ca.CallTypeId = ct.Id inner join
	CallGroup cg on ca.CallGroupId = cg.Id inner join 
	Publisher p on ca.ReleasedToPublisherId = p.Id inner join 
	Publisher p2 on ca.ReleasedByUserId = p2.Id inner join
	Cycle cy on ca.CycleId = cy.Id
	left outer join 
	CallActivityWarning cw on ca.CallTypeId = cw.CallTypeId and datediff(day, DateReleased, getdate()) between cw.FromNumberOfDays and cw.ToNumberOfDays
	where DateReturned is null and (@filterPublisherId = -1 or ca.ReleasedToPublisherId = @filterPublisherId)		
	
	if (@topRole in ('Elder', 'AssistantBrother'))
	begin	
		delete from #Result where not(ReleasedByUserId = @publisherId or ReleasedToPublisherId = @publisherId)			
	end
	
	select  Id,
			CallTypeId,
			CallTypeName,
			CallGroupId,
			CallGroupName,
			DateReleased,
			ReleasedToPublisherId, 
			PublisherName,
			EmailAddress,
			ReleasedByUserId,
			ReleasedBy,
			CycleName,		
			IsComplete,
			DaysOut,
			WarningSeverity = case when IsComplete = 1 then 3 else WarningSeverity end,
			'WarningColour' = case when IsComplete = 1 then 'info' else WarningColour end
	from #Result order by IsComplete desc, DateReleased, PublisherName
	
END

GO

/****** Object:  UserDefinedFunction [dbo].[UserTopRole]    Script Date: 4/03/2017 10:18:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[UserTopRole] 
(
	@publisherId int
)
RETURNS nvarchar(256)
AS
BEGIN
	if (exists (select ur.UserId 
				from webpages_UsersInRoles ur inner join webpages_Roles r on ur.RoleId = r.RoleId
				where UserId = @publisherId and r.RoleName in ('Admin')))
	begin
		return 'Admin'
	end

	if (exists (select ur.UserId 
				from webpages_UsersInRoles ur inner join webpages_Roles r on ur.RoleId = r.RoleId
				where UserId = @publisherId and r.RoleName in ('TerritoryOverseer')))
	begin
		return 'TerritoryOverseer'
	end

	if (exists (select ur.UserId 
				from webpages_UsersInRoles ur inner join webpages_Roles r on ur.RoleId = r.RoleId
				where UserId = @publisherId and r.RoleName in ('Elder')))
	begin
		return 'Elder'
	end

	if (exists (select ur.UserId 
				from webpages_UsersInRoles ur inner join webpages_Roles r on ur.RoleId = r.RoleId
				where UserId = @publisherId and r.RoleName in ('MinisterialServant')))
	begin
		return 'MinisterialServant'
	end

	if (exists (select ur.UserId 
				from webpages_UsersInRoles ur inner join webpages_Roles r on ur.RoleId = r.RoleId
				where UserId = @publisherId and r.RoleName in ('AssistantBrother')))
	begin
		return 'AssistantBrother'
	end

	return 'Publisher'
END


GO
/****** Object:  Table [dbo].[CallActivity]    Script Date: 4/03/2017 10:18:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CallActivity](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CallGroupId] [int] NOT NULL,
	[CallTypeId] [int] NOT NULL,
	[DateReleased] [datetime] NOT NULL,
	[ReleasedToPublisherId] [int] NOT NULL,
	[ReleasedByUserId] [int] NOT NULL,
	[DateReturned] [datetime] NULL,
	[ReturnedByPublisherId] [int] NULL,
	[ReturnedToUserId] [int] NULL,
	[CycleId] [int] NOT NULL,
 CONSTRAINT [PK_CallActivity] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CallActivityAddress]    Script Date: 4/03/2017 10:18:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CallActivityAddress](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CallActivityId] [int] NOT NULL,
	[CallAddressId] [int] NOT NULL,
	[DateFinished] [datetime] NULL,
	[CallActivityStatusId] [int] NULL,
	[Note] [nchar](10) NULL,
 CONSTRAINT [PK_CallActivityAddress] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CallActivityStatus]    Script Date: 4/03/2017 10:18:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CallActivityStatus](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Status] [nvarchar](50) NOT NULL,
	[Code] [nvarchar](50) NOT NULL,
	[IsValidAddress] [bit] NOT NULL,
 CONSTRAINT [PK_CallActivityStatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CallActivityWarning]    Script Date: 4/03/2017 10:18:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CallActivityWarning](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CallTypeId] [int] NOT NULL,
	[FromNumberOfDays] [int] NOT NULL,
	[ToNumberOfDays] [int] NOT NULL,
	[WarningSeverity] [int] NOT NULL,
	[WarningColour] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_CallActivityWarning] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CallAddress]    Script Date: 4/03/2017 10:18:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CallAddress](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Unit] [nvarchar](50) NULL,
	[Number] [nvarchar](50) NOT NULL,
	[Street] [nvarchar](500) NOT NULL,
	[SuburbId] [int] NOT NULL,
	[MelwayRefNo] [nvarchar](50) NULL,
	[RouteOrderFromKh] [int] NULL,
	[CallGroupId] [int] NULL,
	[IsValid] [bit] NOT NULL,
	[LastCallDate] [datetime] NULL,
	[LastCallActivityStatusId] [int] NULL,
	[Longtitude] [float] NULL,
	[Latitude] [float] NULL,
	[Address]  AS (((case when isnull([Unit],'')='' then '' else [Unit]+'/' end+[Number])+' ')+[Street]),
	[GpsAddress]  AS (([Number]+' ')+[Street]),
 CONSTRAINT [PK_CallAddress] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CallAddressNote]    Script Date: 4/03/2017 10:18:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CallAddressNote](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CallAddressId] [int] NOT NULL,
	[Note] [nvarchar](max) NOT NULL,
	[DateNoteAdded] [datetime] NOT NULL,
 CONSTRAINT [PK_CallAddressNote] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CallGroup]    Script Date: 4/03/2017 10:18:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CallGroup](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CallGroupName] [nvarchar](500) NOT NULL,
	[GroupCode] [nvarchar](50) NOT NULL,
	[CurrentAssignCallActivityId] [int] NULL,
	[LastAssignCallActivityId] [int] NULL,
	[AllowAssistantToRelease] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[DateAdded] [datetime] NULL,
 CONSTRAINT [PK_CallAddressGroup] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CallType]    Script Date: 4/03/2017 10:18:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CallType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CallTypeName] [nvarchar](500) NOT NULL,
 CONSTRAINT [PK_CallType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Country]    Script Date: 4/03/2017 10:18:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Country](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CountryName] [nvarchar](500) NOT NULL,
 CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Cycle]    Script Date: 4/03/2017 10:18:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cycle](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CycleNumber] [int] NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[CycleName]  AS ('Cycle '+CONVERT([nvarchar](20),[CycleNumber],(0))),
 CONSTRAINT [PK_Cycle] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[InactiveCallAddress]    Script Date: 4/03/2017 10:18:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InactiveCallAddress](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CallAddressId] [int] NULL,
	[CallGroupId] [int] NULL,
	[CallStatus] [int] NULL,
	[DateDeactivated] [datetime] NULL,
	[LastCallActivityId] [int] NULL,
	[ApprovedDate] [datetime] NULL,
	[ApprovedBy] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Publisher]    Script Date: 4/03/2017 10:18:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Publisher](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](500) NOT NULL,
	[EmailAddress] [nvarchar](500) NOT NULL,
	[PhoneNumber] [nvarchar](500) NULL,
	[UserName] [nvarchar](100) NOT NULL,
	[UserRoleId] [int] NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_Caller] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[State]    Script Date: 4/03/2017 10:18:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[State](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CountryId] [int] NOT NULL,
	[StateName] [nvarchar](500) NOT NULL,
 CONSTRAINT [PK_State] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Suburb]    Script Date: 4/03/2017 10:18:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Suburb](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StateId] [int] NOT NULL,
	[SuburbName] [nvarchar](500) NOT NULL,
	[PostCode] [nvarchar](10) NULL,
 CONSTRAINT [PK_Suburb] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SystemReference]    Script Date: 4/03/2017 10:18:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SystemReference](
	[Id] [int] NOT NULL,
	[CurrentCycleId] [int] NULL,
	[CurrentCycleNumber] [int] NULL,
 CONSTRAINT [PK_SystemReference] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[webpages_Membership]    Script Date: 4/03/2017 10:18:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[webpages_Membership](
	[UserId] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[ConfirmationToken] [nvarchar](128) NULL,
	[IsConfirmed] [bit] NULL,
	[LastPasswordFailureDate] [datetime] NULL,
	[PasswordFailuresSinceLastSuccess] [int] NOT NULL,
	[Password] [nvarchar](128) NOT NULL,
	[PasswordChangedDate] [datetime] NULL,
	[PasswordSalt] [nvarchar](128) NOT NULL,
	[PasswordVerificationToken] [nvarchar](128) NULL,
	[PasswordVerificationTokenExpirationDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[webpages_PasswordResets]    Script Date: 4/03/2017 10:18:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[webpages_PasswordResets](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[ResetQuestion] [nvarchar](max) NOT NULL,
	[ResetAnswer] [nvarchar](max) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[webpages_Roles]    Script Date: 4/03/2017 10:18:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[webpages_Roles](
	[RoleId] [int] IDENTITY(1,1) NOT NULL,
	[RoleName] [nvarchar](256) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[RoleName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[webpages_UsersInRoles]    Script Date: 4/03/2017 10:18:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[webpages_UsersInRoles](
	[UserId] [int] NOT NULL,
	[RoleId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  View [dbo].[vwAddress]    Script Date: 4/03/2017 10:18:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwAddress]
AS
SELECT        cd.Id, CASE WHEN isnull(Unit, '') = '' THEN '' ELSE Unit + '/' END + cd.Number + ' ' + cd.Street + ', ' + sb.SuburbName AS Address, 
                         cd.Number + ' ' + cd.Street + ', ' + sb.SuburbName AS AddressGps, cd.Unit, cd.Number, cd.Street, sb.SuburbName, st.StateName, sb.PostCode, 
                         cd.CallGroupId, cg.CallGroupName, cg.GroupCode, cd.RouteOrderFromKh, cd.SuburbId, cd.Longtitude, cd.Latitude, cd.MelwayRefNo, cd.LastCallDate
FROM            dbo.CallAddress AS cd INNER JOIN
                         dbo.Suburb AS sb ON cd.SuburbId = sb.Id INNER JOIN
                         dbo.State AS st ON sb.StateId = st.Id LEFT OUTER JOIN
                         dbo.CallGroup AS cg ON cd.CallGroupId = cg.Id




GO
ALTER TABLE [dbo].[CallGroup] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[webpages_Membership] ADD  CONSTRAINT [DF_webpages_Membership_IsConfirmed]  DEFAULT ((0)) FOR [IsConfirmed]
GO
ALTER TABLE [dbo].[webpages_Membership] ADD  CONSTRAINT [DF_webpages_Membership_PasswordFailuresSinceLastSuccess]  DEFAULT ((0)) FOR [PasswordFailuresSinceLastSuccess]
GO
ALTER TABLE [dbo].[CallActivity]  WITH CHECK ADD  CONSTRAINT [FK_CallActivity_CallGroup] FOREIGN KEY([CallGroupId])
REFERENCES [dbo].[CallGroup] ([Id])
GO
ALTER TABLE [dbo].[CallActivity] CHECK CONSTRAINT [FK_CallActivity_CallGroup]
GO
ALTER TABLE [dbo].[CallActivity]  WITH CHECK ADD  CONSTRAINT [FK_CallActivity_CallType] FOREIGN KEY([CallTypeId])
REFERENCES [dbo].[CallType] ([Id])
GO
ALTER TABLE [dbo].[CallActivity] CHECK CONSTRAINT [FK_CallActivity_CallType]
GO
ALTER TABLE [dbo].[CallActivity]  WITH CHECK ADD  CONSTRAINT [FK_CallActivity_Cycle] FOREIGN KEY([CycleId])
REFERENCES [dbo].[Cycle] ([Id])
GO
ALTER TABLE [dbo].[CallActivity] CHECK CONSTRAINT [FK_CallActivity_Cycle]
GO
ALTER TABLE [dbo].[CallActivity]  WITH CHECK ADD  CONSTRAINT [FK_CallActivity_Publisher] FOREIGN KEY([ReleasedToPublisherId])
REFERENCES [dbo].[Publisher] ([Id])
GO
ALTER TABLE [dbo].[CallActivity] CHECK CONSTRAINT [FK_CallActivity_Publisher]
GO
ALTER TABLE [dbo].[CallActivity]  WITH CHECK ADD  CONSTRAINT [FK_CallActivity_Publisher1] FOREIGN KEY([ReturnedByPublisherId])
REFERENCES [dbo].[Publisher] ([Id])
GO
ALTER TABLE [dbo].[CallActivity] CHECK CONSTRAINT [FK_CallActivity_Publisher1]
GO
ALTER TABLE [dbo].[CallActivity]  WITH CHECK ADD  CONSTRAINT [FK_CallActivity_Publisher2] FOREIGN KEY([ReleasedByUserId])
REFERENCES [dbo].[Publisher] ([Id])
GO
ALTER TABLE [dbo].[CallActivity] CHECK CONSTRAINT [FK_CallActivity_Publisher2]
GO
ALTER TABLE [dbo].[CallActivity]  WITH CHECK ADD  CONSTRAINT [FK_CallActivity_Publisher3] FOREIGN KEY([ReturnedToUserId])
REFERENCES [dbo].[Publisher] ([Id])
GO
ALTER TABLE [dbo].[CallActivity] CHECK CONSTRAINT [FK_CallActivity_Publisher3]
GO
ALTER TABLE [dbo].[CallActivityAddress]  WITH CHECK ADD  CONSTRAINT [FK_CallActivity_CallActivityAddress] FOREIGN KEY([CallActivityId])
REFERENCES [dbo].[CallActivity] ([Id])
GO
ALTER TABLE [dbo].[CallActivityAddress] CHECK CONSTRAINT [FK_CallActivity_CallActivityAddress]
GO
ALTER TABLE [dbo].[CallActivityAddress]  WITH CHECK ADD  CONSTRAINT [FK_CallActivityAddress_CallActivityStatus] FOREIGN KEY([CallActivityStatusId])
REFERENCES [dbo].[CallActivityStatus] ([Id])
GO
ALTER TABLE [dbo].[CallActivityAddress] CHECK CONSTRAINT [FK_CallActivityAddress_CallActivityStatus]
GO
ALTER TABLE [dbo].[CallActivityAddress]  WITH CHECK ADD  CONSTRAINT [FK_CallActivityAddress_CallAddress] FOREIGN KEY([CallAddressId])
REFERENCES [dbo].[CallAddress] ([Id])
GO
ALTER TABLE [dbo].[CallActivityAddress] CHECK CONSTRAINT [FK_CallActivityAddress_CallAddress]
GO
ALTER TABLE [dbo].[CallActivityWarning]  WITH CHECK ADD  CONSTRAINT [FK_CallActivityWarning_CallType] FOREIGN KEY([CallTypeId])
REFERENCES [dbo].[CallType] ([Id])
GO
ALTER TABLE [dbo].[CallActivityWarning] CHECK CONSTRAINT [FK_CallActivityWarning_CallType]
GO
ALTER TABLE [dbo].[CallAddress]  WITH CHECK ADD  CONSTRAINT [FK_CallAddress_CallActivityStatus] FOREIGN KEY([LastCallActivityStatusId])
REFERENCES [dbo].[CallActivityStatus] ([Id])
GO
ALTER TABLE [dbo].[CallAddress] CHECK CONSTRAINT [FK_CallAddress_CallActivityStatus]
GO
ALTER TABLE [dbo].[CallAddress]  WITH CHECK ADD  CONSTRAINT [FK_CallAddress_CallGroup] FOREIGN KEY([CallGroupId])
REFERENCES [dbo].[CallGroup] ([Id])
GO
ALTER TABLE [dbo].[CallAddress] CHECK CONSTRAINT [FK_CallAddress_CallGroup]
GO
ALTER TABLE [dbo].[CallAddress]  WITH CHECK ADD  CONSTRAINT [FK_CallAddress_Suburb] FOREIGN KEY([SuburbId])
REFERENCES [dbo].[Suburb] ([Id])
GO
ALTER TABLE [dbo].[CallAddress] CHECK CONSTRAINT [FK_CallAddress_Suburb]
GO
ALTER TABLE [dbo].[CallAddressNote]  WITH CHECK ADD  CONSTRAINT [FK_CallAddressNote_CallAddress] FOREIGN KEY([CallAddressId])
REFERENCES [dbo].[CallAddress] ([Id])
GO
ALTER TABLE [dbo].[CallAddressNote] CHECK CONSTRAINT [FK_CallAddressNote_CallAddress]
GO
ALTER TABLE [dbo].[CallGroup]  WITH CHECK ADD  CONSTRAINT [FK_CallGroup_CallActivity] FOREIGN KEY([CurrentAssignCallActivityId])
REFERENCES [dbo].[CallActivity] ([Id])
GO
ALTER TABLE [dbo].[CallGroup] CHECK CONSTRAINT [FK_CallGroup_CallActivity]
GO
ALTER TABLE [dbo].[CallGroup]  WITH CHECK ADD  CONSTRAINT [FK_CallGroup_CallActivity1] FOREIGN KEY([LastAssignCallActivityId])
REFERENCES [dbo].[CallActivity] ([Id])
GO
ALTER TABLE [dbo].[CallGroup] CHECK CONSTRAINT [FK_CallGroup_CallActivity1]
GO
ALTER TABLE [dbo].[Publisher]  WITH CHECK ADD  CONSTRAINT [FK_Publisher_webpages_Roles] FOREIGN KEY([UserRoleId])
REFERENCES [dbo].[webpages_Roles] ([RoleId])
GO
ALTER TABLE [dbo].[Publisher] CHECK CONSTRAINT [FK_Publisher_webpages_Roles]
GO
ALTER TABLE [dbo].[State]  WITH CHECK ADD  CONSTRAINT [FK_State_Country] FOREIGN KEY([CountryId])
REFERENCES [dbo].[Country] ([Id])
GO
ALTER TABLE [dbo].[State] CHECK CONSTRAINT [FK_State_Country]
GO
ALTER TABLE [dbo].[Suburb]  WITH CHECK ADD  CONSTRAINT [FK_Suburb_State] FOREIGN KEY([StateId])
REFERENCES [dbo].[State] ([Id])
GO
ALTER TABLE [dbo].[Suburb] CHECK CONSTRAINT [FK_Suburb_State]
GO
ALTER TABLE [dbo].[SystemReference]  WITH CHECK ADD  CONSTRAINT [FK_SystemReference_Cycle] FOREIGN KEY([CurrentCycleId])
REFERENCES [dbo].[Cycle] ([Id])
GO
ALTER TABLE [dbo].[SystemReference] CHECK CONSTRAINT [FK_SystemReference_Cycle]
GO
ALTER TABLE [dbo].[webpages_Membership]  WITH CHECK ADD  CONSTRAINT [FK_webpages_Membership_Publisher] FOREIGN KEY([UserId])
REFERENCES [dbo].[Publisher] ([Id])
GO
ALTER TABLE [dbo].[webpages_Membership] CHECK CONSTRAINT [FK_webpages_Membership_Publisher]
GO
ALTER TABLE [dbo].[webpages_PasswordResets]  WITH CHECK ADD  CONSTRAINT [FK_PasswordResets] FOREIGN KEY([UserId])
REFERENCES [dbo].[webpages_Membership] ([UserId])
GO
ALTER TABLE [dbo].[webpages_PasswordResets] CHECK CONSTRAINT [FK_PasswordResets]
GO
ALTER TABLE [dbo].[webpages_UsersInRoles]  WITH CHECK ADD  CONSTRAINT [FK_UsersInRoles_MembershipUserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[webpages_Membership] ([UserId])
GO
ALTER TABLE [dbo].[webpages_UsersInRoles] CHECK CONSTRAINT [FK_UsersInRoles_MembershipUserId]
GO
ALTER TABLE [dbo].[webpages_UsersInRoles]  WITH CHECK ADD  CONSTRAINT [FK_UsersInRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[webpages_Roles] ([RoleId])
GO
ALTER TABLE [dbo].[webpages_UsersInRoles] CHECK CONSTRAINT [FK_UsersInRoles_RoleId]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[30] 4[18] 2[26] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "cd"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 233
               Right = 230
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "sb"
            Begin Extent = 
               Top = 6
               Left = 268
               Bottom = 180
               Right = 438
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "st"
            Begin Extent = 
               Top = 6
               Left = 476
               Bottom = 155
               Right = 646
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cg"
            Begin Extent = 
               Top = 6
               Left = 684
               Bottom = 119
               Right = 858
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 2745
         Width = 2535
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwAddress'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwAddress'
GO
