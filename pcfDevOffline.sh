#!/bin/sh

connect(){
  sudo brew services stop dnsmasq
  sudo networksetup -setdnsservers Wi-Fi 127.0.0.1
  dscacheutil -flushcache;sudo killall -HUP mDNSResponder;
  sudo brew services start dnsmasq
  echo "Network settings in offline mode"
}

disconnect() {
  sudo brew services stop dnsmasq
  sudo networksetup -setdnsservers Wi-Fi 8.8.8.8 8.8.4.4 192.168.1.254
  dscacheutil -flushcache;sudo killall -HUP mDNSResponder;
  echo "Network settings in online mode"
}

start(){
  connect
  cf dev start
  cf login -a https://api.local.pcfdev.io -u user -p pass -s pcfdev-space --skip-ssl-validation
  echo "Apps Manager is available at: http://local.pcfdev.io"
}

stop() {
  cf dev stop
  disconnect
}

usage ()
{
  echo 'Usage : <scriptname> stop (Will stop pcfdev and reset network settings)'
  echo '               start (Will start pcfdev and reset network settings)'
  echo '               connect (Will ONLY set network settings to offline mode)'
  echo '               disconnect (Will ONLY set network settings to online mode)'
  exit
}


while [ "$1" != "" ]; do
case $1 in
        start )       start
                       ;;
        stop )       stop
                       ;;
        connect )    connect
                       ;;
        disconnect ) disconnect
                       ;;
        -usage )       usage
                       ;;
        -? )           usage
                       ;;
        --help )       usage
                       ;;
    esac
    shift
done
