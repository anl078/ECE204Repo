# install the dndscv package
remotes::install_github("im3sanger/dndscv", dependencies=TRUE)

# load the dndscv package
library(dndscv)
message("dndscv version: ", packageVersion("dndscv"))

# read the mutation data
maf_file <- "Team_4_STAD/TCGA.STAD.mutations.txt"
maf <- read.table(maf_file,
                  header=TRUE, sep="\t", quote="",
                  stringsAsFactors=FALSE, comment.char="")

mutations <- data.frame(
  sampleID = maf$patient_id,
  chr      = maf$Chromosome,
  pos      = maf$Start_Position,
  ref      = maf$Reference_Allele,
  alt      = maf$Tumor_Seq_Allele2,
  geneName = maf$Hugo_Symbol,
  stringsAsFactors = FALSE
)
mutations <- na.omit(mutations)

# run dNdScv
dnds_out <- dndscv(mutations)

# extract and save the results
sel   <- dnds_out$sel_cv
sig   <- subset(sel, qglobal_cv < 0.05)
write.table(sel, file="dndscv_all_genes.tsv", sep="\t", quote=FALSE, row.names=FALSE)
write.table(sig, file="dndscv_significant_genes.tsv", sep="\t", quote=FALSE, row.names=FALSE)

message("Done.")
