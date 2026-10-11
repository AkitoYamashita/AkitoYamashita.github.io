# utils.sh

```bash
#!/bin/bash
alignleft(){ printf "%-${COLUMNS}s\n" $1; }
alignright(){ printf "%${COLUMNS}s\n" $1; }
# aligncenter(){ printf "%*s\n" $(((${#msg}+$COLUMNS)/2)) "$1"; }
# aligncenter(){ c=$(tput cols); m=$1; l=$(printf %s "$m"|wc -c); printf "%*s\n" $(((c+l)/2)) "$m"; }
aligns(){ printf "$1%*.*s$2\n" 0 $(( $COLUMNS - ${#1} - ${#2} )) "$(hr)"; }
keyval(){ printf "$1%*.*s$2\n" 0 $(( $COLUMNS / 2  - ${#1} )) "$(hr)"; }
ask(){
  while true; do
    echo -n "$* (y/n): "; read ANS; case $ANS in
      [Yy]*) return 0;;
      [Nn]*) return 1;;
      *) echo "Please (y/n)";;
    esac
  done
}
symbolic(){
  TARGET=$1
  DIR=$2
  cd $TARGET
  if [ -d $DIR ]; then
    echo "found $DIR"
  else
    echo "not found $DIR"
    sudo ln -s $TARGET $DIR
  fi
}
chmodparentdir(){
sudo chmod 777 $(cd $(dirname $0); pwd) -f
}
chmodcurrentfile(){
sudo chmod 700 ${0##*/}
}
fx(){ 
  sudo wget $1 && sudo chmod +x ${1##*/} && sudo ./${1##*/}
}
shutdownlater(){
  sudo shutdown -h +300
}
rundir(){
  echo $(cd $(dirname $(readlink $0 || echo $0));pwd)
}
fromdir(){
  echo $(cd $(dirname $BASH_SOURCE); pwd)
}
getenvroiment(){
	printenv
}
download(){
  if [ ! -e ${1##*/} ]; then
    wget $1 --trust-server-names --no-check-certificate -O ./${1##*/}
  fi
}
#chmod 600 .ssh/authorized_keys
sshkeygen(){
ssh-keygen -t rsa -b 4096 -C ""
}
nginxandphpfpm(){
  d_start(){
    sudo /etc/init.d/nginx   start
    sudo /etc/init.d/php-fpm start
    #sudo /etc/init.d/fcgiwrap start
  }
  d_stop(){
    sudo /etc/init.d/nginx stop
    sudo /etc/init.d/php-fpm stop
    #sudo /etc/init.d/fcgiwrap stop
  }
  case "$1" in
    start)
      d_start
      xdg-open http://localhost/
    ;;
    restart)
      d_stop
      sleep 2
      d_start
    ;;
    stop)
      d_stop
    ;;
    kill)
      sudo killall -KILL nginx
      sudo killall -KILL php-fpm
      #sudo killall -KILL fcgiwrap
    ;;
  esac
}
browse(){
  (sleep 2s; xdg-open $1) &
}
chmod-r(){
  if [ $# -ne 3 ]; then
    echo "Require [f/d],[Permission],[path] "
  else
    sudo find $3 -type $1 -exec sudo chmod $2 {} +
  fi
}
devcopy(){
sudo df
echo "Ex) dd if=/dev/sr0 of=/root/dev.iso"
echo "if path:"
read DDIF
echo "of path:"
read DDOF
sudo dd if=$DDIF of=$DDOF
}
launch-maya(){
	sudo /usr/autodesk/maya2016/bin/maya
}
launch-unity(){
	LD_PRELOAD=/lib/x86_64-linux-gnu/libresolv.so.2 /opt/Unity/Editor/Unity
}
getZipRootDirectoryName(){
  unzip -qql $1 | head -n1 | tr -s ' ' | cut -d' ' -f5- | rev | cut -c 2- | rev
}
togif(){
  if [ $# -ne 1 ]; then
    echo "Require [Filename]"
  else
    ffmpeg -i "$1" -an -r 24 "$(pwd)/${$(basename $1)%.*}.gif"
  fi
}
img2base64(){
  #usage cat image.gif | base64 > img.css
  w=''
  case "${1:-}" in
    --wrap=*) printf '%s\n' "$1" | grep -q '^--wrap=[0-9]\{1,\}$' && {
                w=${1#--wrap=}
              }
              ;;
  esac
  case "$w" in '') w=76;; esac
  od -A n -t x1 -v                                                         |
  awk 'BEGIN{OFS=""; ORS="";                                               #
             x2o["0"]="0000"; x2o["1"]="0001"; x2o["2"]="0010";            #
             x2o["3"]="0011"; x2o["4"]="0100"; x2o["5"]="0101";            #
             x2o["6"]="0110"; x2o["7"]="0111"; x2o["8"]="1000";            #
             x2o["9"]="1001"; x2o["a"]="1010"; x2o["b"]="1011";            #
             x2o["c"]="1100"; x2o["d"]="1101"; x2o["e"]="1110";            #
             x2o["f"]="1111";                                              #
             x2o["A"]="1010"; x2o["B"]="1011"; x2o["C"]="1100";            #
             x2o["D"]="1101"; x2o["E"]="1110"; x2o["F"]="1111";         }  #
       {     l=length($0);                                                 #
             for(i=1;i<=l;i++){print x2o[substr($0,i,1)];}                 #
             printf("\n");                                              }' |
  awk 'BEGIN{s="";                                                      }  #
       {     buf=buf $0;                                                   #
             l=length(buf);                                                #
             if(l<6){next;}                                                #
             u=int(l/6)*6;                                                 #
             for(p=1;p<u;p+=6){print substr(buf,p,6);}                     #
             buf=substr(buf,p);                                         }  #
       END  {if(length(buf)>0){print substr(buf "00000",1,6);}          }' |
  awk 'BEGIN{ORS=""; w='$w';                                               #
             o2b6["000000"]="A"; o2b6["000001"]="B"; o2b6["000010"]="C";   #
             o2b6["000011"]="D"; o2b6["000100"]="E"; o2b6["000101"]="F";   #
             o2b6["000110"]="G"; o2b6["000111"]="H"; o2b6["001000"]="I";   #
             o2b6["001001"]="J"; o2b6["001010"]="K"; o2b6["001011"]="L";   #
             o2b6["001100"]="M"; o2b6["001101"]="N"; o2b6["001110"]="O";   #
             o2b6["001111"]="P"; o2b6["010000"]="Q"; o2b6["010001"]="R";   #
             o2b6["010010"]="S"; o2b6["010011"]="T"; o2b6["010100"]="U";   #
             o2b6["010101"]="V"; o2b6["010110"]="W"; o2b6["010111"]="X";   #
             o2b6["011000"]="Y"; o2b6["011001"]="Z"; o2b6["011010"]="a";   #
             o2b6["011011"]="b"; o2b6["011100"]="c"; o2b6["011101"]="d";   #
             o2b6["011110"]="e"; o2b6["011111"]="f"; o2b6["100000"]="g";   #
             o2b6["100001"]="h"; o2b6["100010"]="i"; o2b6["100011"]="j";   #
             o2b6["100100"]="k"; o2b6["100101"]="l"; o2b6["100110"]="m";   #
             o2b6["100111"]="n"; o2b6["101000"]="o"; o2b6["101001"]="p";   #
             o2b6["101010"]="q"; o2b6["101011"]="r"; o2b6["101100"]="s";   #
             o2b6["101101"]="t"; o2b6["101110"]="u"; o2b6["101111"]="v";   #
             o2b6["110000"]="w"; o2b6["110001"]="x"; o2b6["110010"]="y";   #
             o2b6["110011"]="z"; o2b6["110100"]="0"; o2b6["110101"]="1";   #
             o2b6["110110"]="2"; o2b6["110111"]="3"; o2b6["111000"]="4";   #
             o2b6["111001"]="5"; o2b6["111010"]="6"; o2b6["111011"]="7";   #
             o2b6["111100"]="8"; o2b6["111101"]="9"; o2b6["111110"]="+";   #
             o2b6["111111"]="/";                                           #
             if (getline) {print o2b6[$0];n=1;}                         }  #
       n==w {printf("\n")  ; n=0;                                       }  #
       {     print o2b6[$0]; n++;                                       }  #
       END  {if(NR>0){printf("%s\n",substr("===",1,(4-(NR%4))%4));}     }'
}
portcheck(){
  if [ $# -ne 1 ]; then
    echo "Require [PortNumber]"
  else
    sudo netstat -apnt4 | grep $1	
  fi
}
compress(){
  tar cfvz $1.tar.gz $1/
}
extract(){
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2) tar xvjf $1   ;;
      *.tar.gz)  tar xvzf $1   ;;
      *.tar.xz)  xz -dc $1 | tar xfv - ;;
      *.bz2)     bunzip2 $1    ;;
      *.rar)     unrar x $1    ;;
      *.gz)      gunzip $1     ;;
	  *.tar)     tar xvf $1    ;;
      *.tbz2)    tar xvjf $1   ;;
	  *.tgz)     tar xvzf $1   ;;
      *.zip)     unzip $1      ;;
      *.Z)       uncompress $1 ;;
      *.7z)      7z x $1       ;;
      *)
        echo "Unable to extract '$1'"
      ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}
declare -a jetbrains=("IdeaProjects" "PhpstormProjects" "CLionProjects" "PycharmProjects" "RubymineProjects" "WebstormProjects" )
createJetBrainsDirectory(){
  for ((i = 0; i < ${#jetbrains[@]}; i++)) {
    echo "mkdir -p ${jetbrains[i]}"
  }
}
urlencode() {
  local string="${1}"
  local strlen=${#string}
  local encoded=""
  local pos c o
  for (( pos=0 ; pos<strlen ; pos++ )); do
     c=${string:$pos:1}
     case "$c" in
        [-_.~a-zA-Z0-9] ) o="${c}" ;;
        * )               printf -v o '%%%02x' "'$c"
     esac
     encoded+="${o}"
  done
  echo "${encoded}"    # You can either set a return variable (FASTER) 
  REPLY="${encoded}"   #+or echo the result (EASIER)... or both... :p
}
gtk-input(){
  VAR=$(zenity --entry --text="input:")
  echo $VAR
}
cmakeclean(){
  rm CMakeCache.txt
  rm cmake_install.cmake
  rm -r CMakeFiles
  rm Makefile
}
cmakeuninstall(){
  xargs rm < install_manifest.txt
}
sudopostgres(){
sudo -i -u postgres
}
crossorigincheck(){
  if [ $# -ne 1 ]; then
    echo "Require [http://example.com]"
  else
    curl -H "Origin: ${1}" \
      -H "Access-Control-Request-Method: POST" \
      -H "Access-Control-Request-Headers: X-Requested-With" \
      -X OPTIONS \
      --verbose https://www.googleapis.com/discovery/v1/apis?fields=
  fi
}

directorysize(){
  du -sh ./*/
}
phpconfigurecheck(){
php -i  | grep './configure'
}
updatelocaletime(){
sudo cp /etc/localtime /etc/localtime.org
sudo ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
}
rmcomment(){
grep -v -e '^\s*#' -e '^\s*$' $1
}
bkup(){
if [[ -d "${1}" && ! -L "${1}" ]] ; then
  rm -rf $1.org
  cp -rf $1 $1.org
fi
}
checkglobalip(){
curl inet-ip.info
}
checkproxy(){
HOST=${1:-localhost}
curl inet-ip.info -x $HOST:3128
}
sudoeof(){
sudo bash -c "cat << 'EOF' > $1
$2
EOF"
}
simpleHTTPServer(){
python -u -m SimpleHTTPServer 8000
}
isRoot(){
  test "$(id -u)" == "0";
}
vncstart(){
export USER=root
VNC_RESOLUTION="800x600"#"1360x768"
vncserver :1 -geometry $VNC_RESOLUTION -depth 24
}
vncstop(){
export USER=root
vncserver -kill :1
}
gorun(){
  MAIN=${1:-main.go}
  go run $MAIN
}
filesearch(){
  if [ $# -ne 1 ]; then
    echo "Require [FileName]"
  else
    find / -name $1 -ls
  fi
}
dnscheck(){
  if [ $# -ne 1 ]; then
    echo "Require [domain]"
  else
    dig + noall + answer $1
  fi
}
rmknown_hosts(){
  rm ~/.ssh/known_hosts
}
cmdconfirm(){
  echo "run [$1] ? [y]"
  read ans
  case $ans in
    '' | y* | Y* )
      echo "Yes" && eval "${1}"
      ;;
    * )
      echo "No" && exit
    ;;
  esac
}
requirecmd(){
  CMD=$1
  if type "$CMD" > /dev/null 2>&1 ; then
    echo "found command:$CMD"
  else
    echo "not found command:$CMD"
    exit
  fi
}
requirepkg(){
  requirecmd "dpkg-query"
  PKG=$1
  PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $PKG|grep "install ok installed") 
  if [ "" != "$PKG_OK" ]; then
    echo "found package:$PKG"
  else
    echo "not found package:$PKG"
    cmdconfirm "sudo apt-get install -y $PKG"
  fi
}
requiresudo(){
  if [[ "$(id -u)" != "0" ]]; then
    PASS=$(zenity --entry --text="input:")
    CMD=$0
    expect -c "
      set timeout -1
      spawn sudo $CMD
      expect \"assword\" {
        send \"$PASS\n\"
      }
      interact
    "
    exit
  fi
}
tmuxexit(){
  tmux kill-server
}
# winry(){
#   vim +":source ~/.vim/dein/repos/github.com/axrat/winry.vim/plugin/winry.vim " +:q
# }
purge(){
  if [ $# -ne 1 ]; then
    echo "Require [Directory]"
  else
    readonly DRYRUN=false
    #BASE=$(cd $(dirname $0); pwd)
    BASE=$(pwd)
    HEADER="####################################################################################################"
    A="a.txt"
    A_NO_MAX=$([ `wc -c < $A` -eq 0 ] && echo 0 || ([ `tail -c 1 $A | wc -l` -eq 1 ] && wc -l < $A || expr `wc -l < $A` + 1))
    TEST_DIR="$BASE/$1"
    if [ ! -f "$A" ]; then
      echo "not found $A"
    else
      echo $HEADER
      mkdir -p $TEST_DIR
      ##
      AR=($(grep -e ^"$HEADER"$ -n $A | sed -e 's/:.*//g'))
      for i in "${!AR[@]}"; do
        #printf '${AR[%s]}=%s\n' "$i" "${AR[i]}"
        _NEXT=`expr $i \+ 1`
        _START=`expr ${AR[$i]} \+ 2`
        _NAME=$(head -n `expr ${AR[$i]} \+ 1` $A | tail -n 1)
        if [ `expr ${#AR[@]} \- 1` -eq $i ];then
         #echo "last"
          _END=$A_NO_MAX
        else
          _END=`expr ${AR[$_NEXT]} \- 1`
        fi
        ##empty
        if [ $_START -gt $_END ];then
          _END=$_START
        fi
        echo "$_NAME#L$_START-L$_END"
        _OUT="$TEST_DIR/$_NAME"
        _CMD="sed -n ${_START},${_END}p $A >> $_OUT"
        echo " => $_CMD"
        if ! "${DRYRUN}"; then
          :> $_OUT
          eval "${_CMD}"
        fi
      done
      ##
      #rm -rf $TEST_DIR
      echo $HEADER
      echo "diff -rs --speed-large-files $TEST_DIR [DIR]"
    fi
  fi
}
forParentDir(){
  sudo chmod 777 ../`pwd | awk -F "/" '{ print $NF }'`
}
forSudo(){
chown root:root /usr/bin/sudo && chmod 4755 /usr/bin/sudo
chmod u+s "$(command -v su)" "$(command -v sudo)"
}
forNodejs(){
sudo chown -R $(whoami) $(npm config get prefix)/lib/node_modules
#rm -rf node_modules/ && npm cache clean && npm install
#sudo chmod 770 $NVM_DIR -R
}
forDocker(){
sudo groupadd docker
sudo gpasswd -a $USER docker
sudo systemctl restart docker
echo "plz relogin"
}
```
