function gaussianMan = visualizeGaussianModel(vals,skel,varargin)

[color,type,person,connect]=process_options(varargin,'color','r','type',1,'person',1,'connect',[]);

for i =1:size(vals,1)
    strs{i}={int2str(i)};
end
if isempty(connect)
    connect = skelConnectionMatrix(skel);
end

indices = find(connect);
[I, J] = ind2sub(size(connect), indices);
handle(1) = plot3(vals(:, 1), vals(:, 3), vals(:, 2), '.');
axis ij % make sure the left is on the left.
set(handle(1), 'markersize', 1);
hold on
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
            colors(6,:); colors(6,:); colors(6,:); colors(5,:); colors(5,:); colors(5,:);...
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



if(type<4)
    for i = 1:length(indices)
        P1 = [vals(I(i),1) vals(I(i),3) vals(I(i),2)];
        P2 = [vals(J(i),1) vals(J(i),3) vals(J(i),2)];
        P = 0.5*(P1 + P2);
        U = [ null(P1 - P2)'; (P1 -P2)/norm(P1-P2)];
        S = eye(3); S(1,1) = 1.5*norm(P1-P2);
        C = U*S*U';
        [x,y,z] = ellipsoid(0,0,0,0.8,0.8,1.1*sqrt(1.5*norm(P1-P2)),8);
        axis equal;
        xv =x(:);
        yv = y(:);
        zv = z(:);
        newXYZ = U'*[xv';yv';zv'];
        xnew = reshape(newXYZ(1,:)+P(1),size(x,1),size(x,2));
        ynew = reshape(newXYZ(2,:)+P(2),size(x,1),size(x,2));
        znew = reshape(newXYZ(3,:)+P(3),size(x,1),size(x,2));

        
        handle(i+1) = patch(surf2patch(xnew,ynew,znew));

        set(handle(i+1),'EdgeColor','k','EdgeAlpha',0.1);
        set(handle(i+1),'FaceLighting','phong','AmbientStrength',0.6);
        set(handle(i+1),'FaceColor', M(i,:));  
        set(handle(i+1),'BackfaceLighting','lit');
        
        gaussianMan(i).P = P;
        gaussianMan(i).C = C;
        
    end
    axis equal
  
else
    

    
end

axis on
hold off



