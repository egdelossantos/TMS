use Territory
go

alter table CallAddress add Longtitude float
alter table CallAddress add Latitude float

ALTER TABLE dbo.CallAddress ADD Address AS (
	case when isnull(Unit, '') = '' then '' else Unit + '/' end
	+ Number + ' ' + Street
);

ALTER TABLE dbo.CallAddress ADD GpsAddress AS (
	Number + ' ' + Street
);