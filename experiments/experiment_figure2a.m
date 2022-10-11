close all; clear all; format longG;

%% parameters

m = 399; n = 200; 

ks = 10:10:90;

p = 0.1;

num_iter = 50;

num_trials = 20;

errors_IRLSp = zeros(num_trials, length(ks));
errors_IRLS1 = zeros(num_trials, length(ks));
errors_Kaczmarz = zeros(num_trials, length(ks));
errors_PhaseLamp = zeros(num_trials, length(ks));
errors_TWF = zeros(num_trials, length(ks));
errors_CD = zeros(num_trials, length(ks));

for i=1:length(ks)    
    num_positive_sign = ks(i);
    i
    for t=1:num_trials
        % [y, A, x] = gen_RR(m, n, k, sigma);
        [y, A, x] = gen_RPR(m, n, num_positive_sign);

        %% the proposed
            
        [x_hat] = IRLSp_AwA(A, y, p, num_positive_sign, num_iter);
              
        errors_IRLSp(t,i) = min(norm(x_hat - x)/ norm(x), norm(x_hat + x)/ norm(x));
        
        [x_hat] = IRLSp_AwA(A, y, 1, num_positive_sign, num_iter);
              
        errors_IRLS1(t,i) = min(norm(x_hat - x)/ norm(x), norm(x_hat + x)/ norm(x));
        
        %% Kaczmarz
        opts = struct;
        opts.tol = 1e-11;
        opts.verbose = 0;    
        
        opts.initMethod = 'Truncatedspectral';
        opts.algorithm = 'Kaczmarz';
        opts.isComplex = false;

           
        [x_Kaczmarz, outs, opts] = solvePhaseRetrieval(A, A', y, n, opts);

        errors_Kaczmarz(t,i) = min(norm(x_Kaczmarz - x)/ norm(x), norm(x_Kaczmarz + x)/ norm(x));
        %% PhaseLamp
        opts.algorithm = 'PhaseLamp';
        
        [x_PhaseLamp, outs, opts] = solvePhaseRetrieval(A, A', y, n, opts);

        errors_PhaseLamp(t,i) = min(norm(x_PhaseLamp - x)/ norm(x), norm(x_PhaseLamp + x)/ norm(x));
        
        %% TWF      
        opts.algorithm = 'TWF';
        opts.gradType = 'TWFPoiss';
        
        [x_TWF, outs, opts] = solvePhaseRetrieval(A, A', y, n, opts);
        errors_TWF(t,i) = min(norm(x_TWF - x)/ norm(x), norm(x_TWF + x)/ norm(x));
        
        %%
        opts.algorithm = 'CoordinateDescent';
        
        [x_CD, outs, opts] = solvePhaseRetrieval(A, A', y, n, opts);
        errors_CD(t,i) = min(norm(x_CD- x)/ norm(x), norm(x_CD+ x)/ norm(x));
    end
end

mean_errors_IRLSp = mean(errors_IRLSp,1); std_errors_IRLSp = std(errors_IRLSp,1);
mean_errors_IRLS1 = mean(errors_IRLS1,1); std_errors_IRLS1 = std(errors_IRLS1,1);
mean_errors_Kaczmarz = mean(errors_Kaczmarz,1); std_errors_Kaczmarz = std(errors_Kaczmarz,1);
mean_errors_PhaseLamp = mean(errors_PhaseLamp,1); std_errors_PhaseLamp = std(errors_PhaseLamp,1);
mean_errors_TWF = mean(errors_TWF,1); std_errors_AmplitudeFlow = std(errors_TWF,1);
mean_errors_CD = mean(errors_CD,1); std_errors_CD = std(errors_CD,1);


[mean_errors_IRLSp; mean_errors_IRLS1; mean_errors_Kaczmarz; mean_errors_PhaseLamp; mean_errors_TWF; mean_errors_CD]

clear A, y, x;
filename = "./experiments/experiment_RPR_minimum_samples.mat";
% save(filename);
