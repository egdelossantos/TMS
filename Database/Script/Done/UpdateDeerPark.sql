if (not exists(select * from CallAddress where Street = 'Corby Close' and number = '3' and SuburbId = 25))
begin
INSERT INTO CallAddress
           (Id, Unit,Number,Street,SuburbId,IsValid)
select 1251, '', '3', 'Corby Close', 25,1
end

if (not exists(select * from CallAddress where Street = 'Station Road' and number = '168' and SuburbId = 25))
begin
INSERT INTO CallAddress
           (Id, Unit,Number,Street,SuburbId,IsValid)
select 1252, '', '168', 'Station Road', 25,1
end

if (not exists(select * from CallAddress where Street = 'Station Road' and number = '136' and SuburbId = 25))
begin
INSERT INTO CallAddress
           (Id, Unit,Number,Street,SuburbId,IsValid)
select 1253, '', '136', 'Station Road', 25,1
end

update CallAddress set CallGroupId = null, RouteOrderFromKh = null where suburbid = 25

--148	Deer Park 1
update CallAddress set CallGroupId = 148, RouteOrderFromKh = 1 where id = 557
update CallAddress set CallGroupId = 148, RouteOrderFromKh = 2 where id = 566
update CallAddress set CallGroupId = 148, RouteOrderFromKh = 3 where id = 565
update CallAddress set CallGroupId = 148, RouteOrderFromKh = 4 where id = 568
update CallAddress set CallGroupId = 148, RouteOrderFromKh = 5 where id = 569
update CallAddress set CallGroupId = 148, RouteOrderFromKh = 6 where id = 1213
update CallAddress set CallGroupId = 148, RouteOrderFromKh = 7 where id = 1214
update CallAddress set CallGroupId = 148, RouteOrderFromKh = 8 where id = 1215
update CallAddress set CallGroupId = 148, RouteOrderFromKh = 9 where id = 1210

--149	Deer Park 2
update CallAddress set CallGroupId = 149, RouteOrderFromKh = 1 where id = 554
update CallAddress set CallGroupId = 149, RouteOrderFromKh = 2 where id = 561
update CallAddress set CallGroupId = 149, RouteOrderFromKh = 3 where id = 562
update CallAddress set CallGroupId = 149, RouteOrderFromKh = 4 where id = 570
update CallAddress set CallGroupId = 149, RouteOrderFromKh = 5 where id = 558
update CallAddress set CallGroupId = 149, RouteOrderFromKh = 6 where id = 559
update CallAddress set CallGroupId = 149, RouteOrderFromKh = 7 where id = 555
update CallAddress set CallGroupId = 149, RouteOrderFromKh = 8 where id = 563
update CallAddress set CallGroupId = 149, RouteOrderFromKh = 9 where id = 560
update CallAddress set CallGroupId = 149, RouteOrderFromKh = 10 where id = 556

--150	Deer Park 3
update CallAddress set CallGroupId = 150, RouteOrderFromKh = 1 where id = 553
update CallAddress set CallGroupId = 150, RouteOrderFromKh = 2 where id = 564
update CallAddress set CallGroupId = 150, RouteOrderFromKh = 3 where id = 571
update CallAddress set CallGroupId = 150, RouteOrderFromKh = 4 where id = 523
update CallAddress set CallGroupId = 150, RouteOrderFromKh = 5 where id = 574
update CallAddress set CallGroupId = 150, RouteOrderFromKh = 6 where id = 573
update CallAddress set CallGroupId = 150, RouteOrderFromKh = 7 where id = 575
update CallAddress set CallGroupId = 150, RouteOrderFromKh = 8 where id = 1252
update CallAddress set CallGroupId = 150, RouteOrderFromKh = 9 where id = 1253
update CallAddress set CallGroupId = 150, RouteOrderFromKh = 10 where id = 572

