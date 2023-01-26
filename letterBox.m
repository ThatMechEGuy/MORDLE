classdef letterBox < letterContainer

    properties (Dependent)
        letterIsEmpty (1,1) logical
    end


    %% Methods -- constructor/destructor
    methods
        function obj = letterBox(opts)
            arguments
                opts.?letterContainer
            end

            optsCell = namedargs2cell(opts);

            obj@letterContainer(optsCell{:});

            
        end
    end

    %% Methods -- set/get
    methods
        function out = get.letterIsEmpty(obj)
            out = obj.letter == "";
        end
    end

    %% Methods
    methods
        function clearLetter(obj)
            obj.letter = "";
            obj.letterIsGuessed = false;
            obj.updateGraphics;
        end
    end
end