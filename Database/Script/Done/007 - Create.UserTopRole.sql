USE [Territory]
GO

/****** Object:  UserDefinedFunction [dbo].[UserTopRole]    Script Date: 25/07/2014 8:14:16 PM ******/
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


