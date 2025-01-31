#!/usr/bin/env bash

# Set strict error handling
set -euo pipefail

# Configuration
MAX_CACHE_SIZE=10000
DEBUG=${DEBUG:-0}
# Allow override via environment variable
MODEL_NAME=${MODEL_NAME:-"llama3.2:3b"}

# Check if ollama is installed
if ! command -v ollama &> /dev/null; then
    echo "Error: ollama is not installed or not in PATH"
    exit 1
fi

if ! ollama list | grep "$MODEL_NAME"  > /dev/null; then
    echo "Error: Model $MODEL_NAME is not installed"
    echo "Please install it using: ollama pull $MODEL_NAME"
    exit 1
fi

# set DEBUG=1 to see debug messages
debug() {
    if [[ "$DEBUG" == "1" ]]; then
        echo "DEBUG: $*" >&2
    fi
}

# Function to calculate MD5 hash in linux and macOS
get_md5() {
    local input="$1"
    echo "$input" | md5 2>/dev/null || echo "$input" | md5sum | awk '{print $1}'
}

# Function to initialize cache with pre-defined emojis
init_cache() {
    cache["d9bed3b7e151f11b8fdadf75f1db96d9"]="🔹"  # { opening bracket
    cache["7d9d25f71cb8a5aba86202540a20d405"]="🔸"  # } closing bracket
    cache["abd48b2e7f8c33b45c3b00a9ca2af8c4"]="🌟"  # ( opening parenthesis
    cache["878e08b0c9cf3710b9dc228122b07c7f"]="🌙"  # ) closing parenthesis
}

# Function to manage cache size
manage_cache_size() {
    if [[ ${#cache[@]} -gt $MAX_CACHE_SIZE ]]; then
        debug "Cache size exceeded. Clearing cache."
        unset cache
        declare -A cache
        debug "Reinitializing pre-defined emojis"
        init_cache
    fi
}

# Function to get emoji from LLM
get_emoji_from_llm() {
    local text="$1"
    local prompt="Give me an appropiate emoji for the following text. Don't provide extra text or explanation:"
    local result
    result=$(echo "$prompt $text" | ollama run "$MODEL_NAME") || echo "❓"
    echo "${result:0:1}"  # Get first character only
}

# Show usage if no arguments provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <filename>"
    echo "Environment variables:"
    echo "  DEBUG=1    Enable debug output"
    exit 1
fi

# Check if file exists
if [ ! -f "$1" ]; then
    echo "Error: File not found: $1" >&2
    exit 1
fi

# Initialize cache
declare -A cache
init_cache

# Process the file
while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ -n "$line" ]]; then
        # Process non-empty lines
        trim_spaces=$(echo "$line" | cut -c-200 | awk '{$1=$1};1')
        hash=$(get_md5 "$trim_spaces")
        debug "Processing line: $line"
        debug "Hash: $hash"

        if [[ -n "${cache[$hash]:-}" ]]; then
            emoji="${cache[$hash]}"
            debug "Cache hit: $emoji"
        else
            debug "Cache miss, calling LLM"
            emoji=$(get_emoji_from_llm "$trim_spaces")
            cache[$hash]="$emoji"
            manage_cache_size
        fi
    else
        # If the line is empty use 🗿 (moai) which resembles a gargoyle
        emoji="🗿"
        debug "Empty line, using moai"
    fi
    echo "$emoji $line"
done < "$1"
