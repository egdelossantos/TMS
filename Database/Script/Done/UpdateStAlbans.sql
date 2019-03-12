update CallAddress set SuburbId = 49,CallGroupId = null, RouteOrderFromKh = null where Id = 1202 --kingpark
delete from CallActivityAddress where CallAddressId = 1202
delete from CallAddress where id = 1202

--Albanvale
-- make CallGroup Id identity
update CallAddress set SuburbId = 2,CallGroupId = null, RouteOrderFromKh = null where Id in (928,929,930,931,932,921,922,
923,
924,
925,
926) 

update CallAddress set CallGroupId = 32, RouteOrderFromKh = 1 where id = 1209
update CallAddress set CallGroupId = 32, RouteOrderFromKh = 2 where id = 921
update CallAddress set CallGroupId = 32, RouteOrderFromKh = 3 where id = 621
update CallAddress set CallGroupId = 32, RouteOrderFromKh = 4 where id = 620
update CallAddress set CallGroupId = 32, RouteOrderFromKh = 5 where id = 619
update CallAddress set CallGroupId = 32, RouteOrderFromKh = 6 where id = 597
update CallAddress set CallGroupId = 32, RouteOrderFromKh = 7 where id = 610
update CallAddress set CallGroupId = 32, RouteOrderFromKh = 8 where id = 613
update CallAddress set CallGroupId = 32, RouteOrderFromKh = 9 where id = 612
update CallAddress set CallGroupId = 32, RouteOrderFromKh = 10 where id =614
update CallAddress set CallGroupId = 32, RouteOrderFromKh = 11 where id =611

declare @albanvale4 int
select @albanvale4 = Id from CallGroup where CallGroupName = 'Albanvale 4'
if (@albanvale4 is null)
begin
	insert into CallGroup(CallGroupName, GroupCode, AllowAssistantToRelease)
	select 'Albanvale 4', '0164', 0

	select @albanvale4 = Id from CallGroup where CallGroupName = 'Albanvale 4'
end

update CallAddress set CallGroupId = @albanvale4, RouteOrderFromKh = 1 where id = 932
update CallAddress set CallGroupId = @albanvale4, RouteOrderFromKh = 2 where id = 928
update CallAddress set CallGroupId = @albanvale4, RouteOrderFromKh = 3 where id = 929
update CallAddress set CallGroupId = @albanvale4, RouteOrderFromKh = 4 where id = 930
update CallAddress set CallGroupId = @albanvale4, RouteOrderFromKh = 5 where id = 931
update CallAddress set CallGroupId = @albanvale4, RouteOrderFromKh = 6 where id = 925
update CallAddress set CallGroupId = @albanvale4, RouteOrderFromKh = 7 where id = 924
update CallAddress set CallGroupId = @albanvale4, RouteOrderFromKh = 8 where id = 923
update CallAddress set CallGroupId = @albanvale4, RouteOrderFromKh = 9 where id = 922
update CallAddress set CallGroupId = @albanvale4, RouteOrderFromKh = 10 where id =926

--st albans

update CallAddress set CallGroupId = null, RouteOrderFromKh = null where suburbid = 69

-- 161	St Albans 1
update CallAddress set CallGroupId = 161, RouteOrderFromKh = 1 where id = 896
update CallAddress set CallGroupId = 161, RouteOrderFromKh = 2 where id = 897
update CallAddress set CallGroupId = 161, RouteOrderFromKh = 3 where id = 894
update CallAddress set CallGroupId = 161, RouteOrderFromKh = 4 where id = 889
update CallAddress set CallGroupId = 161, RouteOrderFromKh = 5 where id = 893
update CallAddress set CallGroupId = 161, RouteOrderFromKh = 6 where id = 895
update CallAddress set CallGroupId = 161, RouteOrderFromKh = 7 where id = 888
update CallAddress set CallGroupId = 161, RouteOrderFromKh = 8 where id = 886
update CallAddress set CallGroupId = 161, RouteOrderFromKh = 9 where id = 887
update CallAddress set CallGroupId = 161, RouteOrderFromKh = 10 where id = 885

-- 162	St Albans 2
update CallAddress set CallGroupId = 162, RouteOrderFromKh = 1 where id = 941
update CallAddress set CallGroupId = 162, RouteOrderFromKh = 2 where id = 942
update CallAddress set CallGroupId = 162, RouteOrderFromKh = 3 where id = 933
update CallAddress set CallGroupId = 162, RouteOrderFromKh = 4 where id = 934
update CallAddress set CallGroupId = 162, RouteOrderFromKh = 5 where id = 935
update CallAddress set CallGroupId = 162, RouteOrderFromKh = 6 where id = 936
update CallAddress set CallGroupId = 162, RouteOrderFromKh = 7 where id = 937
update CallAddress set CallGroupId = 162, RouteOrderFromKh = 8 where id = 890
update CallAddress set CallGroupId = 162, RouteOrderFromKh = 9 where id = 891
update CallAddress set CallGroupId = 162, RouteOrderFromKh = 10 where id = 892
update CallAddress set CallGroupId = 162, RouteOrderFromKh = 11 where id = 927

