#!/bin/bash
set -e

mydir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $mydir/inc.config.sh

if [ -n "$1" ]; then
	sshhost="$1"
fi

echo "Connecting to $sshhost ..."
echo ""
echo "Visit http://localhost:8080 to open rspamd interface. Press CTRL-C to hang up."

ssh -L 8080:localhost:11334 $sshhost -N
