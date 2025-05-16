#set directory to this file location
#
#import the package
library(signature.tools.lib)
outdir <- "C:\\Users\\andyl\\Documents\\signature.tools.lib-master\\signature.tools.lib-master\\sigextract"
dir.create(outdir,showWarnings = F,recursive = T)

#set sample names
sample_names <- c("sample1")

#set the file names. 
SNV_tab_files <- c("C:\\Users\\andyl\\Documents\\signature.tools.lib-master\\signature.tools.lib-master\\TCGA.STAD.mutations.txt")
#name the vectors entries with the sample names
names(SNV_tab_files) <- sample_names
#load SNV data and convert to SNV mutational catalogues
SNVcat_list <- list()
for (i in 1:length(SNV_tab_files)){
  tmpSNVtab <- read.table(SNV_tab_files[i],sep = "\t",
                          header = TRUE,check.names = FALSE,
                          stringsAsFactors = FALSE)
  #convert to SNV catalogue, see ?tabToSNVcatalogue or
  #?vcfToSNVcatalogue for details
  res <- tabToSNVcatalogue(subs = tmpSNVtab,genome.v = "hg19")
  SNVcat_list[[i]] <- res$catalogue
}
#bind the catalogues in one table
SNV_catalogues <- do.call(cbind,SNVcat_list)
writeTable(SNV_catalogues,file = "SNVtestcat.tsv")
#SignatureExtraction(cat = SNV_catalogues,
 #                   outFilePath = paste0(outdir,"Extraction/"),
  #                  nrepeats = 25,nboots = 4,filterBestOfEachBootstrap = T,
   #                 nparallel = 4,nsig = 8:11,plotResultsFromAllClusteringMethods = T,
    #                parallel = T)
