#
# Vagrant2Docker - Install script
#

# Set Varibles here

USE_PROXY="no"	# chenge to yes to enable proxy support
APPS="no" 	# change to yes if you want awsome apps in your virtual machine
if [ $USE_PROXY == "yes" ] ; then 
	MY_PROXY=""
	MY_PORT=""
	export HTTP_PROXY=""
	export HTTPS_PROXY=""
	export NO_PROXY=""
fi
APPS="no" # change to yes if you want awsome apps in your virtual machine

echo "BEGIN OF PROVISION SCRIPT"

if [ $USE_PROXY == "yes"] ; then
		echo 'Setup::Proxy'
		echo 'Acquire::http::proxy "http://$MY_PROXY:$MY_PORT/";' | sudo tee /etc/apt/apt.conf
		echo 'http_proxy = $MY_PROXY:$MY_PORT' | sudo tee /home/vagrant/.wgetrc
		echo 'use_proxy = on' | sudo tee -a /home/vagrant/.wgetrc
		echo 'wait = 15' | sudo tee -a /home/vagrant/.wgetrc # might be romoved
		alias curl='curl -x $MY_PROXY:$MY_PORT'
fi

echo 'Init::InstallDocker'
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
if [ $USE_PROXY == "yes" ] ; then 
	echo "Docker::Proxy"
	sudo mkdir -p /etc/systemd/system/docker.service.d
	DOCKER_PROXY_PATH=/etc/systemd/system/docker.service.d/http-proxy.conf
	sudo touch $DOCKER_PROXY_PATH
	echo "[Service]" | sudo tee -a $DOCKER_PROXY_PATH
	echo "Environment='HTTP_PROXY=http://$MY_PROXY:$MY_PROXY'" | sudo tee -a $DOCKER_PROXY_PATH
	# change to HTTPS if needed
	# echo "Environment='HTTPS_PROXY=https://$MY_PROXY:$MY_PROXY'" | sudo tee -a $DOCKER_PROXY_PATH
	sudo service docker restart
fi

echo 'Init::UserConfig'
sudo groupadd docker
sudo usermod -aG docker vagrant

if [ $APPS == "yes" ] ; then
	echo 'Install::NiceApps'
	sudo apt-get install -y ranger zsh git
	if [ $USE_PROXY == "yes" ] ; then
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
