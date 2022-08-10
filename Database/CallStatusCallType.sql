-----------------
INSERT INTO [dbo].[CallActivityStatus]
           ([Status]
           ,[Code]
           ,[IsValidAddress])
VALUES ('Home(Filo)', 'HOMEFILO', 1)
	  ,('Home(Not Filo)', 'HOMENOTFILO', 1)
	  ,('Home(Busy - Try Again)', 'HOMEBUSY', 1)
	  ,('NH(No Answer)', 'NOANSWER', 1)
	  ,('NH(Message Bank)', 'MESSAGEBANK', 1)
	  ,('NH(Ringing Only)', 'RINGINGONLY', 1)
	  ,('NH(Line Busy)', 'LINEBUSY', 1)
	  ,('Hung up(Try Again)', 'HUNGUP', 1)
	  ,('Business Number', 'BUSINESSNUMBER', 1)
	  ,('Fax Number', 'FAXNUMBER', 1)
	  ,('Disconnected', 'DISCONNECTED', 1)

-----------------------

INSERT INTO [dbo].[CallType] ([CallTypeName])
VALUES ('Phone Witnessing')

-----------------------

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
UNION	SELECT 4, Id FROM CallActivityStatus WHERE Code IN ('HOMEFILO', 'HOMENOTFILO', 'HOMEBUSY', 'NOANSWER', 'MESSAGEBANK', 'RINGINGONLY', 'LINEBUSY', 'HUNGUP', 'BUSINESSNUMBER', 'FAXNUMBER', 'DISCONNECTED')





