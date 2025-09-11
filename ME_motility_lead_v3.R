# Install and load required packages
if (!require("rstatix")) install.packages("rstatix")
if (!require("dplyr")) install.packages("dplyr")
library(rstatix)
library(dplyr)

# Define your lead_100 data
lead_100_0h <- c(50.36875121, 49.04325776, 66.55870696, 63.87488813,
                 40.63176878, 31.76665559, 46.59109487, 18.9614921,
                 37.06109819, 26.472213, 60.39586372, 46.59109487)
lead_100_1h <- c(173.0601413, 175.2039043, 115.1549172, 131.491774,
                 120.8302788, 92.68566509, 62.09333772, 62.09333772,
                 120.8302788, 135.2981148, 193.3284461, 210.7625292)
lead_100_4h <- c(96.20605594, 111.9488651, 71.04447208, 51.69280618,
                 89.79231888, 85.51649417, 94.5182304, 80.46324679,
                 110.5346175, 123.9989165, 96.20605594, 99.90628886,
                 106.0230004)
lead_100_24h <- c(85.17034404, 100.0602643, 69.36951098, 111.7214229,
                  101.9919297, 81.32977149, 119.9970839, 148.3612444,
                  121.8591076, 108.4939152, 84.90828144, 99.30793151,
                  84.55227187)

# Combine into one vector
values <- c(lead_100_0h, lead_100_1h, lead_100_4h, lead_100_24h)

# Create grouping factor
groups <- factor(c(
  rep("0.1h", length(lead_100_0h)),
  rep("1.5h", length(lead_100_1h)),
  rep("4h", length(lead_100_4h)),
  rep("24h", length(lead_100_24h))
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
write.csv(welch_summary, "lead_50mgL_welch_anova_result.csv", row.names = FALSE)

# Conditional Games-Howell post hoc test
if (p_val <= 0.05) {
  cat("\nWelch's ANOVA is significant (p <= 0.05), conducting Games-Howell post-hoc test...\n")
  posthoc <- games_howell_test(df, value ~ timepoint)
  print(posthoc)
  posthoc_rounded <- posthoc %>% mutate(across(where(is.numeric), ~ round(., 20)))
  write.csv(posthoc_rounded, "lead_50mgL_games_howell_posthoc_results.csv", row.names = FALSE)
} else {
  cat("\nWelch's ANOVA is NOT significant (p > 0.05), skipping post-hoc test.\n")
}
