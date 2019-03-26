% Shivam Saheb
% CARD PRICE IDENTIFIER - American
%%


function [] = CPIdentifier()
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
    
    writetable(cardList, 'card_list_currents.csv');
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
    pri = getPrice(tree, url);
    priSplit = strsplit(pri, '$');
    priSplit = priSplit{2};
    p = str2double(priSplit);
end

function [pageTree] = getHtmlTree(url)
    % Find the URL, save it to a variable called "code"
    code = webread(url);

    % Parse HTML code in "code"
    pageTree = htmlTree(code);
end

function [price] = getPrice(tree, url)
    
    % for the beta version of the website
%     if  contains(url, "beta")
        selector = "DIV.price";
        priceSection = findElement(tree, selector);
        price = extractHTMLText(priceSection);
        price = price{2};
        
%     % for the old version    
%     else
%         selector = "SPAN.priceSection";
%         priceSection = findElement(tree, selector);
%         price = extractHTMLText(priceSection);
%     end  
end

function [name] = getTitle(tree)
    selector = "DIV.itemHeader";
    nameSection = findElement(tree, selector);
    name = extractHTMLText(nameSection);
end

