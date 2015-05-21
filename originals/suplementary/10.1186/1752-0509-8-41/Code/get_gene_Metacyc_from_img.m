function [gene MetaCyc]=get_gene_Metacyc_from_img(xlsfile)
% The aim of this function is extracting the set (gene TIGRFAM desccription)
%the xlsfile is excel file is downoladed from IMG
%NOTE 
     % 3 is col which containg KO
     % 2 is col which containg gene locus name
     
% written by Ibrahim El-Semman 24-May-2013

[ndata, text, alldata] =xlsread(xlsfile);
[n m]=size(text);
k=1;
for i=1:n
    index=regexp(cell2mat(text(i,3)),'Metacyc','match');
     if numel(index)
        gene(k)=text(i,2);
        MetaCyc(k)=text(i,4);
        k=k+1;
     
    end
end
