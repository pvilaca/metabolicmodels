#! /usr/bin/perl
use strict;

###################################################################################################
# author: Adam M. Feist
# e-mail: afeist@be-research.ucsd.edu
# free of use, no support
#
# no preprocessing for the simpheny files is needed as of 10/26/06 version 1.11 of simpheny.
#
# To use:
# Export simulation data (numerical output) from your model from a single optimization entering the file name 'your_file_handle' in the required prompt.
# Run the command 'GPR Association for Model' and save all of the text in a .txt file in the following format: your_file_handle_gpr.txt
# Run the command 'Compounds in Model' and save all of the text in a .txt file in the following format: your_file_handle_cmpd.txt
#
# put all 5 of these files in the same directory with this perl script
# run the script with the following command:  simpheny_to_sbml_l2v1.pl your_file_handle
#
# for example for the E. coli iJR904 model I had the files iJR904.met, iJR904.sto, iJR904.rxn, iJR904_gpr.txt, iJR904_cmpd.txt, and simpheny_to_sbml_l2v1.pl
# files all in the same directory and then I typed:    simpheny_to_sbml_l2v1.pl iJR904
# and it correctly made the .xml file and placed it in the same directory.
#
# you can validate your new SBML .xml file at sbml.org --> online tools
###################################################################################################

## assigns the command line arguement to your model
my $file_handle = iMM904;

## these files are generated directly from a SimPhney export of a model single optimization simulation.  When saving your export
## enter the file name:  your_file_handle in the required prompt.
my $S_file   = $file_handle . ".sto";
my $rxn_file = $file_handle . ".rxn";
my $met_file = $file_handle . ".met";

## these files are generated from reports from the 'admin console' in SimPheny.
## Run the command 'GPR Association for Model' and save all of the text in a .txt file in the following format: your_file_handle_gpr.txt
## Run the command 'Compounds in Model' and save all of the text in a .txt file in the following format: your_file_handle_cmpd.txt
my $gpr_file = $file_handle . "_gpr.txt";
my $cmpd_file = $file_handle . "_cmpd.txt";

my %rxn_dat;
my @rxnlist;
## read the reaction data file
open(RXNDAT, $rxn_file) or die "can't open $rxn_file\n";
## find the correct line to start reading in
my $startline;
while(my $line = <RXNDAT>){
	if ($line =~ m/REACTION NUMBER/) {
		$startline = $. + 2;
		last;
	}
}
close(RXNDAT);

open(RXNDAT, $rxn_file) or die "can't open $rxn_file\n";
while(<RXNDAT>){ 		## <  > is the command for reading in line by line
    next until ($.>= $startline);  	## $. is the variable for line count, starts at a value of 1
    chomp;			## gets rid of the return \n at the end of the line
    my @F=split(/\t/);	## splits the line string into an array
	## [0]REACTION NUMBER							
	## [1]ABBREVIATION
	## [2]OFFICIAL NAME
	## [3]DIRECTION
	## [4]LOWER BOUND
	## [5]UPPER BOUND
	## [6]OBJECTIVE COEFFICIENT
	## [7]FLUX VALUE
	## [8]REDUCED COST

	for ( my $k = 1 ; $k < 3 ; $k++) { ## only 1-2 need to be altered
		$F[$k] =~ tr/ ,\',(,),\-/_/;  ##replace with an underscore '_', g is for global - replaces all in a string
		$F[$k] =~ s/\W//g; ##remove any invalid characters and replace with nothing
	}

	my $rxn_id = "R_" . $F[1];   # append this to the reaction ID for a valid leading character 
	my $rxn_name = "R_" . $F[2];  

	$rxn_dat{$rxn_id}{RXNNAME} = $rxn_name;	## a hash of a hash
    $rxn_dat{$rxn_id}{DIR} = $F[3];
	$rxn_dat{$rxn_id}{LB} = $F[4];
	$rxn_dat{$rxn_id}{UB} = $F[5];
	$rxn_dat{$rxn_id}{OBC} = $F[6];
	$rxn_dat{$rxn_id}{FLUX} = $F[7];
	$rxn_dat{$rxn_id}{REDCOST} = $F[8];
	my $i = $. - $startline;
	$rxnlist[$i]=$rxn_id;
}
close(RXNDAT);

