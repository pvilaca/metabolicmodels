function model=initModel(type)
% type is kind of gram postive or negative
if type=='-'
    
model.description='draft';
model.id='draft';
model.rxns={};
model.mets={};
model.S=0;
model.lb=0;
model.ub=0;
model.rev=0;
model.c=0;
model.b=0;
model.comps={'c' ;'p'; 'e'; 'b'};
model.compNames={'Cytosol'; 'Periplasm'; 'Extraorganism'; 'b'};
model.compOutside={'c' '' 'p' 'b'};
model.rxnNames={};
model.metNames={};
model.metComps={};
model.rxnGeneMat=0;
model.genes={};
model.grRules={};
model.metFormulas={};
model.subSystems={};
model.unconstrained=0;
model.eccodes={};
model.unconstrained=true;
model.metFormulas={};
model.inchis={};
model.metMiriams={};
model.first=1;

elseif type=='+'
model.description='draft';
model.id='draft';
model.rxns={};
model.mets={};
model.S=0;
model.lb=0;
model.ub=0;
model.rev=0;
model.c=0;
model.b=0;
model.comps={'c' ;'e'; 'b'};
model.compNames={'Cytosol'; 'Extraorganism'; 'b'};
model.compOutside={'c' '' 'b' };
model.rxnNames={};
model.metNames={};
model.metComps={};
model.rxnGeneMat=0;
model.genes={};
model.grRules={};
model.metFormulas={};
model.subSystems={};
model.unconstrained=0;
model.eccodes={};
model.unconstrained=true;
model.metFormulas={};
model.inchis={};
model.metMiriams={};
model.first=1;
end
    