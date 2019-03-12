ALTER PROCEDURE [dbo].[GetUnReturnedCallAddress]
	@publisherId int = -1
AS
BEGIN
	if (exists(select ur.UserId 
				from webpages_UsersInRoles ur inner join webpages_Roles r on ur.RoleId = r.RoleId
				where UserId = @publisherId and r.RoleName in ('Admin', 'Elder', 'TerritoryOverseer')))
	begin
		select @publisherId = -1
	end

	select 
		ca.Id,
		ca.CallTypeId,
		ct.CallTypeName,
		ca.CallGroupId,
		cg.CallGroupName,
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
		cdr.LastCallDate
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
	where ca.DateReturned is null and (@publisherId = -1 or ca.ReleasedToPublisherId = @publisherId)
	order by ca.DateReleased, p.Name, ca.Id, cdr.RouteOrderFromKh
END

GO