--163	St Albans 3
update CallAddress set CallGroupId = 163, RouteOrderFromKh = 1 where id = 938
update CallAddress set CallGroupId = 163, RouteOrderFromKh = 2 where id = 939
update CallAddress set CallGroupId = 163, RouteOrderFromKh = 3 where id = 940
update CallAddress set CallGroupId = 163, RouteOrderFromKh = 4 where id = 943
update CallAddress set CallGroupId = 163, RouteOrderFromKh = 5 where id = 974
update CallAddress set CallGroupId = 163, RouteOrderFromKh = 6 where id = 973
update CallAddress set CallGroupId = 163, RouteOrderFromKh = 7 where id = 1201
update CallAddress set CallGroupId = 163, RouteOrderFromKh = 8 where id = 962
update CallAddress set CallGroupId = 163, RouteOrderFromKh = 9 where id = 972
update CallAddress set CallGroupId = 163, RouteOrderFromKh = 10 where id = 971

--164	St Albans 4
update CallAddress set CallGroupId = 164, RouteOrderFromKh = 1 where id = 961
update CallAddress set CallGroupId = 164, RouteOrderFromKh = 2 where id = 975
update CallAddress set CallGroupId = 164, RouteOrderFromKh = 3 where id = 967
update CallAddress set CallGroupId = 164, RouteOrderFromKh = 4 where id = 963
update CallAddress set CallGroupId = 164, RouteOrderFromKh = 5 where id = 964
update CallAddress set CallGroupId = 164, RouteOrderFromKh = 6 where id = 968
update CallAddress set CallGroupId = 164, RouteOrderFromKh = 7 where id = 969
update CallAddress set CallGroupId = 164, RouteOrderFromKh = 8 where id = 970
update CallAddress set CallGroupId = 164, RouteOrderFromKh = 9 where id = 965
update CallAddress set CallGroupId = 164, RouteOrderFromKh = 10 where id = 966

--166	St Albans 5
update CallAddress set CallGroupId = 166, RouteOrderFromKh = 1 where id = 945
update CallAddress set CallGroupId = 166, RouteOrderFromKh = 2 where id = 949
update CallAddress set CallGroupId = 166, RouteOrderFromKh = 3 where id = 950
update CallAddress set CallGroupId = 166, RouteOrderFromKh = 4 where id = 952
update CallAddress set CallGroupId = 166, RouteOrderFromKh = 5 where id = 954
update CallAddress set CallGroupId = 166, RouteOrderFromKh = 6 where id = 955
update CallAddress set CallGroupId = 166, RouteOrderFromKh = 7 where id = 946
update CallAddress set CallGroupId = 166, RouteOrderFromKh = 8 where id = 947
update CallAddress set CallGroupId = 166, RouteOrderFromKh = 9 where id = 951
update CallAddress set CallGroupId = 166, RouteOrderFromKh = 10 where id = 953
update CallAddress set CallGroupId = 166, RouteOrderFromKh = 11 where id = 948

--167	St Albans 6
update CallAddress set CallGroupId = 167, RouteOrderFromKh = 1 where id = 999
update CallAddress set CallGroupId = 167, RouteOrderFromKh = 2 where id = 1000
update CallAddress set CallGroupId = 167, RouteOrderFromKh = 3 where id = 1004
update CallAddress set CallGroupId = 167, RouteOrderFromKh = 4 where id = 1003
update CallAddress set CallGroupId = 167, RouteOrderFromKh = 5 where id = 1005
update CallAddress set CallGroupId = 167, RouteOrderFromKh = 6 where id = 985
update CallAddress set CallGroupId = 167, RouteOrderFromKh = 7 where id = 984
update CallAddress set CallGroupId = 167, RouteOrderFromKh = 8 where id = 996
update CallAddress set CallGroupId = 167, RouteOrderFromKh = 9 where id = 1001
update CallAddress set CallGroupId = 167, RouteOrderFromKh = 10 where id = 1002
update CallAddress set CallGroupId = 167, RouteOrderFromKh = 11 where id = 1008
update CallAddress set CallGroupId = 167, RouteOrderFromKh = 12 where id = 944

