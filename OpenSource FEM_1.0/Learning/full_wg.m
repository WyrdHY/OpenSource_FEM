% =========================================================================
% Ridge Waveguide User Input
% =========================================================================
n1 = 1.4;          % Substrate
n2 = 1.464;        % Core
n3 = 1.00;         % Cladding (air)

rh = 5;          % Waveguide height
rw = 7;           % Waveguide Width

h1 = 8;           % Substrate Height
h2 = rh;          % Core material height, must be >= rh. if >rh, wg is not fully etched
h3 = 8;           % Upper cladding Height

side = 5;         % Space on side

lambda = 1.55;      
dx = 0.125;        
dy = 0.125;        
resolution = 100;
nmodes = 1;        % Number of modes to compute

boundary_cond = '0000'; 


% Below are all written by Gemini
%% Mesh
[x,y,xc,yc,nx,ny,eps,edges] = waveguidemeshfull([n1,n2,n3], [h1,h2,h3],rh, rw, side, dx, dy); 
%% ---- Calculate H-fields and neff ----
[Hx, Hy, neff] = wgmodes(lambda, n2, nmodes, dx, dy, eps, boundary_cond);

%% ---- Convert H-fields to E-fields via Postprocessing ----
% The exact syntax from help: [Hz, Ex, Ey, Ez] = postprocess(lambda, neff, Hx, Hy, dx, dy, eps, boundary)
[Hz, Ex, Ey, Ez] = postprocess(lambda, neff, Hx, Hy, dx, dy, eps, boundary_cond);

%% ==================== NEW SECTION: PLOT REFRACTIVE INDEX PROFILE ====================
% Calculate refractive index from permittivity (n = sqrt(eps))
n_profile = sqrt(eps);

figure('Name', 'Refractive Index Profile Validation', 'NumberTitle', 'off', 'Position', [100, 500, 600, 450]);

% Plot n profile using xc and yc (since eps is defined at cell centers)
contourf(xc, yc, n_profile', 5, 'LineColor', 'none'); 
colormap(parula); % 'parula' or 'gray' is great for refractive index contrast
colorbar;
axis image; % Force correct physical aspect ratio
title('Refractive Index Distribution (n)'); xlabel('x (\mu m)'); ylabel('y (\mu m)'); 

% Overlay the structural edges to verify alignment
hold on; 
for v = edges
    line(v{:}, 'Color', 'r', 'LineWidth', 1.5, 'LineStyle', '--'); % Red dashed lines for ideal geometry
end
hold off;


%% ---- Calculate H-fields and neff ----
[Hx, Hy, neff] = wgmodes(lambda, n2, nmodes, dx, dy, eps, boundary_cond);
fprintf(1, 'Effective index neff = %.6f\n', neff);

%% ---- Convert H-fields to E-fields via Postprocessing ----
[Hz, Ex, Ey, Ez] = postprocess(lambda, neff, Hx, Hy, dx, dy, eps, boundary_cond);

%% ---- Plot Electric Fields ----
figure('Name', 'Waveguide Electric Fields (High-Res View)', 'NumberTitle', 'off', 'Position', [100, 100, 1100, 450]);

% Plot Ex (Horizontal Electric Field Component)
subplot(121);
contourf(xc, yc, Ex', 100, 'LineColor', 'none'); 
shading interp; colormap(jet); colorbar; axis image; 
title('Ex Field component'); xlabel('x (\mu m)'); ylabel('y (\mu m)'); 
hold on; for v = edges, line(v{:}, 'Color', 'w', 'LineWidth', 1.5); end; hold off; 

% Plot Ey (Vertical Electric Field Component)
subplot(122);
contourf(xc, yc, Ey', 100, 'LineColor', 'none'); 
shading interp; colormap(jet); colorbar; axis image; 
title('Ey Field component'); xlabel('x (\mu m)'); ylabel('y (\mu m)'); 
hold on; for v = edges, line(v{:}, 'Color', 'w', 'LineWidth', 1.5); end; hold off;