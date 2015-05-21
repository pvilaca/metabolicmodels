function generateOptComModel(CML,GAMSFile)
%the aim of this is to generate optcom model using communityML file CML
%NOTE CML should written as full path with folder sepration \\ instead of \
%example

fid=fopen(GAMSFile,'w');
com=importCommunity(CML);
modelNames=com.modelNames;
modelFiles=com.modelFiles;
for i=1:numel(modelNames)
    SBMLFromExcel(cell2mat(modelFiles(i)),'test_com.xml');
    b(i)=importModel('test_com.xml');
    b(i)=simplifyModel(b(i));

end
%write report about reading process
clc
fprintf('\n--Reading Models\n');
for i=1:numel(modelNames)
   fprintf('----Reads %s\n',cell2mat(modelNames(i)));
end


fprintf(fid,'\n SETS\n');

% print the metabolite set for each bacteria int GAMS

for i=1:numel(b)
   set=sprintf('i_%s',cell2mat(modelNames(i)));
   comment=sprintf('The set of metabolites in the model bacteria %s',cell2mat(modelNames(i)));
   printMetabolites2GAMS(fid,b(i),modelNames(i), ...
                set,comment);
end

%print the reaction set for each bacteria
 
for i=1:numel(b)
   set=sprintf('j_%s',cell2mat(modelNames(i)));
   comment=sprintf('The set of reactions in the model bacteria %s',cell2mat(modelNames(i)));
   printReaction2GAMS(fid,b(i),cell2mat(modelNames(i)), ...
                set,comment);
end

fprintf(fid,'\nPARAMETERS\n');
 
 for i=1:numel(b)
     org=cell2mat(modelNames(i));
     set=sprintf('j_%s',cell2mat(modelNames(i)));
     fprintf(fid,'\nUB_%s(%s) UB on reactions for bacterial %s',org,set,org);
     fprintf(fid,'\nLB_%s(%s) LB on reactions for bacterial %s',org,set,org);
 end
 
fprintf(fid,'\n\n\n');

  for i=1:numel(b)
     org=cell2mat(modelNames(i));
     set=sprintf('j_%s',cell2mat(modelNames(i)));
     fprintf(fid,'\nS_%s(i_%s,j_%s) Stoichiomteric matrix for %s \n/\n',org,org,org,org);
     printSmatrix2GAMS(fid,b(i),org)     
 end

fprintf(fid,'\n;\n\n');

for i=1:numel(b)
   org=cell2mat(modelNames(i));
   printBoundery2GAMS(fid,b(i),org);
end


fprintf(fid,'\n\nVARIABLES\n');
fprintf(fid,'        z_outer        Outer problem objective function\n\n');

for i=1:numel(b)
    org=cell2mat(modelNames(i));
    fprintf(fid,'        v_%s(j_%s)        Flux of %s rxns\n',org,org,org);
    fprintf(fid,'        lambda_%s(i_%s)   Dual variables associated with mass balaance eqn for %s\n',org,org,org);
    fprintf(fid,'\n\n');
end

% print dual variable for import and export
k=1;
I=com.Interaction;
[nc mc]=size(I);

constrain={};
sum_dual={};
for i=1:nc
    dual_var='';
    dual='';
    plus='';
    
    org=cell2mat(com.modelNames(i));
    for j=1:mc
       met=com.metNames{k};
       flux=com.fluxNames{k};
        if I(i,j)==1
          fprintf(fid,'        alpha_%s\n',met);
          var=sprintf('alpha_%s',met);
          dual=sprintf('%s %s %s',dual,plus,var);
          var1=sprintf('eval_%s',met);
          dual_var=sprintf('%s %s %s*%s',dual_var,plus,var,var1);
          plus='+';
          
           k=k+1;
        elseif I(i,j)==-1
          fprintf(fid,'        beta_%s\n',met);
          var=sprintf('beta_%s',met);
          var1=sprintf('uval_%s',met);
          dual=sprintf('%s %s %s',dual,plus,var);
          dual_var=sprintf('%s%s%s*%s',dual_var,plus,var,var1);
          plus='+';
          
          k=k+1;
        end
    end
     constrain(i)={dual_var};    
     sum_dual(i)={dual};

    fprintf(fid,'\n\n');
end

fprintf(fid,'\nPOSITIVE VARIABLES\n');

for i=1:numel(b)
    org=cell2mat(modelNames(i));
    fprintf(fid,'        muLB_%s(j_%s)     Dual variables associated with v(j) >= LB(j) for %s\n',org,org,org);
    fprintf(fid,'        muUB_%s(j_%s)     Dual variables associated with v(j) >= LB(j) for %s\n',org,org,org);

    fprintf(fid,'\n\n');
end
I=com.Interaction;

