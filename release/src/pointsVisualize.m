function pointsVisualize(vals,skel,varargin)
%function pointsVisualize(vals,skel)
[color,type,person,connect,missing,gt,texton,textsize,linewidth,showlines,marker]=process_options(varargin,'color','r','type',1,'person',1,'connect',[],'missing', [],'gt',0,'texton',1,'textsize',10,'linewidth',5,'showlines',1,'marker','o');

for i =1:size(vals,1)
    strs{i}=num2str(i);
end
if isempty(connect)
    connect = skelConnectionMatrix(skel);
end

indices = find(connect);
[I, J] = ind2sub(size(connect), indices);
%handle(1)=figure;
inds = ones(size(vals,1),1);
inds(missing) = 0;
inds = logical(inds);

handle(1) = plot3(vals(inds, 1), vals(inds, 3), vals(inds, 2), marker, 'LineWidth', linewidth, 'MarkerSize', 5);
hold on;
if(texton)
    for i = 1: length(vals)
        h1 = text( vals(i, 1), vals(i, 3), vals(i, 2),strs{i},'FontSize',textsize,'FontWeight','bold');
    end
end
axis ij % make sure the left is on the left.


grid on

colors=prism(6);
if(type==2)
    M=[ colors(4:6,:); ...
        colors(4:6,:); ...
        colors(6,:); colors(6,:); colors(6,:); colors(5,:); colors(6,:); ...
        colors(1,:); colors(2,:); colors(1,:); ...
        colors(1,:); colors(2,:); colors(1,:); ...
        ];
elseif(type==1)
    if person ==1
        colors=prism(6);
        M= [colors(4:6,:); colors(1,:); ...
            colors(4:6,:); colors(1,:); ...
            colors(6,:); colors(6,:); colors(6,:); colors(5,:); colors(6,:); colors(5,:);...
            colors(1,:); colors(2,:); colors(1,:); colors(4,:); ...
            colors(1,:); colors(2,:); colors(1,:); colors(4,:);...
            ];
    elseif person ==2
        colors =jet(6);
        M= [colors(4:6,:); colors(1,:); ...
            colors(4:6,:); colors(1,:); ...
            colors(6,:); colors(6,:); colors(6,:); colors(5,:); colors(6,:); colors(5,:);...
            colors(1,:); colors(2,:); colors(1,:); colors(4,:); ...
            colors(1,:); colors(2,:); colors(1,:); colors(4,:);...
            ];
        
    end
elseif(type==3)
    M=[ colors(4:6,:); ...
        colors(4:6,:); ...
        colors(6,:); colors(6,:);  colors(6,:); ...
        colors(1,:); colors(2,:); colors(1,:); ...
        colors(1,:); colors(2,:); colors(1,:); ...
        ];
else
    M = repmat(colors(2,:),length(indices),1);
end
if(showlines)
    if(type<4)
        for i = 1:length(indices)
            
            handle(i+1) = line([vals(I(i), 1) vals(J(i), 1)], ...
                [vals(I(i), 3) vals(J(i), 3)], ...
                [vals(I(i), 2) vals(J(i), 2)]);
            missI = logical(length(find(missing == I(i))));
            missJ = logical(length(find(missing == J(i))));
            if(missI || missJ)
                set(handle(i+1), 'linewidth', linewidth,'Color',M(i,:), 'LineStyle', '--');
            elseif(gt)
                set(handle(i+1), 'linewidth', linewidth,'Color','k', 'LineStyle', '--');
            else
                set(handle(i+1), 'linewidth', linewidth,'Color',M(i,:));
            end
        end
        axis equal
    else
        
        for i = 1:length(indices)
            handle(i+1) = line([vals(I(i), 1) vals(J(i), 1)],...
                [vals(I(i), 2) vals(J(i), 2)], ...
                [vals(I(i), 3) vals(J(i), 3)]);
            set(handle(i+1), 'linewidth', 5,'Color',M(i,:));
        end
        axis equal
    end
end

% xlabel('x','Interpreter','latex','fontsize',10);
% ylabel('z','Interpreter','latex','fontsize',10);
% zlabel('y','Interpreter','latex','fontsize',10);



hold off