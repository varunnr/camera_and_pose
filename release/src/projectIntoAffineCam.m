function xy=projectIntoAffineCam(X, K,R,t,S,skel,varargin )
%xy=projectIntoAffineCam(X, K,R,t,S,skel )
[viz,s]=process_options(varargin,'viz',0,'scale',1);

%% Do projection
numPts =size(X,1);

%Create Affine camera
Raff =[ R(1,:); R(2,:); zeros(1,3)];
taff =K*[ t(1); t(2); 1]; % TODO: z-dim should be scaling
M=K*Raff;


%Project into affine camera
xy = S*M(1:2,:)*X' + repmat(taff(1:2),[1,numPts]);
xy(3,:) = ones(1,size(xy,2));
%% Plot projection

if(viz)
    connect = skelConnectionMatrix(skel);
    indices = find(connect);
    [I, J] = ind2sub(size(connect), indices);
    for i =1:numPts
        strs{i}={int2str(i)};
    end
    
    if(~isempty(skel))
        
        figure
        handle(1)=plot(xy(1,:),xy(2,:),'x');
        hold on
        for i =1:size(xy,2)
            text(xy(1,i),xy(2,i),strs{i});
        end
        axis equal
        hold off
        
        if(K(1,3)>0) &&(K(2,3)>0)
            axis([0 2*K(1,3) 0 2*K(2,3)]);
        end
        axis ij% make sure the left is on the left.
        set(handle(1), 'markersize', 20);
        hold on
        grid on
        for i = 1:length(indices)
            handle(i+1) = line([xy(1,I(i)) xy(1,J(i))], ...
                [xy(2,I(i)) xy(2,J(i))]);
            set(handle(i+1), 'linewidth', 2);
        end
        hold off
    end
end
