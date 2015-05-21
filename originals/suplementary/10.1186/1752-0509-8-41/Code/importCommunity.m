function community=importCommunity(xmlFile)
%The aim of this of this function is to read a community xml file
%it returns a communtiy structure containg
% community.orgNames array of organisms
% community.modelNames array of xml model file
% commpunity.metNames array of all uptake and export metabolite
% community.Interaction is nxm array, where is organism and m metaoblite
% Interaction(i,j)=1 the organism i export metabolite j
% Interaction(i,j)=-1 the organism i uptake metabolite j
%writtein by
% Ibrahim El-Semman 24 March 2013
% Chalmers university of technolgy, Sweden

% init Community

community.orgNames={};
community.media={};
community.media_con={};
community.media_relation={};
community.modelNames={};
community.modelFiles={};
community.metNames={};
community.fluxNames={};
community.Interaction=0;


tree=xmlread(xmlFile);
tree = tree.getDocumentElement;



org = tree.getElementsByTagName('Organism');

component = tree.getElementsByTagName('component');

n=component.getLength();
for i=0:n-1
   community.media(i+1)={char(component.item(i).getAttribute('met'))};
   community.media_con(i+1)={char(component.item(i).getAttribute('amount'))};
   community.media_relation(i+1)={char(component.item(i).getAttribute('relation'))};
end
    

n=org.getLength();
km=0;
for i=0:n-1
     org_name=org.item(i).getElementsByTagName('Model');
     community.orgNames(i+1)={char(org_name.item(0).getAttribute('name'))};
    
    org_name=org.item(i).getElementsByTagName('Model');
    community.modelNames(i+1)={char(org_name.item(0).getAttribute('ID'))};
     
     org_name=org.item(i).getElementsByTagName('Model');
     community.modelFiles(i+1)={char(org_name.item(0).getAttribute('file'))};
     
     uptake=org.item(i).getElementsByTagName('uptake');
     n_uptake=uptake.getLength();
     
     for j=0:n_uptake-1
           km=km+1;
           s1=char(uptake.item(j).getAttribute('metName'));
           community.metNames(km)={sprintf('%s_%s',cell2mat(community.modelNames(i+1)),s1)};
           community.Interaction(i+1,km)=-1;
           
           s1=char(uptake.item(j).getAttribute('flux'));
           community.fluxNames(km)={s1};
     end

     export=org.item(i).getElementsByTagName('export');
     n_export=export.getLength();
     
     for j=0:n_export-1
           km=km+1;
            s1=char(export.item(j).getAttribute('metName'));
           community.metNames(km)={sprintf('%s_%s',cell2mat(community.modelNames(i+1)),s1)};
           community.Interaction(i+1,km)=1;
           s1=char(export.item(j).getAttribute('flux'));
           community.fluxNames(km)={s1};
     end

end
