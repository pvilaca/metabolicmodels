function r=get_kegg_reaction_id(ec,pathway)
   % The aim of this function is to return KEGG reaction ID (r) from EC and 
   % KEGG Map ID 
   %example: r=get_kegg_reachion_id('1.3.5.1','map00020')
   % NOTE:
   %   the file kegg_rn_ec was downloaded from http://rest.kegg.jp/link/rn/ec
   
   %written by Ibrahim El-Semman 25-May-2013
ec={ec};
[all_enz all_rn]=textread('kegg_rn_ec','%s%s');
all_enz=regexprep(all_enz,'ec:','');
J_ec=find(ismember(all_enz,ec));

rn= all_rn(J_ec);

url=sprintf('http://rest.kegg.jp/link/rn/%s',pathway);
urlwrite(url,'tmp_rn_map');
[map rn_map]=textread('tmp_rn_map','%s%s');

r=intersect(rn,rn_map);
r=regexprep(rn,'rn:','');


