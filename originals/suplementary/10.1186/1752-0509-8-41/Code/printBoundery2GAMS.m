function printBoundery2GAMS(fid,model,bacteria)
nr=length(model.rxns);
for i=1:nr
    fprintf(fid,'UB_%s(''%s_%s'')=%f;\n',bacteria,bacteria,model.rxns{i},model.ub(i));
    fprintf(fid,'LB_%s(''%s_%s'')=%f;\n',bacteria,bacteria,model.rxns{i},model.lb(i));
end
