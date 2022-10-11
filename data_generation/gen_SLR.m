function [y, A, x] = gen_SLR(m, n, sigma, shuffle_ratio)
    A = randn(m, n);
    x = randn(n,1);
    
    w = sigma*randn(m, 1);
    
    y0 = A*x;
    k = int64(shuffle_ratio * m);
    partial_idx = datasample(1:m, k, 'Replace', false);
    y1 = y0(partial_idx, 1);
    y0(partial_idx, 1) = y1(randperm(k));
    
    y = y0 + w;
end