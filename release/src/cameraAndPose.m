function [camera, pose] = cameraAndPose(pose)
% Inputs:   pose - Structure containing 2D annotations and algorithm
%                  parameters. See recon3DPose.m
%
% Outputs:  camera - Structure with estimated camera parameters.
%           pose   - Structure with estimated 3D pose.
%
% Reconstructs the 3D Pose of a human figure given the locations of the 2D
% anatomical landmarks.
% Copyright (C) 2012  Varun Ramakrishna.
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

% Compute lengths and skeleton connectivity matrix.
pose = getLimbLengths(pose);

%% Initialization
% Scale input so that K = eye(3).
pose = scaleInput(pose);

% Reshape Basis
pose = reshapeBasis(pose);

% Estimate initial cameras
rigidInds = [1 2 5 8]; % Use rigid landmarks to estimate initial cam.
xyMissing = pose.xyh(:,rigidInds);
XMissing  = pose.Xmu(rigidInds,1:3);
[camera]  = estimateWPCamera(xyMissing',XMissing);

%Assemble projection matrix
Msub = kron(eye(length(pose.annoids),length(pose.annoids)),camera.M);
Mmu = Msub*pose.mureVis;
xyt = pose.xyvisible(:) - kron(ones(length(pose.annoids),1),camera.taff);
res = xyt - Mmu;

%% Projected Matching Pursuit
selectIdx = [];
pose.numIters = 0;
pose.repErr = inf;
while (pose.repErr> pose.tol1 && length(selectIdx) < pose.ks)
    
    %Pick best basis vector
    A = Msub*pose.BreVis;
    A(:,selectIdx) = NaN;
    lambdas = res'*A;
    [~,imax] = max(abs(lambdas));
    
    % Add basis to collection
    selectIdx = [selectIdx imax];
    pose.selectIdx = selectIdx;
    
    % Minimize reconstruction error and compute residual
    [camera, pose, res] = minimizeReconError(pose, camera);
    Msub = kron(eye(length(pose.annoids),length(pose.annoids)),camera.M);
end

end



function pose = scaleInput(pose)
% Helper function to scale input so that K = eye(3)
pose.xyunscaled = pose.xy;
pose.xyh        = pose.K\pose.xy;
pose.xyvisible  = pose.xyh(1:2,pose.annoids);
end


function pose = reshapeBasis(pose)
% Helper function to reshape basis

Bnew=[];
for i =1:size(pose.BOMP,2);
    Bnew =cat(3,Bnew,reshape(pose.BOMP(:,i),pose.numPoints,3));
end
pose.Breshaped = Bnew;
pose.mur = reshape(pose.mu,pose.numPoints,3);
pose.Bfull = pose.BOMP;
[pose.Bre,pose.mure] = reArrangeBasis(pose.BOMP,pose.mu,pose.numPoints);

pose.BreTensor  = reshape(pose.Bre,3,pose.numPoints,[]);
pose.mureTensor = reshape(pose.mure,3,pose.numPoints,[]);
pose.mureVis    = pose.mureTensor(:,pose.annoids);
pose.mureVis    = pose.mureVis(:);
pose.BreVis     = pose.BreTensor(:,pose.annoids,:);
pose.BreVis     = reshape(pose.BreVis, 3*length(pose.annoids),[]);

end

function pose = getLimbLengths(pose)
% Helper function to compute limblengths.

connect         = skelConnectionMatrix(pose.skel);
[pose.I,pose.J] = ind2sub(size(connect), find(connect));
Xmu             = reshape(pose.mu,pose.numPoints,3);
Xmu             = [Xmu ones(length(pose.xy),1)];
pose.lengths    = squareform(pdist(Xmu));
pose.Xmu        = Xmu;
pose.lengths    = squareform(pdist(Xmu));

end


function [camera,pose,res] = minimizeReconError(pose,camera)
selectIdx = pose.selectIdx;
optType = pose.optType;
mur = pose.mur;
I = pose.I;
J  = pose.J;
lengths = pose.lengths;
Bnew = pose.Breshaped;
xyvisible = pose.xyvisible;
B = pose.Bfull;
annoids = pose.annoids;
epsxy  = inf;
xyprev = zeros(2,pose.numPoints);
numIters = 0;
while(epsxy>pose.tol2 && numIters < pose.numIters2)
        Msub = kron(eye(length(annoids),length(annoids)),camera.M);
        A = Msub*pose.BreVis(:,selectIdx);
        b = xyvisible(:) - kron(ones(length(annoids),1),camera.taff) - kron(eye(length(annoids),length(annoids)),camera.M)*pose.mureVis;
        %% Equality constrained
        switch optType
            case 1
                C = [];
                d = [];
                alphasq = 0;
                for i = 1:length(I)
                    if(length(selectIdx)>1)
                        Bi = (squeeze(Bnew(I(i),:,selectIdx)));
                        Bj = (squeeze(Bnew(J(i),:,selectIdx)));
                    else
                        
                        Bi = (squeeze(Bnew(I(i),:,selectIdx)))';
                        Bj = (squeeze(Bnew(J(i),:,selectIdx)))';
                    end
                    mui = mur(I(i),:)';
                    muj = mur(J(i),:)';
                    C = [C; (Bi-Bj)] ;
                    d = [d; -(mui-muj)];
                    alphasq = alphasq + lengths(I(i),J(i))^2;
                end
                alpha = sqrt(alphasq);
                %                 alpha = sqrt(pose.lengthsum);
                [a,asolT] = leastsquareseqcon3(A,b,C,d,alpha);
                asol = asolT';
                
        end
        
        Xnew = B(:,selectIdx)*asol + pose.mu;
        XnewR= reshape(Xnew,pose.numPoints,3);
        pose.Xnew = Xnew;
        pose.XnewR = XnewR;
        pose.XnewRt = XnewR';
        pose.Xnewre = pose.XnewRt(:);
        pose.XnewreVis = pose.XnewRt(:,annoids);
        pose.XnewreVis = pose.XnewreVis(:);
        
        XMissing=XnewR(annoids,:);
        xyMissing = xyvisible;
        pose.asol = asol;
        pose.selectIdx = selectIdx;
        
        xyrep1 = projectIntoAffineCam(XnewR,pose.K,camera.R,camera.t,camera.S,pose.skel);
        repErr1 = sum(sum((xyrep1(1:2,annoids)-pose.xyunscaled(1:2,annoids)).^2,1));
        
        %Estimate camera
        [cameraHyp]= estimateWPCamera(xyMissing',XMissing);
        
        %Compute reprojection error
        xyrep2 = projectIntoAffineCam(XnewR,pose.K,cameraHyp.R,cameraHyp.t,cameraHyp.S,pose.skel);
        repErr2 = sum(sum((xyrep2(1:2,annoids)-pose.xyunscaled(1:2,annoids)).^2,1));
        
        
        camera =cameraHyp;
        xyrep = xyrep2;
        repErr = repErr2;

        epsxy = sum(sum((xyrep(1:2,annoids)-xyprev(1:2,annoids)).^2,1));
        xyprev = xyrep;
        pose.repErr = repErr;
        
        % Visualize
        if(pose.viz)
            figure(4);clf;
            pointsVisualize(XnewR,pose.skel,'texton',0);hold on;
            drawCam(cameraHyp.R,cameraHyp.t,'gt',1);
     
            figure(3);clf;
            imshow(pose.im);hold on;
            plot2Dskeleton(xyrep',pose.skel,1,'texton',0);
            hold on;
            plot2Dskeleton(pose.xyunscaled',pose.skel,1,'texton',0,'gt',1);
            axis ij;
        end
        
        numIters = numIters + 1;
        pose.numIters = pose.numIters +1;
end

res = xyvisible(:) - kron(ones(length(annoids),1),camera.taff) - kron(eye(length(annoids),length(annoids)),camera.M)*pose.XnewreVis;
res = res- ((kron(eye(length(annoids),length(annoids)),camera.M))*B(:,selectIdx))*((kron(eye(length(annoids),length(annoids)),camera.M))*B(:,selectIdx))'*res;
end