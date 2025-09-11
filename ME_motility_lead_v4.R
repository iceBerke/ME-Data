# Install and load required packages
if (!require("rstatix")) install.packages("rstatix")
if (!require("dplyr")) install.packages("dplyr")
library(rstatix)
library(dplyr)

# Define your lead_50 data
lead_50_0h <- c(84.854045, 73.28303887, 94.83687383, 113.9958382,
                123.1155053, 64.4890742, 83.75204442, 62.81403331,
                57.57953054, 109.9245583, 109.9245583, 122.9263878)

lead_50_1h <- c(67.93959346, 93.32361738, 71.36511918, 45.49526348,
                60.6603513, 83.00890178, 129.6876476, 158.9719551,
                84.3970105, 83.00890178, 126.3757319, 65.71538058,
                97.05656208, 97.05656208, 121.3207026, 94.36054647)

lead_50_4h <- c(86.31103122, 79.49700244, 52.67186008, 50.10250105,
                70.1625157, 83.07436755, 62.65541526, 69.04882498,
                71.84810167, 58.78481045, 54.92520169, 60.41772186,
                78.54303841, 57.90031678, 49.22925485, 60.41772186)

lead_50_24h <- c(116.8722137, 99.95649858, 80.52051274, 90.86954416,
                 76.02325244, 90.15684186, 99.95649858, 80.66664798,
                 89.24687373, 74.0418508, 126.4755696, 170.7590184,
                 122.3957125, 142.2457864, 109.7561553)

# Combine into one vector
values <- c(lead_50_0h, lead_50_1h, lead_50_4h, lead_50_24h)

# Create grouping factor
groups <- factor(c(
  rep("0.1h", length(lead_50_0h)),
  rep("1.5h", length(lead_50_1h)),
  rep("4h", length(lead_50_4h)),
  rep("24h", length(lead_50_24h))
), levels = c("0.1h", "1.5h", "4h", "24h"))

# Build dataframe
df <- data.frame(timepoint = groups, value = values)
print(head(df))

# Welch's ANOVA (instead of classical ANOVA)
welch_test <- oneway.test(value ~ timepoint, data = df, var.equal = FALSE)
print(welch_test)

# Extract p-value
p_val <- welch_test$p.value

# Save Welch ANOVA result
welch_summary <- data.frame(statistic = welch_test$statistic,
                            parameter = welch_test$parameter,
                            p.value = p_val)
write.csv(welch_summary, "lead_25mgL_welch_anova_result.csv", row.names = FALSE)

# Conditional Games-Howell post hoc test
if (p_val <= 0.05) {
  cat("\nWelch's ANOVA is significant (p <= 0.05), conducting Games-Howell post-hoc test...\n")
  posthoc <- games_howell_test(df, value ~ timepoint)
  print(posthoc)
  posthoc_rounded <- posthoc %>%
    mutate(across(where(is.numeric), ~ round(., 20)))
  write.csv(posthoc_rounded, "lead_25mgL_games_howell_posthoc_results.csv", row.names = FALSE)
} else {
  cat("\nWelch's ANOVA is NOT significant (p > 0.05), skipping post-hoc test.\n")
}
