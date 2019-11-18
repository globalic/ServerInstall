########################################################################
###                                                                  ###
###          Writen by Janis Valters                                 ###
###  Website: https://www.valters.eu                                 ###
###  GITHUB:  https://github.com/jvalters/                           ###
###                                                                  ###
###                                                                  ###
###         Tested on Centos 7                                       ###
########################################################################


#Need to test httpd write and other things using some CMS.
#Need to cleanUP the scripts

#!/bin/bash
IP=$(curl ifconfig.me) #Dont change this config is getting server IP
PORT="22" #Change SSH port to
ihost="testsite.yoursite.com" #Your website domain name
ihosts="testsite" #Server short name
email1="your_e-mail@domain.com" #Your e-mail where to send credentials when all is done
user2="testsite" #User to be created for SFTP and other purposes
pvers="72" #Desired PHP version
tzone="Europe/Riga" #Your timezone



# Add admins ssh public keys
mkdir -p /root/.ssh/
echo "#SSH keys to be added" > /root/.ssh/authorized_keys
chmod 700 /root/.ssh/
chmod 400 /root/.ssh/authorized_keys
# End of addmin authorized_keys

# Stop of IPtables
sudo systemctl stop firewalld
sudo systemctl disable firewalld
# END of Stop IPtables

# Start of nano installation
yum -y install nano
# END of nano installation

# Start of IPtables
yum install -y iptables-services

echo "########################################################################
###                                                                  ###
###  Auto configuration writen by Janis Valters                      ###
###  Website: https://www.valters.eu                                 ###
###  GITHUB:  https://github.com/jvalters/                           ###
###                                                                  ###
###                                                                  ###
###         Tested on Centos 7                                       ###
########################################################################
# sample configuration for iptables service
# you can edit this manually or use system-config-firewall
# please do not ask us to add additional ports/services to this default configuration
*filter
:INPUT DROP [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 1990 -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 443 -j ACCEPT
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
COMMIT" > /etc/sysconfig/iptables

systemctl enable iptables
systemctl restart iptables
# END of IPtables

# Start of port change of SSH
sed -i 's|#Port 22|Port '$PORT'|' /etc/ssh/sshd_config
systemctl restart sshd
# END of port change of SSH

#Start of motd
echo "
IT services for your company" > /etc/motd
#End of motd

#Set timezone to Europe/Riga
timedatectl set-timezone $tzone
#End of timezone settings

#Install pwgen & yum-utils starts
yum -y install httpd http://li.nux.ro/download/nux/misc/el7/x86_64//mod_rpaf-0.8.4-1.el7.nux.x86_64.rpm
sleep 10
yum -y install yum-utils
sleep 10
#Install pwgen & yum-utils ends


#Do changes into hosts and Hostname
echo -e "127.0.0.1 localhost.localdomain localhost \n::1 localhost6.localdomain6 localhost6 \n$iip $ihost $ihostss" > /etc/hosts
echo -e "$ihost "> /etc/hostname
#End of changes into hosts and Hostname

#Start of httpd configuration
mkdir /etc/httpd/vhosts
mkdir /var/www/$ihost/


echo "<VirtualHost *:80>

    DocumentRoot /var/www/$ihost/

    RewriteEngine On

    ServerName $ihost
    DirectoryIndex index.html index.php
    ErrorLog /var/log/httpd/"$ihost"_apache_error.log
    CustomLog /var/log/httpd/"$ihost"_apache_access.log combined

<Directory "/var/www/"$ihost"/">
    Options FollowSymLinks MultiViews
    AllowOverride All
    Order allow,deny
    Allow from all
</Directory>

</VirtualHost>" > /etc/httpd/vhosts/$ihost.conf

echo "$ihost is hosted by $ihosts" > /var/www/$ihost/index.php
echo "IncludeOptional vhosts/*.conf" >> /etc/httpd/conf/httpd.conf

systemctl restart httpd
sleep 10
#End of httpd configuration

#Start of sendmail installation
yum install -y sendmail
sleep 10
systemctl start sendmail
# End of sendmail installation

#Start of installing httpd
yum install -y httpd mod_ssl
sleep 10
systemctl start httpd
systemctl enable httpd
#End of installing httpd

#Start of installing PHP
yum -y install epel-release
sleep 10
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sleep 10
yum install -y yum-utils
sleep 10
wget http://rpms.remirepo.net/enterprise/remi-release-7.rpm
sleep 10
rpm -Uvh remi-release-7.rpm epel-release-latest-7.noarch.rpm
sleep 10
yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum-config-manager --enable remi-php$pvers
yum -y install php php-pecl-zip php-devel php-gd php-snmp php-xmlrpc php-xml php$pvers-php-gd php$pvers-php-json php$pvers-php-mbstring php$pvers-php-mysqlnd php$pvers-php-xml php$pvers-php-xmlrpc php$pvers-php-opcache php-mysql

systemctl restart httpd
#End of installing httpd

#Start of MySQL install

#Add the new MySQL repository to the CentOS 7 server with this yum command.
yum -y localinstall https://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm

#Install MySQL 5.7
yum -y install mysql-community-server

#Start MySQL and Enable Start at Boot Time
systemctl start mysqld
systemctl enable mysqld

#Configure the MySQL Root Password and delte log file
MySQL=$(grep 'root@localhost:' '{print $2}' /var/log/mysqld.log)
#rm -rf /var/log/mysqld.log
#nano /var/log/mysqld.log > test

systemctl restart mysqld

#End of MySQL install

#Generate passwords starts
yum -y install https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
sleep 5
yum -y install pwgen
sleep 10
mkdir /admins_dir/
echo -e "sftp:`pwgen 18 -1`" >/admins_dir/secret
SFTP_PASS=$(awk -F: /^sftp/'{print $2}' /admins_dir/secret)
#Gnerate passwords ends

#add user for httpd starts
adduser $user2
echo -e "${SFTP_PASS}\n${SFTP_PASS}" | passwd $user2
usermod -a -G apache $user2
#add user for httpd ends


#CHOWN httpd and session folder starts
chown -R $user2:$user2 /var/www/$ihost
chown -R root:$user2 /var/lib/php/session
ln -s /var/www/$ihost/ /home/$user2/$ihost

#CHOWN httpd and session folder ends


#Start of send e-mail when all done
echo -e "Subject: $ihosts  installation finished `date +%d.%m.%y\ \%H:%M`"\ "\n Your $ihosts installation is finished. \n\n Your IP is: $IP \n SSH port = $PORT \n username = $user2 \n Password = ${SFTP_PASS} \n\n\n your MySQL password = $MySQL \n\n Thank you" | sudo sendmail -F " $ihosts installation finished" -f "yourdomain@yourdomain.com" -t  $email1
#END of send e-mail when all done
