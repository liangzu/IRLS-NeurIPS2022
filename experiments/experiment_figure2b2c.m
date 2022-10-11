close all; clear all; format longG;

%% parameters

n = 50;
ms = 1000:1000:9000;

sigma = 0; 

shuffled_ratio = 0.5;

% ms = 10:10:70;

num_iter = 50;

num_trials = 20;

times_IRLS1 = zeros(num_trials, length(ms));
times_IRLSp = zeros(num_trials, length(ms));

times_Gurobi = zeros(num_trials, length(ms));
times_PDHG = zeros(num_trials, length(ms));
times_proximal = zeros(num_trials, length(ms));


errors_IRLS1 = zeros(num_trials, length(ms));
errors_IRLSp = zeros(num_trials, length(ms));

errors_Gurobi = zeros(num_trials, length(ms));
errors_PDHG = zeros(num_trials, length(ms));
errors_proximal = zeros(num_trials, length(ms));

for i=1:length(ms)
    m = ms(i);
    k = round(shuffled_ratio*m);
    i
    for t=1:num_trials
        % [y, A, x] = gen_RR(m, n, k, sigma);
        [y, A, x] = gen_SLR(m, n, sigma, shuffled_ratio);

        %% the proposed               
        tic;
        [x_hat] = IRLSp_AwA(A, y, 1, k, num_iter);
        times_IRLS1(t,i) = toc;
        errors_IRLS1(t,i) = norm(x_hat - x) / norm(x);
        
        tic;
        [x_hat] = IRLSp_AwA(A, y, 0.1, k, num_iter);
        times_IRLSp(t,i) = toc;
        errors_IRLSp(t,i) = norm(x_hat - x) / norm(x);
                       
        %% Gurobi
        [x_Gurobi, time_Gurobi] = my_Gurobi_RR(A, y);
        times_Gurobi(t,i) = time_Gurobi;
        errors_Gurobi(t,i) = norm(x_Gurobi - x) / norm(x);
        
        %% PDHG
        [x_PDHG, time_PDHG] = my_PDHG(A, y);
        times_PDHG(t,i) = time_PDHG;
        errors_PDHG(t,i) = norm(x_PDHG - x) / norm(x);
        
        %% Proximal subgradient
        tic;
        [x_proximal] = L1_RR_proximal(A, y);
        times_proximal(t,i) = toc;
        errors_proximal(t,i) = norm(x_proximal - x) / norm(x);
    end
end

mean_times_IRLS1 = mean(times_IRLS1,1); std_times_IRLS1 = std(times_IRLS1,1);
mean_times_IRLSp = mean(times_IRLSp,1); std_times_IRLSp = std(times_IRLSp,1);
mean_times_Gurobi = mean(times_Gurobi,1); std_times_Gurobi = std(times_Gurobi,1);
mean_times_PDHG = mean(times_PDHG,1); std_times_PDHG = std(times_PDHG,1);
mean_times_proximal = mean(times_proximal,1); std_times_proximal = std(times_proximal,1);

mean_errors_IRLS1 = mean(errors_IRLS1,1); std_errors_IRLS1 = std(errors_IRLS1,1);
mean_errors_IRLSp = mean(errors_IRLSp,1); std_errors_IRLSp = std(errors_IRLSp,1);
mean_errors_Gurobi = mean(errors_Gurobi,1); std_errors_Gurobi = std(errors_Gurobi,1);
mean_errors_PDHG = mean(errors_PDHG,1); std_errors_PDHG = std(errors_PDHG,1);
mean_errors_proximal = mean(errors_proximal,1); std_errors_proximal = std(errors_proximal,1);

[mean_times_IRLS1; mean_times_IRLSp; mean_times_Gurobi; mean_times_PDHG; mean_times_proximal]

[mean_errors_IRLS1; mean_errors_IRLSp; mean_errors_Gurobi; mean_errors_PDHG; mean_errors_proximal]

clear A, y, x;
filename = "./experiments/experiment_SLR_time_error_m.mat";
% save(filename);