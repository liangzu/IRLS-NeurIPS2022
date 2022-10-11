close all; clear all; format longG;

load('ExtendedYaleB.mat');

label = EYALEB_LABEL;
data = EYALEB_DATA;

p = 0.1;
num_iter = 50;

num_trials = 1;

corruption_rates = 0.1:0.1:0.7;

errors_LS_gt = zeros(num_trials, length(corruption_rates));
errors_LS = zeros(num_trials, length(corruption_rates));
errors_IRLSp = zeros(num_trials, length(corruption_rates));
errors_IRLS1 = zeros(num_trials, length(corruption_rates));

for c=1:length(corruption_rates)
    corruption_rate = corruption_rates(c);
    
    k = round(48*42*corruption_rate);
    
    for t=1:num_trials
        [errs_LS_gt_, errs_LS_, errs_IRLSp_, errs_IRLS1_] = EYaleB_salt_pepper(data, label, corruption_rate, p, k, num_iter);
        
        errors_LS_gt(t,c) = mean(errs_LS_gt_);
        errors_LS(t,c) = mean(errs_LS_);
        errors_IRLSp(t,c) = mean(errs_IRLSp_);        
        errors_IRLS1(t,c) = mean(errs_IRLS1_);        
    end
    [c mean(errors_LS_gt(:,c)) mean(errors_LS(:,c)) mean(errors_IRLSp(:,c)) mean(errors_IRLS1(:,c))]
end

mean_errors_LS_gt = mean(errors_LS_gt, 1); 
% mean_errors_LS_gt = ones(1, length(corruption_rates)) * 0.107193248246816;

mean_errors_LS = mean(errors_LS, 1); 
mean_errors_IRLSp = mean(errors_IRLSp, 1); 
mean_errors_IRLS1 = mean(errors_IRLS1, 1);  

filename = "./experiments/experiment_EYaleB.mat";
clear EYALEB_LABEL; clear EYALEB_DATA; clear label; clear data;
% save(filename);


function [errors_LS_gt, errors_LS, errors_IRLSp, errors_IRLS1] = EYaleB_salt_pepper(data, label, corruption_rate, p, k, num_iter)

    errors_LS_gt = zeros(1,38);
    errors_LS = zeros(1,38);
    errors_IRLSp = zeros(1,38);
    errors_IRLS1 = zeros(1,38);
    
    for l = 1:38    
   
        subject_l = data(:, label == l);
        for i=1:size(subject_l, 2)

            featurei = subject_l(:,i);
            facei = reshape(subject_l(:,i), 48, 42);

            noisy_facei = facei .* imnoise(facei,'salt & pepper', corruption_rate);

            noisy_featurei = reshape(noisy_facei, 48*42, 1);

            dictionaryi = [subject_l(:,1:i-1) subject_l(:,i+1:end)];     
                                               
            %% LS GT
            recovered_featurei = dictionaryi * (dictionaryi\featurei);
            errors_LS_gt(l) = errors_LS_gt(l) +  norm(recovered_featurei - featurei) / norm(featurei);
            % errors_LS_gt(l) = 0;
            %% LS
            recovered_featurei = dictionaryi * (dictionaryi\noisy_featurei);
            errors_LS(l) = errors_LS(l) +  norm(recovered_featurei - featurei) / norm(featurei);
            %% IRLSp
            [x_hat] = IRLSp_AwA(dictionaryi, noisy_featurei, p, k, num_iter);
            recovered_featurei = dictionaryi * x_hat;
            errors_IRLSp(l) = errors_IRLSp(l) +  norm(recovered_featurei - featurei) / norm(featurei);         
            
            %% IRLS1
            [x_hat] = IRLSp_AwA(dictionaryi, noisy_featurei, 1, k, num_iter);
            recovered_featurei = dictionaryi * x_hat;
            errors_IRLS1(l) = errors_IRLS1(l) +  norm(recovered_featurei - featurei) / norm(featurei);     
        end
        errors_LS_gt(l) = errors_LS_gt(l) / size(subject_l, 2);
        errors_LS(l) = errors_LS(l) / size(subject_l, 2);
        errors_IRLSp(l) = errors_IRLSp(l) / size(subject_l, 2);
        errors_IRLS1(l) = errors_IRLS1(l) / size(subject_l, 2);
    end
end



