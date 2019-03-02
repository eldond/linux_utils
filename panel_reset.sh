#! /bin/bash

# This script resets the KDE plasma 5 environment. Useful if task manager widgets in panels get confused about tracking windows and stuff like that.
# There is a bug that affects task manager widgets when they are set to display tasks "only from the current screen": when external monitors are connected and disconnected, they can stop displaying anything (probably confusion about which is the current screen?). This script solves the problem.

# Used on Fedora 25-29 with KDE plasma 5.

# Main Plasma 5 Desktop Configuration File
plasma_applets_file="${HOME}/.config/plasma-org.kde.plasma.desktop-appletsrc"

awk '
function initialise_global_variables()
{
	# **** Add per panel settings in an ordered list here ****
	# location=5 formfactor=3 [left]
	# location=6 formfactor=3 [right]
	# location=3 formfactor=2 [top]
	# location=4 formfactor=2 [bottom]

	# Panel 1
	panel_array[1,"formfactor"]=2
	panel_array[1,"lastScreen"]=0
	panel_array[1,"location"]=4
	# Panel 2 ...
	panel_array[2,"formfactor"]=2
	panel_array[2,"lastScreen"]=1
	panel_array[2,"location"]=4
	# **** Add per panel settings in an ordered list here ****

	# List of all panel variables we want to be able to reset
	panel_variables="formfactor lastScreen location"

	split(panel_variables, panel_settings_array)
	blank_line_regexp="^[[:blank:]]*$"
}

function check_panel_settings_valid(			i)
{
	for (i in panel_settings_array) {
		if ((panel,panel_settings_array[i]) in panel_array)
			return 1
	}
	return 0
}

function process_panel_block(line,
	i, panel_setting)
{
	# Go to end of panel block ...
	while ((++line<=line_count) && (plasma_file_array[line] !~ blank_line_regexp)) {}

	# ... work back through panel block ...
	while ((--line >= 1) && (plasma_file_array[line] !~ blank_line_regexp)) {
		for (i in panel_settings_array) {
			panel_setting=panel_settings_array[i]
			if ((panel,panel_setting) in panel_array)
				sub((panel_setting "=[[:digit:]]+$"),
					(panel_setting "=" panel_array[panel,panel_setting]),
					plasma_file_array[line])
		}
	}
}

BEGIN{
	initialise_global_variables()
}

{
	plasma_file_array[++line]=$0
}

END{
	line_count=line
	panel=1
	if (! check_panel_settings_valid())
			exit 1
	for (line=1; line<=line_count; ++line) {
		if (plasma_file_array[line] !~ /^plugin=org\.kde\.panel/)
			continue
			
		process_panel_block(line)
		++panel
		if (! check_panel_settings_valid())
			break
	}
	for (line=1; line<=line_count; ++line)
		print plasma_file_array[line]
}' "${plasma_applets_file}" 1>"${plasma_applets_file}.new" 2>/dev/null

[ -f "${plasma_applets_file}.new" ] && mv "${plasma_applets_file}.new" "${plasma_applets_file}"

#kquitapp5 plasmashell ; /usr/bin/plasmashell --shut-up &>/dev/null &
kquitapp5 plasmashell ; /usr/bin/plasmashell replace &>/dev/null &
