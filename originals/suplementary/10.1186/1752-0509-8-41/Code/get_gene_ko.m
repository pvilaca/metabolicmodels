function enz=get_gene_ko(ko)
% this function back with gene has KO ko
% written by Ibrahim El-Semman 24-May-2013

global un_kegg_gene kegg_ko 
J=find(ismember(kegg_ko,ko));
enz=un_kegg_gene(J);