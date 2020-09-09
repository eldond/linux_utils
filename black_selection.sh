#!/usr/bin/env bash

set -x

black=$1
input_file=$2
start_line=$3
end_line=$4

# Read selected lines and write to tmpfile
selection=$(sed -n "$start_line, $end_line p; $(($end_line+1)) q" < $input_file)
tmpfile=$(mktemp)
echo "$selection" > "$tmpfile"

# Apply Black formatting to tmpfile
$black $tmpfile -l140 -S

echo "f"

# Delete original lines from file
sed -i "$start_line,$end_line d" $input_file

echo "ddj"

# And insert newly formatted lines
sed -i "$(($start_line-1)) r $tmpfile" $input_file