my %met_dat;
my %cmpt_dat;
my @metlist;
## read the metabolite data file

open(METDAT, $met_file) or die "can't open $met_file\n";
## find the correct line to start reading in
my $startline_met;
while(my $line = <METDAT>){
	if ($line =~ m/^\d/) {
		$startline_met = $.;
		last;
	}
}
close(METDAT);

open(METDAT, $met_file) or die "can't open $met_file\n";
while(<METDAT>){ 		## <  > is the command for reading in line by line
    next until ($. >= $startline_met);  	## $. is the variable for line count, starts at a value of 1
	chomp;			## gets rid of the return \n at the end of the line
    my @F=split(/\t/);	## splits the line string into an array
	## [0]METABOLITE NUMBER							
	## [1]METABOLITE  ## does have the compartment appended to the end of the abbreviation i.e. (e) or (c)
	## [2]MOLECULE
	## [3]COMPARTMENT
	## [4]SHADOW PRICE

	for ( my $k = 1 ; $k < 4 ; $k++) { ## only 1-3 need to be altered
		$F[$k] =~ tr/ ,\',(,),\-/_/;  ##replace with an underscore '_', g is for global - replaces all in a string
		$F[$k] =~ s/\W//g; ##remove any invalid characters and replace with nothing
	}

	my $length_met_id = length($F[1]) - 1;  ## get rid of the trailing underscore '_', an artifact of the compartement tag on the ID
	my $met_id = substr($F[1], 0, $length_met_id);

	$met_id = "M_" . $met_id;   # append this to the metabolite ID for a valid leading character 
	my $met_name = "M_" . $F[2];    

	$met_dat{$met_id}{METNAME} = $met_name;	## a hash of hash
    $met_dat{$met_id}{COMPART} = $F[3];
	$met_dat{$met_id}{SHADP} = $F[4];

	##another hash by compartment
	$cmpt_dat{$F[3]}{METID} = $met_id;

	my $i = $. - $startline_met;
	$metlist[$i]=$met_id;
}
close(METDAT);

## read the stoichiometry matrix
my %S;
open(SMATRIX, $S_file) or die "can't open $S_file\n";
while(<SMATRIX>){
    next until ($.>=15);  ## shold probably look for the first line in the file with a number
    chomp;
    my @F = split(/\t/);
	
    for my $j (0..$#rxnlist) {
        my $rxn_j = $rxnlist[$j];
        push @{ $S{$rxn_j} }, $F[$j];  ## hash-of-arrays
    }
}

## read the reaction gpr file
open(GPRDAT, $gpr_file) or die "can't open $gpr_file\n";
while(<GPRDAT>){ 		## <  > is the command for reading in line by line
    next until ($.>=2);  	## $. is the variable for line count, starts at a value of 1
    chomp;			## gets rid of the return \n at the end of the line
    my @F=split(/","/);	## splits the line string into an array
	## [0]abbreviation							
	## [1]officialName
	## [2]equation
	## [3]subSystem
	## [4]proteinClass
	## [5]proteinGeneAssociation
	## [6]geneAssociation
	## [7]proteinAssociation


	for ( my $k = 0 ; $k < 4 ; $k++) {  ## k is 3 in this case since we want the proteinClass, proteinGeneAssociation, geneAssociation and proteinAssociation to be conserved
		$F[$k] =~ tr/ ,\',(,),\-/_/;  ##replace with an underscore '_', g is for global - replaces all in a string
		$F[$k] =~ s/\W//g; ##remove any invalid characters and replace with nothing
	}

	my $rxn_id = "R_" . $F[0];   # append this to the reaction ID for a valid leading character 
	my $subsys = "S_" . $F[3];

	## need to take the " off the end of the [7] variable, specific to the file type generated from SimPheny
		my $length_PA = length($F[7]) - 1;
		my $PA = substr($F[7], 0, $length_PA);

    $rxn_dat{$rxn_id}{SUBSYS} = $subsys;
    $rxn_dat{$rxn_id}{PROTCLASS} = $F[4];
#	$rxn_dat{$rxn_id}{PRA} = $F[5];
    $rxn_dat{$rxn_id}{GA} = $F[6];
    $rxn_dat{$rxn_id}{PA} = $PA;  
}
close(GPRDAT);

