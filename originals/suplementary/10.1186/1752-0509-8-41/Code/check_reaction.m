function [insert r]=check_reaction(r,type)
    if type=='-'
      insert =true;
      return;
    elseif type=='+' 
        insert=false;
        if numel(regexp(cell2mat(r.equations),'\[b\]'))>0
           insert=false;
           return;
        end
        if numel(regexp(cell2mat(r.equations),'Cytosol'))>0
            insert=true;
        end
        if numel(regexp(cell2mat(r.equations),'Extraorganism'))>0
            insert=true;
        end
        
        r.equations={regexprep(cell2mat(r.equations),'Extraorganism','b')};
        r.equations={regexprep(cell2mat(r.equations),'Periplasm','Extraorganism')};
    end
        
   