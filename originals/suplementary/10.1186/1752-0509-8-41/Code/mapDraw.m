% SBMLFromExcel('refRxNs.xlsx','d:\ref.xml');
% ref=importModel('d:\ref.xml');
map={'map00130' 'map00860' 'map00670' 'map00790' 'map00785' 'map00780' 'map00770' 'map00760' 'map00750' 'map00740' 'map00730'};
for i=1:numel(map)
    drawKEGGPathway(ref,cell2mat(map(i)));
end