k=1;
for i=1:nc
    
    
    org=cell2mat(com.modelNames(i));
    for j=1:mc
        met=com.metNames{k};
       flux=com.fluxNames{k};
        if I(i,j)==1
          fprintf(fid,'        eval_%s\n',met);
          k=k+1;
          
        elseif I(i,j)==-1
          fprintf(fid,'        uval_%s\n',met);
          
          k=k+1;
        end
        
    end
    fprintf(fid,'\n\n');

end
%print ; end of postive variable
fprintf(fid,'\n;\n');

% print assign lower and upper bound to each flux

for i=1:numel(b)
    org=cell2mat(modelNames(i));
    fprintf(fid,'v_%s.lo(j_%s)=LB_%s(j_%s);\n',org,org,org,org);
    fprintf(fid,'v_%s.up(j_%s)=UB_%s(j_%s);\n',org,org,org,org);
    fprintf(fid,'\n\n');
end

printModel={};
fprintf(fid,'EQUATIONS\n');
fprintf(fid,'* Outer problem\n');
printModel(1)={sprintf('* Outer problem\n')};
fprintf(fid,'         outerobj         Objective function of the outer problem\n');

printModel(2)={sprintf('outerobj\n')};
km=2;
for i=1:numel(com.media)
    media=cell2mat(com.media(i));
    fprintf(fid,'         total_%s\n',media);
    km=km+1;
    printModel(km)={sprintf('total_%s\n',media')};
    media_eq_name(i)={sprintf('total_%s..',media')};
    leftside='0';
    rightside='0';
    for ii=1:numel(com.modelNames)
        for jj=1:numel(com.metNames)
            ind=regexp(cell2mat(com.metNames(jj)),media);
            if numel(ind)
                if (com.Interaction(ii,jj)<0)
                    leftside=sprintf('%s + uval_%s',leftside,cell2mat(com.metNames(jj)));
                end
                if (com.Interaction(ii,jj)>0)
                    rightside=sprintf('%s + eval_%s',rightside,cell2mat(com.metNames(jj)));
                end
                
            end
        end
    end
    if leftside=='0'
        leftside='';
    else
        leftside=regexprep(leftside,'0 \+ ','');
    end
    
    if rightside=='0'
        rightside='';
    else
        rightside=regexprep(rightside,'0 \+ ','');
    end
    ammount=cell2mat(com.media_con(i));
    relation=cell2mat(com.media_relation(i));
    
    opertor='e';
    if strcmp(relation,'Competition')
        opertor='e';
    end
    
    if strcmp(relation,'Mutualism')
        opertor='l';
    end
    
    
    
    
    if (numel(rightside)==0)
          media_eq(i)= {sprintf('%s=%s=%s',leftside,opertor,ammount)}; 
    else
        media_eq(i)= {sprintf('%s-%s=%s=%s',leftside,rightside,opertor,ammount)}; 
    end
end
k=1;
eq_org={};
for i=1:numel(com.modelNames)
    org=cell2mat(modelNames(i));
    fprintf(fid,'* %s\n\n',org);
     km=km+1;
    printModel(km)={sprintf('\n\n* %s\n\n',org)};
    fprintf(fid,'massbalance_%s mass balance %s\n',org,org);
     km=km+1;
    printModel(km)={sprintf('massbalance_%s\n',org)};
    eq={};
     kq=1;
     for j=1:mc
        eq_s='';
        flag=0;
       
        met1=com.metNames{k};
        rep=sprintf('%s_',org);
        met=regexprep(met1,rep,'');
        flux=com.fluxNames{k};
        if I(i,j)==1
           fprintf(fid,'%s_export_%s\n',org,met);
              km=km+1;
             printModel(km)={sprintf('%s_export_%s\n',org,met)};
           eq_s=sprintf('%s_export_%s.. v_%s(''%s_%s'')=e=eval_%s',org,met,org,org,flux,met1);
           k=k+1;
           flag=1;
        elseif I(i,j)==-1
          fprintf(fid,'%s_uptake_%s\n',org,met);
             km=km+1;
             printModel(km)={sprintf('%s_uptake_%s\n',org,met)};
          eq_s=sprintf('%s_uptake_%s.. v_%s(''%s_%s'')=e=uval_%s',org,met,org,org,flux,met1);
           k=k+1;
           flag=1;
        end
        if flag==1
            eq(kq)={eq_s};
            kq=kq+1;
        end
     end
     eq_org{i}=eq;
    fprintf(fid,'dualconst_%s \n',org);
    km=km+1;
    printModel(km)={sprintf('dualconst_%s \n',org)};
    fprintf(fid,'dualconst_bm_%s \n',org);
    km=km+1;
    printModel(km)={sprintf('dualconst_bm_%s \n',org)};
    
    fprintf(fid,'dualconst_export_import_%s \n',org);
    km=km+1;
    printModel(km)={sprintf('dualconst_export_import_%s \n',org)};
    
    fprintf(fid,'primaldual_%s \n',org);
    km=km+1;
    printModel(km)={sprintf('primaldual_%s \n',org)};
    

    
    
end

fprintf(fid,'\n;\n');


fprintf(fid,'**********************************************************************************\n');
fprintf(fid,'****************************** Outer problem  ************************************\n');
fprintf(fid,'**********************************************************************************\n');
% print objective function
eq_biomass='outerobj..         z_outer =e=';

% avoid the previous + 
org=cell2mat(modelNames(1));
m=b(1);
biomass_index=find(m.c);
biomass={};
biomass(1)=m.rxns(biomass_index);
bm=cell2mat(biomass(1));
eq_biomass=sprintf('%s v_%s(''%s_%s'')  ',eq_biomass,org,org,bm);

for i=2:numel(modelNames)
    org=cell2mat(modelNames(i));
    m=b(i);
    biomass_index=find(m.c);
    biomass(i)=m.rxns(biomass_index);
    bm=cell2mat(biomass(i));
    eq_biomass=sprintf('%s + v_%s(''%s_%s'')  ',eq_biomass,org,org,bm);
   
end
fprintf(fid,'%s;\n',eq_biomass);
for i=1:numel(modelNames)
    fprintf(fid,'%s  %s;\n',cell2mat(media_eq_name(i)),cell2mat(media_eq(i)));
end
k=1;
for i=1:numel(modelNames)
    bm=cell2mat(biomass(i));
    org=cell2mat(modelNames(i));
    
    fprintf(fid,'**********************************************************************************\n');
    fprintf(fid,'******************************  %s inner and outer *******************************\n',org);
    fprintf(fid,'**********************************************************************************\n');
    bm=cell2mat(biomass(i));
    fprintf(fid,'PARAMETERS cb%s(j_%s),cbm%s(j_%s);\n',org,org,org,org);
    fprintf(fid,'cbm%s(''%s_%s'')=1;\n',org,org,bm);
     
    nn=numel(eq_org{i});
    for kk=1:nn
        fprintf(fid,'%s;\n',eq_org{i}{kk});
    end
    for j=1:mc
        clear met
        flux=cell2mat(com.fluxNames(k));
            
        if I(i,j)~=0
           fprintf(fid,'cb%s(''%s_%s'')=1;\n',org,org,flux);
           k=k+1;
        end
        
    end
   
    fprintf(fid,'\n\n* Primal\n\n');
    fprintf(fid,'massbalance_%s(i_%s)..   sum(j_%s,S_%s(i_%s,j_%s)*v_%s(j_%s)) =e= 0;\n\n',org,org,org,org,org,org,org,org);   
    
    fprintf(fid,'\n\n* Dual\n\n');
    fprintf(fid,'dualconst_%s(j_%s)$((not cbm%s(j_%s)) and (not cb%s(j_%s)))..  sum(i_%s, lambda_%s(i_%s)*S_%s(i_%s,j_%s))+muUB_%s(j_%s)-muLB_%s(j_%s) =e= 0;\n\n',...
        org,org,org,org,org,org,org,org,org,org,org,org,org,org,org,org);
    
    fprintf(fid,'dualconst_export_import_%s(j_%s)$(cb%s(j_%s))..  sum(i_%s, lambda_%s(i_%s)*S_%s(i_%s,j_%s))+muUB_%s(j_%s)-muLB_%s(j_%s)+ %s =e= 0;\n\n',...
        org,org,org,org,org,org,org,org,org,org,org,org,org,org,cell2mat(sum_dual(i)));
    
   fprintf(fid,'dualconst_bm_%s..  sum(i_%s, lambda_%s(i_%s)*S_%s(i_%s,''%s_%s''))+muUB_%s(''%s_%s'')-muLB_%s(''%s_%s'') =e=1; \n\n',...
        org,org,org,org,org,org,org,bm,org,org,bm,org,org,bm);
 
    %
  fprintf(fid,'primaldual_%s..     v_%s(''%s_%s'')=e=sum(j_%s$(not cb%s(j_%s)),muUB_%s(j_%s)*UB_%s(j_%s)-muLB_%s(j_%s)*LB_%s(j_%s))+%s;\n', ... 
                            org,org,org,bm,org,org,org,org,org,org,org,org,org,org,org,cell2mat(constrain(i)));
end 
fprintf(fid,'MODEL OptCom\n/\n');
for kk=1:km
   fprintf(fid,'%s',cell2mat(printModel(kk)));
    
end

fprintf(fid,'/;\nSOLVE OptCom USING NLP MAXIMIZING z_outer;\n\n');


fclose(fid);



    