function [x,y,xc,yc,nx,ny,eps,varargout] = Ridge_Geo(n,h,wg_width,side,dx,dy)

% Hongrui wrote
% This is adapted from Thomas E. Murphy (tem@umd.edu) wg
% It is now customized to simulate a fully etched ridge waveguide
% ---------------------------------------------------------------------
% 
% USAGE:
% 
% [x,y,xc,yc,nx,ny,eps] = waveguidemeshfull(n,h,rh,rw,side,dx,dy)
% [x,y,xc,yc,nx,ny,edges] = waveguidemeshfull(n,h,rh,rw,side,dx,dy)
%
% INPUT
%
% n - refractive index for each layer, a vector [n1,n2]
% h - height of each layer in waveguide, a vector [h1,h2]
% [h1,h2,h3], h1 is sub, h2 is wg_height, h3 is air clad on top
% rw - wg_width
% side - excess space to the right of waveguide
% dx - horizontal grid spacing
% dy - vertical grid spacing
% 
% OUTPUT
% 
% x,y - vectors specifying mesh coordinates
% xc,yc - vectors specifying grid-center coordinates
% nx,ny - size of index mesh
% eps - index mesh (n^2)
% edges - (optional) list of edge coordinates, to be used later
%   with the line() command to plot the waveguide edges
%
% 
if isscalar(side)
  side1 = side;
  side2 = side;
else
  side1 = side(1);
  side2 = side(2);
end

ih = round(h/dy);
irh = round (h(2)/dy);
irw = round (wg_width/dx);
iside1 = round (side1/dx);
iside2 = round (side2/dx);
nlayers = length(h);

nx = irw+iside1+iside2+1; % +1 because the grid is always one more than the segment
ny = sum(ih)+1;

x = dx*(-(irw/2+iside1):1:(irw/2+iside2))';
xc = (x(1:nx-1) + x(2:nx))/2;

y = (0:(ny-1))*dy;
yc = (1:(ny-1))*dy - dy/2;

eps = zeros(nx-1,ny-1); % eps is not defined on the vertice but on the grid, so it is -1

iy = 1;

for jj = 1:nlayers % Paint eps cell row by row from the bottom to the top
  for i = 1:ih(jj)
	eps(:,iy) = n(jj)^2*ones(nx-1,1);
	iy = iy+1;
  end
end

iy = sum(ih)-ih(nlayers);
for i = 1:irh
  eps(1:iside1,iy) = n(nlayers)^2*ones(iside1,1);
  eps(irw+iside1+1:irw+iside1+iside2,iy) = n(nlayers)^2*ones(iside2,1);
  iy = iy-1;
end

nx = length(xc);
ny = length(yc);

if (nargout == 8)
    edges = cell(2, 2); %dim(xy) * number of lines

    % line 1
    edges{1,1} = dx*[-iside1-irw/2,iside2+irw/2];
    edges{2,1} = dy*[ih(1), ih(1)];
    % line 2
    edges{1,2} = dx*[-irw/2,     -irw/2,          irw/2     ,    irw/2];
    edges{2,2} = dy*[ih(1),     ih(1)+irh,        ih(1)+irh,     ih(1)];
    varargout = {edges};
end