# Install and load required packages
if (!require("dplyr")) install.packages("dplyr")
library(dplyr)

# Define nickel 50 mg/L new data vectors
nickel_50_4h <- c(108.1144739, 107.2609385, 150.5662023, 133.0135648, 
                  114.1499906, 71.25726686, 71.98438182, 62.70639483, 
                  91.4468258, 88.22328277, 101.7960955, 101.7960955, 
                  97.30302647, 85.66447382, 170.6296458)

nickel_50_24h <- c(35.35162055, 40.77840441, 50.97300551, 69.83082987, 
                   37.18990482, 47.2432734, 9.187229452, 53.6392858, 
                   26.8196429, 78.34951859, 75.79464298, 44.06386827, 
                   30.71853372, 65.47518455, 73.40112794)

# Combine values and create group factor for timepoints
values <- c(nickel_50_4h, nickel_50_24h)
timepoints <- factor(c(
  rep("4h", length(nickel_50_4h)),
  rep("24h", length(nickel_50_24h))
), levels = c("4h", "24h"))

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
write.csv(anova_df_rounded, "nickel_25mgL_ANOVA_result.csv", row.names = TRUE)

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
  write.csv(tukey_df_rounded, "nickel_25mgL_TukeyHSD_results.csv", row.names = FALSE)
} else {
  cat("ANOVA p-value > 0.05; skipping Tukey pairwise comparisons.\n")
}
