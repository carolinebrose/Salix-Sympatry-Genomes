#### To run on UWyo XFCE medicine bow desktop, open the remote desktop with [this link](https://medicinebow.arcc.uwyo.edu/pun/sys/dashboard/batch_connect/sessions) and open remote desktop with OnDemand.

Open RStudio in the remote desktop using 
``` 
module load gcc r/4.4.0 rstudio
module load gdal/3.7.3 udunits/2.2.28
rstudio
```
in the terminal.


## Whole Genome Data wrangling 
`NovogeneDownloads` folder has all raw data, summary report, MD5 report directions, and list of how big each file is so you can double check if they were downloaded correctly 
`01.RawData` folder has all of the raw reads and MD5 files for each individual, each in their own folders

- working directory for this is called `SympatryGenomes`
- preliminary scripts for filtering etc beginning analyses are from Sarah Palmieri's github [here](https://github.com/spalmieri02/Passerina-Project) and Sean's github repository from the class [here](https://github.com/seanharrington256/evoanalysis/tree/main)


#### notes from Sarah about order to do things after downloading stuff (scripts are in `Scripts` directory, names of files listed after each step): 
- quality check (multiqc)
- combine any files with 4 fastqs to 2 fastqs `rawdatacombine.sh`
- trimming (fastp) `snptrim.sh`
- mapping (BWA-MEM) `bwa.sh`
- check mapping (flag stat) `flagstat.sh`
- remove duplicates `rmdup.sh`
- variant calling; then sort vcfs `varcall.sh`, `sortvcfs.sh`
- combine vcfs into 1 vcf `combinevcf.sh`
- post-variant filtering `filtervcf.sh`
- thinning `thin.sh` 

#### notes from me while running these things and asking sean for help 
- when running BWA for mapping - first have to index the genome otherwise it won't work. This also needs to spit out a .fai file for you to use during variant calling, if bwa doesn't do it, use samtools - faidx command will index the reference seq FASTA to create the .fai file
- using samtools to index genome and create .fai requries an unzipped file: 
``` 
gunzip Spurpurea_519_v5.0.fa.gz
module load arcc gcc samtools
samtools faidx Spurpurea_519_v5.0.fa 
```
- indexed file `Spurpurea_519_v5.0.fa.fai` is in same directory as the other genome files `PurpureaGenome/assembly`
- when `varcall.sh` asks for number of scaffolds for the job array, this number should be found in whatever stats thatcome with the genome assembly: Spurpurea_519_v5.0 has 348 scaffolds
- not entirely sure what the point is for the `thin.sh` for why this should be thinned out - this isn't in Sean's code, so I'm not going to deal with it, especially because I didn't want to troubleshoot the issues with it until we need to 


##### nQuack for ploidy estimation #### 
in `nQuack` directory, there is an R script `nQuack-prep.R` that holds the script for preparing data and running the program. Run this through the slurm script `Scripts/nQuack-prep.sh` because it seems to take ages and the salloc session times out every time. Might need to un-comment out the installation of devtools and nQuack, but it causes problems for me when I keep re-installing whilst fixing errors 

