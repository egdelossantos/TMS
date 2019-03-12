alter table CallActivity add CycleId int not null

ALTER TABLE [dbo].[CallActivity]  WITH CHECK ADD  CONSTRAINT [FK_CallActivity_Cycle] FOREIGN KEY([CycleId])
REFERENCES [dbo].[Cycle] ([Id])
GO

ALTER TABLE [dbo].[CallActivity] CHECK CONSTRAINT [FK_CallActivity_Cycle]