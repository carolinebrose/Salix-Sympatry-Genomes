#!/bin/bash

#SBATCH --job-name rmd
#SBATCH -A tanklab
#SBATCH -t 0-72:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=80G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cbrose1@uwyo.edu        # EDIT TO YOUR EMAIL
#SBATCH -e /project/tanklab/cbrose1/Salix/Scripts/errors/err_rmd_%A_%a.err    # EDIT TO YOUR DIRECTORY IN evoanalysis (or wherever else)
#SBATCH -o /project/tanklab/cbrose1/Salix/Scripts/outs/std_rmd_%A_%a.out    # EDIT TO YOUR DIRECTORY IN evoanalysis (or wherever else)
#SBATCH --array 1-24          # EDIT BASED ON HOW MANY SAMPLES


# Load modules - make sure these are current
module load gcc/14.2.0 picard/3.2.0 samtools/1.20

# Set up output directory variable - set this to where you want to output to go
OUTDIR=/project/tanklab/cbrose1/Salix/SympatryGenomes/RemovedDuplicates
mkdir -p $OUTDIR  # make the directory if it doens't exist

# Set working dir to where the bam files are - set to your location
cd /project/tanklab/cbrose1/Salix/SympatryGenomes/MappedData

#array of files - this takes all the bam file names from the current directory and puts them into a bash array (analagous to an R vector if you are more familiar with R)
bams=(*.bam)

# Get the file name of the single sample to work on in a given array job
SAMPLE=${bams[($SLURM_ARRAY_TASK_ID-1)]}

# get individual name only from that file name - this works with my file name structure, may not for you
name=$(echo $SAMPLE| cut -d '_' -f 3) #this gets the 3rd piece of the name, each piece delimited by a _ , which means that since the sample name is (ex: trim_read_SALAK25098_sort , then it just gets SALAK25098)


#add readgroups - this is necessary if you don't have readgroups already assigned to your files
picard AddOrReplaceReadGroups \
    -I $SAMPLE \
    -O $OUTDIR/${name}.rg.bam \
    -RGID id \
    -RGLB lib1 \
    -RGPL illumina \
    -RGPU unit1 \
    -RGSM $name
 
#run picard MarkDuplicates
picard \
 MarkDuplicates -REMOVE_DUPLICATES true \
 -ASSUME_SORTED true -VALIDATION_STRINGENCY SILENT \
 -INPUT $OUTDIR/${name}.rg.bam \
 -OUTPUT $OUTDIR/${name}.rmd.bam \
 -METRICS_FILE $OUTDIR/${name}.rmd.bam.metrics
 
# Index the new bam file with duplicates removed
samtools index $OUTDIR/${name}.rmd.bam
