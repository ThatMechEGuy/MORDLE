classdef letterContainer < handle & matlab.mixin.SetGet
    %% Properties
    properties
        letter (1,1) string = ""
        fillColor (1,1) Colors = Colors.emptyLight
        fontSize (1,1) double = 0.2
        fontWeight (1,1) string = "bold"
        fontName (1,1) string = "Helvetica"
        fontColor (1,1) Colors = Colors.fontLight
        lineWidth (1,1) double = 2;
        position (1,2) double = [0,0]

        axes {mustBeScalarOrEmpty}
        letterIsGuessed (1,1) logical = false
    end

    properties (Access = private)
        boxGraphics
        letterGraphics
    end

    %% Methods -- constructor/destructor
    methods
        function obj = letterContainer(opts)
            arguments
                opts.letter (1,1) string = ""
                opts.fillColor (1,1) Colors = Colors.emptyLight
                opts.fontSize (1,1) double = 0.2
                opts.fontWeight (1,1) string = "bold"
                opts.fontName (1,1) string = "Helvetica"
                opts.fontColor (1,1) Colors = Colors.fontLight
                opts.lineWidth (1,1) double = 2;
                opts.position (1,2) double = [0,0]
        
                opts.axes {mustBeScalarOrEmpty} = []
                opts.letterIsGuessed (1,1) logical = false
            end

            obj.letter = opts.letter;
            obj.fillColor = opts.fillColor;
            obj.fontSize = opts.fontSize;
            obj.fontWeight = opts.fontWeight;
            obj.fontName = opts.fontName;
            obj.fontColor = opts.fontColor;
            obj.lineWidth = opts.lineWidth;
            obj.position = opts.position;
            if ~isempty(opts.axes)
                obj.axes = opts.axes;
            end
            obj.letterIsGuessed = opts.letterIsGuessed;


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
    end

    %% Methods -- graphics
    methods (Access = protected)
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