#!/bin/bash
sudo apt update -y
sudo apt install apache2 -y

myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`

cat <<EOF > /var/www/html/index.html
<html>
<h2>Build by Power of Terraform <font color ="red">v.1.15</font></h2><br>
Owner ${f_name} ${l_name} <br>
%{ for x in names ~}
Hello to ${x} from ${f_name}
%{ endfor ~}

</html>
EOF
sudo echo "web server with $privateIP" > /var/www/html/index.html
sudo service apache2 start
chkconfig apache2 on