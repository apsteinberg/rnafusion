#!/bin/bash
#SBATCH --partition=componc_cpu,componc_gpu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --time=48:00:00
#SBATCH --mem=10GB
#SBATCH --job-name=fusions
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=preskaa@mskcc.org
#SBATCH --output=slurm%j_rnafusions_reference.out

source /home/preskaa/miniforge3/bin/activate nf-core

## load modules
module load singularity/3.7.1
module load java/20.0.1



# paths
archive=/data1/shahs3/users/preskaa/ThreeByThreeSarcoma/data/APS030_3x3_fusions
outdir=${archive}/fusioninspector_ont_only_fusions
reference=/data1/shahs3/reference/ref-sarcoma/rnafusion/reference_GRCh38P2
samplesheet=${archive}/fusioninspector_samplesheet.csv
ont_fusion_list=${archive}/ont_only_fusions.txt
# make out directory
mkdir -p ${outdir}

cd ${outdir}

nextflow run apsteinberg/rnafusion \
  -c ${HOME}/rnafusion/conf/iris.config \
  -profile singularity,slurm \
  -work-dir ${outdir}/work \
  --fusioninspector_only \
  --fusioninspector_fusions ${ont_fusion_list} \
  --email preskaa@mskcc.org \
  --outdir ${outdir} \
  --genomes_base ${reference} \
  --input ${samplesheet} \
  --ensembl_version 79

