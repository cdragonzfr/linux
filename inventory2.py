import requests, csv, argparse, os

# Existing functions (fetch, enable, disable) remain unchanged

# New function to generate inventory files
def generate_inventory(results):
    directory_set = set()
    file_data = []

    for item in results['tokens']:
        memo = item.get('memo', '')
        # Expected format: systemname,ip,location,program,token_type,hva_flag
        parts = memo.split(',')
        if len(parts) >= 3:
            location = parts[2]
            directory_path, file_name = os.path.split(location)
            directory_set.add(directory_path)
            destination_path = "" # Define how to calculate this
            file_data.append((file_name, destination_path))

    # Write Directories.csv
    with open('Directories.csv', 'w', newline='') as csvfile:
        csvwriter = csv.writer(csvfile)
        csvwriter.writerow(['DirectoryPath'])
        for dir_path in directory_set:
            csvwriter.writerow([dir_path])

    # Write Files.csv
    with open('Files.csv', 'w', newline='') as csvfile:
        csvwriter = csv.writer(csvfile)
        csvwriter.writerow(['SourcePath', 'DestinationPath'])
        for source_path, dest_path in file_data:
            csvwriter.writerow([source_path, dest_path])

if __name__=="__main__":
    parser = argparse.ArgumentParser(description="Enable, disable, or generate inventory for Bary tokens based on the given flock_id")
    parser.add_argument('action', choices=['enable', 'disable', 'inventory'], help='Action to perform.')
    parser.add_argument('Bary_web_hash', help='The unique hash of the Bary tools web console.')
    parser.add_argument('flock_id', help='The flock_id to use.')
    parser.add_argument('auth_token', help='The authentication token.')

    args = parser.parse_args()

    flock_id = args.flock_id
    action = args.action
    flock_id_value = flock_id.split(":")[1]
    filename = f"{flock_id_value}_{action}_output.csv"
    auth_token = args.auth_token
    Bary_web_hash = args.Bary_web_hash

    results = fetch(auth_token, Bary_web_hash)

    if args.action == "enable":
        enable(filename, results, auth_token, Bary_web_hash)
    elif args.action == "disable":
        disable(filename, results, auth_token, Bary_web_hash)
    elif args.action == "inventory":
        generate_inventory(results)
