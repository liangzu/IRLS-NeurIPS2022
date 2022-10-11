function [x_hat, iterates] = IRLS1_MGJK2019(A, y, eta, M, num_iter)
    [m, n] = size(A);
    w = ones(m,1);
    
    x_hat = 0; x_inner = 0; C = 2/eta/M;
    
    
    iterates = zeros(n, num_iter);
    
    k = 0;
    
    for i=1:num_iter
        while true            
            x_inner_old = x_inner;
            
            x_inner = (A'* (w.*A)) \  (A' * (w.* y));
            
            % x_inner = (w .* A) \ (w .* y);
            % x_hat = lsqr((w.*A), (w.* y));
            % x_hat = mldivide(A'* (w.*A), A' * (w.* y));
            % x_hat = linsolve(A'* (w.*A), A' * (w.* y));
            % x_hat = pcg1(A'* (w.*A), A' * (w.* y), 1e-16, 200);       
            
            abs_residual = abs(A*x_inner - y);
            
            w = min(1./ abs_residual, M);
            
            
            iterates(:,i) = x_inner;
            
            k = k + 1;
            
            if k > num_iter
                break;
            end
            
            if norm(x_inner_old - x_inner) < C
                break;
            end
        end
        x_hat = x_inner;
        M = eta * M;
        
        if k > num_iter
            break;
        end                        
    end
end


