function [hSkel,hSkelText] =plot2Dskeleton(xy,skel,type,varargin)
%PLOT2DSKELETON  Plots projection of skeleton
%    plot2Dskeleton(xy,skel)
%
%   Description:
%
%
%   Inputs:
%
%
%   Outputs:
%
%
%   Example:
%     plot2Dskeleton
%
%   See also

% Author: Varun Ramakrishna
% Created: Jan 31, 2011
xy=xy';
[texton,linewidth,gt,hparent] = process_options(varargin,'texton',1,'linewidth',2,'gt',0,'Parent',gca);
numPts=size(xy,2);
for i =1:numPts
    strs{i}={int2str(i)};
end


connect = skelConnectionMatrix(skel);
indices = find(connect);
[I, J] = ind2sub(size(connect), indices);

% gca; hold on;

%figure
% hold on;
% plot(xy(1,:),xy(2,:),'o','LineWidth',linewidth,'MarkerSize',5);


colors=prism(6);
if(type==2)
    M=[ colors(4:6,:); ...
        colors(4:6,:); ...
        colors(6,:); colors(6,:); colors(6,:); colors(5,:); colors(6,:); ...
        colors(1,:); colors(2,:); colors(1,:); ...
        colors(1,:); colors(2,:); colors(1,:); ...
        ];
elseif(type==1)
    M= [colors(4:6,:); colors(1,:); ...
        colors(4:6,:); colors(1,:); ...
        colors(6,:); colors(6,:); colors(6,:); colors(5,:); colors(5,:); colors(5,:);...
        colors(1,:); colors(2,:); colors(1,:); colors(4,:); ...
        colors(1,:); colors(2,:); colors(1,:); colors(4,:);...
        ];
elseif(type==3)
    M=[ colors(4:6,:); ...
        colors(4:6,:); ...
        colors(6,:); colors(6,:); colors(6,:); colors(5,:); colors(6,:); ...
        colors(1,:); colors(2,:); colors(1,:); ...
        colors(1,:);
        ];
end

if(texton)
    for i =1:size(xy,2)
        hSkelText(i) = text(xy(1,i),xy(2,i),strs{i});
    end
end
xy=xy';
% axis equal
hold on;

for i = 1:length(indices)
    if(gt)
        
    hSkel(i) = line([xy(I(i),1) xy(J(i),1)], ...
        [xy(I(i),2) xy(J(i),2)],'color','k','Parent',hparent);
    set(hSkel(i), 'linewidth', linewidth,'LineStyle','--');
    else
        
    hSkel(i) = line([xy(I(i),1) xy(J(i),1)], ...
        [xy(I(i),2) xy(J(i),2)],'color',M(i,:),'Parent',hparent);
    set(hSkel(i), 'linewidth', linewidth);
    end
end
