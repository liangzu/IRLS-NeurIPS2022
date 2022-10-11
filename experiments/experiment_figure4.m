close all; clear all; format longG;

%% parameters

m = 1000;
n = 10;
sigma = 0; 

k = 200;

num_iter = 10;

num_trials = 20;

errors_IRLS1 = zeros(num_trials, num_iter);

errors_IRLS01 = zeros(num_trials, num_iter);
errors_IRLS05 = zeros(num_trials, num_iter);

for t=1:num_trials
    t    
    [y, A, x] = gen_RR(m, n, k, sigma);
    
    %% the proposed
    [x_hat, epsilons, iterates, num_truncates] = IRLSp(A, y, 1, k, num_iter);
    errors_IRLS1(t,:) = vecnorm(iterates - x, 2, 1) ./ norm(x);

    [x_hat, epsilons, iterates, num_truncates] = IRLSp(A, y, 0.1, k, num_iter);
    errors_IRLS01(t,:) = vecnorm(iterates - x, 2, 1) ./ norm(x);
    
    [x_hat, epsilons, iterates, num_truncates] = IRLSp(A, y, 0.5, k, num_iter);
    errors_IRLS05(t,:) = vecnorm(iterates - x, 2, 1) ./ norm(x);    
end

mean_errors_IRLS1 = mean(errors_IRLS1,1); std_errors_IRLS1 = std(errors_IRLS1,1);

mean_errors_IRLS01 = mean(errors_IRLS01,1); std_errors_IRLS01 = std(errors_IRLS01,1);
mean_errors_IRLS05 = mean(errors_IRLS05,1); std_errors_IRLS05 = std(errors_IRLS05,1);


[mean_errors_IRLS1; mean_errors_IRLS01; mean_errors_IRLS05]

factor = 1;
[mean_errors_IRLS1]= downsample(mean_errors_IRLS1, factor);
[mean_errors_IRLS01]= downsample(mean_errors_IRLS01, factor);
[mean_errors_IRLS05]= downsample(mean_errors_IRLS05, factor);



clear A, y, x;
filename = "./experiments/experiment_LpRR_convergence_noiseless.mat";
save(filename);


function [dv]= downsample(v, factor)
    dv = v(rem(1:length(v), factor) == 0);
end