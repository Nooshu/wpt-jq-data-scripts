#!/usr/bin/env jq -rMf

# Filter to extract DNS, Connect, SSL metrics from WebPageTest run JSON

# Headers for resulting CSV
["DNS", "Connect", "SSL"],
  # drill down into the runs data
  (
  .data.runs
  # convert the run data into an object and drill down into the run request data
  | to_entries[].value.firstView.requests[]
  # only select the request that corresponds to the HTML page (so it has DNS,Connect,SSL data)
  | select(.final_base_page == true)
  # build an array of the resulting data we want in the CSV
  | [(.dns_end - .dns_start), (.connect_end - .connect_start), (.ssl_end - .ssl_start)]
  )
  # pass to the CSV formatter
  | @csv
