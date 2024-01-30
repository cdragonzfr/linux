grep -oP '(\d{4}-\d{2}-\d{2}).*blob_name="[^"]*/y=\d+/m=\d+/d=\d+/h=\d+/m=\d+"' your_log_file.log | 
awk -F '"' '{print $1, $2}' | 
sort
