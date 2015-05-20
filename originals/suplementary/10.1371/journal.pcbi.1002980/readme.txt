
Dataset_S1.zip
<div><p>The iAL1006 genome-scale model of <i>P. chrysogenum</i> in SBML and Excel formats, together with a metabolic map for visualization and a task list for model validation.</p>
          </div>
10.1371/journal.pcbi.1002980.s001

Figure_S1.pdf
<div><p>Proteome comparison of genomes in <i>Fungi</i>. ALR (the ratio of alignment length to query sequence length): >0.50, identity: >0.40. The red shades refer to protein homology that can found within a genome (paralog). The green shades refer to protein homology that can found between two genomes (ortholog).</p>
          </div>
10.1371/journal.pcbi.1002980.s002

Figure_S2.pdf
<div><p>Agreement of model simulations with experimental fermentation data. Data from glucose-limited chemostat with defined medium containing glucose, inorganic salts and phenoxyacetate.</p>
          </div>
10.1371/journal.pcbi.1002980.s003

Table_S1.pdf
<div><p>Reactions which were excluded from the general KEGG model after running <i>removeBadRxns</i>. 72 reactions were unbalanced, general or polymer reactions and were therefore correctly removed. 7 reactions were correct in KEGG, but were removed because they lacked metabolite composition (it is a setting in <i>removeBadRxns</i> whether it is allowed to remove such reactions).</p>
          </div>
10.1371/journal.pcbi.1002980.s004

Table_S2.pdf
<div><p>Comparison of an automatically reconstructed model for <i>S. cerevisiae</i> to a published model of the same organism (iIN800) in terms of included genes. The table shows the genes that are unique to either the automatically reconstructed or the manually reconstructed model, and a classification of the genes into groups that reflect how well suited they are for being included in a GEM. Genes labeled as “enzymatic” should be included, while all other groups should probably be excluded. For iIN800 some enzymatic genes are further classified as “polymer”, “lipid” or “membrane”. These are parts of metabolism where an automatically generated model from KEGG would have particular drawbacks compared to a manually reconstructed model. “Polymer” corresponds mainly to genes involved in sugar polymer metabolism, which is an area that contains many unbalanced reactions in KEGG. Such reactions were excluded in the validation, so the corresponding genes could not be included. The same is true for “lipid”, where the reactions contain many general metabolites, which also results in excluded reactions. “Membrane” corresponds to reactions which depend on any one metabolite in different compartments. This compartmentalization information is absent in KEGG so such a reaction would read, for example, A+B = >A+C. “A” here might mean “A(cytosolic)” and “A(mitochondrial)”, but since that information is missing, the equation becomes incorrect and it is therefore excluded. “Signaling” corresponds to proteins which are primarily involved in signaling, even though they might have an enzymatic capability.</p>
          </div>
10.1371/journal.pcbi.1002980.s005

Table_S3.pdf
<div><p>Metabolites which could be synthesized in the automatically reconstructed <i>S. cerevisiae</i> model from minimal media (glucose, phosphate, sulfate, NH3, oxygen, 4-aminobenzoate, riboflavin, thiamine, biotin, folate, and nicotinate). Uptake of the carriers carnitine and acyl-carrier protein was allowed for modeling purposes (many compounds are bound to them and therefore net synthesis of these compounds is not possible without them).</p>
          </div>
10.1371/journal.pcbi.1002980.s006

Table_S4.pdf
<div><p>New metabolites which could be synthesized in the automatically reconstructed <i>S. cerevisiae</i> model from minimal media after gap-filling. These metabolites were all present in the model before the addition of new reactions.</p>
          </div>
10.1371/journal.pcbi.1002980.s007

Table_S5.pdf
<div><p>Reactions which were added to the automatically reconstructed <i>S. cerevisiae</i> model by <i>fillGaps</i><b>.</b> Out of the 45 added reactions 17 has evidence to support that they should be included in the model, 9 has inconclusive of missing evidence, and 19 should not have been included in the model.</p>
          </div>
10.1371/journal.pcbi.1002980.s008

Table_S6.pdf
<div><p>Genes where their corresponding reactions were localized to the mitochondria after running <i>predictLocalization</i> (transport cost = 0.1). The color indicates whether the gene product is mitochondrial in SGD, where green means that it does, yellow that it is unclear, and red that it does not.</p>
          </div>
10.1371/journal.pcbi.1002980.s009

Table_S7.pdf
<div><p>Reactions which cannot carry flux even when all uptake reactions are unconstrained.</p>
          </div>
10.1371/journal.pcbi.1002980.s010

Table_S8.pdf
<div><p>Comparison of metabolic models.</p>
          </div>
10.1371/journal.pcbi.1002980.s011

Table_S9.pdf
<div><p>Biomass composition calculations for <i>P. chrysogenum</i>.</p>
          </div>
10.1371/journal.pcbi.1002980.s012

Table_S10.pdf
<div><p>Reactions with significantly higher flux in DS17690 compared to Wis 54-1255 where the corresponding genes are also up-regulated. Ranked by significance (p&lt;0.05).</p>
          </div>
10.1371/journal.pcbi.1002980.s013

Table_S11.pdf
<div><p>Reporter metabolites when comparing the DS17690 and Wis 54-1255 strains. Ranked by significance. Top 40 best scoring metabolites are shown.</p>
          </div>
10.1371/journal.pcbi.1002980.s014
