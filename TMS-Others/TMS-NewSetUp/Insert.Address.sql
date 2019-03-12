USE [Territory]
GO

--INSERT INTO [dbo].[CallAddress]
--           ([Unit]
--           ,[Number]
--           ,[Street]
--           ,[SuburbId]
--           ,[RouteOrderFromKh]
--           ,[CallGroupId]
--           ,[IsValid]
--           ,[Longtitude]
--           ,[Latitude])

select distinct tmp.Unit, tmp.Number, tmp.Street, s.id as suburbid, 
0 as RouteOrder,
--'RouteOrder' = case when cc.RouteOrderFromKh is not null then cc.RouteOrderFromKh else
--					isnull(ca.[MaxRouteOrderFromKh], 0) + ROW_NUMBER() OVER (PARTITION BY tmp.[GroupCode] ORDER BY tmp.latitude, tmp.longtitude ASC) 
--				end,
c.id as callgroupid, 1 as isvalid, tmp.longtitude, tmp.latitude 

from
(
SELECT 144.674582 as Longtitude, -37.851223 as Latitude, '' as Unit, '23' as Number, 'Quarrion Court' as Street, 'Hoppers Crossing' as Suburb, 0 as RouteOrder, '' as GroupCode
UNION SELECT 144.876106 as Longtitude, -37.812688 as Latitude, '' as Unit, '5' as Number, 'Adalegh Street' as Street, 'Yarraville' as Suburb, 0 as RouteOrder, '' as GroupCode
UNION SELECT 144.964855 as Longtitude, -37.727453 as Latitude, '' as Unit, '30' as Number, 'Bakers Road' as Street, 'Coburg' as Suburb, 0 as RouteOrder, '' as GroupCode
UNION SELECT 144.672264 as Longtitude, -37.849523 as Latitude, '' as Unit, '20' as Number, 'Abbotswood Drive' as Street, 'Hoppers Crossing' as Suburb, 0 as RouteOrder, '' as GroupCode
UNION SELECT 145.074658 as Longtitude, -37.682125 as Latitude, '106' as Unit, '50' as Number, 'Janefield Drive' as Street, 'Bundoora' as Suburb, 0 as RouteOrder, '' as GroupCode
UNION SELECT 144.761497 as Longtitude, -37.78323 as Latitude, '' as Unit, '122' as Number, 'Lennon Parkway' as Street, 'Derrimut' as Suburb, 0 as RouteOrder, '' as GroupCode
UNION SELECT 144.675299 as Longtitude, -37.912676 as Latitude, '' as Unit, '158' as Number, 'South Ring Road' as Street, 'Werribee' as Suburb, 0 as RouteOrder, '' as GroupCode
UNION SELECT 144.663906 as Longtitude, -37.849383 as Latitude, '' as Unit, '25' as Number, 'Azure Drive' as Street, 'Tarneit' as Suburb, 0 as RouteOrder, '' as GroupCode
UNION SELECT 144.8548 as Longtitude, -37.827865 as Latitude, '' as Unit, '19' as Number, 'Marigold Avenue' as Street, 'Altona North' as Suburb, 0 as RouteOrder, '' as GroupCode
UNION SELECT 144.71201 as Longtitude, -37.870614 as Latitude, '' as Unit, '5' as Number, 'Sunbird Crescent' as Street, 'Hoppers Crossing' as Suburb, 0 as RouteOrder, '' as GroupCode
UNION SELECT 144.742473 as Longtitude, -37.851389 as Latitude, '' as Unit, '16' as Number, 'Constellation Cct' as Street, 'Truganina' as Suburb, 0 as RouteOrder, '' as GroupCode
UNION SELECT 144.769113 as Longtitude, -37.86011 as Latitude, '' as Unit, '2' as Number, 'Sumers Street' as Street, 'Laverton' as Suburb, 0 as RouteOrder, '' as GroupCode
UNION SELECT 144.725534 as Longtitude, -37.714119 as Latitude, '' as Unit, '6' as Number, 'Forclaz Street' as Street, 'Plumpton' as Suburb, 0 as RouteOrder, '' as GroupCode
UNION SELECT 144.722645 as Longtitude, -37.713028 as Latitude, '' as Unit, '39' as Number, 'Annecy Blvd' as Street, 'Plumpton' as Suburb, 0 as RouteOrder, '' as GroupCode
UNION SELECT 144.731305 as Longtitude, -37.719823 as Latitude, '' as Unit, '15' as Number, 'Orbis Avenue' as Street, 'Plumpton' as Suburb, 0 as RouteOrder, '' as GroupCode
UNION SELECT 144.754828 as Longtitude, -37.792993 as Latitude, '' as Unit, '13' as Number, 'Exeter Street' as Street, 'Derrimut' as Suburb, 0 as RouteOrder, '' as GroupCode
UNION SELECT 145.052259 as Longtitude, -37.649172 as Latitude, '' as Unit, '7' as Number, 'Gerry Anna Court' as Street, 'Epping' as Suburb, 0 as RouteOrder, '' as GroupCode
UNION SELECT 144.821619 as Longtitude, -37.777439 as Latitude, '3' as Unit, '8' as Number, 'Derrimut Street' as Street, 'Albion' as Suburb, 0 as RouteOrder, '' as GroupCode
UNION SELECT 144.765515 as Longtitude, -37.743235 as Latitude, '' as Unit, '1' as Number, 'Delamare Drive' as Street, 'Albanvale' as Suburb, 0 as RouteOrder, '' as GroupCode
UNION SELECT 144.821312 as Longtitude, -37.777942 as Latitude, '2' as Unit, '21' as Number, 'Derrimut Street' as Street, 'Albion' as Suburb, 0 as RouteOrder, '' as GroupCode
UNION SELECT 144.918 as Longtitude, -37.571689 as Latitude, '' as Unit, '62' as Number, 'Huntington Drive' as Street, 'Craigieburn ' as Suburb, 0 as RouteOrder, '' as GroupCode
UNION SELECT 144.769292 as Longtitude, -37.749596 as Latitude, '' as Unit, '37' as Number, 'Angelique Grove' as Street, 'Albanvale' as Suburb, 0 as RouteOrder, '' as GroupCode
UNION SELECT 144.794768 as Longtitude, -37.744588 as Latitude, '' as Unit, '41' as Number, 'Scott Avenue' as Street, 'St Albans' as Suburb, 0 as RouteOrder, '' as GroupCode
UNION SELECT 144.794615 as Longtitude, -37.74554 as Latitude, '' as Unit, '27' as Number, 'Scott Avenue' as Street, 'St Albans' as Suburb, 0 as RouteOrder, '' as GroupCode
UNION SELECT 144.794602 as Longtitude, -37.74569 as Latitude, 'A' as Unit, '25' as Number, 'Scott Avenue' as Street, 'St Albans' as Suburb, 0 as RouteOrder, '' as GroupCode
UNION SELECT 144.794602 as Longtitude, -37.74569 as Latitude, 'B' as Unit, '25' as Number, 'Scott Avenue' as Street, 'St Albans' as Suburb, 0 as RouteOrder, '' as GroupCode
UNION SELECT 144.796307 as Longtitude, -37.748268 as Latitude, '' as Unit, '37' as Number, 'Howardson Circuit' as Street, 'St Albans' as Suburb, 0 as RouteOrder, '' as GroupCode
UNION SELECT 144.792731 as Longtitude, -37.744765 as Latitude, '' as Unit, '24' as Number, 'Cornhill Street' as Street, 'St Albans' as Suburb, 0 as RouteOrder, '' as GroupCode
UNION SELECT 144.794107 as Longtitude, -37.747561 as Latitude, '' as Unit, '65' as Number, 'Andrea Street' as Street, 'St Albans' as Suburb, 0 as RouteOrder, '' as GroupCode
UNION SELECT 144.794556 as Longtitude, -37.747705 as Latitude, '' as Unit, '59' as Number, 'Andrea Street' as Street, 'St Albans' as Suburb, 0 as RouteOrder, '' as GroupCode
UNION SELECT 144.796037 as Longtitude, -37.746936 as Latitude, '' as Unit, '4' as Number, 'Glendenning Street' as Street, 'St Albans' as Suburb, 0 as RouteOrder, '' as GroupCode
UNION SELECT 144.766033 as Longtitude, -37.768774 as Latitude, '' as Unit, '50' as Number, 'Hogans Street' as Street, 'Deer Park' as Suburb, 0 as RouteOrder, '' as GroupCode
UNION SELECT 144.805361 as Longtitude, -37.737183 as Latitude, '1' as Unit, '152' as Number, '152 Biggs Street' as Street, 'St Albans' as Suburb, 0 as RouteOrder, '' as GroupCode
UNION SELECT 144.917337 as Longtitude, -37.701892 as Latitude, '' as Unit, '16' as Number, 'Hartington  Street' as Street, 'Glenroy' as Suburb, 0 as RouteOrder, '' as GroupCode
UNION SELECT 144.913358 as Longtitude, -37.585856 as Latitude, '' as Unit, '37' as Number, 'Coringa Way' as Street, 'Craigieburn' as Suburb, 0 as RouteOrder, '' as GroupCode
UNION SELECT 144.729292 as Longtitude, -37.719766 as Latitude, '' as Unit, '17' as Number, 'Goldworthy Way' as Street, 'Plumpton' as Suburb, 0 as RouteOrder, '' as GroupCode
UNION SELECT 144.777508 as Longtitude, -37.745299 as Latitude, '' as Unit, '11' as Number, 'Robyn Avenue' as Street, 'Albanvale' as Suburb, 0 as RouteOrder, '' as GroupCode
UNION SELECT 144.775762 as Longtitude, -37.746014 as Latitude, '' as Unit, '8' as Number, 'Appian Street' as Street, 'Albanvale' as Suburb, 0 as RouteOrder, '' as GroupCode
UNION SELECT 144.774985 as Longtitude, -37.746567 as Latitude, '' as Unit, '20' as Number, 'Appian Street' as Street, 'Albanvale' as Suburb, 0 as RouteOrder, '' as GroupCode
) tmp
inner join suburb s on tmp.suburb = s.suburbname
left join callgroup c on tmp.groupcode = c.groupcode
left join (select callgroupid,max([RouteOrderFromKh]) as [MaxRouteOrderFromKh] from calladdress where isvalid=1 group by callgroupid) ca on c.id = ca.callgroupid
left join (select callgroupid, suburbid, street, min([RouteOrderFromKh]) as [RouteOrderFromKh] from calladdress where isvalid=1 group by callgroupid, suburbid, street) cc on c.id = cc.callgroupid and s.id = cc.suburbid and tmp.street = cc.street
order by callgroupid, tmp.street