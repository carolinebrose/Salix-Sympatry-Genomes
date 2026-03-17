#!/bin/bash

#SBATCH --job-name rawdatacombine
#SBATCH -A tanklab  ## EDIT TO YOUR PROJECT
#SBATCH -t 0-05:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=20G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cbrose1@uwyo.edu   # EDIT TO YOUR EMAIL
#SBATCH -e  /project/tanklab/cbrose1/Salix/Scripts/errors/err_fastqc_%A_%a.err 
#SBATCH -o  /project/tanklab/cbrose1/Salix/Scripts/outs/std_fastqc_%A_%a.out  


cd /project/tanklab/cbrose1/Salix/NovogeneDownloads/01.RawData #directory where all the data are stored

ARCHIVE_ROOT="/project/tanklab/cbrose1/Salix/NovogeneDownloads/01.RawData/Archive" #this is where the og files get moved to when you are done combining them 
mkdir -p "$ARCHIVE_ROOT" #makes a folder for it if there isn't one already

for SAMPLE in S*; do #for each folder in the working directory that starts with S
    [ -d "$SAMPLE" ] || continue # if there isnt a directory that starts with S  skip it

    R1_FILES=("$SAMPLE"/*_1.fq.gz) #temp collect all the files that end in _1 in R1 array 
    R2_FILES=("$SAMPLE"/*_2.fq.gz) #collect files that end in _2 in R2 array

    # Skip if no FASTQs
    if [ ! -e "${R1_FILES[0]}" ]; then #if there's no files in this, skip 
        continue
    fi

    # Sanity check
    if [ "${#R1_FILES[@]}" -ne "${#R2_FILES[@]}" ]; then #if number of R1 doesn't = R2, then skip bc its probably incomplete sequencing 
        echo "ERROR: unequal R1/R2 in $SAMPLE" >&2
        exit 1
    fi

    # Only act on multi-run samples
    if [ "${#R1_FILES[@]}" -gt 1 ]; then
        echo "Processing multi-run sample $SAMPLE" #tell us we are processing this one

        ARCHIVE_DIR="$ARCHIVE_ROOT/$SAMPLE" #make a new folder for this sample in the archive directory 
        mkdir -p "$ARCHIVE_DIR"

        # Move original FASTQs (and MD5s if present) 
        mv "$SAMPLE"/*.fq.gz "$ARCHIVE_DIR"/
        [ -e "$SAMPLE/MD5.txt" ] && mv "$SAMPLE/MD5.txt" "$ARCHIVE_DIR"/

        # Concatenate
        cat "$ARCHIVE_DIR"/*_1.fq.gz > "$SAMPLE/${SAMPLE}_1.fq.gz"
        cat "$ARCHIVE_DIR"/*_2.fq.gz > "$SAMPLE/${SAMPLE}_2.fq.gz"
    fi
done