--168	St Albans 7
update CallAddress set CallGroupId = 168, RouteOrderFromKh = 1 where id = 994
update CallAddress set CallGroupId = 168, RouteOrderFromKh = 2 where id = 1007
update CallAddress set CallGroupId = 168, RouteOrderFromKh = 3 where id = 1006
update CallAddress set CallGroupId = 168, RouteOrderFromKh = 4 where id = 976
update CallAddress set CallGroupId = 168, RouteOrderFromKh = 5 where id = 992
update CallAddress set CallGroupId = 168, RouteOrderFromKh = 6 where id = 983
update CallAddress set CallGroupId = 168, RouteOrderFromKh = 7 where id = 993
update CallAddress set CallGroupId = 168, RouteOrderFromKh = 8 where id = 995
update CallAddress set CallGroupId = 168, RouteOrderFromKh = 9 where id = 997
update CallAddress set CallGroupId = 168, RouteOrderFromKh = 10 where id = 991
update CallAddress set CallGroupId = 168, RouteOrderFromKh = 11 where id = 990

--169	St Albans 8
update CallAddress set CallGroupId = 169, RouteOrderFromKh = 1 where id = 986
update CallAddress set CallGroupId = 169, RouteOrderFromKh = 2 where id = 987
update CallAddress set CallGroupId = 169, RouteOrderFromKh = 3 where id = 988
update CallAddress set CallGroupId = 169, RouteOrderFromKh = 4 where id = 989
update CallAddress set CallGroupId = 169, RouteOrderFromKh = 5 where id = 998
update CallAddress set CallGroupId = 169, RouteOrderFromKh = 6 where id = 978
update CallAddress set CallGroupId = 169, RouteOrderFromKh = 7 where id = 977
update CallAddress set CallGroupId = 169, RouteOrderFromKh = 8 where id = 979
update CallAddress set CallGroupId = 169, RouteOrderFromKh = 9 where id = 980
update CallAddress set CallGroupId = 169, RouteOrderFromKh = 10 where id = 981
update CallAddress set CallGroupId = 169, RouteOrderFromKh = 11 where id = 982

--170	St Albans 9
update CallAddress set CallGroupId = 170, RouteOrderFromKh = 1 where id = 958
update CallAddress set CallGroupId = 170, RouteOrderFromKh = 2 where id = 959
update CallAddress set CallGroupId = 170, RouteOrderFromKh = 3 where id = 956
update CallAddress set CallGroupId = 170, RouteOrderFromKh = 4 where id = 957
update CallAddress set CallGroupId = 170, RouteOrderFromKh = 5 where id = 960
update CallAddress set CallGroupId = 170, RouteOrderFromKh = 6 where id = 898
update CallAddress set CallGroupId = 170, RouteOrderFromKh = 7 where id = 899
update CallAddress set CallGroupId = 170, RouteOrderFromKh = 8 where id = 901
update CallAddress set CallGroupId = 170, RouteOrderFromKh = 9 where id = 902
update CallAddress set CallGroupId = 170, RouteOrderFromKh = 10 where id = 900

--171	St Albans 10
update CallAddress set CallGroupId = 171, RouteOrderFromKh = 1 where id = 920
update CallAddress set CallGroupId = 171, RouteOrderFromKh = 2 where id = 913
update CallAddress set CallGroupId = 171, RouteOrderFromKh = 3 where id = 912
update CallAddress set CallGroupId = 171, RouteOrderFromKh = 4 where id = 914
update CallAddress set CallGroupId = 171, RouteOrderFromKh = 5 where id = 903
update CallAddress set CallGroupId = 171, RouteOrderFromKh = 6 where id = 904
update CallAddress set CallGroupId = 171, RouteOrderFromKh = 7 where id = 905
update CallAddress set CallGroupId = 171, RouteOrderFromKh = 8 where id = 906
update CallAddress set CallGroupId = 171, RouteOrderFromKh = 9 where id = 907

--172	St Albans 11
update CallAddress set CallGroupId = 172, RouteOrderFromKh = 1 where id = 911
update CallAddress set CallGroupId = 172, RouteOrderFromKh = 2 where id = 919
update CallAddress set CallGroupId = 172, RouteOrderFromKh = 3 where id = 917
update CallAddress set CallGroupId = 172, RouteOrderFromKh = 4 where id = 918
update CallAddress set CallGroupId = 172, RouteOrderFromKh = 5 where id = 910
update CallAddress set CallGroupId = 172, RouteOrderFromKh = 6 where id = 908
update CallAddress set CallGroupId = 172, RouteOrderFromKh = 7 where id = 909
update CallAddress set CallGroupId = 172, RouteOrderFromKh = 8 where id = 916
update CallAddress set CallGroupId = 172, RouteOrderFromKh = 9 where id = 915













