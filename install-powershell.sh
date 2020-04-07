#!/bin/bash

# Download ans install PowerShell
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update
sudo add-apt-repository universe
sudo apt-get install -y powershell
sudo apt-get update

sudo apt-get install --yes xfce4 xrdp
sudo systemctl enable xrdp
echo xfce4-session >~/.xsession   
sudo service xrdp restart
sudo ufw allow 3389/tcp
sudo apt-get update

sudo reboot

