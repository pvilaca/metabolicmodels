function model = buildDraftModel_full(reactionsfile)
% the aim of this function is build a draft model from reaction set, gene,
% and KO.
% model is a draft model
% written by Ibrahim El-Semman 25-May-2013 
type='-';
model=initModel(type);
model=buildMainModel_full(model,reactionsfile,type);
if type=='-'
for i=1:numel(model.metNames)
    j=find(ismember(model.metNames,model.metNames(i)));
   if numel(j)==3
       for k=1:numel(j)
           if strcmp(model.metComps(j(k)),{'e'})
               model.unconstrained(j(k))=1;
           end
       end
   end
    
    if numel(j)==4
      for k=1:numel(j)
         if strcmp(model.metComps(j(k)),{'b'})
               model.unconstrained(j(k))=1;
         end
       end
    end
    
end

elseif type=='+'
    for i=1:numel(model.metNames)
    j=find(ismember(model.metNames,model.metNames(i)));
   if numel(j)==3
       for k=1:numel(j)
           if strcmp(model.metComps(j(k)),{'b'})
               model.unconstrained(j(k))=1;
           end
       end
   end
    
     
    end
end

 % ADD metabolite information to the model
 [ndata, met_ref, alldata] =xlsread(reactionsfile,'METS');
 for i=1:numel(model.metNames)
    
    jj=find(ismember(met_ref(:,3),model.metNames(i)));
    if numel(jj)>=1
        model.metFormulas(i)=met_ref(jj(1),6);
        model.inchis(i)=met_ref(jj(1),7);
        model.metMiriams(i)=met_ref(jj(1),5);
    end
 end
end

