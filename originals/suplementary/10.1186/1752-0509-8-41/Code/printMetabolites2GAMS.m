function printMetabolites2GAMS(fid,model,bacteria,setName,comment)
fprintf(fid,'\n %s %s\n',setName,comment);
fprintf(fid,'/\n');
nc=length(model.mets);
for i=1:nc
 fprintf(fid,'''%s_%s_%s''\n',cell2mat(bacteria),cell2mat(model.mets(i)),num2str(model.metComps(i)));
end
fprintf(fid,'/\n');