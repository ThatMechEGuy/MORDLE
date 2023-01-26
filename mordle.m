%{
• Reveal letters one by one
• Dark mode
• No AppDesigner, create uifigure through code
• Keyboard buttons should be able to have "quadrants" of color for immitating "Qourdle"
    ○ Implement in a general way to support an arbitrary grid size
• Each MORDLE game takes a grid as an input, automatically creates sub-grids for axes and controls.
%}

classdef mordle < handle
    %% Proeprties
    properties (SetAccess = immutable)
        nGuesses (1,1) double = 6
        nLetters (1,1) double = 5
        solution = "FONLF";
    end

    properties (Access = private)
        axes (1,1)

        letterBoxes letterBox

        wordIsGuessed (:,1) logical
        gameOver (1,1) logical = false
    end

    properties (Constant, Access = private)
        letterBoxPadding (1,1) double = 0.12
        fontSize (1,1) double = 0.09;
        fontWeight (1,1) string = "bold";
        fontName (1,1) string = "Helvetica";
        boxlineWidth (1,1) double = 1
    end

    properties (Dependent)
        nFilledLetters (1,1) double
        currentGuess (1,1) double
        letterIsFilled (1,:) logical
        lettersAsString string
    end

    %% Methods -- constructor/destructor
    methods
        function obj = mordle(axes)
            
            obj.axes = axes;

            obj.axes.Visible = false;
            axis(obj.axes,"equal");

            obj.letterBoxes(obj.nGuesses,obj.nLetters) = letterBox;

            set(obj.letterBoxes,"axes",obj.axes);
            set(obj.letterBoxes,"fontSize",obj.fontSize);
            set(obj.letterBoxes,"fontWeight",obj.fontWeight);
            set(obj.letterBoxes,"fontName",obj.fontName);
            set(obj.letterBoxes,"lineWidth",obj.boxlineWidth);
            set(obj.letterBoxes,"fillColor",Colors.emptyLight);
            

            for ii = 1:obj.nGuesses
                for jj = 1:obj.nLetters
                    obj.letterBoxes(ii,jj).position = [jj*(1+obj.letterBoxPadding)-obj.letterBoxPadding,(obj.nGuesses - ii)*(1+obj.letterBoxPadding)-obj.letterBoxPadding];
                end
            end

            obj.newGame;

        end
    end

    %% Methods -- set/get
    methods
        function out = get.nFilledLetters(obj)
            out = obj.lettersAsString.strlength;
        end

        function out = get.letterIsFilled(obj)
            out = ~[obj.letterBoxes(obj.currentGuess,:).letterIsEmpty];
        end

        function out = get.lettersAsString(obj)
            out = strjoin([obj.letterBoxes(obj.currentGuess,:).letter],"");
        end

        function out = get.currentGuess(obj)
            out = find(~obj.wordIsGuessed,1);
            out = min(out,obj.nGuesses);
        end
    end

    %% Methods
    methods
        function newGame(obj)
            for B = obj.letterBoxes(:).'
                B.clearLetter;
            end
            obj.wordIsGuessed = false(obj.nGuesses,1);
            set(obj.letterBoxes,"fillColor",Colors.emptyLight);
            set(obj.letterBoxes,"fontColor",Colors.fontDark);
        end

        function submitGuess(obj)
            if obj.gameOver
                return
            end

            if obj.nFilledLetters < obj.nLetters
                return
            end

            guessAsChar = char(obj.lettersAsString);
            solutionAsChar = char(obj.solution);

            correctPos = guessAsChar == solutionAsChar;

            solutionAsChar(correctPos) = ' ';
            guessAsChar(correctPos) = ' ';
            
            wrongPos = false(1,obj.nLetters);
            for ii = find(guessAsChar ~= ' ')
                if contains(solutionAsChar,guessAsChar(ii))
                    wrongPos(ii) = true;
                    letterInd = find(solutionAsChar == guessAsChar(ii),1);
                    solutionAsChar(letterInd) = ' ';
                end
            end

            set(obj.letterBoxes(obj.currentGuess,:),"letterIsGuessed",true);

            set(obj.letterBoxes(obj.currentGuess,correctPos),"fillColor",Colors.correctSpot);
            set(obj.letterBoxes(obj.currentGuess,wrongPos),"fillColor",Colors.wrongSpot);
            set(obj.letterBoxes(obj.currentGuess,~(wrongPos | correctPos)),"fillColor",Colors.notInWord);
            set(obj.letterBoxes(obj.currentGuess,:),"fontColor",Colors.fontLight);

            obj.wordIsGuessed(obj.currentGuess) = true;
            
            obj.gameOver = sum(correctPos) == obj.nLetters;
        end

        function addLetter(obj,letter)
            if obj.gameOver
                return
            end

            if obj.nFilledLetters < obj.nLetters
                addLetterInd = find(~obj.letterIsFilled,1);
                obj.letterBoxes(obj.currentGuess,addLetterInd).letter = letter;
            end
        end

        function deleteLetter(obj)
            if obj.gameOver
                return
            end

            if obj.nFilledLetters >= 1
                deleteLetterInd = find(obj.letterIsFilled,1,"last");
                if isempty(deleteLetterInd)
                    deleteLetterInd = obj.nLetters;
                end
                obj.letterBoxes(obj.currentGuess,deleteLetterInd).clearLetter;
            end
        end
    end
end