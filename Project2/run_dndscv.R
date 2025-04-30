#!/usr/bin/env Rscript

# ——————————————————————————————————————————————————————————
# （0）检查 R 版本（可选，方便排查）
# ——————————————————————————————————————————————————————————
message("R version: ", R.version.string)

# 1. 安装 BiocManager（如果未安装）
if (!requireNamespace("BiocManager", quietly=TRUE))
    install.packages("BiocManager", repos="https://cloud.r-project.org")

# 2. 用 BiocManager 安装 Rsamtools 和 BiocParallel
BiocManager::install(c("Rsamtools","BiocParallel"), 
                     update = TRUE, ask = FALSE)

# 3. 如果之前已经尝试过 remotes::install_github，请先卸载失败的包残留
if ("dndscv" %in% installed.packages()) remove.packages("dndscv")

# 4. 再从 GitHub 安装 dndscv
#    这里用 remotes（或 devtools）从源码安装
if (!requireNamespace("remotes", quietly=TRUE))
    install.packages("remotes", repos="https://cloud.r-project.org")

remotes::install_github("im3sanger/dndscv", dependencies=TRUE)

# 5. 加载并检查
library(dndscv)
message("dndscv version: ", packageVersion("dndscv"))


# ——————————————————————————————————————————————————————————
# （1）安装 remotes（或 devtools），用来从 GitHub 安装
# ——————————————————————————————————————————————————————————
if (!requireNamespace("remotes", quietly=TRUE)) {
  install.packages("remotes", repos="https://cloud.r-project.org")
}

# ——————————————————————————————————————————————————————————
# （2）从 GitHub 安装 dndscv
# ——————————————————————————————————————————————————————————
# 这里直接拉取最新主分支
remotes::install_github("im3sanger/dndscv", dependencies=TRUE)

# ——————————————————————————————————————————————————————————
# （3）加载包，接下来同原脚本流程
# ——————————————————————————————————————————————————————————
library(dndscv)
message("dndscv version: ", packageVersion("dndscv"))

# ——————————————————————————————————————————————————————————
# （4）读入并格式化突变数据
# ——————————————————————————————————————————————————————————
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

# ——————————————————————————————————————————————————————————
# （5）运行 dNdScv
# ——————————————————————————————————————————————————————————
dnds_out <- dndscv(mutations)

# ——————————————————————————————————————————————————————————
# （6）提取并保存结果
# ——————————————————————————————————————————————————————————
sel   <- dnds_out$sel_cv
sig   <- subset(sel, qglobal_cv < 0.05)
write.table(sel, file="dndscv_all_genes.tsv", sep="\t", quote=FALSE, row.names=FALSE)
write.table(sig, file="dndscv_significant_genes.tsv", sep="\t", quote=FALSE, row.names=FALSE)

message("Done.")
