USE [Territory]
GO
/****** Object:  StoredProcedure [dbo].[DeactivateCallAddress]    Script Date: 23/02/2015 11:19:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[DeactivateCallAddress] @callAddressId int	
AS
BEGIN
	declare @callGroupId int
	select @callGroupId = CallGroupId from CallAddress where id = @callAddressId

	-- store last callgroup in a table
	insert into InactiveCallAddress (CallAddressId, CallGroupId, CallStatus, DateDeactivated)
	select Id, CallGroupId, LastCallActivityStatusId, LastCallDate from CallAddress where id = @callAddressId

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
