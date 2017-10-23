#!/usr/bin/env sh
#vim: et! ts=4 sw=4:

etenv_command_ssh ()
{
	dispatch etenv_ssh "${@:-}"
}

# To be called when no arguments are passed
etenv_ssh_ ()
{
	etenv_ssh_option_help
}

# To be called after an invalid command is called
etenv_ssh_call_ ()
{
	echo "Command not found. Run '$0 --help' for more information." 2>&1
	return 1
}

etenv_ssh_option_version ()
{
	echo "etenv-ssh version 1.0"
	exit 0
}

etenv_ssh_option_help ()
{
	cat <<-ETENV
	Usage: $0 ssh [command] [options]

	Examples:
	  $0 ssh ls
	  $0 ssh into php
	  $0 ssh into etenv_mongo_1

	Commands:
	  ls                 List available development machines to log into.
	  into <pattern>     Start a /bin/bash session inside the appointed machine.

	Options:
	  --help    Displays this message
	  --version Shows versioning information

	ETENV
	exit 0
}

etenv_ssh_command_ls()
{
	docker ps --format "{{.Names}}"
}

# TODO Consider when a pattern matches two or more machine names.
etenv_ssh_command_into()
{
	target_machine="$(etenv ssh ls | grep ${1})"
	command=/bin/bash

	if [ "" = "$target_machine" ]
	then
		echo "Machine containing pattern '${1:-'name not privided'}' not found." 1>&2
		echo "Try using 'etenv ssh ls' to list all known machines." 1>&2
		exit 1
	fi

	docker exec $target_machine /bin/echo "Logging into $target_machine..."
	if [ 255 = $? ]
	then
		echo "Machine '$target_machine' is not acessible." 1>&2
		echo "Current status is: " $(docker ps --filter "name=$target_machine" --format "{{.Status}}")
		exit 1
	fi

	docker exec -ti $target_machine $command
}
