# Install and load required packages
if (!require("dplyr")) install.packages("dplyr")
library(dplyr)

# Define nickel 10 mg/L new data vectors
nickel_10_4h <- c(66.33615348, 93.09024703, 69.74473053, 72.42722017, 
                  116.6926398, 82.76760553, 122.3059767, 95.89900448, 
                  91.6556857, 92.80548821, 124.9724583, 121.5010012, 
                  97.37437378, 113.2984019, 116.3364972)

nickel_10_24h <- c(129.2027968, 145.7440465, 131.6560144, 143.7795226, 
                   154.5770191, 68.54789699, 112.0088861, 138.1251679, 
                   188.1286201, 159.1383081, 144.1452469, 104.9206045, 
                   82.03467716, 93.26275954, 123.1807371)

# Combine values and create group factor for timepoints
values <- c(nickel_10_4h, nickel_10_24h)
timepoints <- factor(c(
  rep("4h", length(nickel_10_4h)),
  rep("24h", length(nickel_10_24h))
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
write.csv(anova_df_rounded, "nickel_5mgL_ANOVA_result.csv", row.names = TRUE)

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
  write.csv(tukey_df_rounded, "nickel_5mgL_TukeyHSD_results.csv", row.names = FALSE)
} else {
  cat("ANOVA p-value > 0.05; skipping Tukey pairwise comparisons.\n")
}
