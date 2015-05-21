function printFluxes(model, fluxes, onlyExchange, cutOffFlux, outputFile,outputString)
% printFluxes
%   Prints reactions and fluxes to the screen or to a file
%
%   model         a model structure
%   fluxes        a vector with fluxes
%   onlyExchange  only print exchange fluxes (opt, default true)
%   cutOffFlux    only print fluxes with absolute values above or equal to this 
%                 value (opt, default 0)
%   outputFile    a file to save the print-out to (opt, default is output to
%                 the command window)
%   outputString  a string that specifies the output of each reaction (opt,
%                 default '%rxnID (%rxnName):%flux\n')
%
%   The following codes are available for user-defined output strings:
%
%   %rxnID      Reaction ID
%   %rxnName    Reaction name
%   %lower      Lower bound
%   %upper      Upper bound
%   %obj        Objective coefficient
%   %eqn        Equation
%   %flux       Flux
%
%   Usage: printFluxes(model, fluxes, onlyExchange, cutOffFlux,
%           outputFile,outputString)
%
%   Rasmus Agren, 2010-12-16
%

if nargin<3
    onlyExchange=true;
end
if nargin<4
    cutOffFlux=0;
end
if nargin<5
    fid=1;
else
    if ~isempty(outputFile)
        fid=fopen(outputFile,'w');
    else
        fid=1;
    end
end
if nargin<6
    outputString='%rxnID (%rxnName):%flux\n';
end

if numel(fluxes)~=numel(model.rxns)
   throw(MException('','The number of fluxes and the number of reactions must be the same.')); 
end

if onlyExchange==true
    fprintf(fid,'\nEXCHANGE FLUXES:\n\n');
else
    fprintf(fid,'\nFLUXES:\n\n');
end

for i=1:numel(model.rxns)
   %Only print if it's an exchange reaction or if all reactions should be
   %printed. Exchange reactions only have reactants or only products.
   reactants=find(model.S(:,i)<0);
   products=find(model.S(:,i)>0);
   
   %Only print if the absolute value is >= cutOffFlux
   if (onlyExchange==false || (isempty(reactants) || isempty(products))) && abs(fluxes(i))>=cutOffFlux
       printString=outputString;
        
       eqn=constructEquations(model,i);

       %Produce the final string
       printString=strrep(printString,'%rxnID',model.rxns{i});
       printString=strrep(printString,'%eqn',eqn{1});
       printString=strrep(printString,'%rxnName',model.rxnNames{i});
       printString=strrep(printString,'%lower',num2str(model.lb(i)));
       printString=strrep(printString,'%upper',num2str(model.ub(i)));
       printString=strrep(printString,'%obj',num2str(model.c(i)));
       printString=strrep(printString,'%flux',num2str(fluxes(i)));
       fprintf(fid,printString);
   end
end

if fid~=1
    fprintf('File successfully saved.\n');
    fclose(fid);
end