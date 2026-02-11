#!/bin/bash
# Docker run helper script for Farsi TTS
# Usage: ./docker-run.sh <command> [parameters]

set -e

COMMAND=$1
shift

# Ensure data directory exists
mkdir -p data

# Common docker run options
DOCKER_OPTIONS="-it --rm --gpus all -v $(pwd)/data:/workspace/host_data"

# Run the command
case "$COMMAND" in
    setup|prepare|train|synthesize|batch|verify|shell|help)
        eval "docker run $DOCKER_OPTIONS farsi-tts:latest $COMMAND $@"
        ;;
    *)
        echo "Usage: $0 <command> [parameters]"
        echo "Commands: setup, prepare, train, synthesize, batch, verify, shell, help"
        exit 1
        ;;
esac
