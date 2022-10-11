close all; clear all; format longG;

add_paths;

%% parameters

m = 1000;
n = 3;
k = 100;

sigma = 0; 

p = 1;

num_iter = 50;

delta = 1e-15;

eta = 2; M = 1;

%% data generation
[y, A, x] = gen_RR(m, n, k, sigma);

%% 
tic;
[x_hat, epsilons, iterates, num_truncates] = IRLSp(A, y, p, k, num_iter);
toc;

tic;
[x_vanilla, iterates_vanilla] = IRLSp_vanilla(A, y, p, delta, num_iter);
toc;

tic;
[x_DDFG2010, epsilons_DDFG2010, iterates_DDFG2010] = IRLSp_DDFG2010(A, y, p, k, num_iter);
toc;

tic;
[x_MGJK2019, iterates_MGJK2019] = IRLS1_MGJK2019(A, y, eta, M, num_iter);
toc;

[norm(x_hat - x)/ norm(x) norm(x_vanilla - x)/norm(x) norm(x_DDFG2010 - x)/norm(x) norm(x_MGJK2019 - x)/norm(x)]