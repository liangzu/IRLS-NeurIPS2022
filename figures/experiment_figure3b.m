close all; clear all; format longG;

load('ExtendedYaleB.mat');

label = EYALEB_LABEL;
data = EYALEB_DATA;

p = 0.1;
num_iter = 50;

corruption_rate = 0.7;
k = round(48*42*corruption_rate);


%% randomly select a class and a face
% rng('default');

l = randi(38);

subject_l = data(:, label == l);

i = randi(size(subject_l, 2));

featurei = subject_l(:,i);

facei = reshape(featurei, 48, 42); % input face

%% corrupt the face and recover it 
noisy_facei = facei .* imnoise(facei,'salt & pepper', corruption_rate);

noisy_featurei = reshape(noisy_facei, 48*42, 1);

dictionaryi = [subject_l(:,1:i-1) subject_l(:,i+1:end)];  

recovered_feature_LS_gt = dictionaryi * (dictionaryi\featurei);
recovered_face_LS_gt = reshape(recovered_feature_LS_gt, 48, 42);

recovered_feature_LS = dictionaryi * (dictionaryi\noisy_featurei);
recovered_face_LS= reshape(recovered_feature_LS, 48, 42);

[x_hat] = IRLSp_AwA(dictionaryi, noisy_featurei, p, k, num_iter);
recovered_feature_IRLSp = dictionaryi * x_hat;
recovered_face_IRLSp= reshape(recovered_feature_IRLSp, 48, 42);


% imshow(facei, [min(min(facei)), max(max(facei))] );
imwrite(facei/max(max(facei)), './EYaleB_GT2.jpg', 'jpg');

imwrite(noisy_facei/max(max(noisy_facei)), './EYaleB_input2.jpg', 'jpg');

% imshow(recovered_face_LS_gt, [min(min(recovered_face_LS_gt)), max(max(recovered_face_LS_gt))] );
imwrite(recovered_face_LS_gt/max(max(recovered_face_LS_gt)), './EYaleB_LS_gt2.jpg', 'jpg');

% imshow(recovered_face_LS, [min(min(recovered_face_LS)), max(max(recovered_face_LS))] );
imwrite(recovered_face_LS/max(max(recovered_face_LS)), './EYaleB_LS2.jpg', 'jpg');

% imshow(recovered_face_IRLSp, [min(min(recovered_face_IRLSp)), max(max(recovered_face_IRLSp))] );
imwrite(recovered_face_IRLSp/max(max(recovered_face_IRLSp)), './EYaleB_IRLSp2.jpg', 'jpg');


% function [errors_LS_gt, errors_LS, errors_IRLSp, errors_IRLS1] = EYaleB_salt_pepper(data, label, corruption_rate, p, k, num_iter)
% 
%     
%     for l = 1:38    
%    
%         subject_l = data(:, label == l);
%         for i=1:size(subject_l, 2)
% 
%             featurei = subject_l(:,i);
%             facei = reshape(subject_l(:,i), 48, 42);
% 
%             noisy_facei = facei .* imnoise(facei,'salt & pepper', corruption_rate);
% 
%             noisy_featurei = reshape(noisy_facei, 48*42, 1);
% 
%             dictionaryi = [subject_l(:,1:i-1) subject_l(:,i+1:end)];     
%             
%             %% LS GT
%             % recovered_featurei = dictionaryi * (dictionaryi\featurei);
% 
%             %% LS
%             recovered_featurei = dictionaryi * (dictionaryi\noisy_featurei);
% 
%             %% IRLSp
%             [x_hat] = IRLSp_AwA(dictionaryi, noisy_featurei, p, k, num_iter);
%             recovered_featurei = dictionaryi * x_hat;
%             
%             
%             %% IRLS1
%             [x_hat] = IRLSp_AwA(dictionaryi, noisy_featurei, 1, k, num_iter);
%             recovered_featurei = dictionaryi * x_hat;
%  
%         end
%     end
% end