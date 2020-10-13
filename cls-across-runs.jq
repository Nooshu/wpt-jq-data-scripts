#!/usr/bin/env jq -rMf

# Extract CLS information for each run

# drill down into the runs data
.data.runs
# convert the run data into an object and drill down into the first view data
| to_entries[].value.firstView
# Look at all the layout shift information, unwrap from the array and pull out each score,
# wrap in an array for the CSV formatting (CSV’s require an array an an input)
| [.LayoutShifts[].score]
# pass to the CSV formatter
| @csv
