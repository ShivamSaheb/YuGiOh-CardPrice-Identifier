% Shivam Saheb
% CARD PRICE IDENTIFIER - American
%%

function [] = CPIdentifier()
    cardList = readtable("card_list.csv");

    cardTable = getTable(cardList);
        
end

function [title, cardId, rarity] = getTable(cardList)
    
    [rows] = height(cardList);
    
    for i=1:rows
        row = cardList(i,:);
        
        url = string(row.CardURL(1));
        cardId = string(row.CardID(1));
        rarity = string(row.CardRarity(1));
        quantity = row.Quantity(1);
                   
        [title, p] = getDetails(url);  
        
        cardList.CurrentPricePerCard(i,1) = p;
        cardList.CurrentTotalPrice(i,1) = quantity*p;
    end
    
    writetable(cardList, 'card_list_currents.csv');
end

% function [isValid] = validateDetails(title, expectedCardId, expectedRarity)
%     titleSplit = strsplit(title, ' - ');
% 
%     actualName = string(titleSplit(1));
%     actualCardId = string(titleSplit(2));
%     actualRarity = string(titleSplit(3));    
%     
%     isValid = contains(actualCardId, expectedCardId) && contains(actualRarity, expectedRarity);
% end

function [name, p] = getDetails(url)
    tree = getHtmlTree(url);
    name = getName(tree);
    pri = getPrice(tree);
    priSplit = strsplit(pri, '$');
    priSplit = priSplit{2};
    p = str2double(priSplit);
end

function [pageTree] = getHtmlTree(url)
    code = webread(url);
    pageTree = htmlTree(code);
end

function [price] = getPrice(tree)
        selector = "DIV.price";
        priceSection = findElement(tree, selector);
        price = extractHTMLText(priceSection);
        price = price{2}; 
end

function [name] = getName(tree)
    selector = ".itemName";
    nameSection = findElement(tree, selector);
    name = extractHTMLText(nameSection);
        
end