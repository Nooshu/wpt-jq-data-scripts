#!/usr/bin/env jq -rMf

# jq script to generate a basic text based schema. This can be modified to work with any API response

# decend into the data
.data
  # recursively decent into the large structure and extracting all the paths
  | path(..)
  # map the array into a new array and convert paths to strings
  | map(tostring)
  # join each string together with a forward slash
  | join ("/")
