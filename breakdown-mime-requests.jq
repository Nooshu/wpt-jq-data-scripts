#!/usr/bin/env jq -rMf

# Extract the number of requests of each mime type from the median run

# Headers for resulting CSV
["Request type", "Number of requests"],
  (
    # drill down into the median views breakdown data
    .data.median.firstView.breakdown
    # convert object into array with inner key and value keys
    | to_entries[]
    # pull out the data we want in the CSV
    | [.key, .value.requests]
  )
  # output in CSV format
  | @csv
