function model = buildMainModel_full(model,reactionsfile,type)
% The aim of this function is build a draft model from
% reference model reactionfile

[ndata, text, alldata] =xlsread(reactionsfile);

rxnID=text(:,1);
rxnName=text(:,2);
eq=text(:,3);
EC=text(:,4);
subSystem=text(:,5);

r='';
  for i=2:numel(EC)
      fprintf('Working in reaction %s \n',cell2mat(rxnID(i)));
       % add the reaction without EC
            enz=EC(i);
          rule={''};
          r.equations=eq(i);
          r.rxns=rxnID(i);
          r.rxnNames=regexprep(rxnName(i),'["%<>\\]','');
          r.lb=-100000;
          r.ub= 100000;
          r.c=0;
          r.grRules=rule;
          r.subSystems=subSystem(i);
          r.eccodes=enz;
          
          model=addNewRxns(model,r,3,'1',true);
 end
        
          
  