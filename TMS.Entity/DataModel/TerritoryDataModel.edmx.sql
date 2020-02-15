
-- --------------------------------------------------
-- Entity Designer DDL Script for SQL Server 2005, 2008, 2012 and Azure
-- --------------------------------------------------
-- Date Created: 02/13/2020 22:29:34
-- Generated from EDMX file: C:\Workspace\Code-Git\TMS\TMS.Entity\DataModel\TerritoryDataModel.edmx
-- --------------------------------------------------

SET QUOTED_IDENTIFIER OFF;
GO
USE [Territory];
GO
IF SCHEMA_ID(N'dbo') IS NULL EXECUTE(N'CREATE SCHEMA [dbo]');
GO

-- --------------------------------------------------
-- Dropping existing FOREIGN KEY constraints
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[FK_CallActivity_CallActivityAddress]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[CallActivityAddress] DROP CONSTRAINT [FK_CallActivity_CallActivityAddress];
GO
IF OBJECT_ID(N'[dbo].[FK_CallActivity_CallGroup]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[CallActivity] DROP CONSTRAINT [FK_CallActivity_CallGroup];
GO
IF OBJECT_ID(N'[dbo].[FK_CallActivity_CallType]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[CallActivity] DROP CONSTRAINT [FK_CallActivity_CallType];
GO
IF OBJECT_ID(N'[dbo].[FK_CallActivity_Cycle]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[CallActivity] DROP CONSTRAINT [FK_CallActivity_Cycle];
GO
IF OBJECT_ID(N'[dbo].[FK_CallActivity_Publisher]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[CallActivity] DROP CONSTRAINT [FK_CallActivity_Publisher];
GO
IF OBJECT_ID(N'[dbo].[FK_CallActivity_Publisher1]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[CallActivity] DROP CONSTRAINT [FK_CallActivity_Publisher1];
GO
IF OBJECT_ID(N'[dbo].[FK_CallActivity_Publisher2]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[CallActivity] DROP CONSTRAINT [FK_CallActivity_Publisher2];
GO
IF OBJECT_ID(N'[dbo].[FK_CallActivity_Publisher3]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[CallActivity] DROP CONSTRAINT [FK_CallActivity_Publisher3];
GO
IF OBJECT_ID(N'[dbo].[FK_CallActivityAddress_CallActivityStatus]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[CallActivityAddress] DROP CONSTRAINT [FK_CallActivityAddress_CallActivityStatus];
GO
IF OBJECT_ID(N'[dbo].[FK_CallActivityAddress_CallAddress]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[CallActivityAddress] DROP CONSTRAINT [FK_CallActivityAddress_CallAddress];
GO
IF OBJECT_ID(N'[dbo].[FK_CallActivityWarning_CallType]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[CallActivityWarning] DROP CONSTRAINT [FK_CallActivityWarning_CallType];
GO
IF OBJECT_ID(N'[dbo].[FK_CallAddress_CallActivityStatus]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[CallAddress] DROP CONSTRAINT [FK_CallAddress_CallActivityStatus];
GO
IF OBJECT_ID(N'[dbo].[FK_CallAddress_CallGroup]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[CallAddress] DROP CONSTRAINT [FK_CallAddress_CallGroup];
GO
IF OBJECT_ID(N'[dbo].[FK_CallAddress_Suburb]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[CallAddress] DROP CONSTRAINT [FK_CallAddress_Suburb];
GO
IF OBJECT_ID(N'[dbo].[FK_CallAddressNote_CallAddress]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[CallAddressNote] DROP CONSTRAINT [FK_CallAddressNote_CallAddress];
GO
IF OBJECT_ID(N'[dbo].[FK_CallGroup_CallActivity]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[CallGroup] DROP CONSTRAINT [FK_CallGroup_CallActivity];
GO
IF OBJECT_ID(N'[dbo].[FK_CallGroup_CallActivity1]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[CallGroup] DROP CONSTRAINT [FK_CallGroup_CallActivity1];
GO
IF OBJECT_ID(N'[dbo].[FK_PasswordResets]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[webpages_PasswordResets] DROP CONSTRAINT [FK_PasswordResets];
GO
IF OBJECT_ID(N'[dbo].[FK_Publisher_webpages_Roles]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Publisher] DROP CONSTRAINT [FK_Publisher_webpages_Roles];
GO
IF OBJECT_ID(N'[dbo].[FK_State_Country]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[State] DROP CONSTRAINT [FK_State_Country];
GO
IF OBJECT_ID(N'[dbo].[FK_Suburb_State]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Suburb] DROP CONSTRAINT [FK_Suburb_State];
GO
IF OBJECT_ID(N'[dbo].[FK_SystemReference_Cycle]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[SystemReference] DROP CONSTRAINT [FK_SystemReference_Cycle];
GO
IF OBJECT_ID(N'[dbo].[FK_UsersInRoles_RoleId]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[webpages_UsersInRoles] DROP CONSTRAINT [FK_UsersInRoles_RoleId];
GO
IF OBJECT_ID(N'[dbo].[FK_webpages_Membership_Publisher]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[webpages_Membership] DROP CONSTRAINT [FK_webpages_Membership_Publisher];
GO

-- --------------------------------------------------
-- Dropping existing tables
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[CallActivity]', 'U') IS NOT NULL
    DROP TABLE [dbo].[CallActivity];
GO
IF OBJECT_ID(N'[dbo].[CallActivityAddress]', 'U') IS NOT NULL
    DROP TABLE [dbo].[CallActivityAddress];
GO
IF OBJECT_ID(N'[dbo].[CallActivityStatus]', 'U') IS NOT NULL
    DROP TABLE [dbo].[CallActivityStatus];
GO
IF OBJECT_ID(N'[dbo].[CallActivityWarning]', 'U') IS NOT NULL
    DROP TABLE [dbo].[CallActivityWarning];
GO
IF OBJECT_ID(N'[dbo].[CallAddress]', 'U') IS NOT NULL
    DROP TABLE [dbo].[CallAddress];
GO
IF OBJECT_ID(N'[dbo].[CallAddressNote]', 'U') IS NOT NULL
    DROP TABLE [dbo].[CallAddressNote];
GO
IF OBJECT_ID(N'[dbo].[CallGroup]', 'U') IS NOT NULL
    DROP TABLE [dbo].[CallGroup];
GO
IF OBJECT_ID(N'[dbo].[CallType]', 'U') IS NOT NULL
    DROP TABLE [dbo].[CallType];
GO
IF OBJECT_ID(N'[dbo].[Country]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Country];
GO
IF OBJECT_ID(N'[dbo].[Cycle]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Cycle];
GO
IF OBJECT_ID(N'[dbo].[Publisher]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Publisher];
GO
IF OBJECT_ID(N'[dbo].[State]', 'U') IS NOT NULL
    DROP TABLE [dbo].[State];
GO
IF OBJECT_ID(N'[dbo].[Suburb]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Suburb];
GO
IF OBJECT_ID(N'[dbo].[SystemReference]', 'U') IS NOT NULL
    DROP TABLE [dbo].[SystemReference];
GO
IF OBJECT_ID(N'[dbo].[webpages_Membership]', 'U') IS NOT NULL
    DROP TABLE [dbo].[webpages_Membership];
GO
IF OBJECT_ID(N'[dbo].[webpages_PasswordResets]', 'U') IS NOT NULL
    DROP TABLE [dbo].[webpages_PasswordResets];
GO
IF OBJECT_ID(N'[dbo].[webpages_Roles]', 'U') IS NOT NULL
    DROP TABLE [dbo].[webpages_Roles];
GO
IF OBJECT_ID(N'[dbo].[webpages_UsersInRoles]', 'U') IS NOT NULL
    DROP TABLE [dbo].[webpages_UsersInRoles];
GO
IF OBJECT_ID(N'[TerritoryDataModelStoreContainer].[vwAddress]', 'U') IS NOT NULL
    DROP TABLE [TerritoryDataModelStoreContainer].[vwAddress];
GO

-- --------------------------------------------------
-- Creating all tables
-- --------------------------------------------------

-- Creating table 'CallActivityWarnings'
CREATE TABLE [dbo].[CallActivityWarnings] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [CallTypeId] int  NOT NULL,
    [FromNumberOfDays] int  NOT NULL,
    [ToNumberOfDays] int  NOT NULL,
    [WarningSeverity] int  NOT NULL,
    [WarningColour] nvarchar(50)  NOT NULL
);
GO

-- Creating table 'CallAddressNotes'
CREATE TABLE [dbo].[CallAddressNotes] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [CallAddressId] int  NOT NULL,
    [Note] nvarchar(max)  NOT NULL,
    [DateNoteAdded] datetime  NOT NULL
);
GO

-- Creating table 'CallTypes'
CREATE TABLE [dbo].[CallTypes] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [CallTypeName] nvarchar(500)  NOT NULL
);
GO

-- Creating table 'Countries'
CREATE TABLE [dbo].[Countries] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [CountryName] nvarchar(500)  NOT NULL
);
GO

-- Creating table 'States'
CREATE TABLE [dbo].[States] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [CountryId] int  NOT NULL,
    [StateName] nvarchar(500)  NOT NULL
);
GO

-- Creating table 'Suburbs'
CREATE TABLE [dbo].[Suburbs] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [StateId] int  NOT NULL,
    [SuburbName] nvarchar(500)  NOT NULL,
    [PostCode] nvarchar(10)  NULL
);
GO

-- Creating table 'webpages_Membership'
CREATE TABLE [dbo].[webpages_Membership] (
    [UserId] int  NOT NULL,
    [CreateDate] datetime  NULL,
    [ConfirmationToken] nvarchar(128)  NULL,
    [IsConfirmed] bit  NULL,
    [LastPasswordFailureDate] datetime  NULL,
    [PasswordFailuresSinceLastSuccess] int  NOT NULL,
    [Password] nvarchar(128)  NOT NULL,
    [PasswordChangedDate] datetime  NULL,
    [PasswordSalt] nvarchar(128)  NOT NULL,
    [PasswordVerificationToken] nvarchar(128)  NULL,
    [PasswordVerificationTokenExpirationDate] datetime  NULL
);
GO

-- Creating table 'webpages_PasswordResets'
CREATE TABLE [dbo].[webpages_PasswordResets] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [UserId] int  NOT NULL,
    [ResetQuestion] nvarchar(max)  NOT NULL,
    [ResetAnswer] nvarchar(max)  NOT NULL
);
GO

-- Creating table 'webpages_Roles'
CREATE TABLE [dbo].[webpages_Roles] (
    [RoleId] int IDENTITY(1,1) NOT NULL,
    [RoleName] nvarchar(256)  NOT NULL
);
GO

-- Creating table 'CallActivityStatus'
CREATE TABLE [dbo].[CallActivityStatus] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Status] nvarchar(50)  NOT NULL,
    [Code] nvarchar(50)  NOT NULL,
    [IsValidAddress] bit  NOT NULL
);
GO

-- Creating table 'Cycles'
CREATE TABLE [dbo].[Cycles] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [CycleNumber] int  NULL,
    [StartDate] datetime  NULL,
    [EndDate] datetime  NULL,
    [CycleName] nvarchar(26)  NULL
);
GO

-- Creating table 'SystemReferences'
CREATE TABLE [dbo].[SystemReferences] (
    [Id] int  NOT NULL,
    [CurrentCycleId] int  NULL,
    [CurrentCycleNumber] int  NULL
);
GO

-- Creating table 'CallActivities'
CREATE TABLE [dbo].[CallActivities] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [CallGroupId] int  NOT NULL,
    [CallTypeId] int  NOT NULL,
    [DateReleased] datetime  NOT NULL,
    [ReleasedToPublisherId] int  NOT NULL,
    [ReleasedByUserId] int  NOT NULL,
    [DateReturned] datetime  NULL,
    [ReturnedByPublisherId] int  NULL,
    [ReturnedToUserId] int  NULL,
    [CycleId] int  NOT NULL
);
GO

-- Creating table 'CallActivityAddresses'
CREATE TABLE [dbo].[CallActivityAddresses] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [CallActivityId] int  NOT NULL,
    [CallAddressId] int  NOT NULL,
    [DateFinished] datetime  NULL,
    [CallActivityStatusId] int  NULL,
    [Note] nchar(10)  NULL
);
GO

-- Creating table 'Publishers'
CREATE TABLE [dbo].[Publishers] (
    [Id] int  NOT NULL,
    [Name] nvarchar(500)  NOT NULL,
    [EmailAddress] nvarchar(500)  NOT NULL,
    [PhoneNumber] nvarchar(500)  NULL,
    [UserName] nvarchar(100)  NOT NULL,
    [UserRoleId] int  NULL,
    [IsActive] bit  NULL
);
GO

-- Creating table 'CallAddresses'
CREATE TABLE [dbo].[CallAddresses] (
    [Id] int  NOT NULL,
    [Unit] nvarchar(50)  NULL,
    [Number] nvarchar(50)  NOT NULL,
    [Street] nvarchar(500)  NOT NULL,
    [SuburbId] int  NOT NULL,
    [MelwayRefNo] nvarchar(50)  NULL,
    [RouteOrderFromKh] int  NULL,
    [CallGroupId] int  NULL,
    [IsValid] bit  NOT NULL,
    [LastCallDate] datetime  NULL,
    [LastCallActivityStatusId] int  NULL,
    [Longtitude] float  NULL,
    [Latitude] float  NULL,
    [Address] nvarchar(602)  NULL,
    [GpsAddress] nvarchar(551)  NOT NULL,
    [SuggestedCallGroupId] int  NULL
);
GO

-- Creating table 'vwAddresses'
CREATE TABLE [dbo].[vwAddresses] (
    [Id] int  NOT NULL,
    [Address] nvarchar(2107)  NULL,
    [AddressGps] nvarchar(2056)  NOT NULL,
    [Unit] nvarchar(50)  NULL,
    [Number] nvarchar(50)  NOT NULL,
    [Street] nvarchar(500)  NOT NULL,
    [SuburbName] nvarchar(500)  NOT NULL,
    [StateName] nvarchar(500)  NOT NULL,
    [PostCode] nvarchar(10)  NULL,
    [CallGroupId] int  NULL,
    [CallGroupName] nvarchar(500)  NULL,
    [GroupCode] nvarchar(50)  NULL,
    [RouteOrderFromKh] int  NULL,
    [SuburbId] int  NOT NULL,
    [Longtitude] float  NULL,
    [Latitude] float  NULL,
    [MelwayRefNo] nvarchar(50)  NULL,
    [LastCallDate] datetime  NULL,
    [IsValid] bit  NOT NULL,
    [CountryName] nvarchar(500)  NOT NULL
);
GO

-- Creating table 'CallGroups'
CREATE TABLE [dbo].[CallGroups] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [CallGroupName] nvarchar(500)  NOT NULL,
    [GroupCode] nvarchar(50)  NOT NULL,
    [CurrentAssignCallActivityId] int  NULL,
    [LastAssignCallActivityId] int  NULL,
    [AllowAssistantToRelease] bit  NOT NULL,
    [IsActive] bit  NOT NULL,
    [DateAdded] datetime  NULL
);
GO

-- Creating table 'webpages_UsersInRoles'
CREATE TABLE [dbo].[webpages_UsersInRoles] (
    [webpages_Membership_UserId] int  NOT NULL,
    [webpages_Roles_RoleId] int  NOT NULL
);
GO

-- --------------------------------------------------
-- Creating all PRIMARY KEY constraints
-- --------------------------------------------------

-- Creating primary key on [Id] in table 'CallActivityWarnings'
ALTER TABLE [dbo].[CallActivityWarnings]
ADD CONSTRAINT [PK_CallActivityWarnings]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'CallAddressNotes'
ALTER TABLE [dbo].[CallAddressNotes]
ADD CONSTRAINT [PK_CallAddressNotes]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'CallTypes'
ALTER TABLE [dbo].[CallTypes]
ADD CONSTRAINT [PK_CallTypes]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'Countries'
ALTER TABLE [dbo].[Countries]
ADD CONSTRAINT [PK_Countries]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'States'
ALTER TABLE [dbo].[States]
ADD CONSTRAINT [PK_States]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'Suburbs'
ALTER TABLE [dbo].[Suburbs]
ADD CONSTRAINT [PK_Suburbs]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [UserId] in table 'webpages_Membership'
ALTER TABLE [dbo].[webpages_Membership]
ADD CONSTRAINT [PK_webpages_Membership]
    PRIMARY KEY CLUSTERED ([UserId] ASC);
GO

-- Creating primary key on [Id] in table 'webpages_PasswordResets'
ALTER TABLE [dbo].[webpages_PasswordResets]
ADD CONSTRAINT [PK_webpages_PasswordResets]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [RoleId] in table 'webpages_Roles'
ALTER TABLE [dbo].[webpages_Roles]
ADD CONSTRAINT [PK_webpages_Roles]
    PRIMARY KEY CLUSTERED ([RoleId] ASC);
GO

-- Creating primary key on [Id] in table 'CallActivityStatus'
ALTER TABLE [dbo].[CallActivityStatus]
ADD CONSTRAINT [PK_CallActivityStatus]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'Cycles'
ALTER TABLE [dbo].[Cycles]
ADD CONSTRAINT [PK_Cycles]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'SystemReferences'
ALTER TABLE [dbo].[SystemReferences]
ADD CONSTRAINT [PK_SystemReferences]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'CallActivities'
ALTER TABLE [dbo].[CallActivities]
ADD CONSTRAINT [PK_CallActivities]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'CallActivityAddresses'
ALTER TABLE [dbo].[CallActivityAddresses]
ADD CONSTRAINT [PK_CallActivityAddresses]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'Publishers'
ALTER TABLE [dbo].[Publishers]
ADD CONSTRAINT [PK_Publishers]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'CallAddresses'
ALTER TABLE [dbo].[CallAddresses]
ADD CONSTRAINT [PK_CallAddresses]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id], [AddressGps], [Number], [Street], [SuburbName], [StateName], [SuburbId], [IsValid], [CountryName] in table 'vwAddresses'
ALTER TABLE [dbo].[vwAddresses]
ADD CONSTRAINT [PK_vwAddresses]
    PRIMARY KEY CLUSTERED ([Id], [AddressGps], [Number], [Street], [SuburbName], [StateName], [SuburbId], [IsValid], [CountryName] ASC);
GO

-- Creating primary key on [Id] in table 'CallGroups'
ALTER TABLE [dbo].[CallGroups]
ADD CONSTRAINT [PK_CallGroups]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [webpages_Membership_UserId], [webpages_Roles_RoleId] in table 'webpages_UsersInRoles'
ALTER TABLE [dbo].[webpages_UsersInRoles]
ADD CONSTRAINT [PK_webpages_UsersInRoles]
    PRIMARY KEY CLUSTERED ([webpages_Membership_UserId], [webpages_Roles_RoleId] ASC);
GO

-- --------------------------------------------------
-- Creating all FOREIGN KEY constraints
-- --------------------------------------------------

-- Creating foreign key on [CallTypeId] in table 'CallActivityWarnings'
ALTER TABLE [dbo].[CallActivityWarnings]
ADD CONSTRAINT [FK_CallActivityWarning_CallType]
    FOREIGN KEY ([CallTypeId])
    REFERENCES [dbo].[CallTypes]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_CallActivityWarning_CallType'
CREATE INDEX [IX_FK_CallActivityWarning_CallType]
ON [dbo].[CallActivityWarnings]
    ([CallTypeId]);
GO

-- Creating foreign key on [CountryId] in table 'States'
ALTER TABLE [dbo].[States]
ADD CONSTRAINT [FK_State_Country]
    FOREIGN KEY ([CountryId])
    REFERENCES [dbo].[Countries]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_State_Country'
CREATE INDEX [IX_FK_State_Country]
ON [dbo].[States]
    ([CountryId]);
GO

-- Creating foreign key on [StateId] in table 'Suburbs'
ALTER TABLE [dbo].[Suburbs]
ADD CONSTRAINT [FK_Suburb_State]
    FOREIGN KEY ([StateId])
    REFERENCES [dbo].[States]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_Suburb_State'
CREATE INDEX [IX_FK_Suburb_State]
ON [dbo].[Suburbs]
    ([StateId]);
GO

-- Creating foreign key on [UserId] in table 'webpages_PasswordResets'
ALTER TABLE [dbo].[webpages_PasswordResets]
ADD CONSTRAINT [FK_PasswordResets]
    FOREIGN KEY ([UserId])
    REFERENCES [dbo].[webpages_Membership]
        ([UserId])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_PasswordResets'
CREATE INDEX [IX_FK_PasswordResets]
ON [dbo].[webpages_PasswordResets]
    ([UserId]);
GO

-- Creating foreign key on [webpages_Membership_UserId] in table 'webpages_UsersInRoles'
ALTER TABLE [dbo].[webpages_UsersInRoles]
ADD CONSTRAINT [FK_webpages_UsersInRoles_webpages_Membership]
    FOREIGN KEY ([webpages_Membership_UserId])
    REFERENCES [dbo].[webpages_Membership]
        ([UserId])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating foreign key on [webpages_Roles_RoleId] in table 'webpages_UsersInRoles'
ALTER TABLE [dbo].[webpages_UsersInRoles]
ADD CONSTRAINT [FK_webpages_UsersInRoles_webpages_Roles]
    FOREIGN KEY ([webpages_Roles_RoleId])
    REFERENCES [dbo].[webpages_Roles]
        ([RoleId])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_webpages_UsersInRoles_webpages_Roles'
CREATE INDEX [IX_FK_webpages_UsersInRoles_webpages_Roles]
ON [dbo].[webpages_UsersInRoles]
    ([webpages_Roles_RoleId]);
GO

-- Creating foreign key on [CurrentCycleId] in table 'SystemReferences'
ALTER TABLE [dbo].[SystemReferences]
ADD CONSTRAINT [FK_SystemReference_Cycle]
    FOREIGN KEY ([CurrentCycleId])
    REFERENCES [dbo].[Cycles]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_SystemReference_Cycle'
CREATE INDEX [IX_FK_SystemReference_Cycle]
ON [dbo].[SystemReferences]
    ([CurrentCycleId]);
GO

-- Creating foreign key on [CallTypeId] in table 'CallActivities'
ALTER TABLE [dbo].[CallActivities]
ADD CONSTRAINT [FK_CallActivity_CallType]
    FOREIGN KEY ([CallTypeId])
    REFERENCES [dbo].[CallTypes]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_CallActivity_CallType'
CREATE INDEX [IX_FK_CallActivity_CallType]
ON [dbo].[CallActivities]
    ([CallTypeId]);
GO

-- Creating foreign key on [CycleId] in table 'CallActivities'
ALTER TABLE [dbo].[CallActivities]
ADD CONSTRAINT [FK_CallActivity_Cycle]
    FOREIGN KEY ([CycleId])
    REFERENCES [dbo].[Cycles]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_CallActivity_Cycle'
CREATE INDEX [IX_FK_CallActivity_Cycle]
ON [dbo].[CallActivities]
    ([CycleId]);
GO

-- Creating foreign key on [CallActivityId] in table 'CallActivityAddresses'
ALTER TABLE [dbo].[CallActivityAddresses]
ADD CONSTRAINT [FK_CallActivity_CallActivityAddress]
    FOREIGN KEY ([CallActivityId])
    REFERENCES [dbo].[CallActivities]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_CallActivity_CallActivityAddress'
CREATE INDEX [IX_FK_CallActivity_CallActivityAddress]
ON [dbo].[CallActivityAddresses]
    ([CallActivityId]);
GO

-- Creating foreign key on [CallActivityStatusId] in table 'CallActivityAddresses'
ALTER TABLE [dbo].[CallActivityAddresses]
ADD CONSTRAINT [FK_CallActivityAddress_CallActivityStatus]
    FOREIGN KEY ([CallActivityStatusId])
    REFERENCES [dbo].[CallActivityStatus]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_CallActivityAddress_CallActivityStatus'
CREATE INDEX [IX_FK_CallActivityAddress_CallActivityStatus]
ON [dbo].[CallActivityAddresses]
    ([CallActivityStatusId]);
GO

-- Creating foreign key on [ReleasedToPublisherId] in table 'CallActivities'
ALTER TABLE [dbo].[CallActivities]
ADD CONSTRAINT [FK_CallActivity_Publisher]
    FOREIGN KEY ([ReleasedToPublisherId])
    REFERENCES [dbo].[Publishers]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_CallActivity_Publisher'
CREATE INDEX [IX_FK_CallActivity_Publisher]
ON [dbo].[CallActivities]
    ([ReleasedToPublisherId]);
GO

-- Creating foreign key on [ReturnedByPublisherId] in table 'CallActivities'
ALTER TABLE [dbo].[CallActivities]
ADD CONSTRAINT [FK_CallActivity_Publisher1]
    FOREIGN KEY ([ReturnedByPublisherId])
    REFERENCES [dbo].[Publishers]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_CallActivity_Publisher1'
CREATE INDEX [IX_FK_CallActivity_Publisher1]
ON [dbo].[CallActivities]
    ([ReturnedByPublisherId]);
GO

-- Creating foreign key on [ReleasedByUserId] in table 'CallActivities'
ALTER TABLE [dbo].[CallActivities]
ADD CONSTRAINT [FK_CallActivity_Publisher2]
    FOREIGN KEY ([ReleasedByUserId])
    REFERENCES [dbo].[Publishers]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_CallActivity_Publisher2'
CREATE INDEX [IX_FK_CallActivity_Publisher2]
ON [dbo].[CallActivities]
    ([ReleasedByUserId]);
GO

-- Creating foreign key on [ReturnedToUserId] in table 'CallActivities'
ALTER TABLE [dbo].[CallActivities]
ADD CONSTRAINT [FK_CallActivity_Publisher3]
    FOREIGN KEY ([ReturnedToUserId])
    REFERENCES [dbo].[Publishers]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_CallActivity_Publisher3'
CREATE INDEX [IX_FK_CallActivity_Publisher3]
ON [dbo].[CallActivities]
    ([ReturnedToUserId]);
GO

-- Creating foreign key on [UserRoleId] in table 'Publishers'
ALTER TABLE [dbo].[Publishers]
ADD CONSTRAINT [FK_Publisher_webpages_Roles]
    FOREIGN KEY ([UserRoleId])
    REFERENCES [dbo].[webpages_Roles]
        ([RoleId])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_Publisher_webpages_Roles'
CREATE INDEX [IX_FK_Publisher_webpages_Roles]
ON [dbo].[Publishers]
    ([UserRoleId]);
GO

-- Creating foreign key on [UserId] in table 'webpages_Membership'
ALTER TABLE [dbo].[webpages_Membership]
ADD CONSTRAINT [FK_webpages_Membership_Publisher]
    FOREIGN KEY ([UserId])
    REFERENCES [dbo].[Publishers]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating foreign key on [CallAddressId] in table 'CallActivityAddresses'
ALTER TABLE [dbo].[CallActivityAddresses]
ADD CONSTRAINT [FK_CallActivityAddress_CallAddress]
    FOREIGN KEY ([CallAddressId])
    REFERENCES [dbo].[CallAddresses]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_CallActivityAddress_CallAddress'
CREATE INDEX [IX_FK_CallActivityAddress_CallAddress]
ON [dbo].[CallActivityAddresses]
    ([CallAddressId]);
GO

-- Creating foreign key on [LastCallActivityStatusId] in table 'CallAddresses'
ALTER TABLE [dbo].[CallAddresses]
ADD CONSTRAINT [FK_CallAddress_CallActivityStatus]
    FOREIGN KEY ([LastCallActivityStatusId])
    REFERENCES [dbo].[CallActivityStatus]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_CallAddress_CallActivityStatus'
CREATE INDEX [IX_FK_CallAddress_CallActivityStatus]
ON [dbo].[CallAddresses]
    ([LastCallActivityStatusId]);
GO

-- Creating foreign key on [SuburbId] in table 'CallAddresses'
ALTER TABLE [dbo].[CallAddresses]
ADD CONSTRAINT [FK_CallAddress_Suburb]
    FOREIGN KEY ([SuburbId])
    REFERENCES [dbo].[Suburbs]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_CallAddress_Suburb'
CREATE INDEX [IX_FK_CallAddress_Suburb]
ON [dbo].[CallAddresses]
    ([SuburbId]);
GO

-- Creating foreign key on [CallAddressId] in table 'CallAddressNotes'
ALTER TABLE [dbo].[CallAddressNotes]
ADD CONSTRAINT [FK_CallAddressNote_CallAddress]
    FOREIGN KEY ([CallAddressId])
    REFERENCES [dbo].[CallAddresses]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_CallAddressNote_CallAddress'
CREATE INDEX [IX_FK_CallAddressNote_CallAddress]
ON [dbo].[CallAddressNotes]
    ([CallAddressId]);
GO

-- Creating foreign key on [CallGroupId] in table 'CallActivities'
ALTER TABLE [dbo].[CallActivities]
ADD CONSTRAINT [FK_CallActivity_CallGroup]
    FOREIGN KEY ([CallGroupId])
    REFERENCES [dbo].[CallGroups]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_CallActivity_CallGroup'
CREATE INDEX [IX_FK_CallActivity_CallGroup]
ON [dbo].[CallActivities]
    ([CallGroupId]);
GO

-- Creating foreign key on [CurrentAssignCallActivityId] in table 'CallGroups'
ALTER TABLE [dbo].[CallGroups]
ADD CONSTRAINT [FK_CallGroup_CallActivity]
    FOREIGN KEY ([CurrentAssignCallActivityId])
    REFERENCES [dbo].[CallActivities]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_CallGroup_CallActivity'
CREATE INDEX [IX_FK_CallGroup_CallActivity]
ON [dbo].[CallGroups]
    ([CurrentAssignCallActivityId]);
GO

-- Creating foreign key on [LastAssignCallActivityId] in table 'CallGroups'
ALTER TABLE [dbo].[CallGroups]
ADD CONSTRAINT [FK_CallGroup_CallActivity1]
    FOREIGN KEY ([LastAssignCallActivityId])
    REFERENCES [dbo].[CallActivities]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_CallGroup_CallActivity1'
CREATE INDEX [IX_FK_CallGroup_CallActivity1]
ON [dbo].[CallGroups]
    ([LastAssignCallActivityId]);
GO

-- Creating foreign key on [CallGroupId] in table 'CallAddresses'
ALTER TABLE [dbo].[CallAddresses]
ADD CONSTRAINT [FK_CallAddress_CallGroup]
    FOREIGN KEY ([CallGroupId])
    REFERENCES [dbo].[CallGroups]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_CallAddress_CallGroup'
CREATE INDEX [IX_FK_CallAddress_CallGroup]
ON [dbo].[CallAddresses]
    ([CallGroupId]);
GO

-- --------------------------------------------------
-- Script has ended
-- --------------------------------------------------