#!/bin/bash
set -e

mydir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $mydir/inc.config.sh

if [ -n "$1" ]; then
	sshhost="$1"
fi

echo "Connecting to $sshhost ..."
echo ""

cat <<-'EOF' | ssh $sshhost bash
   echo "=== Domains ==="
   echo 'SELECT * FROM domains;' | mysql --database=vmail --table
   echo ""

   echo "=== Accounts ==="
   echo 'SELECT id, enabled, username, domain, password, quota FROM accounts;' | mysql --database=vmail --table
   echo ""

   echo "=== Aliases ==="
   echo 'SELECT id, enabled, catchall, username, domain, destination FROM aliases;' | mysql --database=vmail --table
   echo ""

   echo "=== TLS Policies ==="
   echo 'SELECT id, domain, policy, params FROM tlspolicies;' | mysql --database=vmail --table
   echo ""
EOF
