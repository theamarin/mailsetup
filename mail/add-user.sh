#!/bin/bash
set -e


if command -v mkpasswd >/dev/null 2>&1; then
   echo "mkpasswd available."
else
   echo "Error: mkpasswd not found, install ..."
   sudo apt-get install whois
fi

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

read -p "username (without domain): " username
read -p "domain: " domain
read -p "password: " password
case $(selectyn "Hash password?") in
   y ) password=$(mkpasswd -m sha256crypt "$password") ;;
   n ) ;;
esac
case $(selectyn "Send-only account?") in
   y ) sendonly="true" ;;
   n ) sendonly="false" ;;
esac

case $(selectyn "Enable account?") in
   y ) enabled="true" ;;
   n ) enabled="false" ;;
esac

echo " ---"
case $(selectyn "Add user  $username@$domain with hashed password $password (enable=$enabled) ?") in
   y ) ;;
   n ) exit 0 ;;
esac

quota=0

query=$(cat <<EOF
INSERT INTO accounts (username, domain, password, quota, enabled, sendonly)
VALUES ('$username', '$domain', '$password', $quota, $enabled, $sendonly)
ON DUPLICATE KEY UPDATE
username='$username', domain='$domain', password='$password', quota=$quota, enabled=$enabled, sendonly=$sendonly;
EOF
)

#echo $query
echo $query | ssh $sshhost mysql --database=vmail

echo "Done."
