%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Demo %%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Reconstructing Example 1');
load example1.mat;
[X, R, t] = recon3DPose(im,xy,'viz',1);
input('Continue?');

disp('Reconstructing Example 2');
load example2.mat;
[X, R, t] = recon3DPose(im,xy,'viz',1);
input('Continue?');

disp('Reconstructing Example 3');
load example3.mat;
[X, R, t] = recon3DPose(im,xy,'viz',1);