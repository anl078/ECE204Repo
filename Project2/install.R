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