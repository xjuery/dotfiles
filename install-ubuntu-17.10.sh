################################################################################
# Post-install Initialisation script
# (Script compatible with *Ubuntu 17.04.x)
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
		curl

echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list

# Import the Google Chrome public key
curl https://dl.google.com/linux/linux_signing_key.pub | apt-key add -

################################################################################
# Post Dependancies installation update
apt update

################################################################################
# APT INSTALLs
# prerequisites
apt install -y --no-install-recommends software-properties-common

# guake and others
apt install -y guake git google-chrome-stable openjdk-9-jdk vlc calibre gparted

################################################################################
# DPKG INSTALLs
# atom
wget -O atom.deb https://atom.io/download/deb
dpkg -i atom.deb
#apt -f install
cleanFile atom.deb

################################################################################
# SPECIFIC INSTALLs
mkdir -p $HOME/bin

# gdrive
wget -O $HOME/bin/gdrive https://docs.google.com/uc?id=0B3X9GlR6EmbnQ0FtZmJJUXEyRTA&export=download
chmod +x $HOME/bin/gdrive

# NVM && NODEJS
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install node

# YARN (NODEJS)
curl -o- -L https://yarnpkg.com/install.sh | bash

# RUBY
git clone https://github.com/rbenv/rbenv.git $HOME/.rbenv
mkdir -p $HOME/.rbenv/plugins
git clone https://github.com/rbenv/ruby-build.git $HOME/.rbenv/plugins/ruby-build

# GOLANG
export GO_VERSION=1.9.2
export GO_SRC=/usr/local/go

# purge old src
if [ -d "$GO_SRC" ]; then
	rm -rf "$GO_SRC"
fi

# subshell
(
curl -sSL "https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz" | tar -v -C /usr/local -xz
# rebuild stdlib for faster builds
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
chown -R xavier:$(id -gn xavier) /home/xavier
apt autoremove
apt autoclean
apt clean
