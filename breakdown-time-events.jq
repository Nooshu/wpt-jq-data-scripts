#!/usr/bin/env jq -rMf

# Pull out the processing categories info
# https://github.com/WPO-Foundation/webpagetest/blob/3de67b54c58127faa66038cccc07ed3883845727/www/breakdownTimeline.php#L56

# Headers for resulting CSV
["Event", "Time (ms)", "Category"],
  (
    # examine the cpu times on the median run
    .data.median.firstView.cpuTimes
    # define our resulting object, pulling out metrics into certain categories (see WPT code example above)
    | {
        "Layout": {
          "Layout", "UpdateLayoutTree", "RecalculateStyles", "ParseAuthorStyleSheet", "ScheduleStyleRecalculation", "InvalidateLayout"
        },
        "Scripting": {
          "EvaluateScript","v8.compile", "FunctionCall", "GCEvent", "TimerFire", "EventDispatch", "TimerInstall", "TimerRemove", "XHRLoad", "XHRReadyStateChange", "MinorGC","MajorGC", "FireAnimationFrame", "ThreadState::completeSweep", "Heap::collectGarbage", "ThreadState::performIdleLazySweep"
        },
        "Painting": {
          "Paint","DecodeImage","ResizeImage","CompositeLayers","Rasterize","PaintImage","PaintSetup","ImageDecodeTask","GPUTask","SetLayerTreeId","layerId","UpdateLayer","UpdateLayerTree","Draw LazyPixelRef","Decode LazyPixelRef"
        },
        "Loading":{
          "ParseHTML","ResourceReceivedData","ResourceReceiveResponse","ResourceSendRequest","ResourceFinish","CommitLoad"
        },
        "Idle": {
          "Idle"
        }
      }
    # convert to array of key / values, unwrap from array
    | to_entries[]
    # store each of the higher level keys (Layout, Scripting etc)
    | .key as $key
    # look at the original value from first to_entries call
    | .value
    # convert to array of key / values, unwrap from array
    | to_entries[]
    # format the data as we want in the CSV
    | [.key, .value, $key]
  )
  # replace any null values with 0
  | map(if . == null then 0 else . end)
  # format as a CSV
  | @csv
