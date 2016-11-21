frame            = [];  % A video frame
detectedLocation = []; 
detectedLocation0 = [];% The detected location
detectedLocation1 = [];  % The detected location
detectedLocation2 = [];  % The detected location
detectedLocation3 = [];  % The detected location
detectedLocationtemp = [];
trackedLocation  = [];  % The tracked location
label            = '';  % Label for the ball
utilities        = [];

%%
% The procedure for tracking a single object is shown below.

  % Create utilities used for reading video, detecting moving objects,
  % and displaying the results.
  
  s=3;
  t=0.05;
  param = [];
  param.motionModel           = 'ConstantAcceleration';
  param.initialLocation       = 'Same as first detection';
  param.initialEstimateError  = 1E5 * ones(1, 3);
  param.motionNoise           = s*[25, 10, 1];
  param.measurementNoise      = t*25;
  param.segmentationThreshold = 0.05;
  utilities = createUtilities();
  utilities0 = createUtilities0();
  isTrackInitialized = false;
  v = VideoWriter('kalman_backgroundsubtract.avi');
  close(v);
  open(v);
  
  Vid=VideoReader('IMG_0373.MOV');
  data = read(Vid, Inf);
  n = Vid.NumberOfFrames;
  tl=zeros(n,3);
  h=1;
  i=1;
  flag1=0;
  flag2=0;
  flag3=0;
  flag4=0;
  distemp=0;
  mindistemp=0;
  
  
  while ~isDone(utilities.videoReader)

    frame0 = step(utilities.videoReader);
    frame = step(utilities.videoReaderorig);
    frame1 = frame(:,:,1);
    frame2 = frame(:,:,2);
    frame3 = frame(:,:,3);
    
    %detectedLocation=zeros(3,2);
    
    % Detect the ball.
    detectedLocationavg=[0 0];
    k=0;
    isObjectDetected=zeros(1,3);
    % Detect the ball.
    [detectedLocation, ar, isObjectDetected0,utilities] = detectObject(utilities0,frame0);
    detectedLocation=[];
    area=[];
    [dl, ar, isObjectDetected(1),utilities] = detectObject(utilities,frame1);
    if isObjectDetected(1)
        detectedLocation=[detectedLocation;dl];
        area=[area;ar];
    end
     [dl, ar, isObjectDetected(2),utilities] = detectObject(utilities,frame2);
     if isObjectDetected(2)
        detectedLocation=[detectedLocation;dl];
        area=[area;ar];
    end
      [dl, ar,isObjectDetected(3),utilities] = detectObject(utilities,frame3);
      if isObjectDetected(3)
        detectedLocation=[detectedLocation;dl];
        area=[area;ar];
      end
      
      [maxarea,I]=max(area);
      L=size(detectedLocation,1);
      
      s=sum(isObjectDetected);
      isObjectDetected=isObjectDetected(1)|isObjectDetected(2)|isObjectDetected(3) & isObjectDetected0;
      
      if isObjectDetected && ~isTrackInitialized
          sorted=sortrows([area detectedLocation],1);
          flag2=flag2+1;
          detectedLocationtemp=[detectedLocationtemp;detectedLocation];
          distemp=0;
          mindistemp=0;
      end
      if flag2>1
          distemp=pdist(detectedLocationtemp);
          mindistemp=min(distemp(1:size(distemp,1)));
          flag2=0;
          detectedLocationtemp=[];
      end

    if ~isTrackInitialized 

      if isObjectDetected && s>2 && mindistemp>1
            mindistemp=0;
            flag=0;
            if flag4>0 
            if pdist2(tltemp,detectedLocationavg)>80
                h=h+1;
            end
            end
        detectedLocationavg=detectedLocation(I(1),:);
        initialLocation = computeInitialLocation(param, detectedLocationavg);
        kalmanFilter = configureKalmanFilter(param.motionModel, ...
          initialLocation, param.initialEstimateError, ...
          param.motionNoise, param.measurementNoise);

        isTrackInitialized = true;
        trackedLocation = correct(kalmanFilter, detectedLocationavg);
        tl(i,1:2)=trackedLocation;
        tltemp=trackedLocation;
        tli=i;
        label = 'Initial';
        end

    else
      % Use the Kalman filter to track the ball.
      flag4=1;
      if isObjectDetected && s>2% The ball was detected.
          loc=[tl(i-1,1:2);detectedLocation];
          locdist=pdist(loc);
          [mindist,mn]=min(locdist(1:L));
          if mindist(1)<1
              flag3=flag3+1;
          end
          if flag3<5
          detectedLocationavg=mean(detectedLocation(mn,:),1);
          d=pdist2(tl(i-1,1:2),detectedLocationavg);
          loc1=[tl(i-1,1:2);detectedLocation(I,:)];
          dd=pdist(loc1);
          [maxdist,mx]=max(dd(1:size(I)));
          if mindist(1)<5 && maxdist(1)>150 && flag1
              ddd=pdist2(mean(detectedLocation(mx,:),1),dltemp);
              if ddd > 150
          detectedLocationavg=mean(detectedLocation(mx,:),1);
          dltemp=detectedLocationavg;
              end
          end
        if mindist(1)<5 && maxdist(1)>150 && flag1==0
          detectedLocationavg=mean(detectedLocation(mx,:),1);
          dltemp=detectedLocationavg;
          flag1=1;
        end
        if pdist2(detectedLocationavg,tltemp)>5
        predict(kalmanFilter);
        trackedLocation = correct(kalmanFilter, detectedLocationavg);
        tl(i,1:2)=trackedLocation;
        tli=i;
        label = 'Corrected';
        else
            tltemp=tl(i-1,1:2);
        trackedLocation = [];
        label = '';
        isTrackInitialized = false;
        flag3=0;
        end
          else
        tltemp=tl(i-1,1:2);
        trackedLocation = [];
        label = '';
        isTrackInitialized = false;
        flag3=0;
          end
        % Reduce the measurement noise by calling predict followed by
        % correct.
      else % The ball was missing.
        % Predict the ball's location.
        if flag<=10
        trackedLocation = predict(kalmanFilter);
        tl(i,1:2)=trackedLocation;
        label = 'Predicted';
        flag=flag+1;
        else
        tltemp=tl(i-1,1:2);
        trackedLocation = [];
        label = '';
        isTrackInitialized = false;
        flag1=0;
        end
      end
    end
    
    if isTrackInitialized && i==1
            tl(i,3)=h;
    end
    
    if isTrackInitialized && i>1
        d=pdist2(tl(i-1,1:2),tl(i,1:2));
        if d<100 || (tl(i-1,1)==0 && tl(i-1,2)==0)
            tl(i,3)=h;
        else
            h=h+1;
            tl(i,3)=h;
        end    
    end
    
    annotateTrackedObject(utilities,frame,detectedLocationavg,trackedLocation,v,h);
    i=i+1;
  end % while
  close(v)