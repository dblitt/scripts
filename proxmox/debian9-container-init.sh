#!/bin/sh

# Change locales to be generated
# Find '# en_US.UTF8 UTF8' and remove the pound
sed -i 's/#\ en_US.UTF-8\ UTF-8/en_US\.UTF8\ UTF8/' /etc/locale.gen

# Set default locale to en_US.UTF8
echo 'LANG=en_US.UTF-8' > /etc/default/locale

# Generate locale
locale-gen

# Update packages
apt-get update
apt-get upgrade -y

# Install vim, curl, zsh, and git
apt-get install vim curl zsh git htop sudo net-tools -y

# Modify Systemd Container Getty for root autologin
sed -i 's/ExecStart=-\/sbin\/agetty\ --noclear\ --keep-baud\ tty%I\ 115200,38400,9600\ $TERM/ExecStart=-\/sbin\/agetty\ --noclear\ --autologin\ root\ --keep-baud\ tty%I\ 115200,38400,9600\ $TERM/' /lib/systemd/system/container-getty@.service

# Modify ~/.bashrc for ls colors
sed -i 's/#\ export\ LS_OPTIONS='"'"'--color=auto'"'"'/export\ LS_OPTIONS='"'"'--color=auto'"'"'/' /root/.bashrc
sed -i 's/#\ eval\ "`dircolors`"/eval\ "`dircolors`"/' /root/.bashrc
sed -i 's/#\ alias\ ls='"'"'ls \$LS_OPTIONS'"'"'/alias\ ls='"'"'ls \$LS_OPTIONS'"'"'/' /root/.bashrc # alias ls='ls $LS_OPTIONS'
sed -i 's/#\ alias\ ll='"'"'ls \$LS_OPTIONS -l'"'"'/alias\ ll='"'"'ls \$LS_OPTIONS -l'"'"'/' /root/.bashrc
sed -i 's/#\ alias\ l='"'"'ls \$LS_OPTIONS -lA'"'"'/alias\ l='"'"'ls \$LS_OPTIONS -lA'"'"'/' /root/.bashrc

