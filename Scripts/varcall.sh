#!/bin/bash

#SBATCH --job-name var_call
#SBATCH -A tanklab
#SBATCH -t 0-72:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=12
#SBATCH --mem=48G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cbrose1@uwyo.edu       # EDIT TO YOUR EMAIL
#SBATCH -e /project/tanklab/cbrose1/Salix/Scripts/errors/err_varcall_%A_%a.err  # EDIT TO YOUR DIRECTORY IN evoanalysis (or wherever else)
#SBATCH -o /project/tanklab/cbrose1/Salix/Scripts/outs/std_varcall_%A_%a.out  # EDIT TO YOUR DIRECTORY IN evoanalysis (or wherever else)
#SBATCH --array=1-348    # EDIT BASED ON HOW MANY SCAFFOLDS YOU ARE CALLING IN PARALLEL


# Variant calling all samples at once

#load modules - check that these are up to date
module load gcc/14.2.0 bcftools/1.20

## set the input directory to where your BAM files are
BAMDIR=/project/tanklab/cbrose1/Salix/SympatryGenomes/RemovedDuplicates

# Define the path to your reference genome
REF=/project/tanklab/cbrose1/Salix/PurpureaGenome/assembly/Spurpurea_519_v5.0.fa #since we unzipped it to index we don't need the zipped version for this (jic it breaks because of a .gz - probably wont but i'm paranoid)

# Get the region of interest from the bed file
#   this is a file that specifies genomic regions, you will need to create one if using this method of calling
#    each scaffold separately
scaf=`cat /project/tanklab/cbrose1/Salix/PurpureaGenome/assembly/Spurpurea_519_v5.0.fa.fai | head -n $SLURM_ARRAY_TASK_ID | tail -n 1 | cut -f 1`

# just print some info to the output file
echo "started scaffold $scaf"

## Create output directory
OUTDIR=/project/tanklab/cbrose1/Salix/SympatryGenomes/VCF-all
mkdir -p $OUTDIR

# Go to target directory
cd $BAMDIR

#run bcftools mpileup and call to create vcf files
bcftools mpileup --threads $SLURM_CPUS_PER_TASK -a DP,AD --regions $scaf -f $REF *.rmd.bam | bcftools call -f GQ,GP -m --variants-only --threads $SLURM_CPUS_PER_TASK -O z -o "${OUTDIR}/unsorted_${scaf}.vcf.gz"

echo "completed scaffold $scaf"
