update CallAddress set CallGroupId = null, RouteOrderFromKh = null where suburbid = 41

--154	Hoppers Crossing 1
update CallAddress set CallGroupId = 154, RouteOrderFromKh = 1 where id = 164
update CallAddress set CallGroupId = 154, RouteOrderFromKh = 2 where id = 166
update CallAddress set CallGroupId = 154, RouteOrderFromKh = 3 where id = 165
update CallAddress set CallGroupId = 154, RouteOrderFromKh = 4 where id = 173
update CallAddress set CallGroupId = 154, RouteOrderFromKh = 5 where id = 136
update CallAddress set CallGroupId = 154, RouteOrderFromKh = 6 where id = 171
update CallAddress set CallGroupId = 154, RouteOrderFromKh = 7 where id = 172
update CallAddress set CallGroupId = 154, RouteOrderFromKh = 8 where id = 169
update CallAddress set CallGroupId = 154, RouteOrderFromKh = 9 where id = 170
update CallAddress set CallGroupId = 154, RouteOrderFromKh = 10 where id =167
update CallAddress set CallGroupId = 154, RouteOrderFromKh = 11 where id =168

--155	Hoppers Crossing 2
update CallAddress set CallGroupId = 155, RouteOrderFromKh = 1 where id = 175
update CallAddress set CallGroupId = 155, RouteOrderFromKh = 2 where id = 174
update CallAddress set CallGroupId = 155, RouteOrderFromKh = 3 where id = 132
update CallAddress set CallGroupId = 155, RouteOrderFromKh = 4 where id = 150
update CallAddress set CallGroupId = 155, RouteOrderFromKh = 5 where id = 153
update CallAddress set CallGroupId = 155, RouteOrderFromKh = 6 where id = 159
update CallAddress set CallGroupId = 155, RouteOrderFromKh = 7 where id = 157
update CallAddress set CallGroupId = 155, RouteOrderFromKh = 8 where id = 155
update CallAddress set CallGroupId = 155, RouteOrderFromKh = 9 where id = 156
update CallAddress set CallGroupId = 155, RouteOrderFromKh = 10 where id =158


--156	Hoppers Crossing 3
update CallAddress set CallGroupId = 156, RouteOrderFromKh = 1 where id = 161
update CallAddress set CallGroupId = 156, RouteOrderFromKh = 2 where id = 162
update CallAddress set CallGroupId = 156, RouteOrderFromKh = 3 where id = 163
update CallAddress set CallGroupId = 156, RouteOrderFromKh = 4 where id = 160
update CallAddress set CallGroupId = 156, RouteOrderFromKh = 5 where id = 133
update CallAddress set CallGroupId = 156, RouteOrderFromKh = 6 where id = 131
update CallAddress set CallGroupId = 156, RouteOrderFromKh = 7 where id = 129
update CallAddress set CallGroupId = 156, RouteOrderFromKh = 8 where id = 130
update CallAddress set CallGroupId = 156, RouteOrderFromKh = 9 where id = 119
update CallAddress set CallGroupId = 156, RouteOrderFromKh = 10 where id =117
update CallAddress set CallGroupId = 156, RouteOrderFromKh = 11 where id =118

--157	Hoppers Crossing 4
update CallAddress set CallGroupId = 157, RouteOrderFromKh = 1 where id = 152
update CallAddress set CallGroupId = 157, RouteOrderFromKh = 2 where id = 151
update CallAddress set CallGroupId = 157, RouteOrderFromKh = 3 where id = 146
update CallAddress set CallGroupId = 157, RouteOrderFromKh = 4 where id = 148
update CallAddress set CallGroupId = 157, RouteOrderFromKh = 5 where id = 149
update CallAddress set CallGroupId = 157, RouteOrderFromKh = 6 where id = 145
update CallAddress set CallGroupId = 157, RouteOrderFromKh = 7 where id = 147
update CallAddress set CallGroupId = 157, RouteOrderFromKh = 8 where id = 121
update CallAddress set CallGroupId = 157, RouteOrderFromKh = 9 where id = 137
update CallAddress set CallGroupId = 157, RouteOrderFromKh = 10 where id =122

--158	Hoppers Crossing 5
update CallAddress set CallGroupId = 158, RouteOrderFromKh = 1 where id = 154
update CallAddress set CallGroupId = 158, RouteOrderFromKh = 2 where id = 142
update CallAddress set CallGroupId = 158, RouteOrderFromKh = 3 where id = 141
update CallAddress set CallGroupId = 158, RouteOrderFromKh = 4 where id = 144
update CallAddress set CallGroupId = 158, RouteOrderFromKh = 5 where id = 140
update CallAddress set CallGroupId = 158, RouteOrderFromKh = 6 where id = 139
update CallAddress set CallGroupId = 158, RouteOrderFromKh = 7 where id = 143
update CallAddress set CallGroupId = 158, RouteOrderFromKh = 8 where id = 134
update CallAddress set CallGroupId = 158, RouteOrderFromKh = 9 where id = 135

declare @hoppers6 int
select @hoppers6 = Id from CallGroup where CallGroupName = 'Hoppers Crossing 6'
if (@hoppers6 is null)
begin
	insert into CallGroup(CallGroupName, GroupCode, AllowAssistantToRelease)
	select 'Hoppers Crossing 6', '0165', 0

	select @hoppers6 = Id from CallGroup where CallGroupName = 'Hoppers Crossing 6'
end

update CallAddress set CallGroupId = @hoppers6, RouteOrderFromKh = 1 where id = 120
update CallAddress set CallGroupId = @hoppers6, RouteOrderFromKh = 2 where id = 1241
update CallAddress set CallGroupId = @hoppers6, RouteOrderFromKh = 3 where id = 126
update CallAddress set CallGroupId = @hoppers6, RouteOrderFromKh = 4 where id = 128
update CallAddress set CallGroupId = @hoppers6, RouteOrderFromKh = 5 where id = 123
update CallAddress set CallGroupId = @hoppers6, RouteOrderFromKh = 6 where id = 124
update CallAddress set CallGroupId = @hoppers6, RouteOrderFromKh = 7 where id = 127
update CallAddress set CallGroupId = @hoppers6, RouteOrderFromKh = 8 where id = 125
update CallAddress set CallGroupId = @hoppers6, RouteOrderFromKh = 9 where id = 138