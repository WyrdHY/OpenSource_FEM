function mode_visualize(sim_obj)

    resolution = 150;
    m = sim_obj.m;

    field_type = 1;   % 1 = E field, 0 = H field

    if field_type == 1
        Fx = sim_obj.modes_data(m).Ex';
        Fy = sim_obj.modes_data(m).Ey';
        Fz = sim_obj.modes_data(m).Ez';
        field_name = 'E';
    else
        Fx = sim_obj.modes_data(m).Hx';
        Fy = sim_obj.modes_data(m).Hy';
        Fz = sim_obj.modes_data(m).Hz';
        field_name = 'H';
    end

    fig_title = sprintf('mode #%d(neff = %.9f)', m, sim_obj.modes_data(m).neff);
    figure('Name', fig_title, 'NumberTitle', 'off', 'Position', [118 85 1268 777]);

    % ---------------------------------------------------------------------
    % Fx
    % ---------------------------------------------------------------------
    ax1 = subplot(231);
    contourf(sim_obj.xc, sim_obj.yc, Fx, resolution, 'LineColor', 'none');
    shading interp;
    colormap(ax1, jet);
    colorbar;
    axis image;
    title(sprintf('Mode %d: %sx', m, field_name));
    xlabel('x (\mu m)');
    ylabel('y (\mu m)');
    hold on;
    for v = sim_obj.edges
        line(v{:}, 'Color', 'w', 'LineWidth', 1.5);
    end
    hold off;

    % ---------------------------------------------------------------------
    % Fy
    % ---------------------------------------------------------------------
    ax2 = subplot(232);
    contourf(sim_obj.xc, sim_obj.yc, Fy, resolution, 'LineColor', 'none');
    shading interp;
    colormap(ax2, jet);
    colorbar;
    axis image;
    title({sprintf('neff = %.15f', sim_obj.modes_data(m).neff), ...
           sprintf('Mode %d: %sy', m, field_name)});
    xlabel('x (\mu m)');
    ylabel('y (\mu m)');
    hold on;
    for v = sim_obj.edges
        line(v{:}, 'Color', 'w', 'LineWidth', 1.5);
    end
    hold off;

    % ---------------------------------------------------------------------
    % Fz
    % ---------------------------------------------------------------------
    ax3 = subplot(233);
    contourf(sim_obj.xc, sim_obj.yc, imag(Fz), resolution, 'LineColor', 'none');
    shading interp;
    colormap(ax3, jet);
    colorbar;
    axis image;
    title(sprintf('Mode %d: %sz', m, field_name));
    xlabel('x (\mu m)');
    ylabel('y (\mu m)');
    hold on;
    for v = sim_obj.edges
        line(v{:}, 'Color', 'w', 'LineWidth', 1.5);
    end
    hold off;

    % ---------------------------------------------------------------------
    % normF
    % ---------------------------------------------------------------------
    ax4 = subplot(234);
    sim_obj.normF = sqrt(abs(Fx).^2 + abs(Fy).^2);

    temp = sim_obj.normF;

    contourf(sim_obj.xc, sim_obj.yc, temp, resolution, 'LineColor', 'none');
    shading interp;
    colormap(ax4, jet);
    colorbar;
    axis image;
    title(sprintf('norm%s', field_name));
    xlabel('x (\mu m)');
    ylabel('y (\mu m)');
    hold on;
    for v = sim_obj.edges
        line(v{:}, 'Color', 'w', 'LineWidth', 1.5);
    end
    hold off;

    % ---------------------------------------------------------------------
    % log(normF)
    % ---------------------------------------------------------------------
    ax5 = subplot(235);
    sim_obj.normF = sqrt(abs(Fx).^2 + abs(Fy).^2);

    if sim_obj.if_log
        temp = log(sim_obj.normF);
    else
        temp = sim_obj.normF;
    end

    contourf(sim_obj.xc, sim_obj.yc, temp, resolution, 'LineColor', 'none');

    if sim_obj.if_log
        max_val = max(temp(:));
        clim([max_val - 10 max_val]);
    end

    shading interp;
    colormap(ax5, jet);
    colorbar;
    axis image;

    if sim_obj.if_log
        title(sprintf('Log(norm%s)', field_name));
    else
        title(sprintf('norm%s', field_name));
    end

    xlabel('x (\mu m)');
    ylabel('y (\mu m)');
    hold on;
    for v = sim_obj.edges
        line(v{:}, 'Color', 'w', 'LineWidth', 1.5);
    end
    hold off;

    % ---------------------------------------------------------------------
    % material plot
    % ---------------------------------------------------------------------
    subplot(236);

    temp = sim_obj.if_idx;
    sim_obj.if_idx = 0;
    mat_visualize(sim_obj);
    sim_obj.if_idx = temp;

    % Re-lock the first five axes after mat_visualize runs
    style = 'jet';
    colormap(ax1, style);
    colormap(ax2, style);
    colormap(ax3, style);
    colormap(ax4, style);
    colormap(ax5, style);

end