function mat_visualize(sim_obj)
    sim_obj.n_profile = sqrt(sim_obj.eps);
    if sim_obj.if_idx
        figure('Name', 'Refractive Index Profile Validation', 'NumberTitle', 'off', 'Position', [100, 600, 600, 450]);
    end
    contourf(sim_obj.xc, sim_obj.yc, sim_obj.n_profile', 20, 'LineColor', 'none'); 
    colormap(parula); 
    colorbar;
    axis image; 
    title('n'); xlabel('x (\mu m)'); ylabel('y (\mu m)'); 
    hold on; 
    for v = sim_obj.edges
        line(v{:}, 'Color', 'red', 'LineWidth', 2, 'LineStyle', '-.'); 
    end
    hold off;
end