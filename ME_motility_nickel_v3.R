# Install and load required packages
if (!require("dplyr")) install.packages("dplyr")
library(dplyr)

# Define nickel 10 mg/L data vectors
nickel_10_0h <- c(142.1270757, 105.0504473, 101.3228507, 123.273484,
                  144.0095535, 83.31587196, 92.9292418, 142.6866311,
                  71.34331556, 111.7607181, 79.54437158, 90.01381461)

nickel_10_1h <- c(73.75812875, 53.81651496, 67.14046716, 50.92126079,
                  80.24884408, 107.7760639, 108.5183232, 102.1948308,
                  70.89290913, 71.18849072, 92.50241009, 65.62405474,
                  97.69424497, 102.1948308, 117.5318371, 90.37926747)

nickel_10_4h <- c(65.53692271, 91.96867779, 68.90443257, 71.55460306,
                  115.2867043, 81.77040546, 120.8324107, 94.74359479,
                  90.55140033, 91.68734979, 123.4667661, 120.0371337,
                  96.20118855, 111.9333609, 114.9348527)

nickel_10_24h <- c(107.6689973, 121.4533721, 109.7133454, 119.8162688,
                   128.8141825, 57.12324749, 93.34073843, 115.1043065,
                   156.7738501, 132.6152568, 120.121039, 87.43383706,
                   68.36223096, 77.71896628, 102.6506142)

# Combine values and create group factor for timepoints
values <- c(nickel_10_0h, nickel_10_1h, nickel_10_4h, nickel_10_24h)
timepoints <- factor(c(
  rep("0.1h", length(nickel_10_0h)),
  rep("1.5h", length(nickel_10_1h)),
  rep("4h", length(nickel_10_4h)),
  rep("24h", length(nickel_10_24h))
), levels = c("0.1h", "1.5h", "4h", "24h"))

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
