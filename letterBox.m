classdef letterBox < handle & matlab.mixin.SetGet
    %% Properties
    properties
        letter (1,1) string = ""
        fillColor (1,1) Colors = Colors.emptyDark
        fontSize (1,1) double = 0.2
        fontWeight (1,1) string = "bold"
        fontName (1,1) string = "Helvetica"
        fontColor (1,1) Colors = Colors.fontDark
        lineWidth (1,1) double = 2;
        position (1,2) double = [0,0]
    end

    properties
        axes (1,1)
        letterIsGuessed (1,1) logical = false
    end

    properties (Access = private)
        boxGraphics
        letterGraphics
    end

    properties (Dependent)
        letterIsEmpty (1,1) logical
    end


    %% Methods -- constructor/destructor
    methods
        function obj = letterBox(opts)
            arguments
                opts.letter =  "";
            end
            
            obj.letter = opts.letter;

            obj.boxGraphics = gobjects(1);
            obj.letterGraphics = gobjects(1);
        end
    end

    %% Methods -- set/get
    methods
        function set.letter(obj,newVal)
            newVal = newVal.strip.upper;
            if obj.letter ~= newVal
                obj.letter = newVal;
                obj.updateGraphics;
            end
        end

        function set.position(obj,newVal)
            if any(obj.position ~= newVal)
                obj.position = newVal;
                obj.updateGraphics;
            end
        end

        function set.fillColor(obj,newVal)
            if obj.fillColor ~= newVal
                obj.fillColor = newVal;
                obj.updateGraphics;
            end
        end

        function set.fontColor(obj,newVal)
            if obj.fontColor ~= newVal
                obj.fontColor = newVal;
                obj.updateGraphics;
            end
        end

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

    %% Methods -- graphics
    methods (Access = private)
        function updateGraphics(obj)
            obj.drawBox;
            obj.drawLetter;
        end

        function drawBox(obj)
            if isempty(obj.boxGraphics) || ~isgraphics(obj.boxGraphics)
                obj.boxGraphics = patch(obj.axes,NaN,NaN,'w');
            end

            obj.boxGraphics.XData = obj.position(1) + 0.5*[-1,1,1,-1];
            obj.boxGraphics.YData = obj.position(2) + 0.5*[-1,-1,1,1];
            if ~obj.letterIsGuessed
                obj.boxGraphics.EdgeColor = Colors.border.RGB;
            else
                obj.boxGraphics.EdgeColor = obj.fillColor.RGB;
            end
            obj.boxGraphics.FaceColor = obj.fillColor.RGB;
            obj.boxGraphics.LineWidth = obj.lineWidth;
        end

        function drawLetter(obj)
            if isempty(obj.letterGraphics) || ~isgraphics(obj.letterGraphics)
                obj.letterGraphics = text(obj.axes,NaN,NaN,'',FontUnits="normalized",HorizontalAlignment="center");
            end

            obj.letterGraphics.String = obj.letter;
            obj.letterGraphics.Position = obj.position;
            obj.letterGraphics.FontSize = obj.fontSize;
            obj.letterGraphics.FontWeight = obj.fontWeight;
            obj.letterGraphics.FontName = obj.fontName;
            obj.letterGraphics.Color = obj.fontColor.RGB;
        end
    end
    
end