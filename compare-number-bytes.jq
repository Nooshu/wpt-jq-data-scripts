#!/usr/bin/env jq -srMf

## Combine 2 JSON files and extract info we need

# Headers for resulting CSV
["Type", "Before", "After"],
  (
    # combine 2 json files into a single array
    [.[0],.[1]] |
    [
      # pull out the 2 sets of data we want to combine
      .[].data.median.firstView.breakdown
      # convert into key / values and unwrap
      | to_entries[]
    ]
    # group the 2 sets of data into arrays by examining the keys (html with html, css with css etc)
    | group_by(.key)
    # reduce the array of arrays, start with an empty object and pull out the key from the
    # first object, then include the values from the other objects
    | reduce .[] as $g ({}; .[$g[0].key] = [$g[].value] )
    # convert into key / values and unwrap
    | to_entries[]
    # pull out the data we want in the CSV
    | [.key, .value[].bytes]
  )
  # format as a CSV
  | @csv
