function [x_hat, epsilons, iterates] = IRLSp_DDFG2010(A, y, p, k, num_iter)
    [m, n] = size(A);
    w = ones(m,1);
    
    q = 2 - p;  l = m - k;
    
    epsilon = inf;
    
    epsilons = zeros(1,num_iter);
    iterates = zeros(n, num_iter);
    
    x_hat = zeros(n,1);
    
    for i = 1:num_iter        
        % x_hat = (A'* (w.*A)) \  (A' * (w.* y));
        
        x_hat = (w .* A) \ (w .* y);
        % x_hat = lsqr((w.*A), (w.* y));
        % x_hat = mldivide(A'* (w.^2.*A), A' * (w.* y));
        % x_hat = linsolve(A'* (w.^2.*A), A' * (w.* y));
        % x_hat = pcg1(A'* (w.^2.*A), A' * (w.^2.* y), 1e-16, 200);
        
        abs_residual = abs(A*x_hat - y);
        
        sigma = max(mink(abs_residual, l)) / m;
        
        epsilon = max(min(epsilon, sigma), 1e-16);
        
        w = 1./ (abs_residual.^2 + epsilon^2).^(q/4);%(q/2)
        
        %% collect data
        epsilons(i) = epsilon;
       
        iterates(:,i) = x_hat;
    end
end