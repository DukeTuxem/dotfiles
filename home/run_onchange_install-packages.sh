#!/bin/sh

has()
{
	_cmd=$(command -v "$1") 2>/dev/null || return 1
	[ -x "$_cmd" ] || return 1
}


operating_system="$(uname -s)"
if [ "$operating_system" = 'Linux' ]
then
	if [ -f '/etc/os-release' ]
	then
		# TODO: know if 'ID' is present everywhere
		distro=$(grep '^ID' /etc/os-release)
		eval "$distro"

		if [ "$ID" = 'debian' ]
		then
			distro_file='debian.txt'
			package_manager='apt-get install'
			privilege_escalation='sudo'
		elif [ "$ID" = 'void' ]
		then
			sudo xbps-install <<EOF
			{{ range .packages.core.void }}
			EOF
		else
			echo 'Can not detect linux distribution, aborting.'
			exit 1
		fi
	elif ! has lsb_release
	then
		echo 'No lsb_release command available.'
		echo 'Can not rely on any reliable method to detect flavor.'
		exit 1
	# TODO: implement the fallback with lsb_release ?
	fi
	echo "Package manager command should be '$package_manager'"

elif [ "$operating_system" = "FreeBSD" ]
then
	echo "(Free)BSD Unimplemented"
	return 1
else
	echo "Unsupported platform for now"
	return 1
fi
