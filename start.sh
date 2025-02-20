#!/bin/bash

run_program() {
    # Define variables for toption and node_id
    toption="2"
    node_id="8757527"

    # Start the program and capture its output
    output=$(cargo run -r -- start --env beta 2>&1 < /dev/null)
    
    if echo "$output" | grep -q "y/n"; then
        # If we see y/n prompt, send y, toption, and node_id
        printf 'y\n%s\n%s\n' "$toption" "$node_id" | cargo run -r -- start --env beta
    else
        # First time or normal run, send toption and node_id
        printf '%s\n%s\n' "$toption" "$node_id" | cargo run -r -- start --env beta
    fi
}

# Run the program
run_program
