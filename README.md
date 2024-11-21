README
====================

## A pipeline for building a phylogenetic tree from the full length 16S sequences

## The pipeline contains three steps.

1. Multiple sequence alignment (http://mafft.cbrc.jp/alignment/software/)

2. Phylogenetic Analysis & generate the phylogenetic tree (http://sco.h-its.org/exelixis/web/software/raxml/hands_on.html)

3. Write the tree in pdf (https://github.com/rambaut/figtree)

==Sequence header format==
>Note: Replace illegal characters in headers to make them valid sequence header.
>
> Illegal characters in headers are: tabulators, carriage returns, spaces, ":", ",", ")", "(", ";", "]", "[", "'" 
>
> hint: tr -d '[:\,)(;\[\]]'\''') ( tr deletes the specified characters above, including the single quote, from the input string)


## A sample batch submission script

```{bash}
aws batch submit-job \
  --job-name nf-phylogenetic-tree \
  --job-queue priority-maf-pipelines \
  --job-definition nextflow-production \
  --container-overrides command="FischbachLab/nf-phylogenetic-tree, \
"--project", "TEST", \
"--fasta", "s3://genomics-workflow-core/Results/phylogenetic_tree/inputs/3B.fasta", \
"--outdir", "s3://genomics-workflow-core/Results/phylogenetic_tree" "
```


### The tree in pdf is available at
```{bash}
s3://genomics-workflow-core/Results/phylogenetic_tree/TEST/pdf/
```

### View and edit phylogenetic trees
#### FigTree:
http://tree.bio.ed.ac.uk/software/figtree/


#### List of tree visualization tools
https://en.wikipedia.org/wiki/List_of_phylogenetic_tree_visualization_software
