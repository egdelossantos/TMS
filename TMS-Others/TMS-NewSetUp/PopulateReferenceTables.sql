-- This script populates the reference tables

INSERT INTO [dbo].[Country]
           ([CountryName])
SELECT 'Australia'


INSERT INTO [dbo].[State]
           ([CountryId]
           ,[StateName])
SELECT 1, 'Victoria'


INSERT INTO [dbo].[Suburb]
           ([StateId]
           ,[SuburbName]
           ,[PostCode])
      SELECT 1, 'Airport West', '3042'
UNION SELECT 1, 'Albanvale', '3021'
UNION SELECT 1, 'Albion', '3020'
UNION SELECT 1, 'Altona', '3018'
UNION SELECT 1, 'Altona Meadows', '3028'
UNION SELECT 1, 'Altona North', '3025'
UNION SELECT 1, 'Ardeer', '3022'
UNION SELECT 1, 'Ascot Vale', '3032'
UNION SELECT 1, 'Avondale Heights', '3034'
UNION SELECT 1, 'Bacchus Marsh', '3340'
UNION SELECT 1, 'Braybrook', '3019'
UNION SELECT 1, 'Broadmeadows', '3047'
UNION SELECT 1, 'Brooklyn', '3012'
UNION SELECT 1, 'Brunswick', '3056'
UNION SELECT 1, 'Bulleen', '3105'
UNION SELECT 1, 'Bundoora', '3083'
UNION SELECT 1, 'Burnside', '3023'
UNION SELECT 1, 'Cairnlea', '3023'
UNION SELECT 1, 'Campbellfield', '3061'
UNION SELECT 1, 'Caroline Springs', '3023'
UNION SELECT 1, 'Clifton Hill', '3068'
UNION SELECT 1, 'Coburg', '3058'
UNION SELECT 1, 'Coolaroo ', '3048'
UNION SELECT 1, 'Craigeburn', '3064'
UNION SELECT 1, 'Deer Park', '3023'
UNION SELECT 1, 'Delahey', '3037'
UNION SELECT 1, 'Derrimut', '3030'
UNION SELECT 1, 'Doncaster', '3108'
UNION SELECT 1, 'Eden Park', '3757'
UNION SELECT 1, 'Epping', '3076'
UNION SELECT 1, 'Fawkner', '3060'
UNION SELECT 1, 'Fitzroy', '3065'
UNION SELECT 1, 'Flemington', '3031'
UNION SELECT 1, 'Footscray', '3011'
UNION SELECT 1, 'West Footscray', '3012'
UNION SELECT 1, 'Gladstone Park', '3043'
UNION SELECT 1, 'Glenroy', '3046'
UNION SELECT 1, 'Greensborough', '3088'
UNION SELECT 1, 'Heidelberg', '3084'
UNION SELECT 1, 'Hillside', '3037'
UNION SELECT 1, 'Hoppers Crossing', '3029'
UNION SELECT 1, 'Ivanhoe ', '3079'
UNION SELECT 1, 'Kealba', '3021'
UNION SELECT 1, 'Keilor', '3036'
UNION SELECT 1, 'Keilor Downs', '3038'
UNION SELECT 1, 'Keilor East', '3033'
UNION SELECT 1, 'Keilor Park', '3042'
UNION SELECT 1, 'Kew', '3101'
UNION SELECT 1, 'Kings Park', '3021'
UNION SELECT 1, 'Kingsbury', '3083'
UNION SELECT 1, 'Lalor', '3075'
UNION SELECT 1, 'Laverton', '3028'
UNION SELECT 1, 'Maidstone', '3012'
UNION SELECT 1, 'Meadow Heights', '3048'
UNION SELECT 1, 'Melton West', '3337'
UNION SELECT 1, 'Mill Park', '3082'
UNION SELECT 1, 'Northcote', '3070'
UNION SELECT 1, 'Pascoe Vale', '3044'
UNION SELECT 1, 'Point Cook', '3030'
UNION SELECT 1, 'Preston', '3072'
UNION SELECT 1, 'Reservoir', '3073'
UNION SELECT 1, 'Richmond', '3121'
UNION SELECT 1, 'Ringwood', '3134'
UNION SELECT 1, 'Roxburgh Park', '3064'
UNION SELECT 1, 'Seabrook', '3028'
UNION SELECT 1, 'South Melbourne', '3205'
UNION SELECT 1, 'South Morang', '3752'
UNION SELECT 1, 'Spotswood', '3015'
UNION SELECT 1, 'St Albans', '3021'
UNION SELECT 1, 'St Kilda', '3182'
UNION SELECT 1, 'Strathmore', '3041'
UNION SELECT 1, 'Sunbury', '3429'
UNION SELECT 1, 'Sunshine', '3020'
UNION SELECT 1, 'Sunshine North', '3020'
UNION SELECT 1, 'Sunshine West', '3020'
UNION SELECT 1, 'Sydenham', '3037'
UNION SELECT 1, 'Taylors Lakes', '3038'
UNION SELECT 1, 'Thornbury', '3071'
UNION SELECT 1, 'Tullamarine', '3043'
UNION SELECT 1, 'Watsonia', '3087'
UNION SELECT 1, 'Werribee', '3030'
UNION SELECT 1, 'West Melbourne', '3033'
UNION SELECT 1, 'Westmeadows', '3049'
UNION SELECT 1, 'Williamstown', '3016'
UNION SELECT 1, 'Wyndham Vale', '3024'
UNION SELECT 1, 'Yan Yean', '3755'
UNION SELECT 1, 'Yarraville', '3013'
UNION SELECT 1, 'Brookfield (Melton South)', '3338'
UNION SELECT 1, 'Taylors Hill', '3037'
UNION SELECT 1, 'Keilor Lodge', '3038'
UNION SELECT 1, 'Truganina', '3029'
UNION SELECT 1, 'Tarneit', '3029'
UNION SELECT 1, 'Burnside Heights', '3023'
UNION SELECT 1, 'Brunswick East', '3057'
UNION SELECT 1, 'Chadstone', '3148'
UNION SELECT 1, 'Glen Waverly', '3150'
UNION SELECT 1, 'Plumpton', '3335'
UNION SELECT 1, 'Williams Landing', '3027'     


