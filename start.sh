#!/bin/bash

# Function to run the program and process its output
run_program() {
    # Start the program and capture its output
    output=$(cargo run -r -- start --env beta 2>&1 < /dev/null)
    
    if echo "$output" | grep -q "y/n"; then
        # If we see y/n prompt, send y,2,1280438
        printf 'y\n2\n1048321\n' | cargo run -r -- start --env beta
    else
        # First time or normal run, send 2,1280438
        printf '2\n1048321\n' | cargo run -r -- start --env beta
    fi
}

# Run the program
run_program
