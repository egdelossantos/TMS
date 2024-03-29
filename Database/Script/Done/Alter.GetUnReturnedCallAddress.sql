USE [Territory]
GO
/****** Object:  StoredProcedure [dbo].[GetUnReturnedCallAddress]    Script Date: 18/09/2014 9:53:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[GetUnReturnedCallAddress]
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

