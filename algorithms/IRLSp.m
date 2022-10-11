function [x_hat, epsilons, iterates, num_truncates] = IRLSp(A, y, p, k, num_iter)
    [m, n] = size(A);
    w = ones(m,1);
    
    q = 2 - p;  l = m - k;
    
    epsilon = inf;
    
    epsilons = zeros(1,num_iter);
    iterates = zeros(n, num_iter);
    num_truncates = zeros(1,num_iter);
    
    x_hat = zeros(n,1); x_old = x_hat; 
    
    for i = 1:num_iter        
        % x_hat = (A'* (w.*A)) \  (A' * (w.* y));      
        x_hat = (w.*A) \  (w.* y);
        
        % x_hat = lsqr((w.*A), (w.* y));
        % x_hat = mldivide(A'* (w.^2.*A), A' * (w.* y));
        % x_hat = linsolve(A'* (w.^2.*A), A' * (w.* y));
        % x_hat = pcg1(A'* (w.*A), A' * (w.* y), 1e-16, 200, 0, x_old);
        
        abs_residual = abs(A*x_hat - y);
        
        sigma = sum(mink(abs_residual, l)) / m;        
        
        epsilon = max(min(epsilon, sigma), 1e-16);
        
        w = 1./ (max(abs_residual, epsilon)).^(q/2);
       
        %% collect data
        epsilons(i) = epsilon;
       
        iterates(:,i) = x_hat;
        
        num_truncates(i) = sum(abs_residual < epsilon);
        
        if norm(x_old - x_hat)/ norm(x_hat) < 1e-15
            % break;
        end
        x_old = x_hat;
    end
end