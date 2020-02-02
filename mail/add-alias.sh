#!/bin/bash
set -e


function selectyn {
   while true; do
      read -p "$1 (y/n) " yn
      case $yn in
         [Yy]* ) echo "y"; break;;
         [Nn]* ) echo "n"; break;;
      esac
   done
}


mydir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $mydir/inc.config.sh

if [ -n "$1" ]; then
	sshhost="$1"
fi

echo "Connecting to $sshhost ..."
echo ""

read -p "alias (without domain): " username
read -p "domain: " domain
read -p "destination: " destination
case $(selectyn "Catch-all account?") in
   y ) catchall="true" ;;
   n ) catchall="false" ;;
esac

case $(selectyn "Enable account?") in
   y ) enabled="true" ;;
   n ) enabled="false" ;;
esac

echo " ---"
case $(selectyn "Add alias  $username@$domain  to destination $destination (enable=$enabled) ?") in
   y ) ;;
   n ) exit 0 ;;
esac

quota=0

query=$(cat <<EOF
INSERT INTO aliases (username, domain, destination, enabled, catchall)
VALUES ('$username', '$domain', '$destination', $enabled, $catchall)
ON DUPLICATE KEY UPDATE
username='$username', domain='$domain', destination='$destination', enabled=$enabled, catchall=$catchall;
EOF
)

#echo $query
echo $query | ssh $sshhost mysql --database=vmail

echo "Done."
