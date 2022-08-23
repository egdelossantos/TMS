BEGIN TRAN

----CallActivityStatus
ALTER TABLE [dbo].[CallActivityStatus] ADD IsDone BIT
GO

UPDATE [CallActivityStatus] SET IsDone = 0
UPDATE [CallActivityStatus] SET IsDone = 1 WHERE Code IN ('DONE', 'NOTATHOME2')

ALTER TABLE [dbo].[CallActivityStatus] ALTER COLUMN IsDone BIT NOT NULL
GO

SET IDENTITY_INSERT [dbo].[CallActivityStatus] ON

INSERT INTO [dbo].[CallActivityStatus]
           ([Id]
		   ,[Status]
           ,[Code]
           ,[IsValidAddress]
		   ,[IsDone])
VALUES (7, 'Home(Filo)', 'HOMEFILO', 1, 1)
	  ,(8, 'Home(Not Filo)', 'HOMENOTFILO', 1, 1)
	  ,(9, 'Home(Busy - Try Again)', 'HOMEBUSY', 1, 0)
	  ,(10, 'NH(No Answer)', 'NOANSWER', 1, 0)
	  ,(11, 'NH(Message Bank)', 'MESSAGEBANK', 1, 0)
	  ,(12, 'NH(Ringing Only)', 'RINGINGONLY', 1, 0)
	  ,(13, 'NH(Line Busy)', 'LINEBUSY', 1, 0)
	  ,(14, 'Hung up(Try Again)', 'HUNGUP', 1, 0)
	  ,(15, 'Business Number', 'BUSINESSNUMBER', 1, 1)
	  ,(16, 'Fax Number', 'FAXNUMBER', 1, 1)
	  ,(17, 'Disconnected', 'DISCONNECTED', 1, 1)
	  ,(18, 'Letter Writing', 'LETTERWRITING', 1, 1)

--CallType
ALTER TABLE [dbo].[CallType] ADD IsVirtual BIT
GO

UPDATE [CallType] SET IsVirtual = 0

ALTER TABLE [dbo].[CallType] ADD IsVirtual BIT NOT NULL
GO

UPDATE [CallType] SET CallTypeName = 'Campaign (In-Person)' WHERE Id = 3

SET IDENTITY_INSERT [dbo].[CallType] ON

INSERT INTO [dbo].[CallType] (Id, CallTypeName, IsVirtual)
VALUES (4, 'Campaign (Virtual)', 1) 
	  ,(5, 'Virtual Witnessing', 1) 

SET IDENTITY_INSERT [dbo].[CallType] OFF


-----[CallTypeCallStatus]
CREATE TABLE [dbo].[CallTypeCallStatus](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CallTypeId] [int] NOT NULL,
	[StatusId] [int] NOT NULL
) ON [PRIMARY]
GO

INSERT INTO [dbo].[CallTypeCallStatus]
           ([CallTypeId]
           ,[StatusId])
		SELECT 1, Id FROM CallActivityStatus WHERE Code IN ('DONE', 'NOTATHOME1', 'NOTATHOME2', 'ADDRESSNOTFOUND', 'NOTFILIPINO', 'DONOTCALL')
UNION	SELECT 2, Id FROM CallActivityStatus WHERE Code IN ('DONE', 'NOTATHOME1', 'NOTATHOME2', 'ADDRESSNOTFOUND', 'NOTFILIPINO', 'DONOTCALL')
UNION	SELECT 3, Id FROM CallActivityStatus WHERE Code IN ('DONE', 'ADDRESSNOTFOUND', 'NOTFILIPINO', 'DONOTCALL')
UNION	SELECT 4, Id FROM CallActivityStatus WHERE Code IN ('HOMEFILO', 'HOMENOTFILO', 'HOMEBUSY', 'NOANSWER', 'MESSAGEBANK', 'RINGINGONLY', 'LINEBUSY', 'HUNGUP', 'BUSINESSNUMBER', 'FAXNUMBER', 'DISCONNECTED', 'LETTERWRITING')
UNION	SELECT 5, Id FROM CallActivityStatus WHERE Code IN ('HOMEFILO', 'HOMENOTFILO', 'HOMEBUSY', 'NOANSWER', 'MESSAGEBANK', 'RINGINGONLY', 'LINEBUSY', 'HUNGUP', 'BUSINESSNUMBER', 'FAXNUMBER', 'DISCONNECTED', 'LETTERWRITING')



ROLLBACK