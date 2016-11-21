%%
% Create utilities for reading video, detecting moving objects, and
% displaying the results.
function utilities = createUtilities()
  % Create System objects for reading video, displaying video, extracting
  % foreground, and analyzing connected components.
  utilities.videoReaderorig = vision.VideoFileReader('IMG_0373.MOV');
  utilities.videoReader = vision.VideoFileReader('IMG_0373.MOV','ImageColorSpace','Intensity');
  utilities.videoPlayer = vision.VideoPlayer();
  utilities.foregroundDetector = vision.ForegroundDetector(...
    'NumTrainingFrames', 70, 'MinimumBackgroundRatio', 0.15, 'NumGaussians', 2, ...
       'InitialVariance', 'Auto','LearningRate',0.00001);
  utilities.blobAnalyzer = vision.BlobAnalysis('AreaOutputPort', true, ...
    'MinimumBlobArea', 2000, 'CentroidOutputPort', true);

  utilities.accumulatedImage      = 0;
  utilities.accumulatedDetections = zeros(0, 2);
  utilities.accumulatedTrackings  = zeros(0, 2);
  utilities.opticalFlow = vision.OpticalFlow('ReferenceFrameDelay',8);%,...
    %'TemporalGradientFilter','Derivative of Gaussian','GradientSmoothingFilterStandardDeviation',2);
  utilities.opticalFlow1 = vision.OpticalFlow('ReferenceFrameDelay',1);
  utilities.opticalFlow2 = vision.OpticalFlow('ReferenceFrameDelay',10);
  utilities.blobA = vision.BlobAnalysis(...
       'CentroidOutputPort', true, 'AreaOutputPort', false, ...
       'BoundingBoxOutputPort', false,'ExcludeBorderBlobs',true,'MinimumBlobArea', 200,'MaximumCount',500);
end