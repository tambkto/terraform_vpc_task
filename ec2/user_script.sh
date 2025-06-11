#!/bin/bash

DB_NAME="wordpress_db"            
DB_USER="umar"            
DB_PASSWORD="9867awsways@29"      
WORDPRESS_DIR="/var/www/html"     

apt update -y
apt install expect -y
apt install -y apache2
systemctl start apache2
systemctl enable apache2
rm -f ${WORDPRESS_DIR}/index.html
apt install -y php php-mysql php-curl php-gd php-mbstring php-xml php-zip php-intl php-bcmath php-json php-fpm php-imap php-common
apt install -y mysql-server
systemctl start mysql
systemctl enable mysql
echo "Securing MySQL installation..."
expect - <<EOF
spawn mysql_secure_installation
expect "Press y|Y for Yes, any other key for No:"
send "n\r"
expect "New password:"
send "$DB_PASSWORD\r"
expect "Re-enter new password:"
send "$DB_PASSWORD\r"
expect "Remove anonymous users?"
send "y\r"
expect "Disallow root login remotely?"
send "y\r"
expect "Remove test database and access to it?"
send "y\r"
expect "Reload privilege tables now?"
send "y\r"
expect eof
EOF
echo "MySQL installation secured."
cd /tmp
apt install -y unzip wget
wget https://wordpress.org/latest.zip
unzip latest.zip
cp -r wordpress/* ${WORDPRESS_DIR}/
chown -R www-data:www-data ${WORDPRESS_DIR}
mysql -u root -p$DB_PASSWORD -e "CREATE DATABASE $DB_NAME;"
mysql -u root -p$DB_PASSWORD -e "CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';"
mysql -u root -p$DB_PASSWORD -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"
mysql -u root -p$DB_PASSWORD -e "FLUSH PRIVILEGES;"
cd ${WORDPRESS_DIR}
cp wp-config-sample.php wp-config.php
sed -i "s/database_name_here/$DB_NAME/" wp-config.php
sed -i "s/username_here/$DB_USER/" wp-config.php
sed -i "s/password_here/$DB_PASSWORD/" wp-config.php
sed -i "s/localhost/localhost/" wp-config.php
find ${WORDPRESS_DIR} -type d -exec chmod 755 {} \;
find ${WORDPRESS_DIR} -type f -exec chmod 644 {} \;
a2enmod rewrite
a2dissite 000-default.conf
cat > /etc/apache2/sites-available/000-default.conf << 'EOF'
<VirtualHost *:80>
    DocumentRoot /var/www/html
    <Directory /var/www/html>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF
a2ensite 000-default.conf
systemctl restart apache2
rm -rf /tmp/wordpress /tmp/latest.zip
