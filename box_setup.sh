#
# Vagrant2Docker - Install script
#

# Set Varibles here

USE_PROXY="no"	# chenge to yes to enable proxy support
APPS="no" 	# change to yes if you want awsome apps in your virtual machine
if [ $USE_PROXY == "yes" ] ; then 
	MY_PROXY=""
	MY_PORT=""
fi
APPS="no" # change to yes if you want awsome apps in your virtual machine

echo "BEGIN OF PROVISION SCRIPT"

echo 'Setup - Proxy (if needed)'
if [ $USE_PROXY == "yes"] ; then
		echo 'Acquire::http::proxy "http://$MY_PROXY:$MY_PORT/";' | sudo tee /etc/apt/apt.conf
		echo 'http_proxy = $MY_PROXY:$MY_PORT' | sudo tee /home/vagrant/.wgetrc
		echo 'use_proxy = on' | sudo tee -a /home/vagrant/.wgetrc
		echo 'wait = 15' | sudo tee -a /home/vagrant/.wgetrc # might be romoved
		alias curl='curl -x $MY_PROXY:$MY_PORT'
fi

echo 'Init - install docker'
# If you are running a xenial(ubuntu 16.04) you may have a nework problem.
# You should prefer trusty (ubuntu 14.04) instead !

# Xenial
# sudo wget https://download.docker.com/linux/ubuntu/dists/xenial/stable/binary-amd64/docker-ce_17.06.0~ce-0~ubuntu_amd64.deb -P /tmp/
# sudo dpkg -i /tmp/docker-ce_17.06.0~ce-0~ubuntu_amd64.deb

# Trusty
# With Trusty you need some other stuff like
sudo apt-get update
sudo apt-get install -y linux-image-extra-$(uname -r) linux-image-extra-virtual libsystemd-journal0
wget https://download.docker.com/linux/ubuntu/dists/trusty/pool/stable/amd64/docker-ce_17.06.0~ce-0~ubuntu_amd64.deb -P /tmp/
sudo dpkg -i /tmp/docker-ce_17.06.0~ce-0~ubuntu_amd64.deb

echo 'Init - User Config'
sudo groupadd docker
sudo usermod -aG docker vagrant

if [ $APPS == "yes" ] ; then
	echo 'Install - nice apps'
	sudo apt-get install -y ranger zsh git
	if [ USE_PROXY == "yes" ] ; then
		sudo git config --global http.proxy http://$MY_PROXY:$MY_PORT
	fi
	sudo git clone git://github.com/robbyrussell/oh-my-zsh.git /home/vagrant/.oh-my-zsh
	echo 'Writing in .zshrc file'
	echo "export ZSH=/home/vagrant/.oh-my-zsh" | sudo tee  .zshrc
	echo 'ZSH_THEME="af-magic"' | sudo tee -a .zshrc
	echo "plugins=(git, docker)" | sudo tee -a .zshrc
	echo 'source $ZSH/oh-my-zsh.sh' | sudo tee -a .zshrc
fi

echo "END OF PROVISION SCRIPT"
