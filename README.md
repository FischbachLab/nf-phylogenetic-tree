README
====================

## A pipeline for building a phylogenetic tree from the full length 16S sequences

## References:

http://mafft.cbrc.jp/alignment/software/

http://sco.h-its.org/exelixis/web/software/raxml/hands_on.html

https://github.com/rambaut/figtree


## A sample batch submission script

```{bash}
aws batch submit-job \
  --job-name nf-phylogenetic-tree \
  --job-queue priority-maf-pipelines \
  --job-definition nextflow-production \
  --container-overrides command="s3://nextflow-pipelines/nf-phylogenetic-tree, \
"--project", "TEST", \
"--fasta", "s3://genomics-workflow-core/Results/phylogenetic_tree/3B.fasta", \
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
