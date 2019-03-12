--this should not happen
update CallAddress set isvalid = 1 where isvalid = 0 and LastCallActivityStatusId is null

-- store last callgroup in a table
insert into InactiveCallAddress (CallAddressId, CallGroupId, CallStatus, DateDeactivated)
select Id, CallGroupId, LastCallActivityStatusId, LastCallDate from CallAddress where isvalid = 0 and CallGroupId is not null

-- remove callgroupid on inactive address
update CallAddress set CallGroupId = null where isvalid = 0

-- reorder route
;with address as(
select *, ROW_NUMBER() OVER(PARTITION BY CallGroupId ORDER BY CallGroupId, RouteOrderFromKh) AS SortOrder 
from CallAddress ca where isvalid = 1 and CallGroupId is not null
)
update a2 set RouteOrderFromKh = a1.SortOrder
from address a1
inner join CallAddress a2 on a1.id = a2.id