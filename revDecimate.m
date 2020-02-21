%% Reverse Decimation Filter
function res = revDecimate(a)
mu = mean(a);
sigma = std(a);
for ii = 1:length(a)
    if (a(ii) > mu + 5*sigma)
        a(ii) = 0;
    end
end

res = a;
end