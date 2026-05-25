% =========================================================================
% Ridge Waveguide User Input & Simulation
% =========================================================================

n1 = 1.4;          % Substrate
n2 = 1.464;        % Core
n3 = 1.00;         % Cladding (air) 

rh = 5;            % Waveguide height
rw = 7;            % Waveguide Width

h1 = 8;            % Substrate Height
h2 = rh;           % Core material height
h3 = 8;            % Upper cladding Height

side = 5;          % Space on side

lambda = 1.55;    

% Solver Config
dx = 0.125;        
dy = 0.125;        
nmodes = 4;        

boundary_cond = '0000'; 

%% ---- Geometry Mesh Generation ----
[x,y,xc,yc,nx,ny,eps,edges] = waveguidemeshfull([n1,n2,n3], [h1,h2,h3], ...
                                                rh, rw, side, dx, dy); 

%% View Material index(confirm your geo)
n_profile = sqrt(eps);
figure('Name', 'Refractive Index Profile Validation', 'NumberTitle', 'off', 'Position', [100, 600, 600, 450]);
contourf(xc, yc, n_profile', 20, 'LineColor', 'none'); 
colormap(parula); 
colorbar;
axis image; 
title('Refractive Index Distribution (n)'); xlabel('x (\mu m)'); ylabel('y (\mu m)'); 
hold on; 
for v = edges
    line(v{:}, 'Color', 'r', 'LineWidth', 1.5, 'LineStyle', '--'); 
end
hold off;
%% Calculate Raw H-fields and neff 
[Hx, Hy, neff] = wgmodes(lambda, n2, nmodes, dx, dy, eps, boundary_cond);

%% Store
% Initialize an empty structure array to hold the calculated mode data
modes_data = struct();

for m = 1:nmodes
    % Process raw vertex H-fields into centered E/H fields for the m-th mode
    [Hz_c, Ex_c, Ey_c, Ez_c] = postprocess(lambda, neff(m), Hx(:,:,m), Hy(:,:,m), dx, dy, eps, boundary_cond);
    
    % Store arrays inside the structure using the mode index 'm'
    modes_data(m).neff = neff(m);
    modes_data(m).Ex   = Ex_c;
    modes_data(m).Ey   = Ey_c;
end

%% Plot
for m = 1:length(modes_data)
    
    fig_title = sprintf('Mode %d Electric Fields (neff = %.6f)', m, modes_data(m).neff);
    figure('Name', fig_title, 'NumberTitle', 'off', 'Position', [150, 500 - (0*220), 1100, 380]);
    
    % Plot Ex component
    subplot(121);
    contourf(xc, yc, modes_data(m).Ex', 100, 'LineColor', 'none'); 
    shading interp; colormap(jet); colorbar; axis image; 
    title(sprintf('Mode %d: Ex Profile', m)); xlabel('x (\mu m)'); ylabel('y (\mu m)'); 
    hold on; for v = edges, line(v{:}, 'Color', 'w', 'LineWidth', 1.5); end; hold off; 
    
    % Plot Ey component
    subplot(122);
    contourf(xc, yc, modes_data(m).Ey', 100, 'LineColor', 'none'); 
    shading interp; colormap(jet); colorbar; axis image; 
    title(sprintf('Mode %d: Ey Profile', m)); xlabel('x (\mu m)'); ylabel('y (\mu m)'); 
    hold on; for v = edges, line(v{:}, 'Color', 'w', 'LineWidth', 1.5); end; hold off;
end