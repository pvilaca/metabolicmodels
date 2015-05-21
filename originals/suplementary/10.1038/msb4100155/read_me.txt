Interpretation of mapping files:

To record the type of match arrived at, a column called "analysis" was
added to the spreadsheets.  It contains a list (enclosed in
parentheses) of one or several mnemonic symbols that start with a
colon.  Generally, if :metacyc is absent, it means by default that if
a match was found, it was to EcoCyc.


The meaning of the analysis symbols for the metabolite mapping:

:metacyc         : A match to MetaCyc was found, but not to EcoCyc.
                  This applies to instances only.
:i-o-c           : The iAF1261 metabolite seems to be an instance of the
                  EcoCyc class. The class could also be
                  protein or tRNA class, not just a small molecule.
                  So the mapping is indirect.
:protein-instance: A match to an EcoCyc protein.
:polymer-section : A hypothetical, representative segment
                  out of a much larger polymer.
:manual          : The match was made by human inspection,
                  not by automated software.
:dispute         : While a tentative assignment was made, there is
                  still a disagreement between the Palsson
                  group and SRI regarding the exact assignment
                  or structure of the cpd.


The meaning of the analysis symbols for the reaction mapping:

:metacyc            : A match to MetaCyc was found, but not to EcoCyc.
:expanded-rxn-match : A match to a generic reaction was made.
                     In the IUBMB and EcoCyc/MetaCyc, compound classes
                     can stand for several metabolite instances,
                     and many reactions are formulated in this generic manner.
:unmapped-cpds      : One or more metabolites of the iAF1261 reaction
                     could not be mapped to EcoCyc/MetaCyc,
                     and thus the entire reaction can not be mapped.
:exchange           : A simple exchange rxn between the [e]
                     compartment and the world outside the model.
                     There is no real representation for this
                     concept in EcoCyc, so none of these match.
:diffusion          : A simple diffusion reaction across
                     a cell compartment boundary.
                     There is no real representation for this
                     concept in EcoCyc, so none of these match.

Additionally, sublists describe more specific transformations
that were applied to elicit a match.
The sublists take the form of
(side operation argument-1 optional-argument-2) , with typical examples being:
(LEFT SUBSTITUTE AMMONIA AMMONIUM)
(RIGHT REMOVE PROTON)