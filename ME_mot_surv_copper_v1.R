# Install and load required packages
if (!require("dplyr")) install.packages("dplyr")
library(dplyr)

# Define copper 10 mg/L data vectors
copper_10_0h <- c(96.40526861, 110.2194382, 142.9366437, 125.5276935, 
                  78.45480844, 87.4889985, 102.1883736, 105.8503794, 
                  92.56790805, 97.31922305, 78.1061204, 68.469651, 
                  109.5514416, 109.8367318, 89.35869707)

copper_10_1h <- c(61.91344385, 93.59185622, 75.15011115, 83.82127783, 
                  45.09006669, 86.36131655, 109.8123717, 127.128938, 
                  77.04784123, 49.90885245, 79.69505459, 60.76777049, 
                  55.65552587, 48.61010907, 75.85432906, 58.82194935)

copper_10_24h <- c(32.25927705, 20.85477675, 0, 6.900638172, 35.14725042, 
                   16.17204774, 12.51286605, 24.86833756, 39.61267978, 
                   48.55870124, 9.787291268, 11.61252767, 2.968517772, 
                   20.05685486, 8.633331162)

# Combine values and create group factor for timepoints
values <- c(copper_10_0h, copper_10_1h, copper_10_24h)
timepoints <- factor(c(
  rep("0.1h", length(copper_10_0h)),
  rep("1.5h", length(copper_10_1h)),
  rep("24h", length(copper_10_24h))
), levels = c("0.1h", "1.5h", "24h"))

# Create data frame
df <- data.frame(timepoint = timepoints, value = values)

# One-way ANOVA (classical)
res.aov <- aov(value ~ timepoint, data = df)
anova_summary <- summary(res.aov)
print(anova_summary)

# Extract p-value
p_val <- anova_summary[[1]][["Pr(>F)"]][1]

# Save ANOVA summary (rounded)
anova_df <- as.data.frame(anova_summary[[1]])
anova_df_rounded <- anova_df %>%
  mutate(across(where(is.numeric), ~ round(., 20)))
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
  tukey_df_rounded <- tukey_df %>%
    mutate(across(where(is.numeric), ~ round(., 20)))
  
  # Save Tukey results
  write.csv(tukey_df_rounded, "copper_5mgL_TukeyHSD_results.csv", row.names = FALSE)
} else {
  cat("ANOVA p-value > 0.05; skipping Tukey pairwise comparisons.\n")
}
