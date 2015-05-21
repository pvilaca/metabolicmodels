function printReaction2GAMS(fid,model,bacteria,setName,comment)
fprintf(fid,'\n %s %s\n',setName,comment);
fprintf(fid,'/\n');
nc=length(model.rxns);
for i=1:nc
    fprintf(fid,'''%s_%s''\n',bacteria,model.rxns{i});
end
fprintf(fid,'/\n');