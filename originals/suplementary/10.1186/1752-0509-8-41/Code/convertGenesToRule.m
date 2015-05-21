function grRule=convertGenesToRule(geneList)

if numel(geneList)>0
    grRule=geneList(1);
    for i=2:numel(geneList)
        grRule={sprintf('%s and %s', cell2mat(grRule),cell2mat(geneList(i)))};
    end
else
    grRule={};
    
end
end
