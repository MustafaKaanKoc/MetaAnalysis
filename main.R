# PACKAGES
install.packages(c(
  "readxl",
  "meta",
  "metafor",
  "dplyr",
  "ggplot2"
))

library(readxl)
library(meta)
library(metafor)
library(dplyr)
library(ggplot2)


data <- read_excel("metaanalysis_data.xlsx")

# INSPECT DATA
View(data)

names(data)

str(data)

summary(data)