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
outdir=/data1/shahs3/users/preskaa/ThreeByThreeSarcoma/APS030_3x3_fusions/rnafusion_test/reference

# make out directory
mkdir -p ${outdir}

cd ${outdir}

nextflow run apsteinberg/rnafusion \
  -r 3.0.2 \
  -c ${HOME}/rnafusion/conf/iris.config \
  -profile singularity,slurm \
  -work-dir ${outdir}/work \
  --email preskaa@mskcc.org \
  --build_references --all \
  --cosmic_username <EMAIL> --cosmic_passwd <PASSWORD> \
  --outdir ${outdir} \
  --genomes_base ${outdir}

