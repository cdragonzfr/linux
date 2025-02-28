import requests
import argparse
import os
import shutil
from urllib.parse import urlparse
import logging

# Set up logging
logging.basicConfig(filename='token_download.log', level=logging.INFO, 
                    format='%(asctime)s - %(levelname)s - %(message)s')

def download_tokens(auth_token, flock_id, Bary_web_hash):
    """Fetch tokens and download them to their appropriate hostname directories."""
    
    results = fetch(auth_token, Bary_web_hash)  # Fetch the flock tokens
    
    for item in results['tokens']:
        memo = item.get('memo', '')
        parts = memo.split(',')
        
        if len(parts) < 3:
            logging.warning(f"Skipping token: Invalid memo format - {memo}")
            continue
        
        hostname = parts[0].upper()  # Standardize hostname to uppercase
        location = parts[2]          # Path from memo
        token_name = os.path.basename(location)  # Extract filename
        token_url = item.get('url', '')  # URL to download token

        # Ensure hostname directory exists
        if not os.path.exists(hostname):
            os.makedirs(hostname)
            logging.info(f"Created directory: {hostname}")

        # Check if URL is valid before downloading
        if not token_url:
            logging.warning(f"Skipping token {token_name}: No download URL found.")
            continue

        # Download token
        try:
            response = requests.get(token_url, stream=True, verify=False)
            response.raise_for_status()  # Raise an error for bad responses (4xx/5xx)

            # Save the token to a temporary file
            temp_filename = f"temp_{token_name}"
            with open(temp_filename, 'wb') as f:
                for chunk in response.iter_content(chunk_size=8192):
                    f.write(chunk)

            logging.info(f"Downloaded token: {token_name}")

            # Move and rename the token to its correct folder
            new_path = os.path.join(hostname, token_name)
            shutil.move(temp_filename, new_path)
            logging.info(f"Renamed and moved token to: {new_path}")

            # Verify the token is in the correct folder
            if os.path.exists(new_path):
                logging.info(f"Verified: Token {token_name} is in {hostname} folder.")
            else:
                logging.error(f"Error: Token {token_name} missing after move!")

        except requests.RequestException as e:
            logging.error(f"Failed to download {token_name}: {e}")

# Argument parser setup
parser = argparse.ArgumentParser(description="Manage tokens.")
parser.add_argument('action', choices=['enable', 'disable', 'inventory', 'create', 'edit', 'download'], 
                    help='Action to perform.')
parser.add_argument('--auth_token', help='The authentication token.', required=True)
parser.add_argument('--Bary_web_hash', help='The unique hash of the Bary tools web console.', required=True)
parser.add_argument('--flock_id', help='The flock_id to use (required for download).', default=None)
parser.add_argument('--excel_file', help="Path to the Excel file for creating tokens.", default=None)

args = parser.parse_args()

# Enforce flock_id requirement for download action
if args.action == "download" and not args.flock_id:
    parser.error("The --flock_id argument is required for the 'download' action.")

# Call respective functions based on action
if args.action == "enable":
    filename, results = get_filename(args.action, args.flock_id, args.auth_token, args.Bary_web_hash)
    enable(filename, results, args.auth_token, args.Bary_web_hash)

elif args.action == "disable":
    filename, results = get_filename(args.action, args.flock_id, args.auth_token, args.Bary_web_hash)
    disable(filename, results, args.auth_token, args.Bary_web_hash)

elif args.action == "inventory":
    filename, results = get_filename(args.action, args.flock_id, args.auth_token, args.Bary_web_hash)
    generate_inventory(results)

elif args.action == "create":
    if not args.excel_file:
        print("Error: --excel_file must be provided when using 'create'.")
    else:
        create_tokens_from_excel(args.auth_token, args.flock_id, args.excel_file)

elif args.action == "edit":
    filename, results = get_filename(args.action, args.flock_id, args.auth_token, args.Bary_web_hash)
    old_hostname = input("Enter the original hostname: ").upper()
    old_ip = input("Enter the original IP address: ")
    new_hostname = input("Enter the new hostname: ").upper()
    new_ip = input("Enter the new IP address: ")
    edit_token(args.auth_token, results['tokens'], old_hostname, old_ip, new_hostname, new_ip)

elif args.action == "download":
    download_tokens(args.auth_token, args.flock_id, args.Bary_web_hash)


____________________________


import requests
import argparse
import os
import shutil
import logging

# Set up logging
logging.basicConfig(filename='token_download.log', level=logging.INFO, 
                    format='%(asctime)s - %(levelname)s - %(message)s')

def download_tokens(auth_token, flock_id, Bary_web_hash):
    """Fetch tokens and download them to their appropriate hostname directories."""
    
    results = fetch(auth_token, Bary_web_hash)  # Fetch the flock tokens

    for item in results['tokens']:
        memo = item.get('memo', '')
        parts = memo.split(',')
        
        if len(parts) < 3:
            logging.warning(f"Skipping token: Invalid memo format - {memo}")
            continue
        
        hostname = parts[0].upper()  # Standardize hostname to uppercase
        location = parts[2]          # Path from memo
        token_name = os.path.basename(location)  # Extract filename
        canarytoken = item.get('canarytoken', '')  # Extract canarytoken

        # Ensure hostname directory exists
        if not os.path.exists(hostname):
            os.makedirs(hostname)
            logging.info(f"Created directory: {hostname}")

        # Ensure canarytoken is available
        if not canarytoken:
            logging.warning(f"Skipping token {token_name}: Missing canarytoken in results.")
            continue

        # Define API URL and payload for downloading
        url = 'https://EXAMPLE.canary.tools/api/v1/canarytoken/download'
        payload = {
            'auth_token': auth_token,
            'canarytoken': canarytoken
        }

        # Download token using GET request
        try:
            response = requests.get(url, params=payload, allow_redirects=True, stream=True, verify=False)
            response.raise_for_status()  # Raise an error for bad responses (4xx/5xx)

            # Save the token file temporarily
            temp_filename = f"temp_{token_name}"
            with open(temp_filename, 'wb') as f:
                for chunk in response.iter_content(chunk_size=8192):
                    f.write(chunk)

            logging.info(f"Downloaded token: {token_name}")

            # Move and rename the token to its correct folder
            new_path = os.path.join(hostname, token_name)
            shutil.move(temp_filename, new_path)
            logging.info(f"Renamed and moved token to: {new_path}")

            # Verify the token is in the correct folder
            if os.path.exists(new_path):
                logging.info(f"Verified: Token {token_name} is in {hostname} folder.")
            else:
                logging.error(f"Error: Token {token_name} missing after move!")

        except requests.RequestException as e:
            logging.error(f"Failed to download {token_name}: {e}")
