$username = "Administrator"
$password = "Password@123"
$domain= "corp.emr.local"
$searchdn="CN=Users,DC=corp,DC=emr,DC=local"
ldifde -i -f c:/load-users-new.ldf -s $domain -b $username $domain $password | Out-File c:/log-out.txt -Append
dsmod user "CN=Hadoop Analyst1,$searchdn" -pwd Hadoop@Analyst1 -disabled no -d $domain -u $username -p $password | Out-File c:/log-out.txt -Append
dsmod user "CN=Hadoop Analyst2,$searchdn" -pwd Hadoop@Analyst2 -disabled no -d $domain -u $username -p $password | Out-File c:/log-out.txt -Append
dsmod user "CN=Hadoop Admin1,$searchdn" -pwd Hadoop@Admin1 -disabled no -d $domain -u $username -p $password | Out-File c:/log-out.txt -Append
dsmod user "CN=Bind User,$searchdn" -pwd Bind@User123 -disabled no -d $domain -u $username -p $password | Out-File c:/log-out.txt -Append