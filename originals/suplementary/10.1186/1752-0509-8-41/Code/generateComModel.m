function generateComModel(CML,xlsfile)
% The aim of this function is to generate FBA model of communityML file CML
% and export this community into excel file xlsfile
% NOTE: CML file should be full path
%example:
     %   generateComModel('community.xml', 'comModel.xlsx')



% Read Community Structure
    com=importCommunity(CML);
    
% init Model
modelNames=com.modelNames;
modelFiles=com.modelFiles;
Model.id='Community';
Model.description='Community';
Model.S=0;
Model.lb=0;
Model.ub=0;
Model.c=0;
Model.b=0;
Model.rev=0;
Model.mets={};
Model.metNames={};
n0=0;
m0=0;
kn=1;
km=1;
kg=1;
kc=1;
ek=1;
kf=1;
for i=1:numel(modelNames)
   SBMLFromExcel1(cell2mat(modelFiles(i)),'test_com.xml');
    b(i)=importModel('test_com.xml',false);
%    b(i)=simplifyModel(b(i));
    [n m]=size(b(i).S);
    n0=n0+n;
    m0=m0+m;
    Model.S(kn:n0,km:m0)=b(i).S;
    Model.lb(km:m0,1)=b(i).lb;
    Model.ub(km:m0,1)=b(i).ub;
    Model.c(km:m0,1)=b(i).c;
    Model.b(kn:n0,1)=b(i).b;
    
    % build media reactions
    k_unconstrain=1;
    for j=1:numel(com.fluxNames)
        if com.Interaction(i,j)~=0
            eq=constructEquations(b(i),com.fluxNames(j));
            met=regexp(eq,'\w*\-\w*\[b\w*\]','match');
            if numel(cell2mat(met{1}))==0
                met=regexp(eq,'\w*\w*\[b\w*\]','match');
            end
            metMedia(ek)=met{1};
            metCompartment=regexp(met{1},'\[b\w*','match');
            metCompartment=regexprep(metCompartment{1},'\[','');
            metMediaName(ek)=regexprep(met{1},'\[b\w*\]','');
            
            unconstraintMet(k_unconstrain)={sprintf('%s[%s]',cell2mat(metMediaName(ek)),cell2mat(metCompartment))};
            
            if com.Interaction(i,j)==-1
                reaction(ek)={sprintf('%s[Media] => %s[%s_%s]',cell2mat(metMediaName(ek)),cell2mat(metMediaName(ek)),cell2mat(com.modelNames(i)),cell2mat(metCompartment))};
            elseif com.Interaction(i,j)==1
                reaction(ek)={sprintf('%s[%s_%s] => %s[Media]',cell2mat(metMediaName(ek)),cell2mat(com.modelNames(i)),cell2mat(metCompartment),cell2mat(metMediaName(ek)))};
            end
            
            % assign reaction ID
            reactionName(ek)={sprintf('%s from Media to %s',cell2mat(metMediaName(ek)), cell2mat(com.modelNames(i)))};
               
            ek=ek+1;
            k_unconstrain=k_unconstrain+1;
        end
    end
   
    
    %change the metabolite Names
  
    for j=1:numel(b(i).mets)
        
         Model.mets(kn+j-1,1)={sprintf('%s_%s',cell2mat(com.modelNames(i)),cell2mat(b(i).mets(j)))};
         Model.metNames(kn+j-1,1)=b(i).metNames(j);
         Model.metComps(kn+j-1,1)={sprintf('%s_%s',cell2mat(com.modelNames(i)),num2str(b(i).metComps(j)))};
         
     %remove unconstrained met for media metabolites such as acetate,glucose.
         
        
        jj=b(i).metComps(j);
         met1={sprintf('%s[%s]' , cell2mat(b(i).metNames(j)),cell2mat(b(i).compNames(jj)))};
        
        if numel(find(ismember(unconstraintMet,met1)))>=1
          Model.unconstrained(kn+j-1,1)=0;
        else
             Model.unconstrained(kn+j-1,1)=b(i).unconstrained(j);
        end
    end
    % change reaction Names
    for j=1:numel(b(i).rxns)
       Model.rxns(km+j-1,1)={sprintf('%s_%s',cell2mat(com.modelNames(i)),cell2mat(b(i).rxns(j)))};
       Model.rxnNames(km+j-1,1)={sprintf('%s_%s',cell2mat(com.modelNames(i)),cell2mat(b(i).rxns(j)))};
       Model.rev(km+j-1,1)=b(i).rev(j);
    end
    
      for j=1:numel(b(i).genes)
         Model.genes(kg+j-1)=b(i).genes(j);
      end
    
    % change compartment name
    for j=1:numel(b(i).comps)
       Model.comps(kc+j-1,1)={sprintf('%s_%s',cell2mat(com.modelNames(i)),cell2mat(b(i).comps(j)))};
       Model.compNames(kc+j-1,1)={sprintf('%s_%s',cell2mat(com.modelNames(i)),cell2mat(b(i).compNames(j)))};
       if numel(cell2mat(b(i).compOutside(j)))~=0
           Model.compOutside(kc+j-1,1)={sprintf('%s_%s',cell2mat(com.modelNames(i)),cell2mat(b(i).compOutside(j)))};
       end
    end
    
    JJ=find(com.Interaction(i,:)~=0);
    
    for j=1:numel(JJ)
        transporter_flux(kf)={sprintf('%s_%s',cell2mat(com.modelNames(i)),cell2mat(com.fluxNames(JJ(j))))};
        kf=kf+1;
    end
    
    kn=kn+n;
    km=km+m;
    kg=kg+numel(b(i).genes);
    
    kc=kc+numel(b(i).comps);
   
  

end

metMedia=unique(metMediaName);

% add the out reactions
ekk=ek;
for i=1:numel(metMedia)
    reaction(ek)={sprintf('%s[Out] <=> %s[Media]',cell2mat(metMedia(i)),cell2mat(metMedia(i)))};
    reactionName(ek)={sprintf('%s from Out to Media',cell2mat(metMedia(i)))};      
    
    jj=0;
    for j=1:numel(com.media)
        if numel(regexp(cell2mat(metMedia(i)),com.media{j},'match'))
            jj=j;
        end
    end
    
    if jj ~=0
        lb(ek)=str2num(cell2mat(com.media_con(jj)));
        ub(ek)=str2num(cell2mat(com.media_con(jj)));
    end
    
    ek=ek+1;
    
end

% Add new Compartments to Model
Model.comps(kc)={'8'};
Model.compNames(kc)={'Media'};
Model.compOutside(kc)={'8'};

Model.comps(kc+1)={'9'};
Model.compNames(kc+1)={'Out'};
Model.compOutside(kc+1)={'9'};

Model.first=2;

% add the media reactions into Model

for i=1:numel(reaction)
    r.equations=reaction(i);
    r.rxnNames=reactionName(i);
    r.rxns={sprintf('M%d',i)};
    r.subSystems={'Media'};
    if i>=ekk
        r.lb=lb(i);
        r.ub=ub(i);
    end
    Model=addNewRxns(Model,r,3,'1',true);
    
end

% make out metabolites are unconstrained
jj=find(ismember(Model.metComps,{'9'}));
Model.unconstrained(jj)=1;

% remove the boundries for transporter reaction
jj=find(ismember(Model.rxns,transporter_flux));
Model.lb(jj)=-1000;
Model.ub(jj)=1000;

saveToExcel(Model,xlsfile);



