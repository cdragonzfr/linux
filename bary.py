import requests, argparse

def edit_token(auth_token, tokens, old_hostname, old_ip, new_hostname, new_ip):
    for item in tokens:
        memo = item.get('memo', '')
        parts = memo.split(',')

        # Check if this token matches the old hostname and IP
        if len(parts) >= 3 and parts[0] == old_hostname and parts[1] == old_ip:
            # Update hostname and IP in the memo
            parts[0] = new_hostname
            parts[1] = new_ip
            new_memo = ','.join(parts)

            # POST request to update the token
            url = 'https://EXAMPLE.canary.tools/api/v1/canarytoken/update'
            payload = {
                'auth_token': auth_token,
                'canarytoken': item['Barytoken'],  # Assuming this is the token ID
                'memo': new_memo
            }
            r = requests.post(url, data=payload)
            print(r.json())

# Argument parser setup
parser = argparse.ArgumentParser(description="Edit token information.")
parser.add_argument('action', choices=['edit'], help='Edit token information.')
parser.add_argument('--auth_token', help='The authentication token.', required=True)
# Assuming results are obtained from elsewhere
# results = ...

args = parser.parse_args()

if args.action == 'edit':
    old_hostname = input("Enter the original hostname: ")
    old_ip = input("Enter the original IP address: ")
    new_hostname = input("Enter the new hostname: ")
    new_ip = input("Enter the new IP address: ")

    edit_token(args.auth_token, results['tokens'], old_hostname, old_ip, new_hostname, new_ip)
