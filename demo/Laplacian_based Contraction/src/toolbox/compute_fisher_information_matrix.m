function fim = compute_fisher_information_matrix(params, data)
    eps_user = 1e-5;  % Small value for numerical differentiation
    num_params = length(params);
    fim = zeros(num_params, num_params);
    
    for i = 1:num_params
        for j = 1:num_params
            params1 = params;
            params2 = params;
            params1(i) = params1(i) + eps_user;
            params2(j) = params2(j) + eps_user;
            
            dL_dtheta_i = (point_cloud_log_likelihood(params1, data) - point_cloud_log_likelihood(params, data)) / eps_user;
            dL_dtheta_j = (point_cloud_log_likelihood(params2, data) - point_cloud_log_likelihood(params, data)) / eps_user;
            
            fim(i, j) = dL_dtheta_i * dL_dtheta_j;
        end
    end
end
