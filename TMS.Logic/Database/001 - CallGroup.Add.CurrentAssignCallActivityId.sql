alter table [dbo].[CallGroup] add CurrentAssignCallActivityId int

ALTER TABLE [dbo].[CallGroup]  WITH CHECK ADD  CONSTRAINT [FK_CallGroup_CallActivity] FOREIGN KEY([CurrentAssignCallActivityId])
REFERENCES [dbo].[CallActivity] ([Id])
GO

ALTER TABLE [dbo].[CallGroup] CHECK CONSTRAINT [FK_CallGroup_CallActivity]
GO

