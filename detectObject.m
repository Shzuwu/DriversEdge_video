%%
% Detect the ball in the current video frame.
function [detectionsave, areasave, isObjectDetected, utilities] = detectObject(utilities, frame)
  utilities.foregroundMask = step(utilities.foregroundDetector, frame);
  [area,detection] = step(utilities.blobAnalyzer, utilities.foregroundMask);
   
  utilities.opticalMask1 = step(utilities.opticalFlow1,frame);
  utilities.opticalMask1 = utilities.opticalMask1 > .000001;

 
  
  
  center  = step(utilities.blobA, utilities.opticalMask1);
  N=size(center,1);
  j=1;
    if ~isempty(center) && ~isempty(detection)
  while j<=N
    i=1;    
  while i<=M      
      dist=pdist2(detection(i,:),center(j,:));
      if dist<100
         detectionsave=[detectionsave;detection(i,:)];
         areasave=[areasave;area(i)];
      end
      i=i+1;
  end
  j=j+1;
  end
    end

  
  %[maxarea,I]=max(area);
  if isempty(detectionsave)
    isObjectDetected = false;
  else
    % To simplify the tracking process, only use the first detected object.
    % detection=detection(I(1),:);
    %detection=detection(I,:);
    isObjectDetected = true;
  end
end