## read the reaction gpr file
my %cmpd_dat;
open(CMPDDAT, $cmpd_file) or die "can't open $cmpd_file\n";
while(<CMPDDAT>){ 		## <  > is the command for reading in line by line
    next until ($.>=2);  	## $. is the variable for line count, starts at a value of 1
    chomp;			## gets rid of the return \n at the end of the line
    my @F=split(/","/);	## splits the line string into an array
	## [0]abbreviation   ## does NOT have the compartment appended to the end of the abbreviation i.e. (e) or (c)				
	## [1]officialName
	## [2]formula
	## [3]reviewStatus
	## [4]charge
	## [5]casNumber

	for ( my $k = 0 ; $k < 2 ; $k++) {  
		$F[$k] =~ tr/ ,\',(,),\-/_/;  ##replace with an underscore '_', g is for global - replaces all in a string
		$F[$k] =~ s/\W//g; ##remove any invalid characters and replace with nothing
	}

	my $cmpd_key = "M_" . $F[0]; ## need a different hash for metabs since the input file is different

	## need to take the " off the end of the [5] variable, specific to the file type generated from SimPheny
		my $length_CN = length($F[5]) - 1;
		my $CN = substr($F[5], 0, $length_CN);

#	$cmpd_dat{$cmpd_key}{OFFINAME} = $F[1];	## a hash of a hash
    $cmpd_dat{$cmpd_key}{FORMULA} = $F[2];
#	$cmpd_dat{$cmpd_key}{ReviewS} = $F[3];
    $cmpd_dat{$cmpd_key}{CHARGE} = $F[4];
#	$cmpd_dat{$cmpd_key}{CASN} = $CN;  
}
close(CMPDDAT);

my $outfile = "temp".$file_handle . ".xml";
open (OUTFILE, ">$outfile") or die "can't open $outfile\n";

######################################## start generating the sbml file
print OUTFILE "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
print OUTFILE "<sbml xmlns=\"http:\/\/www.sbml.org\/sbml/level2\" level=\"2\" version=\"1\" xmlns:html=\"http:\/\/www.w3.org\/1999\/xhtml\">\n";
print OUTFILE "<model id=\"$file_handle\" name=\"$file_handle\">\n";

print OUTFILE "<listOfUnitDefinitions>\n";
print OUTFILE "\t<unitDefinition id=\"mmol_per_gDW_per_hr\">\n";
print OUTFILE "\t\t<listOfUnits>\n";
print OUTFILE "\t\t\t<unit kind=\"mole\" scale=\"-3\"\/>\n";
print OUTFILE "\t\t\t<unit kind=\"gram\" exponent=\"-1\"\/>\n";
print OUTFILE "\t\t\t<unit kind=\"second\" multiplier=\".00027777\" exponent=\"-1\"\/>\n";
print OUTFILE "\t\t<\/listOfUnits>\n";
print OUTFILE "\t<\/unitDefinition>\n";
print OUTFILE "<\/listOfUnitDefinitions>\n";

## determine and print the compartments ######################     
print OUTFILE "<listOfCompartments>\n";
if ($cmpt_dat{"Extra_organism"}) {
    print OUTFILE "\t<compartment id=\"Extra_organism\"\/>\n";
}

if ($cmpt_dat{"Periplasm"}) {
    if ($cmpt_dat{"Extra_organism"}) {
	print OUTFILE "\t<compartment id=\"Periplasm\" outside=\"Extra_organism\"\/>\n";
    }
    else {
    print OUTFILE "\t<compartment id=\"Periplasm\"\/>\n";
    }
}

