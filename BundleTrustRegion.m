function [ xStar, Xs, asCounter, nsCounter ] = BundleTrustRegion( funct, xk,  params )
%BundleTrustRegion A Bundle Trust Region Algorithm to find the minimum of a
%nonsmooth, convex function

m1 = params(1);
m2 = params(2);
m3 = params(3);
T = params(5);
maxBundleSize = params(8);

%Helpers

k = 1;
Xs(:,k) = xk;
nsCounter = 0;
asCounter = 0;

%initial steps
s1 = Subgradient(funct , xk);
Bundle(:,1) = s1;
Alphas = 0;
skTildeMinus1 = s1;
alphakTildeMinus1 = 0;
maxIter = 300;


[ tkMinus1, xPlus, sPlus, alphaPlus, outcome, fxdMinusfx ] = Schrittweite622( funct, xk, -s1, [T*m3 m1 m2] );
[Bundle, Alphas] = UpdateBundlePlus (Bundle, Alphas, outcome, fxdMinusfx, -tkMinus1*s1, sPlus, alphaPlus);
if outcome == 1
    xk = xPlus;
end

%run main loop
while k < maxIter
    [ tk, ~, dt, skTilde, alphakTilde, skPlus, alphakPlus, outcome, fxdMinusfx ] = Verfahren842( funct, xk, tkMinus1, Bundle, Alphas, skTildeMinus1, alphakTildeMinus1, params );
    if outcome == 0
        xStar = xk;
        break;
    end
    
    if outcome == 1
        xkPlus = xk + dt;
        asCounter = asCounter + 1;
    else
        xkPlus = xk;
        nsCounter = nsCounter + 1;
    end
    
    %update Bundle
    [ Bundle, Alphas ] = UpdateBundleFull(Bundle, Alphas, outcome, maxBundleSize, fxdMinusfx, dt, skTilde, alphakTilde, skPlus, alphakPlus);

    xk = xkPlus;
    tkMinus1 = tk;
    skTildeMinus1 = skTilde;
    alphakTildeMinus1 = alphakTilde;
    k = k+1;
    xStar = xk;
    Xs(:,k) = xk;
end


end
