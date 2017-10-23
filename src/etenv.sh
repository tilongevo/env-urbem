#!/usr/bin/env sh

# Dispatches calls to other etenv_* functions
etenv ()
{
	dispatch etenv "${@:-}"
}

# To be called when no arguments are passed
etenv_ ()
{
	return 0
}

# To be called after an invalid command is called
etenv_call_ ()
{
	echo "Command not found. Run '$0 --help' for more information." 2>&1
	return 1
}

# Versioning information
etenv_option_version ()
{
	echo "etenv version 0.1-alpha"
	exit 0
}

# Help instructions
etenv_option_help ()
{
	cat <<-ETENV
	Usage: $0 [options] [command]

	Commands:
	  status     Displays information about the environment
	  ssh        List and logs into available machines
	  selftest   Run tests for etenv itself
	  checkdeps  Checks basic for dependencies for running etenv

	Options:
	  --help    Displays this message
	  --version Shows versioning information

	ETENV
	exit 0
}

# Runs its own tests
etenv_command_selftest ()
{
	posit --shell="bash" --report="${1:-spec}" run "${etenv_dir}/test"
}

# Checks for required dependencies
etenv_command_checkdeps ()
{
	etenv_checkdeps_tool "git" &&
	etenv_checkdeps_workshop
}

# Display the current status
etenv_command_status ()
{
	etenv_checkdeps_tool "docker" &&
	etenv_checkdeps_tool "docker-compose"

	etenv_version="$(etenv_option_version)"
	etenv_gitversion="$(git --version)"
	etenv_dockerversion="$(docker --version)"
	etenv_composeversion="$(docker-compose --version)"

	cat <<-STATUS
		${etenv_version}
		Powered by:
		  ${etenv_gitversion}
		  ${etenv_dockerversion}
		  ${etenv_composeversion}


	STATUS
}

etenv_command_guide ()
{
	answer get 'Foo or bar?|[ foo ]|[ bar ]'
}


# Checks if a command line tool is available.
etenv_checkdeps_tool ()
{
	if [ "" = "${1:-}" ]
	then
		return 1
	fi

	# Try to call tool
	"${1:-:}" --help >/dev/null 2>&1

	# If not found, warn the user. We cannot continue
	if [ 127 = "${?}" ]
	then
		echo "The command '${1:-[name not provided!]}' is not installed or could not be found. Please install it or make it available in your path." 1>&2
		return 1
	fi
}

# Checks if the Mosai Workshop dependency is available
etenv_checkdeps_workshop ()
{
	dependencies_were_changed=0

	if [ ! -d "${etenv_workshop_dir}" ]
	then
		echo "Installing dependencies (one time only)..."  1>&2
		mkdir -p "${etenv_workshop_dir}" &&
		etenv_wrap git clone "${etenv_workshop_repo}" "${etenv_workshop_dir}"

		dependencies_were_changed=1
	else
		current_dir="$(pwd)"
		cd "${etenv_workshop_dir}"
		if [ "" != "$(git status --porcelain)" ]
		then
			echo "Resetting dependencies..."
			etenv_reset_workshop_deps

			dependencies_were_changed=1
		fi
		cd "${current_dir}"
		unset current_dir
	fi

	if [ 1 = "${dependencies_were_changed}" ]
	then
		echo "All dependencies up to date. Continuing..."
		echo ""
	fi
}

etenv_reset_workshop_deps ()
{
	etenv_wrap git clean -df
	etenv_wrap git checkout .
	etenv_wrap git reset --hard origin/master
	etenv_wrap git pull --rebase origin master
}

etenv_wrap ()
{
	"${@:-}" | sed "s/^/  [${1:-output}] /"
}