foreach my $cmpt (sort keys %cmpt_dat)   {
    unless ($cmpt =~ /Extra_organism|Periplasm/ ) {
	if ($cmpt_dat{"Periplasm"}) {
	    printf OUTFILE "\t<compartment id=\"%s\" outside=\"Periplasm\"\/>\n", $cmpt;
	}
	elsif ($cmpt_dat{"Extra_organism"}) {
	    printf OUTFILE "\t<compartment id=\"%s\" outside=\"Extra_organism\"\/>\n", $cmpt;
	}
	else {
	    printf OUTFILE "\t<compartment id=\"%s\"\/>\n", $cmpt;
	}
    }
}
print OUTFILE "</listOfCompartments>\n";
## end of printing compartments ######################


## get the boundary metabolites in a hash
my %bound_met_list;
my $bound_met;
foreach my $rxn (sort keys %rxn_dat) {
	if ($rxn =~ m/^R_EX_|^R_DM_|^R_sink_/) {  ##prints boundary metabolite, if 'R_EX_' or 'R_DM_' or 'R_sink_' is at the beginning of the string
		foreach my $i (0..$#metlist) {
			if ($S{$rxn}[$i] < "0")   {
			$bound_met = $metlist[$i];
			$bound_met_list{$bound_met}++;
			}
		}
	}
}

###### print species
print OUTFILE "<listOfSpecies>\n";
foreach my $met (sort keys %met_dat) {
    ## need to get the correct key to call the metabolite charge
    my $length_key = length($met) - 2;  # need to take off the last two characters corresponding to the compartment
    my $cmpd_key = substr($met, 0, $length_key);
    ## append the formula on the end of the name
    my $met_name = $met_dat{$met}{METNAME} . "_" . $cmpd_dat{$cmpd_key}{FORMULA};
    printf OUTFILE "\t<species id=\"%s\" name=\"%s\" compartment=\"%s\" charge=\"%d\" boundaryCondition=\"false\"\/>\n", $met , $met_name, $met_dat{$met}{COMPART} , $cmpd_dat{$cmpd_key}{CHARGE};
}  

foreach my $bmet (sort keys %bound_met_list) {
    ## need to get the correct key to call the metabolite charge
    my $length_key = length($bmet) - 2;  # need to take off the last two characters corresponding to the compartment
    my $cmpd_key = substr($bmet, 0, $length_key);
    ## append the formula on the end of the name
    my $met_name = $met_dat{$bmet}{METNAME} . "_" . $cmpd_dat{$cmpd_key}{FORMULA};
	
	$bmet =~ s/_[a-z]*$/_b/;
	printf OUTFILE "\t<species id=\"%s\" name=\"%s\" compartment=\"Extra_organism\" charge=\"%d\" boundaryCondition=\"true\"\/>\n", $bmet , $met_name , $cmpd_dat{$cmpd_key}{CHARGE};
}
print OUTFILE "<\/listOfSpecies>\n";
###### end of print species

