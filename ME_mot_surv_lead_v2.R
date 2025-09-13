# Install and load required packages
if (!require("rstatix")) install.packages("rstatix")
if (!require("dplyr")) install.packages("dplyr")
library(rstatix)
library(dplyr)

# Define lead 100 mg/L data vectors
lead_100_0h <- c(95.14097451, 92.63726466, 125.722002, 120.6525665, 76.74889659,
                 60.00368279, 88.00540142, 35.81615174, 70.00429659, 50.00306899, 
                 114.0810759, 88.00540142)

lead_100_1h <- c(253.0919062, 256.2270537, 168.408377, 192.3002228, 176.7083129,
                 135.5482059, 90.80843857, 90.80843857, 176.7083129, 197.8668082,
                 282.7333006, 308.2297858)

lead_100_4h <- c(99.32437948, 115.5774598, 73.34723408, 53.3683233, 92.70275418,
                 88.28833732, 97.58184651, 83.0712992, 114.1173722, 128.0180891,
                 99.32437948, 103.1445479, 109.4595202)

lead_100_24h <- c(95.1336673, 111.7654273, 77.48443491, 124.7907215, 113.9230611,
                  90.84382023, 134.0344786, 165.7167108, 136.114324, 121.1856562,
                  94.84094832, 110.9250858, 94.44329236)

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

# Welch's ANOVA
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
  
  # Round numeric values for cleaner CSV
  posthoc_rounded <- posthoc %>% mutate(across(where(is.numeric), ~ round(., 20)))
  write.csv(posthoc_rounded, "lead_50mgL_games_howell_posthoc_results.csv", row.names = FALSE)
} else {
  cat("\nWelch's ANOVA is NOT significant (p > 0.05), skipping post-hoc test.\n")
}
