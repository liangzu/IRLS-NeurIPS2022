function [x_hat, iterates] = IRLSp_vanilla(A, y, p, delta, num_iter)
    [m, n] = size(A);
    w = ones(m,1);
    
    q = 2 - p;
    
    x_hat = zeros(n,1);
    iterates = zeros(n, num_iter);
    
    
    for i = 1:num_iter
        x_hat = (w .* A) \ (w .* y);
        % x_hat = (A'* (w.*A)) \  (A' * (w.* y));
        
        % x_hat = lsqr((w.*A), (w.* y));
        % x_hat = mldivide(A'* (w.^2.*A), A' * (w.* y));
        % x_hat = linsolve(A'* (w.^2.*A), A' * (w.* y));
        % x_hat = pcg1(A'* (w.^2.*A), A' * (w.^2.* y), 1e-16, 200);
        
        abs_residual = abs(A*x_hat - y);
                
        w = 1./ (max(abs_residual , delta)).^(q/2); 
        
        iterates(:,i) = x_hat;
    end
end