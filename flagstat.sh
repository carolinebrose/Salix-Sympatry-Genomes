#!/bin/bash

#SBATCH --job-name flagstat
#SBATCH -A tanklab
#SBATCH -t 0-36:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=14
#SBATCH --mem=40G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cbrose1@uwyo.edu       # EDIT TO YOUR EMAIL
#SBATCH -e /project/tanklab/cbrose1/Salix/Scripts/errors/err_flagstat_%A_%a.err  # EDIT TO YOUR DIRECTORY IN evoanalysis (or wherever else)
#SBATCH -o /project/tanklab/cbrose1/Salix/Scripts/outs/std_flagstat_%A_%a.out  # EDIT TO YOUR DIRECTORY IN evoanalysis (or wherever else)
#SBATCH --array 1-24    # EDIT BASED ON HOW MANY SAMPLES



# load modules necessary - check that these are current versions
module load gcc/14.2.0 samtools/1.20


# Set the path to your reference genome
REF=/project/tanklab/cbrose1/Salix/PurpureaGenome/assembly/Spurpurea_519_v5.0.fa.gz

# Set up an output directory and create it
OUTDIR=/project/tanklab/cbrose1/Salix/SympatryGenomes/FlagstatReport-checkmapdata
mkdir -p $OUTDIR


# Set working directory to where the sorted reads are

cd /project/tanklab/cbrose1/Salix/SympatryGenomes/MappedData
#array of files

bams=(*.bam)

SAMPLE=${bams[($SLURM_ARRAY_TASK_ID-1)]}


#run
samtools flagstat -@ $SLURM_CPUS_PER_TASK $SAMPLE > $OUTDIR/${SAMPLE}_flagstat.out
