% Shivam Saheb
% CARD PRICE IDENTIFIER - American
%%

function [] = CPIdentifier()
    clear all
    clc
    cardList = readtable("card_list.csv");

    cardTable = getTable(cardList);
end

function [url, cardId, rarity] = getTable(cardList)
    
    [rows] = size(cardList);
    
    for i=1:rows
        row = cardList(i,:);
        
        url = string(row.CardURL(1));
        cardId = string(row.CardID(1));
        rarity = string(row.CardRarity(1));
        quantity = row.Quantity(1);
        
        [title, p] = getDetails(url);  
        
        cardList.CurrentPricePerCard(i,1) = p;
        cardList.CurrentTotalPrice(i,1) = quantity*p;
        
        % The following 2 lines of code can be used as a check to ensure
        % details in the csv file match details obtained directly from the
        % url
%         isValid = validateDetails(title, cardId, rarity);
%         [title, isValid, rarity]

    end
    
    writetable(cardList, 'card_list_currents.xlsx');
end

function [isValid] = validateDetails(title, expectedCardId, expectedRarity)
    titleSplit = strsplit(title, ' - ');

    actualName = string(titleSplit(1));
    actualCardId = string(titleSplit(2));
    actualRarity = string(titleSplit(3));    
    
    isValid = contains(actualCardId, expectedCardId) && contains(actualRarity, expectedRarity);
end


function [title, p] = getDetails(url)
    tree = getHtmlTree(url);
    title = getTitle(tree);
    pri = getPrice(tree);
    priSplit = strsplit(pri, '$');
    priSplit(1) = [];
    p = str2num(priSplit);
    
end

function [pageTree] = getHtmlTree(url)
    % Find the URL, save it to a variable called "code"
    code = webread(url);

    % Parse HTML code in "code"
    pageTree = htmlTree(code);
end

function [price] = getPrice(tree)
    % Select Present Price from class = "priceSection" in HTML tree
    selector = "SPAN.priceSection";
    priceSection = findElement(tree, selector);
    price = extractHTMLText(priceSection);
end

function [name] = getTitle(tree)
    selector = "H1.product_name";
    nameSection = findElement(tree, selector);
    name = extractHTMLText(nameSection);
end

