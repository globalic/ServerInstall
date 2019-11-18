# ServerInstall<br>
Hello, This is Just a simple DevOps script, that will do the following:<br>
It will stop firewalld<br>
It will install iptables-services<br>
It will make Iptables configuration<br>
It will change SSH port (If changed at the beginning of the script)<br>
It will create Motd (Banner when logged in)<br>
It will change the timezone<br>
It will install yum-utils<br>
It will change hosts file and hostname<br>
It will install httpd<br>
It will create a virtual host in httpd<br>
It will install sendmail<br>
It will install PHP (depends on the version that you have entered at the beginning of the script) <br>
It will install additional PHP modules<br>
It will install MySQL 5.7<br>
It will configure MySQL 5.7<br>
It will install pwgen<br>
It will create a new user<br>
It will change new website folder permissions, owner and group also for session folder<br>

When all is done it will send you an e-mail with all the data

The fields that you can change are in the beginning:
<br>
IP=$(curl ifconfig.me) #Dont change this config is getting server IP<br>
PORT="22" #Change SSH port to<br>
ihost="testsite.yoursite.com" #Your website domain name<br>
ihosts="testsite" #Server short name<br>
email1="your_e-mail@domain.com" #Your e-mail where to send credentials when all is done<br>
user2="testsite" #User to be created for SFTP and other purposes<br>
pvers="72" #Desired PHP version<br>
tzone="Europe/Riga" #Your timezone<br>

On line 29 if you have an SSH key, then you can change this "#SSH keys to be added" with your SSH key
<br>
If you are an old fashion then Just copy the content of install.sh<br>
on the server nano install.sh<br>
chmod 775 install.sh<br>
./install.sh<br>

or you can <this will be updated part>
  
For more tutorials visit: https://valters.eu/category/blog/<br>
For more scripts use: https://github.com/jvalters<br>
For docker containers: https://hub.docker.com/u/j90w<br>


That's basically all this script will save your time and if you have multiple servers to configure for web hosting including VPS then also it will save a lot of time :)
