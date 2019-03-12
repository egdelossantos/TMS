CREATE TABLE [dbo].[Cycle](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CycleNumber] [int] NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[CycleName]  AS ('Cycle '+CONVERT([nvarchar](20),[CycleNumber],0)),
 CONSTRAINT [PK_Cycle] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


CREATE TABLE [dbo].[SystemReference](
	[Id] [int] NOT NULL,
	[CurrentCycleId] [int] NULL,
	[CurrentCycleNumber] [int] NULL,
 CONSTRAINT [PK_SystemReference] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO



