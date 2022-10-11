function [y, A, x] = gen_RR(m, n, k, sigma)
    A = randn(m, n);
    x = randn(n,1);
    
    y = zeros(m,1);
    
    idx = datasample(1:m, k, 'Replace', false);
    
    y(idx) = randn(k,1);
    
    s = setdiff(1:m, idx);
    y(s) =  A(s, :) * x + sigma * randn(length(s), 1);
end
