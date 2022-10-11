function [x_hat] = IRLSp_AwA(A, y, p, k, num_iter)

    [m, n] = size(A);
    
    q = 2 - p;  l = m - k;
    epsilon = inf;    

    w = ones(m,1);
    x_old = zeros(n,1);    
    
    for i = 1:num_iter        
        x_hat = (A'* (w.*A)) \  (A' * (w.* y));      
        % x_hat = (w.*A) \  (w.* y);
        
        % x_hat = lsqr((w.*A), (w.* y));
        % x_hat = mldivide(A'* (w.^2.*A), A' * (w.* y));
        % x_hat = linsolve(A'* (w.^2.*A), A' * (w.* y));
        % x_hat = pcg1(A'* (w.*A), A' * (w.* y), 1e-10, 200, 0, x_old);
        
        abs_residual = abs(A*x_hat - y);
        
        sigma = sum(mink(abs_residual, l)) / m;        
        
        epsilon = max(min(epsilon, sigma), 1e-16);
        
        w = 1./ (max(abs_residual, epsilon)).^(q);
      
        if norm(x_old - x_hat)/ norm(x_hat) < 1e-15
            break;
        end
        x_old = x_hat;
    end
end