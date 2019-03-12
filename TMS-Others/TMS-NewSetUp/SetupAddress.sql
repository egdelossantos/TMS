select cg.id,cg.callgroupname, s.Id as SuburbID, aaa.* from
(
 SELECT 144.870629 as Longtitude, -37.770081 as Latitude, '' as Unit, '2' as Number, 'larwood cls' as Street, 'avondale heights' as Suburb, 12 as RouteOrder, '0014' as GroupCode
UNION SELECT 144.870056 as Longtitude, -37.771062 as Latitude, '' as Unit, '11' as Number, 'larwood cls' as Street, 'avondale heights' as Suburb, 13 as RouteOrder, '0014' as GroupCode
UNION SELECT 144.865413 as Longtitude, -37.762362 as Latitude, '' as Unit, '30' as Number, 'templewood cres' as Street, 'avondale heights' as Suburb, 11 as RouteOrder, '0014' as GroupCode

) aaa inner join callgroup cg on aaa.GroupCode = cg.GroupCode inner join Suburb s on aaa.Suburb = s.SuburbName

USE [Territory]
GO

INSERT INTO [dbo].[CallAddress]
           ([Unit]
           ,[Number]
           ,[Street]
           ,[SuburbId]
           ,[RouteOrderFromKh]
           ,[CallGroupId]
           ,[IsValid]
           ,[Longtitude]
           ,[Latitude])
select aaa.Unit, aaa.Number, aaa.Street, s.ID,  aaa.RouteOrder, cg.ID, 1, aaa.Longtitude, aaa.Latitude
from
(
  SELECT 144.787506 as Longtitude, -37.76203 as Latitude, '' as Unit, '3' as Number, 'grovedale cct' as Street, 'cairnlea' as Suburb, 9 as RouteOrder, '0176' as GroupCode

 ) aaa inner join callgroup cg on aaa.GroupCode = cg.GroupCode inner join Suburb s on aaa.Suburb = s.SuburbName


 update ca set routeorderfromkh =  routeorderfromkh -4
 from calladdress ca inner join callgroup cg on ca.callgroupid = cg.id where cg.groupcode = '0031'

UPDATE CallAddress SET CallGroupID = 197, RouteOrderFromKH = 1  WHERE ID = 858
UPDATE CallAddress SET CallGroupID = 197, RouteOrderFromKH = 2  WHERE ID = 1207
UPDATE CallAddress SET CallGroupID = 197, RouteOrderFromKH = 3  WHERE ID = 2341
UPDATE CallAddress SET CallGroupID = 197, RouteOrderFromKH = 4  WHERE ID = 2329
UPDATE CallAddress SET CallGroupID = 197, RouteOrderFromKH = 8  WHERE ID = 868
UPDATE CallAddress SET CallGroupID = 197, RouteOrderFromKH = 7  WHERE ID = 874
UPDATE CallAddress SET CallGroupID = 197, RouteOrderFromKH = 6  WHERE ID = 875
UPDATE CallAddress SET CallGroupID = 197, RouteOrderFromKH = 5  WHERE ID = 869


 select * from calladdress ca inner join callgroup cg on ca.callgroupid = cg.id where cg.groupcode = '0030' order by routeorderfromkh

 select a.id, callgroupid, a.callgroupname, a.groupcode, Address, AddressGps, suburbname, routeorderfromkh, longtitude, latitude
from vwAddress a inner join callgroup cg on a.callgroupid = cg.id
where suburbname = 'cairnlea' order by callgroupid, routeorderfromkh