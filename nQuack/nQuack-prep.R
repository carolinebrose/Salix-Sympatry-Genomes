
setwd("/project/tanklab/cbrose1/Salix/SympatryGenomes/nQuack")

## load packages
#install.packages("devtools", repos = "https://cran.r-project.org")
library(devtools)
#devtools::install_github("mgaynor1/nQuack")
library(nQuack)

## prepare samples - convert .bam to tab-sep. txt file with prepare_data
inpath <- "/project/tanklab/cbrose1/Salix/SympatryGenomes/RemovedDuplicates/"
outpath <- "Processed/"
filelist <- list.files(path = inpath, pattern = "\\.bam$")
filelist <- gsub(".bam", "", filelist)

for(i in 1:length(filelist)){
prepare_data(filelist[i], inpath, outpath)
}


# ## read in data to R envi. and choose between 3 diff types of filtering: total covg., allele covg., allele freq. 
# textfiles <- list.files(path = "Processed/", pattern = "*.txt", full.name = FALSE)
#
# for(i in 1:length(textfiles)){
# temp <- process_data(paste0("Processed/", textfiles[i], #file with full location
# 	min.depth = 2, #total coverage filter
# 	max.depth.quantile.prob = 0.9, #total coverage filter
# 	error = 0.01, #allele coverage filter
# 	trunc = c(0,0)) #allele freq filter
# assign((gsub(".txt", "", textfiles[i])), temp)
# }
#
#
# ## look at total coverage filter - check if need to adjust 
# hist(xm[,1]) #histogram of output total coverage 
# #error cutoffs: if i > seq error rate, how many sites are likely to be removed
# new.err <- 0.02 #2 out of every 100 sites
# removes <- c()
# for(i in 1:nrow(xm)){
# if(xm[i,2] < (xm[i,1]*new.err | xm[i,2] > (xm[i,1]*(1-new.err))){
# removes[i] <- 1
# }else{
# removes[i] <- 0
# }
# }
# sum(removes)
# 
# ## look at allele freq hist to test if you need data  truncated 
# xi <- xm[,2]/xm[,1]
# hist(xi) 
# #if U-shape hist, change the trunc function in the data processing to rm the edges

