#!/bin/bash
set -euo pipefail
set -x
password=Bind@User123
password='"'$password'"'
u16pass=`printf $password|iconv -f ascii -t UTF16LE|base64`
echo "dn: CN=Bind User,CN=Users,DC=corp,DC=emr,DC=local" >ldap.ldif
echo "changetype: modify" >>ldap.ldif
echo "replace: unicodePwd" >>ldap.ldif
echo "unicodePwd:: $u16pass" >>ldap.ldif

password=Hadoop@Analyst1
password='"'$password'"'
u16pass=`printf $password|iconv -f ascii -t UTF16LE|base64`
echo "dn: CN=Hadoop Analyst1,CN=Users,DC=corp,DC=emr,DC=local" >>ldap.ldif
echo "changetype: modify" >>ldap.ldif
echo "replace: unicodePwd" >>ldap.ldif
echo "unicodePwd:: $u16pass" >>ldap.ldif

password=Hadoop@Analyst2
password='"'$password'"'
u16pass=`printf $password|iconv -f ascii -t UTF16LE|base64`
echo "dn: CN=Hadoop Analyst2,CN=Users,DC=corp,DC=emr,DC=local" >>ldap.ldif
echo "changetype: modify" >>ldap.ldif
echo "replace: unicodePwd" >>ldap.ldif
echo "unicodePwd:: $u16pass" >>ldap.ldif

password=Hadoop@Admin1
password='"'$password'"'
u16pass=`printf $password|iconv -f ascii -t UTF16LE|base64`
echo "dn: CN=Hadoop Admin1,CN=Users,DC=corp,DC=emr,DC=local" >>ldap.ldif
echo "changetype: modify" >>ldap.ldif
echo "replace: unicodePwd" >>ldap.ldif
echo "unicodePwd:: $u16pass" >>ldap.ldif

ldapmodify -v -x -D "Administrator@corp.emr.local" -w Password@123 -H ldap://10.0.3.142 -f ldap.ldif