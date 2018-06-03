#!/bin/bash
# ad_server_ip=$1
# ad_server_domain=$2
adworkgroup="EMRSIMPLEAD"
ad_server_ip=$1
ad_server_domain=$2
ad_server_domain_upper=$(echo $ad_server_domain | awk '{print toupper($0)}')
join_user=$3
join_user_password=$4
sudo yum -y install sssd realmd krb5-workstation samba
sudo yum -y remove nscd
sudo yum -y update
sudo sh -c "echo '$ad_server_ip  AD1.$ad_server_domain_upper  $ad_server_domain_upper' >> /etc/hosts"

# sudo sh -c "echo 'domain $ad_server_domain
# search $ad_server_domain
# nameserver $ad_server_ip' > /etc/resolv.conf"

sudo sh -c "echo 'nameserver $ad_server_ip' >> /etc/resolv.conf"

sudo sh -c "echo '[logging]
 default = FILE:/var/log/krb5libs.log
 kdc = FILE:/var/log/krb5kdc.log
 admin_server = FILE:/var/log/kadmind.log

[libdefaults]
 default_realm = $ad_server_domain_upper
 dns_lookup_realm = false
 dns_lookup_kdc = false
 ticket_lifetime = 24h
 renew_lifetime = 7d
 forwardable = true

[realms]
 $ad_server_domain_upper = {
  kdc = $ad_server_ip
  admin_server = $ad_server_ip
 }


[domain_realm]
 .$ad_server_domain = $ad_server_domain_upper
 $ad_server_domain = $ad_server_domain_upper' > /etc/krb5.conf"

sudo realm leave -v emrsimplead.local
sudo realm leave -v $ad_server_domain

sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.original
sudo rm --force /etc/samba/smb.conf
sudo sh -c "echo '[global]

   netbios name = `hostname -s`
   workgroup = $adworkgroup
   security = ADS
   realm = $ad_server_domain
   encrypt passwords = yes

   idmap config *:backend = tdb
   idmap config *:range = 70001-80000
   idmap config $adworkgroup:backend = ad
   idmap config $adworkgroup:schema_mode = rfc2307
   idmap config $adworkgroup:range = 500-40000

   winbind nss info = rfc2307
   winbind trusted domains only = no
   winbind use default domain = yes
   winbind enum users  = yes
   winbind enum groups = yes

[demoshare]

   path = /srv/samba/test
   read only = no' > /etc/samba/smb.conf"
sudo echo $join_user_password | sudo realm join -U $join_user@$ad_server_domain_upper $ad_server_domain --verbose
#net ads join createupn=host/`hostname -f`@$ad_server_domain_upper -U $join_user%$join_user_password -S $ad_realm
#net ads keytab create –U $join_user -P $join_user_password
#TO check above commands
sudo klist -k -t /etc/krb5.keytab
#####SSSD Configuration
sudo service sssd stop
sudo chown root:root /etc/krb5.keytab
sudo chmod 0600 /etc/krb5.keytab
sudo restorecon /etc/krb5.keytab

sudo sh -c "echo '## Add the Domain Admins group from the example.com domain.
%Domain\ Admins@$ad_server_domain ALL=(ALL:ALL) ALL' >> /etc/sudoers"
sudo sh -c "echo '[sssd]
config_file_version = 2
services = nss, pam
domains = $ad_server_domain_upper
debug_level = 5

[nss]
debug_level = 5
override_homedir = /home/%u
default_shell = /bin/bash
reconnection_retries = 3

[pam]
debug_level = 5
reconnection_retries = 3

[domain/$ad_server_domain_upper]
ad_domain = $ad_server_domain 
krb5_realm = $ad_server_domain_upper
realmd_tags = manages-system joined-with-samba 
cache_credentials = True 
id_provider = ad 
krb5_store_password_if_offline = True 
default_shell = /bin/bash 
ldap_id_mapping = True 
use_fully_qualified_names = True 
fallback_homedir = /home/%u@%d 
access_provider = ad' > /etc/sssd/sssd.conf"

#####Modify SSSD.conf Permission
sudo chmod 0600 /etc/sssd/sssd.conf
#####Remove Existing Database
sudo rm –f /var/lib/sss/db/*
#####Start SSSD 
sudo service sssd restart
echo "AD User login on Linux Boxes..."
sudo sed -i 's/PasswordAuthentication\ no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo service sshd restart
exit 0