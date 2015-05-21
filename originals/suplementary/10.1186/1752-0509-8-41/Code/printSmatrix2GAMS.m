function printSmatrix2GAMS(fid,model,bacteria)
[nc nr]=size(model.S);
for i=1:nc
    for j=1:nr
        if (model.S(i,j)~=0)
            fprintf(fid,'''%s_%s_%s''.''%s_%s'' %f\n',bacteria,model.mets{i},num2str(model.metComps(i)),bacteria,model.rxns{j},full(model.S(i,j)));
        end
    end
end

fprintf(fid,'/\n');