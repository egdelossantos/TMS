SET IDENTITY_INSERT [dbo].[CallActivityStatus] on

INSERT INTO [CallActivityStatus] (ID, Status, Code, IsValidAddress, IsDone)
values (18,	'Letter Writing', 'LETTERWRITING', 1, 1)

SET IDENTITY_INSERT [dbo].[CallActivityStatus] off

--call type
SET IDENTITY_INSERT [dbo].[CallType] on

INSERT INTO [dbo].[CallType] (Id, CallTypeName)
values (5, 'Virtual Witnessing')

SET IDENTITY_INSERT [dbo].[CallType] off

ALTER TABLE [dbo].[CallType] ADD IsVirtual bit
GO

UPDATE [CallType] SET IsVirtual = 0
UPDATE [CallType] SET IsVirtual = 1 WHERE Id IN (4,5)

ALTER TABLE [dbo].[CallType] ALTER COLUMN IsVirtual bit NOT NULL
GO

---------

INSERT INTO [dbo].[CallTypeCallStatus] (CallTypeId, StatusId)
SELECT 5, StatusId FROM [CallTypeCallStatus] WHERE CallTypeId = 4