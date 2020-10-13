#!/usr/bin/env jq -rMf

# jq script to inspect the inner structure of the API and output the data types used

# navigate down into the median firstView data
.data.median.firstView
  # convert an object into an array of objects with a key and a value
  | to_entries
  # define a jq function to rewrite the object into key then examine the type of value it is. Create a new array, running each object through this function
  | def parse_entry: {"key": .key, "value": .value | type}; map(parse_entry)
  # sort result alphabetically by the key name
  | sort_by(.key)
  # convert the array back into an object
  | from_entries
