classdef Colors
    properties
        RGB (1,3) double
    end
    methods
        function obj = Colors(R,G,B)
             obj.RGB = [R,G,B];
        end
    end
    enumeration
        emptyLight (1,1,1)
        emptyDark (0,0,0)
        notYetUsed (0.8,0.8,0.8)
        notInWord (0.5,0.5,0.5)
        wrongSpot (0.7795,0.7087,0.3189)
        correctSpot (0.4449,0.6693,0.3819)
        border (0.85,0.85,0.85)
        fontLight (1,1,1)
        fontDark (0,0,0)
    end
end