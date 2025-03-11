function [pjAngles]=calculate_ProjectionOnSphere(receiverCenter)
addpath (genpath('C:\Program Files\MATLAB\R2022b\toolbox\map'))

% Room geometry vertices
roomGeometryVertices=...
[5.5200         0         0
      0         0         0
      0    5.1000         0
 6.2100    4.0200         0
      0         0    3.3000
 5.5200         0    3.3000
      0    5.1000    3.3000
 6.2100    4.0200    3.3000];

% Define edges of the room
edges = [
    1, 2; 2, 3; 3, 4; 4, 1; % Floor edges
    5, 6; 6, 8; 8, 7; 7, 5; % Ceiling edges
    1, 6; 2, 5; 3, 7; 4, 8  % Vertical edges
];

% Receiver position
% receiverCenter = [2,2.5,1.6];
sphereRadius = 0.049; % Radius of the projection sphere

% Figure setup
% figure;
% hold on;
% grid on;
% xlabel('X');
% ylabel('Y');
% zlabel('Z');
% title('Room Edges Projected onto Sphere');

% % Plot original room edges
% for k = 1:size(edges, 1)
%     v1 = roomGeometryVertices(edges(k, 1), :);
%     v2 = roomGeometryVertices(edges(k, 2), :);
%     plot3([v1(1), v2(1)], [v1(2), v2(2)], [v1(3), v2(3)], 'k', 'LineWidth', 1, 'DisplayName', 'Room Edges');
% end
% 
% % Plot receiver position
% scatter3(receiverCenter(1), receiverCenter(2), receiverCenter(3), 30, 'b', 'filled', 'DisplayName', 'Receiver');

% Project and plot edges on sphere using great-circle interpolation
nPoints = 50; % Number of interpolation points along each great-circle arc
for k = 1:size(edges, 1)
    % Get the two endpoints of the edge
    v1 = roomGeometryVertices(edges(k, 1), :) - receiverCenter;
    v2 = roomGeometryVertices(edges(k, 2), :) - receiverCenter;
    
    % Normalize both endpoints to lie on the sphere
    v1 = (v1 / norm(v1)) * sphereRadius;
    v2 = (v2 / norm(v2)) * sphereRadius;
    
    % Compute great-circle interpolation between v1 and v2
    t = linspace(0, 1, nPoints);
    arcPoints = zeros(nPoints, 3);
    
    for n = 1:nPoints
        % Spherical linear interpolation (SLERP)
        omega = acos(dot(v1, v2) / (norm(v1) * norm(v2))); % Angle between vectors
        arcPoints(n, :) = (sin((1 - t(n)) * omega) * v1 + sin(t(n) * omega) * v2) / sin(omega);
    end
    
    % Shift back to receiver position
    arcPoints = arcPoints + receiverCenter;
    
    % Plot the arc
%     plot3(arcPoints(:, 1), arcPoints(:, 2), arcPoints(:, 3), 'r', 'LineWidth', 1.5, 'DisplayName', 'Projected Edges');
    arcPointsAllEdges(k,:,:)=arcPoints;

end

% Plot sphere
[X, Y, Z] = sphere(50);
X = X * sphereRadius + receiverCenter(1);
Y = Y * sphereRadius + receiverCenter(2);
Z = Z * sphereRadius + receiverCenter(3);
% surf(X, Y, Z, 'FaceAlpha', 0.3, 'EdgeColor', 'none');
% view(45, 45)

% legend;
% axis equal;
% hold off;

for k = 1:size(edges, 1)
for n = 1:nPoints
    x = arcPointsAllEdges(k,n, 1) - receiverCenter(1);
    y = arcPointsAllEdges(k,n, 2) - receiverCenter(2);
    z = arcPointsAllEdges(k,n, 3) - receiverCenter(3);
    
    % Convert to spherical coordinates
    r = sqrt(x^2 + y^2 + z^2);
    phi(k,n) = atan2(y, x);  % Azimuth angle (longitude)
    theta(k,n) = asin(z / r);     % Elevation angle (latitude)

end
end
pjAngles=[reshape(theta,1,[])*180/pi;-reshape(phi,1,[])*180/pi+180];

% figure
% axesm('MapProjection', 'robinson', 'Frame', 'on', 'Grid', 'off');
% scatterm(reshape(theta,1,[])*180/pi, reshape(phi,1,[])*180/pi,10,'r',"filled")
% title('Room Edges Projected onto Sphere');


% min(reshape(phi,1,[])*180/pi)
% max(reshape(phi,1,[])*180/pi)
% 