INSERT INTO [dbo].[CallType]
           ([CallTypeName])
	  SELECT 'Regular'
UNION SELECT 'Campaign'


INSERT INTO [dbo].[CallActivityStatus]
           ([Status]
           ,[Code]
           ,[IsValidAddress])
      SELECT 'Done', 'DONE', 1
UNION SELECT 'Not At Home 1', 'NOTATHOME1', 1
UNION SELECT 'Not At Home 2', 'NOTATHOME2', 1
UNION SELECT 'Address Not Found', 'ADDRESSNOTFOUND', 0
UNION SELECT 'Not Filipino', 'NOTFILIPINO', 0
UNION SELECT 'Do Not Call', 'DONOTCALL', 0


INSERT INTO [dbo].[CallActivityWarning]
           ([CallTypeId]
           ,[FromNumberOfDays]
           ,[ToNumberOfDays]
           ,[WarningSeverity]
           ,[WarningColour])
      SELECT 1, -9999, 6, 0, 'success'
UNION SELECT 1, 7, 30, 1, 'warning'
UNION SELECT 1, 31, 9999, 2, 'error'
UNION SELECT 2, -9999, 6, 0, 'success'
UNION SELECT 2, 7, 14, 1, 'warning'
UNION SELECT 2, 15, 9999, 2, 'error'
    

INSERT INTO [dbo].[webpages_Roles]
           ([RoleName])
	  SELECT 'Admin'
UNION SELECT 'AssistantBrother'
UNION SELECT 'Elder'
UNION SELECT 'Publisher'
UNION SELECT 'TerritoryOverseer'

