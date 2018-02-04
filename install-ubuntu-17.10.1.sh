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

#add-apt-repository ppa:webupd8team/unstable
add-apt-repository ppa:webupd8team/java

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list

# Import the Google Chrome public key
curl https://dl.google.com/linux/linux_signing_key.pub | apt-key add -

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
# Google Chrome
apt install -y google-chrome-stable
# java 8
apt install -y oracle-java9-installer
# vlc
apt install -y vlc
# calibre
apt install -y calibre

################################################################################
# DPKG INSTALLs
# atom
wget -O atom.deb https://atom.io/download/deb
dpkg -i atom.deb
apt -f install
cleanFile atom.deb
# keeweb
wget -O keeweb.deb https://github.com/keeweb/keeweb/releases/download/v1.5.6/KeeWeb-1.5.6.linux.x64.deb
dpkg -i keeweb.deb
apt -f install
cleanFile keeweb.deb

################################################################################
# SPECIFIC INSTALLs
# NVM && NODEJS
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.5/install.sh | bash
chown -R xavier "$HOME/.nvm"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install node
# WEBSTORM
mkdir -p $HOME/bin
curl -sSL "https://download.jetbrains.com/webstorm/WebStorm-2017.2.4.tar.gz" | tar -v -C $HOME/bin -xz
chown -R xavier $HOME/bin
# GOLANG
export GO_VERSION=1.9.1
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
xfconf-query --channel xfce4-desktop --property /backdrop/screen0/monitor0/workspace0/last-image --set /home/xavier/dotfiles/wallpaper.jpg

################################################################################
# INSTALL THEME
apt install arc-theme

################################################################################
# FINISH & CLEAN
apt autoremove
apt autoclean
apt clean

################################################################################
# POST INSTALL COMMANDS
chown -R $USER:$(id -gn $USER) /home/xavier
