grep -oP 'y=\d+/m=\d+/d=\d+/h=\d+|blob_name="[^"]+"' your_log_file.log | \
awk 'NR%2{printf "%s ",$0;next;}1' | \
sort -k3,3n -k5,5n -k7,7n -k9,9n
