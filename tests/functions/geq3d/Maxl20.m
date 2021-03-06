classdef  Maxl20 < aFunction
    
    properties (Constant)
        startPoint = [1; 2; 3; 4; 5; 6; 7; 8; 9; 10; -1; -2; -3; -4; -5; -6; -7; -8; -9; -10];
        optimalPoint = zeros(20,1);
        optimalValue = 0;
        name = 'MaxLinear dim 20';
    end
    
    properties(SetAccess = 'private')
        functionCalls = 0;
        subgradientCalls = 0;
    end
    
    methods 
        function value = getValueAt(obj,x)
            obj.functionCalls = obj.functionCalls + 1;
            
            value = max(abs(x));
        end
        
        function value = getSubgradientAt(obj, x)
            obj.subgradientCalls = obj.subgradientCalls + 1;
            reset = obj.functionCalls;
            value = Subgradient(@obj.getValueAt, x);
            obj.functionCalls = reset;
        end
        
        function resetCounters(obj)
            obj.functionCalls = 0;
            obj.subgradientCalls = 0;
        end    
    end
end
