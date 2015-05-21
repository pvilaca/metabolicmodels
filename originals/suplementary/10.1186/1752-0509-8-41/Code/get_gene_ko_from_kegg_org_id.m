function [gene KO]=get_gene_ko_from_kegg_org_id(org)
% the aim of this is to dowonload (gene,ko) from KEGG
% website by KEGG org ID
% org is KEGG organasims ID such as bbb eco bad

url=['http://rest.kegg.jp/link/ko/' org];
urlwrite(url,'tmp_gene_ko');
[gene KO]=textread('tmp_gene_ko','%s%s');
rep1=[org ':'];
rep2='ko:';
gene=regexprep(gene,rep1,'');
KO=regexprep(KO,rep2,'KO:');