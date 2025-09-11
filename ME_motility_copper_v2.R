# Install and load required packages
if (!require("dplyr")) install.packages("dplyr")
library(dplyr)

# Define copper 10 mg/L data vectors
copper_10_0h <- c(90.6141394, 103.5984825, 134.3503435, 117.9871607, 73.74197542, 82.23347562, 96.04984939, 99.49187603, 87.00729167, 91.47319198, 73.41423331, 64.35663309, 102.9706129, 103.2387656, 83.99086014)
copper_10_1h <- c(58.50371796, 88.43752211, 71.01140938, 79.20503354, 42.60684563, 81.60518607, 103.7647339, 120.1276342, 72.80462679, 47.16024898, 75.30605158, 57.42113965, 52.59043894, 45.9330306, 71.67684427, 55.58247968)
copper_10_4h <- c(102.1815845, 135.2028449, 104.6938504, 92.76392691, 96.1996279, 101.6655159, 78.82436471, 58.18904322, 76.95970232, 102.3299963, 87.44071117, 13.80642808)
copper_10_24h <- c(31.6701946, 20.47395039, 0, 6.774626518, 34.50543107, 15.87673209, 12.28437024, 24.41422009, 38.8893178, 47.67197713, 9.608566819, 11.40047282, 2.914310056, 19.69059925, 8.475679028)

# Combine values and create group factor for timepoints
values <- c(copper_10_0h, copper_10_1h, copper_10_4h, copper_10_24h)
timepoints <- factor(c(
  rep("0.1h", length(copper_10_0h)),
  rep("1.5h", length(copper_10_1h)),
  rep("4h", length(copper_10_4h)),
  rep("24h", length(copper_10_24h))
), levels = c("0.1h", "1.5h", "4h", "24h"))

# Create data frame
df <- data.frame(timepoint = timepoints, value = values)

# One-way ANOVA
res.aov <- aov(value ~ timepoint, data = df)
anova_summary <- summary(res.aov)
print(anova_summary)

# Extract p-value from ANOVA
p_val <- anova_summary[[1]][["Pr(>F)"]][1]

# Save ANOVA summary (rounded)
anova_df <- as.data.frame(anova_summary[[1]])
anova_df_rounded <- anova_df %>% mutate(across(where(is.numeric), ~ round(., 20)))
write.csv(anova_df_rounded, "copper_5mgL_ANOVA_result.csv", row.names = TRUE)

# Run Tukey HSD pairwise comparison if ANOVA p <= 0.05
if (!is.na(p_val) && p_val <= 0.05) {
  tukey <- TukeyHSD(res.aov)
  print(tukey)
  
  # Convert Tukey results to a data frame for the factor "timepoint"
  tukey_df <- as.data.frame(tukey$timepoint)
  tukey_df$Comparison <- rownames(tukey_df)
  tukey_df <- tukey_df %>% select(Comparison, everything())
  
  # Round numeric columns
  tukey_df_rounded <- tukey_df %>% mutate(across(where(is.numeric), ~ round(., 20)))
  
  # Save Tukey results
  write.csv(tukey_df_rounded, "copper_5mgL_TukeyHSD_results.csv", row.names = FALSE)
} else {
  cat("ANOVA p-value > 0.05; skipping Tukey pairwise comparisons.\n")
}
