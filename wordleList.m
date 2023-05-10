function out = wordleList(knownLetters,removeList)
    arguments
        knownLetters (1,5) char
        removeList (:,2) cell = {}
    end

    P = perms(knownLetters);

    for ii = 1:height(removeList)
        ind = removeList{ii,1};
        letters = removeList{ii,2};
        for jj = 1:numel(letters)
            removeRow = P(:,ind) == letters(jj);
            P(removeRow,:) = [];
        end
    end

    out = P;
end