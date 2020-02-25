# bash-sandbox

Playing around with bash, trying to figure out the best way to structure some command line commands using the shell


# Set of features I'd like to have

# Be able to introduce new commands
- `playground g command [command_name]` Creates a file that can then be edited

## command/sub-command namespace for bash script. So users of the script can:

- Invoke a command. e.g. `playground [command]`
- Invoke a sub command. e.g. `playground go left`

With a nice way to organize the code

## Have a nice way to get help for commands
- Get a list of available commands `playground help`
- Invoke a sub command. e.g. `playground help generate`
- Get a list of available commands `playground help`

## Create a auto generated bash completion

- `playground build bash`
- `playground build zsh`

# Be able to show a list of libraries and functions
- `playground libraries` Shows all libraries
- `playground help [lib_file]` Shows functions/global variables for that file
