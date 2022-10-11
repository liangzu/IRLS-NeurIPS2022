close all; clear all; format longG;

%% parameters

m = 1000;
n = 10;
sigma = 0; 

k = 200;

alphas = 100:100:900;

num_iter = 50;

num_trials = 20;

errors_IRLS1 = zeros(num_trials, length(alphas));
errors_IRLS05 = zeros(num_trials, length(alphas));
errors_IRLS01 = zeros(num_trials, length(alphas));

errors_DDFG2010_1 = zeros(num_trials, length(alphas));
errors_DDFG2010_05 = zeros(num_trials, length(alphas));
errors_DDFG2010_01 = zeros(num_trials, length(alphas));


for i=1:length(alphas)
    alpha = alphas(i);
    i
    for t=1:num_trials
        [y, A, x] = gen_RR(m, n, k, sigma);

        %% the proposed
        [x_hat, ~, ~, ~] = IRLSp(A, y, 1, alpha, num_iter);
        errors_IRLS1(t,i) = norm(x_hat - x) / norm(x);


        [x_hat, ~, ~, ~] = IRLSp(A, y, 0.5, alpha, num_iter);
        errors_IRLS05(t,i) = norm(x_hat - x) / norm(x);
        
        [x_hat, ~, ~, ~] = IRLSp(A, y, 0.1, alpha, num_iter);
        errors_IRLS01(t,i) = norm(x_hat - x) / norm(x);

        %% IRLS of DDFG2010
        [x_DDFG2010, ~, ~] = IRLSp_DDFG2010(A, y, 1, k, num_iter);
        errors_DDFG2010_1(t, i) = norm(x_DDFG2010 - x) / norm(x);
        
        [x_DDFG2010, ~, ~] = IRLSp_DDFG2010(A, y, 0.5, k, num_iter);
        errors_DDFG2010_05(t, i) = norm(x_DDFG2010 - x) / norm(x);
        
        [x_DDFG2010, ~, ~] = IRLSp_DDFG2010(A, y, 0.1, k, num_iter);
        errors_DDFG2010_01(t, i) = norm(x_DDFG2010 - x) / norm(x);        
    end
end

mean_errors_IRLS1 = mean(errors_IRLS1,1); std_errors_IRLS1 = std(errors_IRLS1,1);
mean_errors_IRLS05 = mean(errors_IRLS05,1); std_errors_IRLS05 = std(errors_IRLS05,1);
mean_errors_IRLS01 = mean(errors_IRLS01,1); std_errors_IRLS01 = std(errors_IRLS01,1);

mean_errors_DDFG2010_1 = mean(errors_DDFG2010_1,1); std_errors_DDFG2010_1 = std(errors_DDFG2010_1,1);
mean_errors_DDFG2010_05 = mean(errors_DDFG2010_05,1); std_errors_DDFG2010_05 = std(errors_DDFG2010_05,1);
mean_errors_DDFG2010_01 = mean(errors_DDFG2010_01,1); std_errors_DDFG2010_01 = std(errors_DDFG2010_01,1);


[mean_errors_IRLS1; mean_errors_IRLS05; mean_errors_IRLS01; ...
 mean_errors_DDFG2010_1; mean_errors_DDFG2010_05; mean_errors_DDFG2010_01]

clear A, y, x;
filename = "./experiments/experiment_sensitivity_alpha.mat";
save(filename);
