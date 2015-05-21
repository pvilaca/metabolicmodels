function r =get_reaction_from_rhea(ec,pathway)
%The aim of this function make a matlab strcture for RHEA reaction
% ec the EC number
% pathway KEGG map ID
%Output: Matlab structure r repreenting the substrates S and product P
%        and reaction direction direction
%example:
%        r=get_reaction_from_rhea('1.3.5.1','map00020')
%Written by: Ibrahim El-Semman 25-May-2013
%

[RheaID dir master keggReactionID]=textread('RheaKegg.txt','%s	%s	%s	%s');

keggID=get_kegg_reaction_id(ec,pathway);

ri=find(ismember(keggReactionID,keggID));

if numel(ri)==0
    error('No RHEA reaction for this KEGG reaction');
end
rheaID=RheaID(ri);



for k=1:numel(rheaID)
    r{k}.RheaID=cell2mat(rheaID);
    r{k}.EC=regexprep(ec,'ec:','');
eq='';
url=sprintf('http://www.ebi.ac.uk/rhea/rest/1.0/ws/reaction/cmlreact/%s',cell2mat(rheaID(k)));
xml=urlread(url);
tempFile=fopen('temp.xml','w');

fprintf(tempFile,'%s',xml);
fclose(tempFile);

tree=xmlread('temp.xml');
tree = tree.getDocumentElement;

reaction=tree;

direction=char(reaction.getAttribute('convention'));

direction=regexp(direction,'\.\w*','match');
direction=regexprep(direction,'\.','');

if strmatch(direction,'BI')
    r{k}.direction='<=>';
elseif  strmatch(direction,'RL')
     r{k}.direction='<=>';
else
     r{k}.direction='<?>';
end

reactant = tree.getElementsByTagName('reactant');

n=reactant.getLength();


 for i=0:n-1
     s1=char(reactant.item(i).getAttribute('title'));
     s1(1)=upper(s1(1));
      r{k}.S{i+1}.title=s1;
      r{k}.S{i+1}.count=char(reactant.item(i).getAttribute('count'));
      if (i<=n-2)
         eq=sprintf('%s %s %s[Cytosol] +',eq,char(reactant.item(i).getAttribute('count')), s1); 
      else
         eq=sprintf('%s %s %s[Cytosol]',eq,char(reactant.item(i).getAttribute('count')), s1); 

      end
      molecule = reactant.item(i).getElementsByTagName('molecule');
      
      r{k}.S{i+1}.formula=char(molecule.item(0).getAttribute('formula'));
      r{k}.S{i+1}.CHEBI=char(molecule.item(0).getAttribute('id'));
      r{k}.S{i+1}.charge=char(molecule.item(0).getAttribute('formalCharge'));
      
      
 end
 eq=sprintf('%s %s ',eq,r{k}.direction);
 product = tree.getElementsByTagName('product');

n=product.getLength();


 for i=0:n-1
       p1=char(product.item(i).getAttribute('title'));
       p1(1)=upper(p1(1));
       r{k}.P{i+1}.title=p1;
       r{k}.P{i+1}.count=char(product.item(i).getAttribute('count'));
        if (i<=n-2)
         eq=sprintf('%s %s %s[Cytosol] +',eq,char(product.item(i).getAttribute('count')), p1); 
           else
         eq=sprintf('%s %s %s[Cytosol]',eq,char(product.item(i).getAttribute('count')), p1); 

        end
     
      
      molecule = product.item(i).getElementsByTagName('molecule');
      
      r{k}.P{i+1}.formula=char(molecule.item(0).getAttribute('formula'));
      r{k}.P{i+1}.CHEBI=char(molecule.item(0).getAttribute('id'));
      r{k}.P{i+1}.charge=char(molecule.item(0).getAttribute('formalCharge'));
 end
 %eq=regexprep(eq,'1.0','');
 eq=regexprep(eq,'(','');
 eq=regexprep(eq,')','');
 r{k}.eq=eq;
 eq
end 
 