#!/bin/bash

# Check if there is at least one command-line argument
if [ "$#" -lt 1 ]; then
    echo "The script should have at least one argument. Please run the script in a correct way."
    exit 1
fi

TextFile="$1"
shift # Remove the first argument

# Check if the file exists
if [ ! -e "$TextFile" ]; then
    echo "File not found: $TextFile"
    exit 1
fi

# Read the text to be printed (treat space-separated strings as one argument)
text="$*"

# Read the font file and store the lines in an array
readarray -t fontList < "$TextFile"

# Split the user's input based on newline characters
IFS=$'\n' read -ra splitText <<< "$text"

# Iterate through each line in the splitText array
for line in "${splitText[@]}"; do
    # Check if the line is empty
    if [ -z "$line" ]; then
        echo
        continue
    fi

    # Loop through 8 times (for each row in the characters)
    for ((i=0; i<8; i++)); do
        # Loop through each character in the line
        for ((j=0; j<${#line}; j++)); do
            char="${line:$j:1}"
            # Check if the character is within the ASCII range
            if [ "$(( $(printf '%d' "'$char")))" -ge 32 ] && [ "$(( $(printf '%d' "'$char")))" -le 126 ]; then
                # Print the corresponding character from fontList
                initial="${fontList[i + (( $(printf '%d' "'$char") - 32) * 9) + 1]}"
                echo -n "$initial"
            fi
        done
        echo # Move to the next row
    done
done
