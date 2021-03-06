#!/usr/bin/env jq -rMf

# Extract the number of bytes from each domain from the median run

# Headers for resulting CSV
["Domain", "Bytes"],
  (
    # drill down into the median views domain data
    .data.median.firstView.domains
    # convert object into array with inner key and value keys
    | to_entries[]
    # pull out the data we want in the CSV
    | [.key, .value.bytes]
  )
  # output in CSV format
  | @csv
