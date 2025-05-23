#!/bin/bash

# Define log file location
LOG_FILE="/tmp/token_placement.log"
echo "===== Script Started: $(date) =====" > "$LOG_FILE"

# Function to log messages
log() {
    echo "$(date) - $1" | tee -a "$LOG_FILE"
}

# Function to ensure directory exists and set proper permissions
ensure_directory_exists() {
    local dir_path="$1"
    local owner="$2"
    local permissions="$3"

    if [[ ! -d "$dir_path" ]]; then
        log "Creating directory: $dir_path"
        mkdir -p "$dir_path"
        if [[ $? -ne 0 ]]; then
            log "ERROR: Failed to create directory $dir_path"
            return 1
        fi

        # Set ownership and permissions to match the token
        chown "$owner" "$dir_path"
        chmod "$permissions" "$dir_path"
        log "Permissions set: Owner=$owner, Mode=$permissions on $dir_path"
    else
        log "Directory already exists: $dir_path (No changes made)"
    fi
}

# Find the .tar.gz file in the current directory
TAR_FILE=$(ls *.tar.gz 2>/dev/null | head -n 1)

if [[ -z "$TAR_FILE" ]]; then
    log "ERROR: No tar.gz file found in the current directory."
    exit 1
fi

log "Found tar.gz file: $TAR_FILE"

# Extract the tar.gz file
log "Extracting $TAR_FILE..."
tar -xzvf "$TAR_FILE" >> "$LOG_FILE" 2>&1
if [[ $? -ne 0 ]]; then
    log "ERROR: Extraction failed."
    exit 1
fi

log "Extraction successful."

# Identify CSV file in the extracted folder
CSV_FILE=$(ls *.csv 2>/dev/null | head -n 1)

if [[ -z "$CSV_FILE" ]]; then
    log "ERROR: No CSV file found in the extracted contents."
    exit 1
fi

log "Found CSV file: $CSV_FILE"

# Process the CSV file, removing any Windows-style carriage returns
while IFS=',' read -r target_path token_name owner permissions; do
    # Remove potential carriage return characters (\r)
    target_path=$(echo "$target_path" | tr -d '\r')
    token_name=$(echo "$token_name" | tr -d '\r')
    owner=$(echo "$owner" | tr -d '\r')
    permissions=$(echo "$permissions" | tr -d '\r')

    log "Processing token: $token_name"

    # Check if token exists
    if [[ ! -f "$token_name" ]]; then
        log "ERROR: Token $token_name not found in the current directory."
        continue
    fi

    # Ensure target directory exists and apply proper permissions
    ensure_directory_exists "$target_path" "$owner" "$permissions"
    if [[ $? -ne 0 ]]; then
        log "ERROR: Failed to prepare directory for $token_name"
        continue
    fi

    # Change owner
    log "Setting owner: $owner for $token_name"
    chown "$owner" "$token_name"
    if [[ $? -ne 0 ]]; then
        log "ERROR: Failed to change owner for $token_name"
        continue
    fi

    # Change permissions
    log "Setting permissions: $permissions for $token_name"
    chmod "$permissions" "$token_name"
    if [[ $? -ne 0 ]]; then
        log "ERROR: Failed to change permissions for $token_name"
        continue
    fi

    # Move token to the target path
    log "Moving $token_name to $target_path"
    mv -f "$token_name" "$target_path"
    if [[ $? -ne 0 ]]; then
        log "ERROR: Failed to move $token_name to $target_path"
        continue
    fi

    # Verify token placement
    if [[ -f "$target_path/$token_name" ]]; then
        log "Verification successful: $token_name is in $target_path"
        ls -l "$target_path/$token_name" >> "$LOG_FILE"
    else
        log "ERROR: Verification failed for $token_name"
    fi

done < <(tr -d '\r' < "$CSV_FILE")  # Remove \r from CSV while reading

log "===== Script Completed: $(date) ====="
