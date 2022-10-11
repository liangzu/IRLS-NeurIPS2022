close all; clear all; format longG;

%% parameters

m = 1000;
n = 10;
sigma = 0; 

k = 200;

p = 1;

num_iter = 50;

eta = 2; M = 1;

num_trials = 20;

errors_IRLSp = zeros(num_trials, num_iter);

errors_vanilla_001 = zeros(num_trials, num_iter);
errors_vanilla_01 = zeros(num_trials, num_iter);
errors_vanilla_1 = zeros(num_trials, num_iter);

errors_DDFG2010 = zeros(num_trials, num_iter);

errors_MGJK2019 = zeros(num_trials, num_iter);


for t=1:num_trials
    t    
    [y, A, x] = gen_RR(m, n, k, sigma);
    
    %% the proposed
    [x_hat, epsilons, iterates, num_truncates] = IRLSp(A, y, p, k, num_iter);
    errors_IRLSp(t,:) = vecnorm(iterates - x, 2, 1) ./ norm(x);

    %% vanilla IRLS
    [x_vanilla, iterates_vanilla] = IRLSp_vanilla(A, y, p, 1e-5, num_iter);
    errors_vanilla_001(t,:) = vecnorm(iterates_vanilla - x, 2, 1) ./ norm(x);
    
    [x_vanilla, iterates_vanilla] = IRLSp_vanilla(A, y, p, 1e-10, num_iter);
    errors_vanilla_01(t,:) = vecnorm(iterates_vanilla - x, 2, 1) ./ norm(x);
    
    [x_vanilla, iterates_vanilla] = IRLSp_vanilla(A, y, p, 1e-15, num_iter);
    errors_vanilla_1(t,:) = vecnorm(iterates_vanilla - x, 2, 1) ./ norm(x);

    %% IRLS of DDFG2010
    [x_DDFG2010, epsilons_DDFG2010, iterates_DDFG2010] = IRLSp_DDFG2010(A, y, p, k, num_iter);
    errors_DDFG2010(t,:) = vecnorm(iterates_DDFG2010 - x, 2, 1) ./ norm(x);
    
    %% IRLS of MGJK2019        
    [x_MGJK2019, iterates_MGJK2019] = IRLS1_MGJK2019(A, y, eta, M, num_iter);
    errors_MGJK2019(t,:) = vecnorm(iterates_MGJK2019 - x, 2, 1) ./ norm(x);
end
mean_errors_IRLSp = mean(errors_IRLSp,1); std_errors_IRLSp = std(errors_IRLSp,1);

mean_errors_vanilla_001 = mean(errors_vanilla_001,1); std_errors_vanilla_001 = std(errors_vanilla_001,1);
mean_errors_vanilla_01 = mean(errors_vanilla_01,1); std_errors_vanilla_01 = std(errors_vanilla_01,1);
mean_errors_vanilla_1 = mean(errors_vanilla_1,1); std_errors_vanilla_1 = std(errors_vanilla_1,1);

mean_errors_DDFG2010 = mean(errors_DDFG2010,1); std_errors_DDFG2010 = std(errors_DDFG2010,1);

mean_errors_MGJK2019 = mean(errors_MGJK2019,1); std_errors_MGJK2019 = std(errors_MGJK2019,1);


[mean_errors_IRLSp; mean_errors_vanilla_001; mean_errors_vanilla_01; mean_errors_vanilla_1; ...
    mean_errors_DDFG2010; mean_errors_MGJK2019]

factor = 5;
[mean_errors_IRLSp]= downsample(mean_errors_IRLSp, factor);
[mean_errors_vanilla_001]= downsample(mean_errors_vanilla_001, factor);
[mean_errors_vanilla_01]= downsample(mean_errors_vanilla_01, factor);
[mean_errors_vanilla_1]= downsample(mean_errors_vanilla_1, factor);
[mean_errors_DDFG2010]= downsample(mean_errors_DDFG2010, factor);
[mean_errors_MGJK2019]= downsample(mean_errors_MGJK2019, factor);



clear A, y, x;
filename = "./experiments/experiment_L1RR.mat";
% save(filename);


function [dv]= downsample(v, factor)
    dv = v(rem(1:length(v), factor) == 0);
end
