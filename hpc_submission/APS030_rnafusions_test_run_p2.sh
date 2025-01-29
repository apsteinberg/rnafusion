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
outdir=/data1/shahs3/users/preskaa/ThreeByThreeSarcoma/data/APS030_3x3_fusions/rnafusion_p2_test
samplesheet=$HOME/rnafusion/resources/TCDO-SAR-006_samplesheet.csv
# reference paths
arriba_ref=/data1/shahs3/reference/ref-sarcoma/rnafusion/reference/arriba
ensembl_ref=/data1/shahs3/reference/ref-sarcoma/rnafusion/reference/ensembl_v79
fusionreport_ref=/data1/shahs3/reference/ref-sarcoma/rnafusion/reference/fusion_report_db
hgnc_ref=/data1/shahs3/reference/ref-sarcoma/rnafusion/reference/hgnc
starfusion_ref=/data1/shahs3/reference/ref-sarcoma/GRCh38/FusionInspector/GRCh38_gencode_v22_CTAT_lib_Mar012021.STAR_v2.7.11a.plug-n-play

# make out directory
mkdir -p ${outdir}

cd ${outdir}

nextflow run apsteinberg/rnafusion \
  -c ${HOME}/rnafusion/conf/iris.config \
  -profile singularity,slurm \
  -work-dir ${outdir}/work \
  --arriba --starfusion \
  --email preskaa@mskcc.org \
  --outdir ${outdir} \
  --input ${samplesheet} \
  --arriba_ref ${arriba_ref} --ensembl_ref ${ensembl_ref} \
  --fusion_report_ref ${fusionreport_ref} \
  --hgnc_ref ${hgnc_ref} --starfusion_ref ${starfusion_ref} \
  --starindex
