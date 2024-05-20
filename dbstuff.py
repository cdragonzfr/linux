import pandas as pd

# Function to manipulate the CSV file
def manipulate_csv(input_csv, output_csv):
    # Read the input CSV file
    df = pd.read_csv(input_csv)

    # Create a new DataFrame with the desired columns
    new_df = pd.DataFrame()
    new_df['A'] = ['DB50'] * len(df)  # Column A with a constant value 'DB50'
    new_df['B'] = df['Code']  # Column B with the 'Code' from the input CSV
    new_df['C'] = df['Action Name']  # Column C with the 'Action Name' from the input CSV

    # Column D with the expression 'Action_Name = "Action Name from C"'
    new_df['D'] = 'Action_Name = "' + df['Action Name'] + '"'

    # Save the new DataFrame to the output CSV file
    new_df.to_csv(output_csv, index=False)

# Example usage
input_csv = 'input.csv'  # Replace with your input CSV file path
output_csv = 'output.csv'  # Replace with your desired output CSV file path
manipulate_csv(input_csv, output_csv)

print(f"New CSV file has been saved as {output_csv}")
