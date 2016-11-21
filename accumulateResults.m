%%
% Accumulate video frames, detected locations, and tracked locations to
% show the trajectory of the ball.
function accumulateResults(utilities,frame,detectedLocation,trackedLocation)
  utilities.accumulatedImage      = max(utilities.accumulatedImage, frame);
  utilities.accumulatedDetections ...
    = [utilities.accumulatedDetections; detectedLocation];
  utilities.accumulatedTrackings  ...
    = [utilities.accumulatedTrackings; trackedLocation];
end