--151	Deer Park 4
update CallAddress set CallGroupId = 151, RouteOrderFromKh = 1 where id = 521
update CallAddress set CallGroupId = 151, RouteOrderFromKh = 2 where id = 522
update CallAddress set CallGroupId = 151, RouteOrderFromKh = 3 where id = 520
update CallAddress set CallGroupId = 151, RouteOrderFromKh = 4 where id = 517
update CallAddress set CallGroupId = 151, RouteOrderFromKh = 5 where id = 1212
update CallAddress set CallGroupId = 151, RouteOrderFromKh = 6 where id = 524
update CallAddress set CallGroupId = 151, RouteOrderFromKh = 7 where id = 525
update CallAddress set CallGroupId = 151, RouteOrderFromKh = 8 where id = 1211
update CallAddress set CallGroupId = 151, RouteOrderFromKh = 9 where id = 519
update CallAddress set CallGroupId = 151, RouteOrderFromKh = 10 where id =518

--152	Deer Park 5
update CallAddress set CallGroupId = 152, RouteOrderFromKh = 1 where id = 551
update CallAddress set CallGroupId = 152, RouteOrderFromKh = 2 where id = 536
update CallAddress set CallGroupId = 152, RouteOrderFromKh = 3 where id = 541
update CallAddress set CallGroupId = 152, RouteOrderFromKh = 4 where id = 537
update CallAddress set CallGroupId = 152, RouteOrderFromKh = 5 where id = 1251
update CallAddress set CallGroupId = 152, RouteOrderFromKh = 6 where id = 538
update CallAddress set CallGroupId = 152, RouteOrderFromKh = 7 where id = 539
update CallAddress set CallGroupId = 152, RouteOrderFromKh = 8 where id = 540
update CallAddress set CallGroupId = 152, RouteOrderFromKh = 9 where id = 542

--153	Deer Park 6
update CallAddress set CallGroupId = 153, RouteOrderFromKh = 1 where id = 546
update CallAddress set CallGroupId = 153, RouteOrderFromKh = 2 where id = 547
update CallAddress set CallGroupId = 153, RouteOrderFromKh = 3 where id = 552
update CallAddress set CallGroupId = 153, RouteOrderFromKh = 4 where id = 548
update CallAddress set CallGroupId = 153, RouteOrderFromKh = 5 where id = 549
update CallAddress set CallGroupId = 153, RouteOrderFromKh = 6 where id = 550
update CallAddress set CallGroupId = 153, RouteOrderFromKh = 7 where id = 530
update CallAddress set CallGroupId = 153, RouteOrderFromKh = 8 where id = 532
update CallAddress set CallGroupId = 153, RouteOrderFromKh = 9 where id = 531

declare @deerPark7 int
if (not exists(select * from CallGroup where CallGroupName = 'Deer Park 7'))
begin
	INSERT INTO CallGroup
           (CallGroupName, AllowAssistantToRelease, GroupCode)
    SELECT 'Deer Park 7', 0, ''

	select @deerPark7 = @@IDENTITY
end
else
begin
	select @deerPark7 = Id from CallGroup where CallGroupName = 'Deer Park 7'
end

--177	Deer Park 7

update CallAddress set CallGroupId = @deerPark7, RouteOrderFromKh = 1  where id = 533
update CallAddress set CallGroupId = @deerPark7, RouteOrderFromKh = 2  where id = 543
update CallAddress set CallGroupId = @deerPark7, RouteOrderFromKh = 3  where id = 534
update CallAddress set CallGroupId = @deerPark7, RouteOrderFromKh = 4  where id = 535
update CallAddress set CallGroupId = @deerPark7, RouteOrderFromKh = 5  where id = 526
update CallAddress set CallGroupId = @deerPark7, RouteOrderFromKh = 6  where id = 544
update CallAddress set CallGroupId = @deerPark7, RouteOrderFromKh = 7  where id = 545
update CallAddress set CallGroupId = @deerPark7, RouteOrderFromKh = 8  where id = 527
update CallAddress set CallGroupId = @deerPark7, RouteOrderFromKh = 9  where id = 529
update CallAddress set CallGroupId = @deerPark7, RouteOrderFromKh = 10 where id = 528