function mode_visualize(sim_obj)
    resolution = 150;
    for m = 1:length(sim_obj.modes_data)
        
        fig_title = sprintf('mode #%d(neff = %.9f)', m, sim_obj.modes_data(m).neff);
        figure('Name', fig_title, 'NumberTitle', 'off', 'Position', [150, 400, 1100, 420]);
        
        % Plot Ex component
        subplot(131);
        contourf(sim_obj.xc, sim_obj.yc, sim_obj.modes_data(m).Ex', resolution, 'LineColor', 'none'); 
        shading interp; colormap(jet); colorbar; axis image; 
        title(sprintf('Mode %d: Ex', m)); xlabel('x (\mu m)'); ylabel('y (\mu m)'); 
        hold on; for v = sim_obj.edges, line(v{:}, 'Color', 'w', 'LineWidth', 1.5); end; hold off; 
        
        % Plot Ey component
        subplot(132);
        contourf(sim_obj.xc, sim_obj.yc, sim_obj.modes_data(m).Ey', resolution, 'LineColor', 'none'); 
        shading interp; colormap(jet); colorbar; axis image; 
        title({sprintf('neff = %.15f', sim_obj.modes_data(m).neff), sprintf('Mode %d: Ey', m)}); 
        xlabel('x (\mu m)'); ylabel('y (\mu m)'); 
        hold on; for v = sim_obj.edges, line(v{:}, 'Color', 'w', 'LineWidth', 1.5); end; hold off;
        
        % Plot NormE component
        subplot(133);
        sim_obj.normE = sqrt((sim_obj.modes_data(m).Ey').^2 + (sim_obj.modes_data(m).Ex').^2);
        if sim_obj.if_log
            temp = log(sim_obj.normE);
        else
            temp = sim_obj.normE;
        end
        contourf(sim_obj.xc, sim_obj.yc, temp, resolution, 'LineColor', 'none'); 
        if sim_obj.if_log
            max_val = max(temp(:));
            clim([max_val - 10 max_val]); 
        end
        shading interp; colormap(jet); colorbar; axis image; 
        title(sprintf('Mode %d: normE', m)); xlabel('x (\mu m)'); ylabel('y (\mu m)'); 
        hold on; for v = sim_obj.edges, line(v{:}, 'Color', 'w', 'LineWidth', 1.5); end; hold off;
        

    end

end