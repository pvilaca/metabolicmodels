% FILE NAME:   metInfo
% 
% DATE CREATED: July 20, 2010 
% 
% PROGRAMMER:   Hnin Aung
%               Department of Biological and Environmental Engineering 
%               Cornell University 
%               Ithaca, NY 14853 
% 
% LAST REVISED: April 11, 2012 
% 
% REVISED BY:   Hnin Aung 
% 
% PURPOSE: Given metabolite indices in vector form, returns the name of the 
% metabolite and the names of the rxns it is involved in.
%
% INPUTS
%  cbModel: COBRA Toolbox formatted model
%  indices: vector of metabolite indices in the S-matrix
%
% OUTPUT
%  locationInS: index of reaction(s) that the metabolite(s) participates in 


function locationInS=metInfo(cbModel,indices)

jnew=0; 
for i=1:length(indices)
    fprintf('********************** For metabolite index %u **********************',indices(i));
    metName = cbModel.metNames(indices(i));
    met = cbModel.mets(indices(i));
    fprintf('\nmetName: %s \n', char(metName{:}));
    fprintf('met: %s \n\n', char(met{:}));
    
    fprintf('Name of reactions that it is involved in: \n');
    involvedRxns = find(cbModel.S(indices(i),:));
    for j=1:length(involvedRxns)
        rxnName = cbModel.rxnNames(involvedRxns(j));
        rxn = cbModel.rxns(involvedRxns(j));
        fprintf('%u: %s (rxn index %u)\n = %s\n', j, char(rxnName{:}), involvedRxns(j), char(rxn{:}));
        
        %Use code below if you want to get the met index and rxn index as a
        %ordered pair i.e. [met index, rxn index]
        %locationInS(jnew+j,:)=[indices(i),involvedRxns(j)];
        
        %Use code below if you want to return just the rxn index 
        locationInS(jnew+j,:)=involvedRxns(j);
    end
    jnew=jnew+j;
end