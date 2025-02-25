import requests
import pandas as pd

def create_tokens_from_excel(auth_token, flock_id, excel_file):
    # Read the Excel file
    df = pd.read_excel(excel_file, usecols=['memo', 'token_type'])
    
    # URL for creating tokens
    url = "https://EXAMPLE.canary.tools/api/v1/canarytoken/create"
    
    for index, row in df.iterrows():
        memo = row['memo']
        token_type = row['token_type']

        # Define the request payload
        payload = {
            'auth_token': auth_token,
            'memo': memo,
            'kind': token_type,  # 'kind' corresponds to token_type
            'flock_id': flock_id
        }

        # Perform the POST request
        try:
            response = requests.post(url, data=payload)
            response_json = response.json()
            print(f"Row {index}: {response_json}")  # Output API response for debugging
        except requests.RequestException as e:
            print(f"Error processing row {index}: {e}")


parser.add_argument('--excel_file', help="Path to the Excel file for creating tokens.", default=None)


if args.action == 'create':
    if not args.excel_file:
        print("Error: --excel_file must be provided when using 'create'.")
    elif not args.flock_id:
        print("Error: --flock_id is required to create tokens.")
    else:
        create_tokens_from_excel(args.auth_token, args.flock_id, args.excel_file)


python script.py create --auth_token YOUR_AUTH_TOKEN --flock_id YOUR_FLOCK_ID --excel_file tokens.xlsx
