function [X, v, y_linear, y_logistic, y_poisson] = data_generator(R, C, Tc, p, q)
k = 3; r = 3;
Ts = Tc * p * q;

X = zeros(p, q, Ts);
v = mvnrnd(zeros(3, 1), eye(3), Ts);
[y_linear, y_logistic, y_poisson] = deal(zeros(Ts, 1));
Zcov = zeros(k*r, k*r);
for i = 1:(k * r)
    Zcov(i, :) = 0.5.^abs((i - (1:(k*r))));
end
gamma = 1;
alpha = 2*[1, -1, 0.5*ones(floor((k*r - 2)/2), 1)', -0.5*ones(k*r-2-floor((k*r - 2)/2), 1)']';
beta = [1, 1, 1]';

for i = 1:Ts
    Z = reshape(mvnrnd(zeros(k * r, 1), Zcov, 1), k, r);
    e = randn(p, q);
    X(:, :, i) = R * Z * C' + e;
    mu = gamma + alpha' * Z(:) + v(1, :) * beta;
    y_linear(i) = normrnd(mu, 1);
    y_logistic(i) = binornd(1, 1 / (1 + exp(-mu)));
    y_poisson(i) = random("Poisson", max(mu, 1));
end
end
