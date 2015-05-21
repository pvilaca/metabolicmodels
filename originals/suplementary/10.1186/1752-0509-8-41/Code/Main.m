clear all

global un_kegg_gene kegg_ko

% here you should define IMG file for the studied org such as bif_img or fap_img
%for fap
%imgFile='fap_img.xlsx';

%for bif
imgFile='bif_img.xlsx';


% here you should define the reaction data set
reactionsfile='refRxNs.xlsx';

% define the MS-Excel file of the draft model
%for fap
%draftFile='fap_draft.xlsx';
%for bif
draftFile='bif_draft.xlsx';

% this tem file contain SBML of draft model
tmp= 'd:\tmp.xml';


%here we extract GK set (gene, KO) from IMG file
[un_kegg_gene kegg_ko]=get_gene_ko_from_img(imgFile);

% if the organism is in KEGG
%[un_kegg_gene kegg_ko]=get_gene_ko_from_kegg_org_id('bad');

%build the draft model from reaction set
% '+' if  bacteria is  of gram-postive bacteria
% '-' if bacteria is  of gram-negative bacteria

model = buildDraftModel(reactionsfile,'+');


saveToExcel(model,draftFile)

SBMLFromExcel(draftFile,tmp);
% 



%Finally for generate community model
generateComModel('community.xml', 'comModel.xlsx');
generateOptComModel('community.xml','com.gms');


%Now we can map the draft model to KEGG map
m=importModel(tmp);
drawKEGGPathway(m,'map00010');


