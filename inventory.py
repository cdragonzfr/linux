import requests, csv, argparse


# This will fetch all the Bary tokens that are a part of the particular flock ID specified

def fetch(auth_token, Bary_web_hash):
  fetch_url = f'https://{Bary_web_hash}.Bary.tools/api/v1/Barytokens/fetch'
  fetch_payload = {
    'auth_token': auth_token,
    'flock_id':   flock_id
    }
  response = requests.get(fetch_url, params=fetch_payload, verify=False)
  results = response.json()
  return results


# This will enable all the Bary tokens for the particular flock ID specified

def enable(filename, results, auth_token, Bary_web_hash):
  enable_url = f'https://{Bary_web_hash}.Bary.tools/api/v1/Barytoken/enable'
  
  # This will write a file detailing all the tokens that are being enabled.
  
  with open(filename, 'w', newline='') as csvfile:
    csvwriter = csv.writer(csvfile, delimiter="|", quotechar='"', quoting=csv.QUOTE_MINIMAL)
    
    # Writer Header
    
    csvwriter.writerow(["Flock ID", "Bary Token ID", "Enabled", "Result", "Type", "Memo"])
    
    
    for item in results['tokens']:
        flock_id = item['flock_id']
        Barytoken = item['Barytoken']
        enabled = item['enabled']
        kind = item['kind']
        memo = item.get('memo', '').replace(',', ';')
            
        enable_payload = {
            'auth_token': auth_token,
            'Barytoken': Barytoken
        }
        
        enable_response = requests.post(enable_url, params=enable_payload, verify=False)
        enable_results = enable_response.json()
        result = enable_results['result']
        csvwriter.writerow([flock_id, Barytoken, enabled, result, kind, memo])
  
# This will disable all the Bary tokens for the particular flock ID specified

def disable(filename, results, auth_token, Bary_web_hash):
  disable_url = f'https://{Bary_web_hash}.Bary.tools/api/v1/Barytoken/disable'
  
    # This will write a file detailing all the tokens that are being disabled.
  
  with open(filename, 'w', newline='') as csvfile:
    csvwriter = csv.writer(csvfile, delimiter="|", quotechar='"', quoting=csv.QUOTE_MINIMAL)
    
    # Writer Header
    
    csvwriter.writerow(["Flock ID", "Bary Token ID", "Enabled", "Result", "Type", "Memo"])
    
    
    for item in results['tokens']:
        flock_id = item['flock_id']
        Barytoken = item['Barytoken']
        enabled = item['enabled']
        kind = item['kind']
        memo = item.get('memo', '').replace(',', ';')
            
        disable_payload = {
            'auth_token': auth_token,
            'Barytoken': Barytoken
        }
        
        disable_response = requests.post(disable_url, params=disable_payload, verify=False)
        disable_results = disable_response.json()
        result = disable_results['result']
        csvwriter.writerow([flock_id, Barytoken, enabled, result, kind, memo])

if __name__=="__main__":
  parser = argparse.ArgumentParser(description="Enable or disable Bary tokens based on the given flock_id")
  parser.add_argument('action', choices=['enable', 'disable'], help='Action to perform (enable or disable).')
  parser.add_argument('Bary_web_hash', help='The unique hash of the Bary tools web console  e.g., 9a342ab23')
  parser.add_argument('flock_id', help='The flock_id to use.')
  parser.add_argument('auth_token', help='The authentication token.')
  
  args = parser.parse_args()

  flock_id = args.flock_id
  action = args.action
  flock_id_value = flock_id.split(":")[1]
  filename = f"{flock_id_value}_{action}_output.csv"
  auth_token = args.auth_token
  Bary_web_hash = args.Bary_web_hash

  
  if args.action == "enable":
    results = fetch(auth_token, Bary_web_hash)
    enable(filename, results, auth_token, Bary_web_hash)
  
  if args.action == "disable":
    results = fetch(auth_token, Bary_web_hash)
    disable(filename, results, auth_token, Bary_web_hash)
 
