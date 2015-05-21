function model = buildMainModel(model,reactionsfile,type)
% The aim of this function is build a draft model from
% reference model reactionfile

[ndata, text, alldata] =xlsread(reactionsfile);

rxnID=text(:,2);
rxnName=text(:,3);
eq=text(:,4);
EC=text(:,5);
subSystem=text(:,10);

r='';
  for i=2:numel(EC)
   
      fprintf('Working in reaction %s \n',cell2mat(rxnID(i)));
       % add the reaction without EC
        if strcmp(EC(i),'')
          enz={''};
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
          
          
         [insert r]=check_reaction(r,type);
         if insert==true
             model=addNewRxns(model,r,3,'1',true);
         end
        
          
          
      else
         ko_flag=0;
         clear org_genes
         index= regexp(cell2mat(EC(i)),'K');
         if numel(index)>=1
             kos_genes=1;
             kos=regexp(cell2mat(EC(i)),'K\d*','match');
             for koi=1:numel(kos)
                 ko=strcat('KO:', kos(koi));
                 org_genes1=get_gene_ko(ko);
                  for kk=1:numel(org_genes1)
                      org_genes(kos_genes)=org_genes1(kk);
                      kos_genes=kos_genes+1;
                      ko_flag=1;
                  end
             end
           
         end
             
          enzyme=strcat('ec:', EC(i));
          enz=get_gene_ec(enzyme);
          if  numel(enz)>=1 || ko_flag==1
              % Reterive the genes for enzymes and build the rule
              if ko_flag==0
                  org_genes=get_gene_ec(enzyme);
              end
                            
              if ~iscell(org_genes)
                  org_genes={org_genes};
              end
              
              rule=convertGenesToRule(org_genes);
              if ko_flag==1
                  enz=regexprep(ko,'ko:','');
              else
                  enz=regexprep(enzyme,'ec:','');
              end
              
           
         
              
    r.equations=eq(i);
    r.rxns=rxnID(i);
    r.rxnNames=regexprep(rxnName(i),'["%<>\\]','');
    rev=regexp(cell2mat(eq(i)),'<=>');
    if numel(rev)
      r.lb=-1000;
      r.ub=1000;
    else
      r.lb=0;
      r.ub=1000;
    end
    r.c=0;
    r.grRules=rule;
    r.subSystems=subSystem(i);
    r.eccodes=EC(i);
    
    [insert r]=check_reaction(r,type);
    if insert==true
           % % Insert genes into model
        for jj=1:numel(org_genes)
                 ng=find(ismember(model.genes,org_genes(jj)));
                 if numel(ng)==0
                   model.genes(numel(model.genes)+1)=org_genes(jj);
                 end
        end
        model=addNewRxns(model,r,3,'1',true);
    end
        
    end
 end
      
 end
  
  
  
  
  