function n = mat(filepath, lambda_um)
% GET_INDEX_AT_LAMBDA Interpolates refractive index n for a given wavelength.
%
%   n = GET_INDEX_AT_LAMBDA(filepath, lambda_target) reads a 2-column text 
%   file where Column 1 is wavelength and Column 2 is the refractive index, 
%   and performs a cubic spline interpolation at the target wavelength(s).
%
%   Input Arguments:
%       filepath      - String/char vector specifying the path to the txt file.
%       lambda_target - Scalar or vector of target wavelength(s). 
%                       (Units must match the wavelength units in the txt file).
%
%   Output Arguments:
%       n             - Interpolated refractive index value(s).
    lambda_target = lambda_um * 1000;
    if ~exist(filepath, 'file')
        error('Error: The file "%s" could not be found. Please check the file path.', filepath);
    end

    data = readmatrix(filepath);
    
    lambda_raw = data(:, 1);
    n_raw      = data(:, 2);

    min_lam = min(lambda_raw);
    max_lam = max(lambda_raw);
    if any(lambda_target < min_lam) || any(lambda_target > max_lam)
        warning('Warning: Target wavelength [%g] is outside the experimental data range [%g, %g]. Extrapolation might be inaccurate.', ...
                min(lambda_target), min_lam, max_lam);
    end
    n = interp1(lambda_raw, n_raw, lambda_target, 'spline');

end