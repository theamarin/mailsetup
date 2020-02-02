#!/bin/bash
set -e

mydir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cat <<-EOF
Runs a setup script (or all scripts in a folder) remotely,
to setup a mail or webmail server.
   Usage:    ./setup.sh <script>|<folder> [<config file>]
   Example:  ./setup.sh mail/0-basic mail/inc.config.sh
EOF


if [ -z "$1" ]; then
	echo "Error: Please specify a script or a folder to be run remotely."
	exit 1
fi

function load-config {
   if [ -z "$2" ]; then
      configfile="$scriptdir/inc.config.sh"
   else
      configfile="$2"
   fi
   echo "Using config file: $configfile"
	source $configfile
   echo "  Host:   $sshhost"
   echo "  Domain: $domain"
}

function run-scripts {
	# Don't use "" around $@ to allow expansion:
	for script in $@; do
		echo "Run $script ..."
		basename="${script#"$scriptdir/"}"
		basename="${basename##[0-9]*-}.d"
		localresdir="$scriptdir/$basename"
		if [ -d "$localresdir" ]; then
			echo "Uploading resources from $basename to $sshhost:$resdir/$basename ..."
			ssh $sshhost "mkdir -p $resdir && rm -rf $resdir/$basename"
			scp -r "$localresdir/" $sshhost:$resdir/$basename
		fi

      # Set environment variables to be visible to the script and launch remote bash to execute the script.
		ssh $sshhost resdir=$resdir/$basename hostname=$hostname fqdn=$fqdn domain=$domain vmailpasswd=$vmailpasswd add_domains=$add_domains 'bash -s' < $script
		echo ""
	done
}

if [ -f "$1" ]; then
   # setup.sh is called with a script as argument
	scriptdir=$(dirname "$1")
   load-config "$scriptdir" "$2"
	run-scripts "$1"
elif [ -d "$1" ]; then
   # setup.sh is called with a folder as argument
	scriptdir=${1%'/'}
   load-config "$scriptdir" "$2"
	echo "Run all scripts in $scriptdir ..."
	run-scripts "$scriptdir/?-*"
else
	echo "Error: $1 not found."
	exit 1
fi


echo "Done."