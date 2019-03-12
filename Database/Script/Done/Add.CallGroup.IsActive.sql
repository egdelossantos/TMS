alter table CallGroup add IsActive bit default 1
go

update CallGroup set IsActive = 1
go

alter table CallGroup alter column IsActive bit not null
go


update cg1 set IsActive = 0
from CallGroup cg1
inner join
(select cg.Id,
	   cg.CallGroupName,	  
	   'validAddressCount' = (select count(1) from CallAddress ca where ca.CallGroupId = cg.Id and ca.IsValid = 1)
from CallGroup cg) cg2 on cg1.Id = cg2.Id
where cg2.validAddressCount = 0