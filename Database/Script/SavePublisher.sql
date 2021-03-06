USE [Territory]
GO
/****** Object:  StoredProcedure [dbo].[SavePublisher]    Script Date: 5/26/2019 3:28:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[SavePublisher]
	 @id INT
	,@email NVARCHAR(500)
	,@name NVARCHAR(500)
	,@phoneNumber NVARCHAR(500)
	,@roleID INT
	,@isActive BIT
AS
BEGIN
	
	UPDATE Publisher SET Name = @name, PhoneNumber = @phoneNumber, UserRoleId = @roleID, IsActive = @isActive WHERE Id = @id
	IF @@ROWCOUNT > 0
	BEGIN
		UPDATE webpages_UsersInRoles SET RoleId = @roleID WHERE UserId = @id
	END
	ELSE
	BEGIN
		INSERT INTO [dbo].[Publisher]
			   ([Name]
			   ,[EmailAddress]
			   ,[PhoneNumber]
			   ,[UserName]
			   ,[UserRoleId]
			   ,[IsActive])
		 VALUES
			   (@name
			   ,@email
			   ,@phoneNumber
			   ,'111'
			   ,@roleID
			   ,1)

		SELECT @id = @@IDENTITY		
	END

	UPDATE webpages_UsersInRoles SET RoleId = @roleID WHERE UserId = @id
	IF @@ROWCOUNT = 0
	BEGIN
		INSERT INTO webpages_UsersInRoles (UserId, RoleId)
		VALUES (@id, @roleID)
	END		

	IF (@isActive = 0)
	BEGIN
		DELETE FROM webpages_UsersInRoles WHERE UserId = @id
	END

	SELECT @id
END

