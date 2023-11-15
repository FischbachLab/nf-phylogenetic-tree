#!/usr/bin/env nextflow
nextflow.enable.dsl=2
// If the user uses the --help flag, print the help text below
params.help = false

// Function which prints help message text
def helpMessage() {
    log.info"""
    Build a Phylogenetic tree for a given set of full length 16S sequences

    Required Arguments:
      --project       name        A project/tree name
      --fasta         path        A file contains 16S sequences in fasta
      --outdir        path        Output s3 path

    Options:
      -profile        docker      run locally


    """.stripIndent()
}

// Show help message if the user specifies the --help flag at runtime
if (params.help){
    // Invoke the function above which prints the help message
    helpMessage()
    // Exit out and do not run anything else
    exit 0
}

if (params.outdir  == "null") {
	exit 1, "Missing the output path"
}
if (params.project == "null") {
	exit 1, "Missing the project name"
}
if (params.fasta == "null") {
	exit 1, "Missing the sequence file"
}


/*
 * Defines the pipeline inputs parameters (giving a default value for each for them)
 * Each of the following parameters can be specified as command line options
 */

def outdir1  = "${params.outdir}"
println outdir1


/*
 process get_mafft_help_message {

  container params.container_mafft

 	output:

 	script:

 	"""

   mafft -h

 	"""
 }
 */
 /*
  MSA using mafft
*/
 process msa {
     tag "$fa"

     container params.container_mafft
     cpus { 16 * task.attempt }
     memory { 32.GB * task.attempt }

     publishDir "${params.outdir}/${params.project}/mafft/", mode:'copy'

     input:
     path fa

     output:
     path "aligned_*.aln"


     script:
     """
     mafft --thread 16 --localpair --adjustdirectionaccurately --maxiterate 1000  --auto "$fa" > aligned_msa.aln
     """
 }


/*
Generate a tree file
*/
 process build_tree {
     tag "${params.project}"

     container params.container_raxml
     cpus { 16 * task.attempt }
     memory { 32.GB * task.attempt }

     errorStrategy { task.exitStatus in 137..140 ? 'retry' : 'terminate' }
     maxRetries 2

     publishDir "${params.outdir}/${params.project}/tree", mode:'copy', pattern: 'RAxML_bestTree.*'

     input:
     file aln

     output:
     file "RAxML_bestTree.*"

     script:
     """
     raxmlHPC -m GTRGAMMA -p 12345 -s "$aln" -n "${params.project}" -f a -x 12345 -N 100 -T 16
     """
 }

 /*
  Write the tree in pdf using figtree
*/
  process write_tree_in_pdf {
      tag "${params.project}"

      container params.container_figtree

      errorStrategy { task.exitStatus in 137..140 ? 'retry' : 'terminate' }
      maxRetries 2

      publishDir "${params.outdir}/${params.project}/pdf", mode:'copy', pattern: '*.pdf'

      input:
      file tree

      output:
      file "*.pdf"

      script:
      """
      figtree -graphic PDF "$tree" "${params.project}".bestTree.pdf
      """
  }


  fasta_ch = Channel.fromPath(params.fasta)
   .ifEmpty { exit 1, "Cannot find the input fasta file matching: ${params.fasta}." }

  workflow {
     fasta_ch | msa
     msa.out | build_tree
     build_tree.out | write_tree_in_pdf
  }
