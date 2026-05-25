function dx = auto_mesh(sim_obj)
    lambda_um = sim_obj.lambda;

    if lambda_um > 1.1
        dx = 0.1;
    elseif lambda_um > 0.7
        dx = 0.075;
    else
        dx = 0.05;
    end
end