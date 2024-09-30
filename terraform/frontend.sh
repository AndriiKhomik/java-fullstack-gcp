#!/bin/bash
echo "*****    Installing Nginx    *****"
sudo apt update -y
sudo apt install -y nginx 
sudo apt install -y certbot 
sudo apt install -y python3-certbot-nginx

# Configure firewall and system limits
sudo ufw --force enable
sudo ufw allow "Nginx Full"
sudo ufw allow 22
sudo sh -c "echo 'shilvy soft nofile 30000' >> /etc/security/limits.conf"
sudo sh -c "echo 'shilvy hard nofile 30000' >> /etc/security/limits.conf"
sysctl -p
sudo sh -c "echo 'worker_rlimit_nofile 40000;' >> /etc/nginx/nginx.conf"
sudo sed -i 's/worker_connections 768;/worker_connections 20000;/g' /etc/nginx/nginx.conf
sudo service nginx restart
Set correct ownership for the Nginx root folder
sudo chown -R $USER:$USER /var/www/

# Copy the React build to Nginx HTML directory
sudo rm -rf /var/www/html/*
# sudo cp -r build/* /var/www/html/