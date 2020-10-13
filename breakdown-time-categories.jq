#!/usr/bin/env jq -rMf

# Pull out the processing categories info
# https://github.com/WPO-Foundation/webpagetest/blob/3de67b54c58127faa66038cccc07ed3883845727/www/breakdownTimeline.php#L56

# Headers for resulting CSV
["Category", "Time (ms)"],
  (
    # examine the cpu times on the median run
    .data.median.firstView.cpuTimes
    # loop over all times and store a total (used when calculating 'other')
    | ([keys[] as $k | .[$k]] | add) as $total
    # define our resulting object, pulling out metrics into certain categories (see WPT code example above)
    | {
        "Layout": {
          "Layout", "UpdateLayoutTree", "RecalculateStyles", "ParseAuthorStyleSheet", "ScheduleStyleRecalculation", "InvalidateLayout"
        },
        "Scripting": {
          "EvaluateScript","v8.compile", "FunctionCall", "GCEvent", "TimerFire", "EventDispatch", "TimerInstall", "TimerRemove", "XHRLoad", "XHRReadyStateChange", "MinorGC", "MajorGC", "FireAnimationFrame", "ThreadState::completeSweep", "Heap::collectGarbage", "ThreadState::performIdleLazySweep"
        },
        "Painting": {
          "Paint","DecodeImage","ResizeImage","CompositeLayers","Rasterize","PaintImage","PaintSetup","ImageDecodeTask","GPUTask","SetLayerTreeId","layerId","UpdateLayer","UpdateLayerTree","Draw LazyPixelRef","Decode LazyPixelRef"
        },
        "Loading": {
          "ParseHTML","ResourceReceivedData","ResourceReceiveResponse","ResourceSendRequest","ResourceFinish","CommitLoad"
        },
        "Idle": {
          "Idle"
        }
      # save this object for later
      } as $obj
    # minus the values of all other categories from the total to find a value for other
    | ($total - ([ $obj | to_entries[] | (.value | .. | add?)] | add)) as $other
    # calculate the values and add on the 'other' category at the end
    | ($obj | to_entries[] | [.key, (.value | .. | add?)]),["Other", $other]
  )
  # format as a CSV
  | @csv
