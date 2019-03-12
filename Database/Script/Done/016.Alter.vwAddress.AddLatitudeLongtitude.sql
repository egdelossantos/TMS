ALTER VIEW [dbo].[vwAddress]
AS
SELECT        cd.Id, CASE WHEN isnull(Unit, '') = '' THEN '' ELSE Unit + '/' END + cd.Number + ' ' + cd.Street + ', ' + sb.SuburbName AS Address, 
                         cd.Number + ' ' + cd.Street + ', ' + sb.SuburbName AS AddressGps, cd.Unit, cd.Number, cd.Street, sb.SuburbName, st.StateName, sb.PostCode, 
                         cd.CallGroupId, cg.CallGroupName, cg.GroupCode, cd.RouteOrderFromKh, cd.SuburbId, cd.Longtitude, cd.Latitude, cd.MelwayRefNo, cd.LastCallDate
FROM            dbo.CallAddress AS cd INNER JOIN
                         dbo.Suburb AS sb ON cd.SuburbId = sb.Id INNER JOIN
                         dbo.State AS st ON sb.StateId = st.Id LEFT OUTER JOIN
                         dbo.CallGroup AS cg ON cd.CallGroupId = cg.Id



