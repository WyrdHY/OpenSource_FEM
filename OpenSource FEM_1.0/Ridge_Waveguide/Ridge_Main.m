%% Load Material
sputter2 = "Library/Material/Sputter_2575_650C(2%).txt";
thox     = "Library/Material/Remeasured_Good_THOX.txt";
%%
% =========================================================================
% Ridge Waveguide User Input & Simulation
% Hongrui: 
    % I made this simple and quick mode tool for waveguide simulation
    % It is adapted from the old 2011 UMD professor's code
    % I have compared the accuracy of it with COMSOL
    % Under exactly the same geo condition, dx and dy take as 100nm
    % it is less than 0.01% differ from COMSOL
    % neff. If you increase the dx and dy, it will approach COMSOL result
% Unit must be in [um]
% =========================================================================
sim_obj= struct;
sim_obj.lambda = 0.532;    

% Refractive index
sim_obj.n1 = mat(thox,sim_obj.lambda);          % Substrate
sim_obj.n2 = mat(sputter2,sim_obj.lambda);        % Core
sim_obj.n3 = 1.00;         % Cladding (air) 

% Define GEO
sim_obj.rw = 1;            % Waveguide Width
sim_obj.h1 = 10;            % Substrate Height
sim_obj.h2 = 2;          % Waveguide height
sim_obj.h3 = 8;            % Upper cladding Height
sim_obj.side = 5;          % Space on side

% Solver Config
sim_obj.dx = auto_mesh(sim_obj);        
sim_obj.dy = auto_mesh(sim_obj);        
sim_obj.nmodes = 2;        
sim_obj.boundary_cond = '0000'; 

% Plot Config 
sim_obj.if_idx = 0;
sim_obj.if_log = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ---- Geometry Mesh Generation ----
[sim_obj.x,sim_obj.y,sim_obj.xc,sim_obj.yc,sim_obj.nx,sim_obj.ny,sim_obj.eps,sim_obj.edges] = Ridge_Geo([sim_obj.n1,sim_obj.n2,sim_obj.n3], [sim_obj.h1,sim_obj.h2,sim_obj.h3], ...
                                                 sim_obj.rw, sim_obj.side, sim_obj.dx, sim_obj.dy); 

%% View Material index
if sim_obj.if_idx
    mat_visualize(sim_obj);
end

%% Calculate Raw H-fields and neff, and store
[sim_obj.Hx, sim_obj.Hy, sim_obj.neff] = wgmodes(sim_obj.lambda, sim_obj.n2, sim_obj.nmodes, sim_obj.dx, sim_obj.dy, sim_obj.eps, sim_obj.boundary_cond);

sim_obj.modes_data = struct();
for m = 1:sim_obj.nmodes
    [sim_obj.Hz_c, sim_obj.Ex_c, sim_obj.Ey_c, sim_obj.Ez_c] = postprocess(sim_obj.lambda, sim_obj.neff(m), sim_obj.Hx(:,:,m), sim_obj.Hy(:,:,m), sim_obj.dx, sim_obj.dy, sim_obj.eps, sim_obj.boundary_cond);
    sim_obj.modes_data(m).neff = sim_obj.neff(m);
    sim_obj.modes_data(m).Ex   = sim_obj.Ex_c;
    sim_obj.modes_data(m).Ey   = sim_obj.Ey_c;
end

%% Plot
for m = 1:length(sim_obj.modes_data)
    mode_visualize(sim_obj);
end