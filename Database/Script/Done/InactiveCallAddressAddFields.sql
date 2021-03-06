USE [Territory]
GO

alter table InactiveCallAddress add LastCallActivityId int
alter table InactiveCallAddress add ApprovedDate datetime
alter table InactiveCallAddress add ApprovedBy int
go


ALTER PROCEDURE [dbo].[DeactivateCallAddress] 
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