###### print reactions
my $bound_met;
print OUTFILE "<listOfReactions>\n";
foreach my $rxn (sort keys %rxn_dat) {
    my $rev;
    if ($rxn_dat{$rxn}{DIR} eq "Reversible") { $rev = "true"; }
    else { $rev = "false"; }
    printf OUTFILE "\t<reaction id=\"%s\" name=\"%s\" reversible=\"%s\">\n", $rxn , $rxn_dat{$rxn}{RXNNAME}, $rev ;
    
	## notes for each reaction
    print OUTFILE "\t\t<notes>\n";
    print OUTFILE "\t\t\t<html:p>GENE_ASSOCIATION: ";  printf OUTFILE "%s<\/html:p>\n", $rxn_dat{$rxn}{GA};
    print OUTFILE "\t\t\t<html:p>PROTEIN_ASSOCIATION: "; printf OUTFILE "%s<\/html:p>\n", $rxn_dat{$rxn}{PA};
    print OUTFILE "\t\t\t<html:p>SUBSYSTEM: "; printf OUTFILE "%s<\/html:p>\n", $rxn_dat{$rxn}{SUBSYS};
    print OUTFILE "\t\t\t<html:p>PROTEIN_CLASS: "; printf OUTFILE "%s<\/html:p>\n", $rxn_dat{$rxn}{PROTCLASS};
    print OUTFILE "\t\t<\/notes>\n";
	
	print OUTFILE "\t\t<listOfReactants>\n";
    foreach my $i (0..$#metlist) {
	if ($S{$rxn}[$i] < "0")   {
	    printf OUTFILE "\t\t\t<speciesReference species=\"%s\" stoichiometry=\"%f\"\/>\n", $metlist[$i] , -$S{$rxn}[$i] ;
	}
    }
    print OUTFILE "\t\t<\/listOfReactants>\n";

    unless ($rxn =~ /^R_EX_|^R_DM_|^R_sink_/) {  ##skips printing out the products if it contains 'R_EX_' or 'R_DM_' or 'R_sink_' at the beginning of the string
	print OUTFILE "\t\t<listOfProducts>\n";
	foreach my $i (0..$#metlist) {
	    if ($S{$rxn}[$i] > "0")   {
		printf OUTFILE "\t\t\t<speciesReference species=\"%s\" stoichiometry=\"%f\"\/>\n", $metlist[$i] , $S{$rxn}[$i] ;
	    }
	}
    }
    if ($rxn =~ /^R_EX_|^R_DM_|^R_sink_/) {  ##prints boundary metabolite, if 'R_EX_' or 'R_DM_' or 'R_sink_' is at the beginning of the string
	print OUTFILE "\t\t<listOfProducts>\n";
	foreach my $i (0..$#metlist) {
	    if ($S{$rxn}[$i] < "0")   {
		$bound_met = $metlist[$i];
		$bound_met =~ s/_[a-z]*$/_b/; 
		printf OUTFILE "\t\t\t<speciesReference species=\"%s\" stoichiometry=\"%f\"\/>\n", $bound_met , -$S{$rxn}[$i] ;
	    }
	}
    }
    print OUTFILE "\t\t<\/listOfProducts>\n";

## flux values, bounds and reduced cost for each reaction
    print OUTFILE "\t\t<kineticLaw>\n";
## back to flux values, bounds and reduced cost for each reaction
    print OUTFILE "\t\t\t<math xmlns=\"http\:\/\/www\.w3\.org\/1998\/Math\/MathML\">\n";

    print OUTFILE "\t\t\t\t<ci> FLUX_VALUE <\/ci>\n";

    print OUTFILE "\t\t\t<\/math>\n";
    print OUTFILE "\t\t\t<listOfParameters>\n";
	printf OUTFILE "\t\t\t\t<parameter id=\"LOWER_BOUND\" value=\"%f\" units=\"mmol_per_gDW_per_hr\"\/>\n", $rxn_dat{$rxn}{LB} ;
	printf OUTFILE "\t\t\t\t<parameter id=\"UPPER_BOUND\" value=\"%f\" units=\"mmol_per_gDW_per_hr\"\/>\n", $rxn_dat{$rxn}{UB} ;
	printf OUTFILE "\t\t\t\t<parameter id=\"OBJECTIVE_COEFFICIENT\" value=\"%f\"\/>\n", $rxn_dat{$rxn}{OBC} ;
	printf OUTFILE "\t\t\t\t<parameter id=\"FLUX_VALUE\" value=\"%f\" units=\"mmol_per_gDW_per_hr\"\/>\n", $rxn_dat{$rxn}{FLUX} ;
	printf OUTFILE "\t\t\t\t<parameter id=\"REDUCED_COST\" value=\"%f\"\/>\n", $rxn_dat{$rxn}{REDCOST} ;
    print OUTFILE "\t\t\t<\/listOfParameters>\n";
    print OUTFILE "\t\t<\/kineticLaw>\n";
    print OUTFILE "\t<\/reaction>\n";
}

print OUTFILE "<\/listOfReactions>\n";
###### end print reactions

print OUTFILE "<\/model>\n";
print OUTFILE "<\/sbml>\n";

close(OUTFILE);

##########################################################################################################################################
## below gets rid of any 'deleted' tags on metabolites that have been updaed in the database since model generation
## read the .xml file
open(DAT, $outfile) or die "can't open $outfile\n";
my $outfile2 = $file_handle . "_flux.xml";
open(OUTFILE2, ">", $outfile2) or die "can't open $outfile2\n";

while(my $line = <DAT>){ 		## <  > is the command for reading in line by line
   chomp $line;			## gets rid of the return \n at the end of the line
    
    $line =~ s/_deleted_.{19,19}//g;
    
    print OUTFILE2"$line\n";
}

