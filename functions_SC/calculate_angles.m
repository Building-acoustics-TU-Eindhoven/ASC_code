%% To generate angles around zero angle
function [phi_angles,theta_angles] = calculate_angles(dr)
nCircle=3;
for iCircle=1:nCircle
thisdr=iCircle/nCircle*dr;
num_points = 6*iCircle;
% Initialize arrays for the points
theta_angles = linspace(0, 2*pi, num_points + 1); % +1 to complete the circle
theta_angles(end) = []; % remove the last point to avoid duplication
% Calculate the Cartesian coordinates of the points
phi_angles = thisdr * cos(theta_angles);
theta_angles = thisdr * sin(theta_angles);
eval(['phi_angles_' num2str(iCircle) ' = phi_angles;']);
eval(['theta_angles_' num2str(iCircle) ' = theta_angles;']);
end
phi_angles=[phi_angles_1,phi_angles_2,phi_angles_3];
theta_angles=[theta_angles_1,theta_angles_2,theta_angles_3];
end