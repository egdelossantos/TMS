update CallGroup set CurrentAssignCallActivityId = null, LastAssignCallActivityId = null
update CallAddress set LastCallDate = null, LastCallActivityStatusId = null

delete from CallActivityAddress
delete from CallActivity
delete from SystemReference
delete from Cycle


DBCC CHECKIDENT (CallActivityAddress, RESEED, 0)
DBCC CHECKIDENT (CallActivity, RESEED, 0)
DBCC CHECKIDENT (Cycle, RESEED, 0)

insert into Cycle (CycleNumber)
select 1

insert into SystemReference(Id, CurrentCycleId, CurrentCycleNumber)
select 1, 1, 1


