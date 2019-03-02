################################################################################
# Post-install Initialisation script
# (Script compatible with *Ubuntu 16.04.x)
################################################################################

################################################################################
# UTILITY FUNCTIONS
cleanFile(){
	local name=$1
  if [ -f "$name" ]
  then
  	rm -f $name
  fi
}

################################################################################
# preliminary checks
ping -q -w 1 -c 1 www.google.fr  > /dev/null 2>&1 && echo -e "Internet connection [\e[32mOK\e[39m]" || exit 1

################################################################################
# DEPENDANCIES
apt update && apt -y upgrade && apt install -y \
		apt-transport-https \
		ca-certificates \
		software-properties-common \
		curl

add-apt-repository ppa:webupd8team/java

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

################################################################################
# Post Dependancies installation update
apt update

################################################################################
# APT INSTALLs
# docker
apt install -y --no-install-recommends software-properties-common
apt install -y docker-ce
groupadd docker
gpasswd -a xavier docker
service docker restart

# guake
apt install -y guake
# git
apt install -y git
# java 8
apt install -y oracle-java9-installer
# vlc
apt install -y vlc
# calibre
apt install -y calibre

################################################################################
# SPECIFIC INSTALLs
# GOLANG
export GO_VERSION=1.11.5²²
export GO_SRC=/usr/local/go

# purge old src
if [ -d "$GO_SRC" ]; then
	rm -rf "$GO_SRC"
fi

# subshell
(
curl -sSL "https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz" | tar -v -C /usr/local -xz
 rebuild stdlib for faster builds
chown -R xavier /usr/local/go/pkg
export PATH=$PATH:/usr/local/go/bin
CGO_ENABLED=0 go install -a -installsuffix cgo std
)

################################################################################
# INSTALL MY_DOTFILES
git clone https://github.com/xjuery/dotfiles.git ~/dotfiles
echo "" >> ~/.bashrc
echo "source ~/dotfiles/my_bashrc" >> ~/.bashrc
echo "" >> ~/.bashrc
ln -s ~/dotfiles/face.jpg ~/.face
chown xavier ~/.face
chown -R xavier ~/dotfiles

# Install the cron line for the upgrade count background script (used by the PS1 prompt)
line="*/1 * * * * ~/dotfiles/upgrade_count_cron.sh"
(crontab -u xavier -l; echo "$line" ) | crontab -u xavier -

################################################################################
# FINISH & CLEAN
apt autoremove
apt autoclean
apt clean

################################################################################
# POST INSTALL COMMANDS
chown -R $USER:$(id -gn $USER) /home/xavier
