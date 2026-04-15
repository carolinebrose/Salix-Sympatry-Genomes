#!/bin/bash

#SBATCH --job-name nQuackprep
#SBATCH -A tanklab
#SBATCH -t 0-10:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=24G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cbrose1@uwyo.edu       # EDIT TO YOUR EMAIL
#SBATCH -e /cluster/medbow/project/tanklab/cbrose1/Salix/Scripts/errors/nQ_%A_%a.err  # EDIT TO YOUR DIRECTORY IN evoanalysis (or wherever else)
#SBATCH -o /cluster/medbow/project/tanklab/cbrose1/Salix/Scripts/outs/nQ_%A_%a.out  # EDIT TO YOUR DIRECTORY IN evoanalysis (or wherever else)


module load arcc gcc samtools r
Rscript ../nQuack/nQuack-prep.R