# Import Internal Root CA
mkdir /usr/share/ca-certificates/internal
echo '-----BEGIN CERTIFICATE-----
MIIGHDCCBASgAwIBAgIJANfZjmOeI8fGMA0GCSqGSIb3DQEBCwUAMIGaMQswCQYD
VQQGEwJVUzERMA8GA1UECAwITWlzc291cmkxETAPBgNVBAoMCERCbGl0dDk5MScw
JQYDVQQLDB5EQmxpdHQ5OSBDZXJ0aWZpY2F0ZSBBdXRob3JpdHkxGTAXBgNVBAMM
EERCbGl0dDk5IFJvb3QgQ0ExITAfBgkqhkiG9w0BCQEWEmRibGl0dDk5QGdtYWls
LmNvbTAeFw0xODAzMjQwMzIyMDdaFw0zODAzMTkwMzIyMDdaMIGaMQswCQYDVQQG
EwJVUzERMA8GA1UECAwITWlzc291cmkxETAPBgNVBAoMCERCbGl0dDk5MScwJQYD
VQQLDB5EQmxpdHQ5OSBDZXJ0aWZpY2F0ZSBBdXRob3JpdHkxGTAXBgNVBAMMEERC
bGl0dDk5IFJvb3QgQ0ExITAfBgkqhkiG9w0BCQEWEmRibGl0dDk5QGdtYWlsLmNv
bTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAKpzx6YIRdKTtvAaLHZR
sBJGanb/RS/eMZwSRIhGRBwZ1hkHX8Uff9XhWob2xERFmEzfo+9D76hBG+BTX+CQ
h++JuNrBLD8XIMyXdeipAfipRVjxO1jEZFARy6JeFxSyE9sLgcAenPDc0h4r5hQM
/lhSssFxNhzmLmx2UQS84rMyFsMx+zTOUUlFiyR1ZCCzDp4v77X5lwya5X/5GWIV
8A6Y+EREbQXxuvvvYgZDLtOX/9KSM+FK0y46bdW7fgRjbj+oMopsXQmnhsdm0IvJ
d+7yS90v68vbv59CPRkS8Vlcl7NUNOvLEh81b6iFbWsx1vN33msvcHQtOHbT0cw9
AKxpHAD1ntBw2/ur3gUlD9LIL2KJlqIJSPndnatAwLQxNtBLFoYJjdIC+pdNhyBE
4iABTegFD0SLd43Z+QFeXxJ5AmF9HiCMlGUJy1yS9hJAv25jrht1ZD9qiRNmbpUp
7+1XgUu1YiCAfJTiXZsojucOnHffgay+2VZ8hQLBJbfbsfnD+L1SUmstWKvvCUS4
ZRsSU2rCXFDbLm1Po3M86V5hAb04PQ5Obef8UxjLp9ZeyJPToYkJE7Dnk+3ME4FU
lur5e98emEh2gTZVI1waFrxCj0K/n1F0P5inuYwHQi9hBd12w4sShBokdVIsiBD6
yi02wHr/r696GqXjRgL8BtGrAgMBAAGjYzBhMB0GA1UdDgQWBBRhRe8bCr0cKpTc
W65V6F3MPXOs6DAfBgNVHSMEGDAWgBRhRe8bCr0cKpTcW65V6F3MPXOs6DAPBgNV
HRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBhjANBgkqhkiG9w0BAQsFAAOCAgEA
pvD+EsUZejVZZDF7cBrQ/Rm68O1Q9jq50tO4cr3ac78LVnDzoI4/lnf8kFVJYvNd
YyErXYARLcUXC4bhYZ3J9lPdieIwLyDq8mUuJarZipv9OTZMp0XLOljUkUvdBJO7
lr+mYzibWYUSFATnB4Mb27FFOyzCgq2D8nNEWOC3X+7IewynUdnw77cVaXDD1LVV
KPWItg49E4qnO9V/qCMEhFnZIYSFt6fmmQaG64zlB2le3JTAj3UJ6Mfi1gFeTruB
tOABIm1sMoZXFl4PGgy9/8EZgy1hd+MOGiuKo7h3G/vKjw27SPpns8MkR4IVyYIx
35HQpi4VeLBqAKbyQHYfNJebPn1HmIYX8SttlwniIloJnmChuQdhpqtGALAPhWvy
QRTBoTV53LHXIvPfOTlZP8Ws+vkRjusQKsJicJUVEvyD2PUbH7IUCw+4raOYbg8G
PYaRniyfnU3tqVOhQk4IIEKhnilgGz1BJAQXm9X1JBoAKS2mkUy6rHucuvO1McIu
JswvxCf43utiu1MRfUU3A51v/1q0cXIhZWoY6ItAQ/nl0eciLe9WKegcTUmoVWaM
cNe1lxlemyE4zijZLQnvTh/MiiVlgd82wmAJin1ARIkaFzwSg1trbwwFesZrg3or
RNVaGYUmh8YctN+WxYVMTpA4QSNSYCgVjbmbByMX3eU=
-----END CERTIFICATE-----' > /usr/share/ca-certificates/internal/internal-ca.crt
ln -s /usr/share/ca-certificates/internal/internal-ca.crt /usr/local/share/ca-certificates/internal-ca.crt
update-ca-certificates

# ZSH Config
git config --global user.email "dblitt99@gmail.com"
git config --global user.name "DBlitt99"

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Create dblitt99 ZSH theme
echo 'local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
PROMPT='"'"'%n@%M ${ret_status}%{$fg[cyan]%}%~%{$reset_color%} $(git_prompt_info)%{$fg_bold[blue]%}%(!.#.$)%{$reset_color%} '"'"'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"' > /root/.oh-my-zsh/themes/dblitt99.zsh-theme

# Change default theme to 'dblitt99'
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="dblitt99"/' /root/.zshrc

# Git stuff
git --git-dir /root/.oh-my-zsh/.git --work-tree /root/.oh-my-zsh add themes/dblitt99.zsh-theme
git --git-dir /root/.oh-my-zsh/.git --work-tree /root/.oh-my-zsh commit -m 'added dblitt99 theme'

# After everything is done: Shutdown
# Keep this at the end of the file
shutdown -r now
