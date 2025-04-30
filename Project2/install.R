#!/usr/bin/env Rscript
message("R version: ", R.version.string)

if (!requireNamespace("BiocManager", quietly=TRUE))
    install.packages("BiocManager", repos="https://cloud.r-project.org")

BiocManager::install(c("Rsamtools","BiocParallel"), 
                     update = TRUE, ask = FALSE)

if ("dndscv" %in% installed.packages()) remove.packages("dndscv")

if (!requireNamespace("remotes", quietly=TRUE))
    install.packages("remotes", repos="https://cloud.r-project.org")

remotes::install_github("im3sanger/dndscv", dependencies=TRUE)

library(dndscv)
message("dndscv version: ", packageVersion("dndscv"))

if (!requireNamespace("remotes", quietly=TRUE)) {
  install.packages("remotes", repos="https://cloud.r-project.org")
}