close(OUTFILE2);
close(DAT);

## command to delete a file
unlink($outfile);


my %rxn_dat = "";
## read the reaction gpr file
open(GPRDAT, $gpr_file) or die "can't open $gpr_file\n";
while (my $line = <GPRDAT>){ 		## <  > is the command for reading in line by line
    next until ($.>=2);  	## $. is the variable for line count, starts at a value of 1
    chomp;			## gets rid of the return \n at the end of the line
    my @F=split(/","/, $line);	## splits the line string into an array
	## [0]abbreviation							
	## [1]officialName
	## [2]equation
	## [3]subSystem
	## [4]proteinClass
	## [5]proteinGeneAssociation
	## [6]geneAssociation
	## [7]proteinAssociation

	## need to take the " off the beginning of the [0] variable, specific to the file type generated from SimPheny
		my $length_AB = length($F[0]) - 1;
		my $AB = substr($F[0], 1, $length_AB);

	## need to take the " off the end of the [7] variable, specific to the file type generated from SimPheny
		my $length_PA = length($F[7]) - 1;
		my $PA = substr($F[7], 0, $length_PA);

 #   $rxn_dat{$AB}{SUBSYS} = $F[3];
#    $rxn_dat{$AB}{PROTCLASS} = $F[4];
#    $rxn_dat{$AB}{PRA} = $F[5];
    $rxn_dat{$AB}{GA} = $F[6];
#    $rxn_dat{$AB}{PA} = $PA;  
}
close(GPRDAT);


foreach my $rxn (keys %rxn_dat) {
    my @G = split(/  or  /, $rxn_dat{$rxn}{GA});

    for (my $i=0; $i < scalar(@G); $i++) {
    $G[$i] =~ s/\( | \)//g;
    }

    foreach my $gpr (@G) {
	
	my @H = split(/  and  /, $gpr); # my @H = split(/\s+and\s+/, $gpr);
	@H = sort @H;
	my $key = join '^', @H;
	$rxn_dat{$rxn}{GPR}{$key} = \@H;
	
    }
}

my $outiso = $file_handle . "_isozymes.txt";
open (OUTISO, ">$outiso") or die "can't open $outiso\n";
my %gene_dat = "";
my $count_iso = 0;
foreach my $rxn (keys %rxn_dat) {
    my @gprs = keys %{$rxn_dat{$rxn}{GPR}};
    
    if (scalar(@gprs) > 1) {
	$count_iso++;
	
	printf OUTISO "%s\t%d\t", $rxn, scalar (@gprs);
	
	foreach my $gpr (sort @gprs) {
	    printf OUTISO "%s\t", $gpr;
	}
	
	print OUTISO "\n";
    }
    	
    foreach my $gpr (@gprs) {
	$gene_dat{$gpr} = $gpr;
    }
    
}
print OUTISO "\nThe system has $count_iso instances of isozymes.\n";
close(OUTISO);


my $outcmplx = $file_handle . "_complexes.txt";
open (OUTCMPLX, ">$outcmplx") or die "can't open $outcmplx\n";
my %c_gene_dat = "";
my $count_cmplx = 0;
my $i = "";
foreach my $cmplx (sort keys %gene_dat) {

   if ($cmplx =~ m/\^/) {  ## if the complex has a '^' in it
	$count_cmplx++;
	printf OUTCMPLX "%s\n", $cmplx;
	
	my @I = split(/\^/, $cmplx);
	for ($i = 0; $i <= $#I; $i++) {
	#foreach my $c_gene (@I) {
	    $c_gene_dat{$I[$i]} = $I[$i];
	}
    }
    
}
print OUTCMPLX "\nThe system has $count_cmplx different multigene complexes.\n";

my $count_cmplx_genes = 0;
foreach my $cm_gene (sort keys %c_gene_dat) {
    $count_cmplx_genes++;
    printf OUTCMPLX "%s\n", $cm_gene;
}

print OUTCMPLX "\nThe system has $count_cmplx_genes genes in multigene complexes.\n";
close(OUTCMPLX);
