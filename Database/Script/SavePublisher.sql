
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE SavePublisher
	 @id INT
	,@email NVARCHAR(500)
	,@name NVARCHAR(500)
	,@phoneNumber NVARCHAR(500)
	,@roleID INT
AS
BEGIN
	
	UPDATE Publisher SET Name = @name, PhoneNumber = @phoneNumber, UserRoleId = @roleID WHERE Id = @id
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

		IF (@roleID <> 3)
		BEGIN
			INSERT INTO webpages_UsersInRoles (UserId, RoleId)
			VALUES (@id, @roleID)
		END
	END

	SELECT @id
END
GO
