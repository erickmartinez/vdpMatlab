function [F] = vanDerPauwF(R1234,R2341)
    Rr  = R1234/R2341;
    u   = (Rr-1)/(Rr+1);
    % Use the Newton-Raphson algorithm to find F
    % set initial value
    F0 = 0.5;
    for i=1:100
        F = F0 - corrf(F0,u)/dcorrf(F0,u);
        F0 = F;
    end
end

function [f] = corrf(F,u)
    ln2 = log(2);
    f = cosh(u*ln2/F) - exp(ln2/F)/2.0;
end

function [fp] = dcorrf(F,u)
    ln2 = log(2);
    fp  = (-ln2/F*F)*(u*sin(u*ln2/F) - exp(ln2/F)/2.0);
end