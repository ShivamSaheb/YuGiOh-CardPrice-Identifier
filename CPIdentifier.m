% Shivam Saheb
% CARD PRICE IDENTIFIER - American
%%

function [] = CPIdentifier()
    cardList = readtable("card_list_currents.csv");

    cardTable = getTable(cardList);
        
end

function [title, cardId, rarity] = getTable(cardList)
    
    [rows] = height(cardList);
    
    formatOut = 'mmmm_dd_yyyy_HH_MM_SS';
    identifier = datestr(now, formatOut);
       
    for i=1:rows
        row = cardList(i,:);
        
        url = string(row.CardURL(1));
        cardId = string(row.CardID(1));
        rarity = string(row.CardRarity(1));
        quantity = row.Quantity(1);
                   
        [title, price] = getDetails(url);  
        
        cardList(i, ("PPC_" + identifier)) = cellstr(num2str(price));
        cardList(i, ("TPC_" + identifier)) = cellstr(num2str(quantity * price));
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

function [name, price] = getDetails(url)
    tree = getHtmlTree(url);
    name = getName(tree);
    
    price = getPrice(tree);
end

function [pageTree] = getHtmlTree(url)
    code = webread(url);
    pageTree = htmlTree(code);
end

function [p] = getPrice(tree)
    selector = "DIV.price";
    priceSection = findElement(tree, selector);
    p = extractHTMLText(priceSection);
    
    p = extractAfter(p{1}, "$");
    
    p = str2num(p);
end

function [name] = getName(tree)
    selector = ".itemName";
    nameSection = findElement(tree, selector);
    name = extractHTMLText(nameSection);
        
end