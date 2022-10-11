function [y, A, x] = gen_RPR(m, n, num_positive_sign)
    A = randn(m, n);
    x = randn(n,1);
    
    y = zeros(m,1);
    
    idx = datasample(1:m, num_positive_sign, 'Replace', false);
    
    
    
    y(idx) = A(idx, :) * x;
    
    s = setdiff(1:m, idx);
    y(s) = - A(s, :) * x;
    
    
    % make y positive
    idx = y < 0;
    y(idx) = -y(idx);
    
    A(idx,:) = -A(idx,:);
end
