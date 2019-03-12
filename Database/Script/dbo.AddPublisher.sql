-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE dbo.AddPublisher
	 @email NVARCHAR(500)
	,@name NVARCHAR(500)
	,@phoneNumber NVARCHAR(500)
	,@roleID INT
AS
BEGIN
	
	IF NOT EXISTS(SELECT EmailAddress FROM Publisher WHERE EmailAddress = @email)
	BEGIN
		DECLARE @userID INT

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

		SELECT @userID = @@IDENTITY

		INSERT INTO [dbo].[webpages_UsersInRoles]
			   ([UserId]
			   ,[RoleId])
		 VALUES
			   (@userID
			   ,@roleID)

		SELECT 'successfully-inserted', * FROM Publisher WHERE EmailAddress = @email
	END
	ELSE
	BEGIN
		SELECT 'already-existing', * FROM Publisher WHERE EmailAddress = @email
	END

END
GO
