close all; clear all; format longG;

%% parameters

m = 1000;
n = 10;
sigma = 0; 

ks = 100:100:600; ks = [0 ks];

num_iter = 500;

num_trials = 20;


opts=struct;
opts.precond = 'exact';
opts.mode_linsys = 'standard';

opts.verbose = false;


errors_IRLS05 = zeros(num_trials, length(ks));
errors_IRLS01 = zeros(num_trials, length(ks));


errors_vanilla_05 = zeros(num_trials, length(ks));
errors_vanilla_01 = zeros(num_trials, length(ks));

errors_DDFG2010_05 = zeros(num_trials, length(ks));
errors_DDFG2010_01 = zeros(num_trials, length(ks));

for i=1:length(ks)
    k = ks(i);
    i
    for t=1:num_trials
        [y, A, x] = gen_RR(m, n, k, sigma);

        %% the proposed               
        [x_hat, ~, ~, ~] = IRLSp(A, y, 0.5, k, num_iter);
        % [x_hat, ~, ~, ~, ~] = IRLSp_mat_inverse(A, y, 0.5, k, num_iter, opts);       
        errors_IRLS05(t,i) = norm(x_hat - x) / norm(x);
        
        [x_hat, ~, ~, ~] = IRLSp(A, y, 0.1, k, num_iter);
        % [x_hat, ~, ~, ~, ~] = IRLSp_mat_inverse(A, y, 0.1, k, num_iter, opts);       
        errors_IRLS01(t,i) = norm(x_hat - x) / norm(x);
        
        %% vanilla IRLS
        [x_vanilla, ~] = IRLSp_vanilla(A, y, 0.5, 1e-15, num_iter);
        errors_vanilla_05(t,i) = norm(x_vanilla - x) / norm(x);

        [x_vanilla, ~] = IRLSp_vanilla(A, y, 0.1, 1e-15, num_iter);
        errors_vanilla_01(t,i) = norm(x_vanilla - x) / norm(x);

        %% IRLS of DDFG2010
        [x_DDFG2010, ~, ~] = IRLSp_DDFG2010(A, y, 0.5, k, num_iter);
        errors_DDFG2010_05(t, i) = norm(x_DDFG2010 - x) / norm(x);
        
        [x_DDFG2010, ~, ~] = IRLSp_DDFG2010(A, y, 0.1, k, num_iter);
        errors_DDFG2010_01(t, i) = norm(x_DDFG2010 - x) / norm(x);          
    end
end

mean_errors_IRLS05 = mean(errors_IRLS05,1); std_errors_IRLS05 = std(errors_IRLS05,1);
mean_errors_IRLS01 = mean(errors_IRLS01,1); std_errors_IRLS01 = std(errors_IRLS01,1);

mean_errors_vanilla05 = mean(errors_vanilla_05,1); std_errors_vanilla05 = std(errors_vanilla_05,1);
mean_errors_vanilla01 = mean(errors_vanilla_01,1); std_errors_vanilla01 = std(errors_vanilla_01,1);

mean_errors_DDFG2010_05 = mean(errors_DDFG2010_05,1); std_errors_DDFG2010_05 = std(errors_DDFG2010_05,1);
mean_errors_DDFG2010_01 = mean(errors_DDFG2010_01,1); std_errors_DDFG2010_01 = std(errors_DDFG2010_01,1);

[mean_errors_IRLS05; mean_errors_IRLS01; ...
 mean_errors_vanilla05; mean_errors_vanilla01; ...
 mean_errors_DDFG2010_05; mean_errors_DDFG2010_01]

clear A, y, x;
filename = "./experiments/experiment_LpRR.mat";
% save(filename);
