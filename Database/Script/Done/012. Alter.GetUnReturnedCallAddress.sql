ALTER PROCEDURE [dbo].[GetUnReturnedCallAddress]
	@publisherId int = -1
AS
BEGIN
	declare @topRole nvarchar(256), @filterPublisherId int
	select @filterPublisherId = @publisherId

	if (@publisherId > 0)
	begin
		select @topRole = dbo.UserTopRole(@publisherId)

		if (@topRole in ('Admin', 'TerritoryOverseer', 'Elder'))
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
		cw.WarningSeverity,
		cw.WarningColour,
		cy.CycleName,
		cdr.RouteOrderFromKh,
		cdr.MelwayRefNo,
		cdr.LastCallDate,
		ca.ReleasedByUserId
	into #Result
	from CallActivity ca
		inner join CallActivityAddress cad on ca.Id = cad.CallActivityId
		inner join CallAddress cdr on cad.CallAddressId = cdr.Id
		inner join vwAddress cd on cad.CallAddressId = cd.Id
		inner join CallGroup cg on ca.CallGroupId = cg.Id
		inner join CallType ct on ca.CallTypeId = ct.Id
		inner join Publisher p on ca.ReleasedToPublisherId = p.Id
		inner join CallActivityWarning cw on ca.CallTypeId = cw.CallTypeId and datediff(day, DateReleased, getdate()) between cw.FromNumberOfDays and cw.ToNumberOfDays
		inner join Cycle cy on ca.CycleId = cy.Id
		left outer join CallActivityStatus cas on cad.CallActivityStatusId = cas.Id
	where ca.DateReturned is null and (@filterPublisherId = -1 or ca.ReleasedToPublisherId = @filterPublisherId)
	
	if (@topRole = 'Elder')
	begin		
		select * from #Result where ReleasedByUserId = @publisherId or ReleasedToPublisherId = @publisherId order by DateReleased, Name, Id, RouteOrderFromKh
	end
	else
	begin
		select * from #Result order by DateReleased, Name, Id, RouteOrderFromKh
	end
END

