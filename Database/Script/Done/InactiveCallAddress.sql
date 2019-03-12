USE [Territory]
GO

/****** Object:  Table [dbo].[InactiveCallAddress]    Script Date: 25/02/2015 11:52:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[InactiveCallAddress](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CallAddressId] [int] NULL,
	[CallGroupId] [int] NULL,
	[CallStatus] [int] NULL,
	[DateDeactivated] [datetime] NULL
) ON [PRIMARY]

GO


