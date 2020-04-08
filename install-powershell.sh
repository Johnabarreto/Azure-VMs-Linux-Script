#!/bin/bash

sudo mkdir /mnt/sourcefiles
sudo mount -t cifs //pipedreamoperations.file.core.windows.net/installers /mnt/sourcefiles -o vers=3.0,username=pipedreamoperations,password=ACsK+VOj//p5p93sdtL3xVLOc4vw2TegEkeUS7uuUI04CJGH6sWtu0KRUJQ9h3p3WbgAlKoz/7VPqNIUx1CATQ==,dir_mode=0777,file_mode=0777,serverino

# Add the Microsoft package repository
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo add-apt-repository universe
sudo apt-get update

# If building an image to upload to Azure
if [[ "$(uname -r)" == *"generic" ]]; then
	#Install the Azure required packages
	sudo apt-get install --install-recommends --yes \
		linux-generic-hwe-18.04 linux-cloud-tools-generic-hwe-18.04 \
		xserver-xorg-hwe-18.04 xorgxrdp-hwe-18.04
	# Remove the floppy drive
	echo "blacklist floppy" | sudo tee /etc/modprobe.d/blacklist-floppy.conf
	sudo rmmod floppy
	sudo update-initramfs -u
fi

# Install the Pipe Dream required packages
sudo apt-get install --install-recommends --yes \
	cifs-utils \
	xfce4 \
	xrdp \
	git \
	libboost-all-dev \
	powershell

# Make sure the distribution is up-to-date and clean
sudo apt-get --yes dist-upgrade 
sudo apt-get --yes autoremove 
sudo apt-get --yes autoclean 
sudo apt-get --yes check

# Set the Enable XRDP - Required for Xilinx install
sudo systemctl enable xrdp
echo xfce4-session >~/.xsession
sudo service xrdp restart

# Create the mountpoint for the sourceiles
sudo mkdir /mnt/sourcefiles

# Create the tools directory
sudo mkdir /tools && sudo chmod a+rwx /tools

mkdir /tools/pipedream && cd /tools/pipedream
tar xvfz /mnt/sourcefiles/pipedream.tar.gz

sudo apt install --yes /mnt/sourcefiles/xrt_201920.2.5.309_18.04-amd64-xrt.deb

sudo apt install --yes /mnt/sourcefiles/xilinx-u250-xdma-201830.2-2580015_18.04.deb

sudo apt install --yes /mnt/sourcefiles/xilinx-u250-xdma-201830.2-dev-2580015_18.04.deb
sudo /opt/xilinx/xrt/bin/xrtdeps.sh

rm -rf /tmp/Xilinx_Vitis_2019.2_1106_2127

echo "======================================================================="
echo "=== Finished installation                                           ==="
echo "======================================================================="
