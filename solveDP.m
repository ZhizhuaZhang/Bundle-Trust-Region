function [v, d, beta] = solveDP(t, Bundle, Alphas, tol, round)
    dimensionOfBeta = length(Alphas);
    A = [];
    b = [];
    Aeq = ones(1,dimensionOfBeta);
    beq = 1;
    lb = zeros(dimensionOfBeta,1);
    ub = Inf(dimensionOfBeta,1);
    
    %Start Value
    startValue = repmat(1/dimensionOfBeta,dimensionOfBeta,1);
    
    options = optimoptions('fmincon','Algorithm','active-set', 'TolCon', tol, 'TolFun', tol, 'Display', 'off');
    beta = fmincon(@QP_Problem, startValue, A, b, Aeq, beq, lb, ub, [], options);
    if round
        beta = max (beta,0);
        if sum(beta)>0
            beta = beta / sum(beta);
        end
    end
    %Convert to solution of DP
    sBeta = Bundle * beta;
    
    d = -t*sBeta;
    v = -t*dot(sBeta,sBeta) - Alphas*beta;

    function value = QP_Problem(beta)
        vector = Bundle*beta;
        barrier = Alphas*beta/t;
        value = 0.5* dot(vector,vector) + barrier;
    end
end