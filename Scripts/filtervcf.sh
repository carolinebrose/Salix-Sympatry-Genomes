#!/bin/bash

#SBATCH --job-name vcf_filter
#SBATCH -A tanklab
#SBATCH -t 0-12:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=24G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cbrose1@uwyo.edu       # EDIT TO YOUR EMAIL
#SBATCH -e /cluster/medbow/project/tanklab/cbrose1/Salix/Scripts/errors/err_filt_%A_%a.err  # EDIT TO YOUR DIRECTORY IN evoanalysis (or wherever else)
#SBATCH -o /cluster/medbow/project/tanklab/cbrose1/Salix/Scripts/outs/std_filt_%A_%a.out  # EDIT TO YOUR DIRECTORY IN evoanalysis (or wherever else)


#load packages - check that these are current
module load arcc/1.0 gcc/14.2.0 bcftools/1.20 vcftools/0.1.17

#go to directory- CHANGE TO SORTED VCFs?
cd /cluster/medbow/project/tanklab/cbrose1/Salix/SympatryGenomes/VCF-sorted

# set up the inputs 
VCF_IN=genome.vcf.gz
VCF_OUT=filtered_genome.vcf.gz


# Set up filters as bash variables to be called in the vcftools command
MAF=0 #minor allele frequency greater than this value excluded ##Sean's code suggests this = 0 to give correct calculation of pi & dxy and SFS so we are going to start with that
MISS=0.7 #includes only sites with this amount or less missing data 
QUAL=30 #includes only sites with Quality score above this
MIN_DEPTH=7 #includes only genotypes with this value or more depth
MIN_ALLELES=2 #includes only sites with this number of alleles or more
MAX_ALLELES=2 #includes only sites with this number of alleles or less - use both min and max = 2 to make only biallelic sites


# Apply those filters in vcftools
vcftools --gzvcf $VCF_IN \
	--remove-indels \
	--maf $MAF \
	--max-missing $MISS \
	--minQ $QUAL \
	--minDP $MIN_DEPTH \
	--min-alleles $MIN_ALLELES \
	--max-alleles $MAX_ALLELES \
	--recode --stdout | gzip -c > $VCF_OUT
