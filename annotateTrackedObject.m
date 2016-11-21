%%
% Show the current detection and tracking results.
function annotateTrackedObject(utilities,frame,detectedLocation,trackedLocation,v,h)
  accumulateResults(utilities,frame,detectedLocation,trackedLocation);
  % Combine the foreground mask with the current video frame in order to
  % show the detection result.
  %combinedImage = max(repmat(utilities.foregroundMask, [1,1,3]), step(utilities.videoReaderorig));
  combinedImage = frame;

  if ~isempty(trackedLocation)
    shape = 'circle';
    region = trackedLocation;
    region(:, 3) = 20;
    combinedImage = insertObjectAnnotation(frame, shape, ...
      region, {['car ' num2str(h)]}, 'Color', 'red','FontSize',25,'LineWidth',3);
  end
  writeVideo(v,combinedImage);
  step(utilities.videoPlayer, combinedImage);
end
