#!/bin/bash

#SBATCH --job-name sort_vcfs
#SBATCH -A tanklab
#SBATCH -t 0-30:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=25G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cbrose1@uwyo.edu       # EDIT TO YOUR EMAIL
#SBATCH -e /cluster/medbow/project/tanklab/cbrose1/Salix/Scripts/errors/err_sort_vcfs_%A_%a.err  # EDIT TO YOUR DIRECTORY IN evoanalysis (or wherever else)
#SBATCH -o /cluster/medbow/project/tanklab/cbrose1/Salix/Scripts/outs/std_sort_vcfs_%A_%a.out  # EDIT TO YOUR DIRECTORY IN evoanalysis (or wherever else)
#SBATCH --array=1-348      # EDIT BASED ON HOW MANY SCAFFOLDS/VCF FILE YOU HAVE

#load packages - check these are current
module load gcc/14.2.0 bcftools/1.20

#set directory
cd /cluster/medbow/project/tanklab/cbrose1/Salix/SympatryGenomes/VCF-all

# make a bash array of all vcf files in the current directory - based on how I named things
files=(unsorted*.vcf.gz)


#define the vcf file to work on
vcf=${files[($SLURM_ARRAY_TASK_ID-1)]} 

echo "started file $vcf"

# run sort
bcftools sort -Oz $vcf -o sort_$vcf

echo "completed file $vcf"

# delete the original vcf, we don't need it anymore
# rm $vcf # started doing this manually afterwards in case something doesn't go right
