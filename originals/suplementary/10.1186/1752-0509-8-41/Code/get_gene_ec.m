function enz=get_gene_ec(ec)
% the file kegg_ko_ec is downloaded from KEGG 
% by http://rest.kegg.jp/link/ko/ec
% Written by Ibrahim El-Semman 24-May-2013


global un_kegg_gene kegg_ko 

[EC KOs]=textread('kegg_ko_ec.txt','%s%s');
KOs=regexprep(KOs,'ko:','KO:');

I =find(ismember(EC,ec));
J=find(ismember(kegg_ko,KOs(I)));
enz=un_kegg_gene(J);
