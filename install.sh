# UTILITY FUNCTIONS
cleanFile(){
	local name=$1
  if [ -f "$name" ]
  then
  	rm -f $name
  fi
}

ping -q -w 1 -c 1 www.google.fr  > /dev/null 2>&1 && echo -e "Internet connection [\e[32mOK\e[39m]" || exit 1

# DEPENDANCIES
apt update && apt -y upgrade && apt install -y \
		apt-transport-https \
		ca-certificates \
		curl

add-apt-repository ppa:webupd8team/unstable
add-apt-repository ppa:webupd8team/java
curl -fsSL https://apt.dockerproject.org/gpg | apt-key add -
add-apt-repository \
       "deb https://apt.dockerproject.org/repo/ \
       ubuntu-$(lsb_release -cs) \
       main"

echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list

# Import the Google Chrome public key
curl https://dl.google.com/linux/linux_signing_key.pub | apt-key add -

apt update

# INSTALL GUAKE
apt install -y guake

# INSTALL GIT
apt install -y git

# INSTALL DOCKER
apt install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

apt install -y docker-engine

# INSTALL NVM
export NVM_DIR="$HOME/.nvm" && (
  git clone https://github.com/creationix/nvm.git "$NVM_DIR"
  cd "$NVM_DIR"
  git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" origin`
) && . "$NVM_DIR/nvm.sh"

nvm install node

# INSTALL atom
wget -O atom.deb https://atom.io/download/deb
dpkg -i atom.deb
apt -f install
cleanFile atom.deb

# INSTALL GOOGLE CHROME
apt install -y google-chrome-stable

# INSTALL JAVA 8
apt install -y oracle-java8-installer

# INSTALL keeweb
wget -O keeweb.deb https://github.com/keeweb/keeweb/releases/download/v1.4.0/KeeWeb-1.4.0.linux.x64.deb
dpkg -i keeweb.deb
apt -f install
cleanFile keeweb.deb

# INSTALL WEBSTORM
mkdir -p $HOME/bin
curl -sSL "https://download.jetbrains.com/webstorm/WebStorm-2016.3.3.tar.gz" | tar -v -C $HOME/bin -xz

# INSTALL GOLANG
export GO_VERSION=1.8
export GO_SRC=/usr/local/go

# purge old src
if [ -d "$GO_SRC" ]; then
	rm -rf "$GO_SRC"
fi

# subshell
(
curl -sSL "https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz" | tar -v -C /usr/local -xz
# rebuild stdlib for faster builds
chown -R "$USER" /usr/local/go/pkg
export PATH=$PATH:/usr/local/go/bin
CGO_ENABLED=0 go install -a -installsuffix cgo std
)

# INSTALL MY_DOTFILES
git clone https://github.com/xjuery/dotfiles.git ~/dotfiles
echo "" >> ~/.bashrc
echo "source ~/dotfiles/my_bashrc" >> ~/.bashrc
echo "" >> ~/.bashrc
ln -s ~/dotfiles/face.jpg ~/.face
chown xavier ~/.face

# INSTALL THEME ONLY FOR UBUNTU 16.04
sh -c "echo 'deb http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_16.04/ /' > /etc/apt/sources.list.d/arc-theme.list"
curl http://download.opensuse.org/repositories/home:Horst3180/xUbuntu_16.04/Release.key | apt-key add -
apt update && apt install arc-theme

# FINISH & CLEAN
apt autoremove
apt autoclean
apt clean
