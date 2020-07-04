#!/bin/bash

#Installation part :

apt-get -y update
apt-get upgrade -y
apt install -y wget
apt -y install mariadb-server
apt install -y nginx
apt install -y php7.3-fpm php7.3-common php7.3-mysql php7.3-gmp php7.3-curl php7.3-intl php7.3-mbstring php7.3-xmlrpc php7.3-gd php7.3-xml php7.3-cli php7.3-zip php7.3-soap php7.3-imap

#Config Nginx :

chown -R www-data:www-data /var/www/*
chmod -R 755 /var/www/*
mkdir -p var/www/localhost
cp /tmp/localhost-conf /etc/nginx/sites-available/localhost
ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/

#Install MariaDB Database:

service mysql start
echo "CREATE DATABASE wpdb;" | mysql -u root
echo "CREATE USER 'wpuser'@'localhost' identified by 'dbpassword';" | mysql -u root
echo "GRANT ALL PRIVILEGES ON wpdb.* TO 'wpuser'@'localhost';" | mysql -u root
echo "FLUSH PRIVILEGES;" | mysql -u root

#Install WordPress

cd var/www/localhost/
wget -p https://wordpress.org/latest.tar.gz
cd wordpress.org/
tar -xf latest.tar.gz
cp -r wordpress ..
cd ..
rm -rf wordpress.org
rm wordpress/wp-config-sample.php
cd
cd ..
cp tmp/wp-config.php var/www/localhost/wordpress/

#Installation PHPMyAdmin

mkdir /var/www/localhost/phpmyadmin
cd var/www/localhost/phpmyadmin
wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-english.tar.gz
tar xzf phpMyAdmin-4.9.0.1-english.tar.gz --strip-components=1 -C /var/www/localhost/phpmyadmin
cd
cp /tmp/config.inc.php /var/www/localhost/phpmyadmin/

#Installation certif SSL

cd
cd ..
mkdir /etc/nginx/ssl
openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl/localhost.pem -keyout /etc/nginx/ssl/localhost.key -subj "/C=FR/ST=Paris/L=Paris/O=42 School/OU=fbuthod/CN=localhost"

echo "Lancement de Nginx, MySQL"

service php7.3-fpm start

nginx -g 'daemon off;'