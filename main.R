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

# ==================================================
# PART 1 — COMBINE THE EFFECTS
# ==================================================

# META-ANALYSIS:
# Boys vs Girls for MALE toys

m_male <- metacont(
  
  n.e = N_boys,
  mean.e = Mean_boys_play_male,
  sd.e = SD_boys_play_male,
  
  n.c = N_girls,
  mean.c = Mean_girls_play_male,
  sd.c = SD_girls_play_male,
  
  studlab = Study,
  data = data,
  
  common = TRUE,
  random = TRUE
)

# Results
m_male

# ==================================================
# PART 2 — FUNNEL PLOT
# ==================================================

# Basic funnel plot
funnel(m_male)
# Contour-enhanced funnel plot

contour_levels <- c(0.90, 0.95, 0.99)

contour_colors <- c(
  "darkgreen",
  "green",
  "lightgreen"
)

funnel(
  m_male,
  contour = contour_levels,
  col.contour = contour_colors
)

legend(
  "topright",
  c("p < 0.10", "p < 0.05", "p < 0.01"),
  bty = "n",
  fill = contour_colors
)
metabias(m_male)


# ==================================================
# PART 3A — METHODS EFFECTS
# ==================================================

# Meta-regression:
# Do study methods affect effect sizes?

methods_model <- metareg(
  m_male,
  
  ~ `Neutral toys` +
    `Parent present` +
    Setting +
    Country +
    Year
)

summary(methods_model)


# ==================================================
# PART 3B — QUALITY EFFECTS
# ==================================================

quality_model <- metareg(
  m_male,
  
  ~ `NOS score`
)

summary(quality_model)

# ==================================================
# PART 4 — AUTHOR GENDER EFFECTS
# ==================================================

# Create author gender ratio

data$author_gender_ratio <-
  data$`Female authors` /
  (data$`Female authors` + data$`Male authors`)

# Recreate meta-analysis object

m_male <- metacont(
  
  n.e = N_boys,
  mean.e = Mean_boys_play_male,
  sd.e = SD_boys_play_male,
  
  n.c = N_girls,
  mean.c = Mean_girls_play_male,
  sd.c = SD_girls_play_male,
  
  studlab = Study,
  data = data,
  
  common = TRUE,
  random = TRUE
)

# Meta-regression for author gender

author_model <- metareg(
  m_male,
  
  ~ author_gender_ratio
)

summary(author_model)
