# ServerInstall
Hello, This is Just a simple DevOps script, that will do the following:
It will stop firewalld
It will install iptables-services
It will make Iptables configuration
It will change SSH port (If changed at the beginning of the script)
It will create Motd (Banner when logged in)
It will change the timezone
It will install yum-utils
It will change hosts file and hostname
It will install httpd
It will create a virtual host in httpd
It will install sendmail
It will install PHP (depends on the version that you have entered at the beginning of the script) 
It will install additional PHP modules
It will install MySQL 5.7
It will configure MySQL 5.7
It will install pwgen
It will create a new user
It will change new website folder permissions, owner and group also for session folder

When all is done it will send you an e-mail with all the data

The fields that you can change are in the beginning:

IP=$(curl ifconfig.me) #Dont change this config is getting server IP
PORT="22" #Change SSH port to
ihost="testsite.yoursite.com" #Your website domain name
ihosts="testsite" #Server short name
email1="your_e-mail@domain.com" #Your e-mail where to send credentials when all is done
user2="testsite" #User to be created for SFTP and other purposes
pvers="72" #Desired PHP version
tzone="Europe/Riga" #Your timezone

On line 29 if you have an SSH key, then you can change this "#SSH keys to be added" with your SSH key

If you are an old fashion then Just copy the content of install.sh
on the server nano install.sh
chmod 775 install.sh
./install.sh

or you can <this will be updated part>
  
For more tutorials visit: https://valters.eu/category/blog/
For more scripts use: https://github.com/jvalters
For docker containers: https://hub.docker.com/u/j90w


That's basically all this script will save your time and if you have multiple servers to configure for web hosting including VPS then also it will save a lot of time :)
