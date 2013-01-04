function drawCam(R,t,varargin)
[gt]= process_options(varargin,'gt',0);
scale =5;
P = scale*[0 0 0;0.5 0.5 0.8; 0.5 -0.5 0.8; -0.5 0.5 0.8;-0.5 -0.5 0.8];

%P = scale*[0 0 0;0.5 0.5 -0.8; 0.5 -0.5 -0.8; -0.5 0.5 -0.8;-0.5 -0.5 -0.8];

P1=R'*(P'-repmat(t,[1,5]));
%P1=R*P'+repmat(t,[1,5]);
P1=P1';
maxp=max(max(P1));
%axis(2*[-maxp maxp -maxp maxp -maxp maxp]);
if(~gt)
    line([P1(1,1) P1(2,1)],[P1(1,3) P1(2,3)],[P1(1,2) P1(2,2)],'color','k')
    line([P1(1,1) P1(3,1)],[P1(1,3) P1(3,3)],[P1(1,2) P1(3,2)],'color','k')
    line([P1(1,1) P1(4,1)],[P1(1,3) P1(4,3)],[P1(1,2) P1(4,2)],'color','k')
    line([P1(1,1) P1(5,1)],[P1(1,3) P1(5,3)],[P1(1,2) P1(5,2)],'color','k')
    
    line([P1(2,1) P1(3,1)],[P1(2,3) P1(3,3)],[P1(2,2) P1(3,2)],'color','k')
    line([P1(3,1) P1(5,1)],[P1(3,3) P1(5,3)],[P1(3,2) P1(5,2)],'color','k')
    line([P1(5,1) P1(4,1)],[P1(5,3) P1(4,3)],[P1(5,2) P1(4,2)],'color','k')
    line([P1(4,1) P1(2,1)],[P1(4,3) P1(2,3)],[P1(4,2) P1(2,2)],'color','k')
    
    
    cameraPlane =[P1(2,1) P1(2,3) P1(2,2);  P1(4,1) P1(4,3) P1(4,2); P1(3,1) P1(3,3) P1(3,2);P1(5,1) P1(5,3) P1(5,2)];
    faces =[2 1 3 4];
    patch('Vertices',cameraPlane,'Faces',faces,'FaceVertexCData',hsv(6),'FaceColor','k','FaceAlpha',0.1);
else
    line([P1(1,1) P1(2,1)],[P1(1,3) P1(2,3)],[P1(1,2) P1(2,2)],'color','k','LineStyle','--')
    line([P1(1,1) P1(3,1)],[P1(1,3) P1(3,3)],[P1(1,2) P1(3,2)],'color','k','LineStyle','--')
    line([P1(1,1) P1(4,1)],[P1(1,3) P1(4,3)],[P1(1,2) P1(4,2)],'color','k','LineStyle','--')
    line([P1(1,1) P1(5,1)],[P1(1,3) P1(5,3)],[P1(1,2) P1(5,2)],'color','k','LineStyle','--')
    
    line([P1(2,1) P1(3,1)],[P1(2,3) P1(3,3)],[P1(2,2) P1(3,2)],'color','k','LineStyle','--')
    line([P1(3,1) P1(5,1)],[P1(3,3) P1(5,3)],[P1(3,2) P1(5,2)],'color','k','LineStyle','--')
    line([P1(5,1) P1(4,1)],[P1(5,3) P1(4,3)],[P1(5,2) P1(4,2)],'color','k','LineStyle','--')
    line([P1(4,1) P1(2,1)],[P1(4,3) P1(2,3)],[P1(4,2) P1(2,2)],'color','k','LineStyle','--')
    
%     
%     cameraPlane =[P1(2,1) P1(2,3) P1(2,2);  P1(4,1) P1(4,3) P1(4,2); P1(3,1) P1(3,3) P1(3,2);P1(5,1) P1(5,3) P1(5,2)];
%     faces =[2 1 3 4];
%     patch('Vertices',cameraPlane,'Faces',faces,'FaceVertexCData',hsv(6),'FaceColor','k','FaceAlpha',0.05);
    
end


C1=[P1(2,1) P1(2,3) P1(2,2)];
C2=[P1(3,1) P1(3,3) P1(3,2)];
C3=[P1(4,1) P1(4,3) P1(4,2)];
C4=[P1(5,1) P1(5,3) P1(5,2)];

O=[P1(1,1) P1(1,3) P1(1,2)];
Cmid =0.25*(C1+C2+C3+C4);

% Lz = [O; O+0.5*(Cmid-O)];
% Lx = [O; O+0.5*(C2-C1)];
% Ly = [O; O+0.5*(C3-C1)];

Lz = [O; O+0.5*(Cmid-O)];
Lx = [O; O+0.5*(C1-C3)];
Ly = [O; O+0.5*(C1-C2)];

if(~gt)
    
    line(Lz(:,1),Lz(:,2),Lz(:,3),'color','b','linewidth',2)
    line(Lx(:,1),Lx(:,2),Lx(:,3),'color','g','linewidth',2)
    line(Ly(:,1),Ly(:,2),Ly(:,3),'color','r','linewidth',2)
    
else
    line(Lz(:,1),Lz(:,2),Lz(:,3),'color','b','linewidth',1)
    line(Lx(:,1),Lx(:,2),Lx(:,3),'color','g','linewidth',1)
    line(Ly(:,1),Ly(:,2),Ly(:,3),'color','r','linewidth',1)
    
    
    
end

axis tight;