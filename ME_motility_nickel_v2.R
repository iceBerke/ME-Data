# Install and load required packages
if (!require("rstatix")) install.packages("rstatix")
if (!require("dplyr")) install.packages("dplyr")
library(rstatix)
library(dplyr)

# Define your nickel_50 data
nickel_50_0h <- c(146.2412805, 117.2893343, 140.1639945, 83.0954596,
                  135.8196611, 115.7442054, 104.810606, 130.2831527,
                  90.7478042, 101.8045065, 45.02162025, 70.68554031,
                  43.40407701, 45.22225136)
nickel_50_1h <- c(33.43701837, 59.338934, 33.43701837, 49.21804105,
                  60.09626274, 35.26918376, 36.95670451, 56.67799526,
                  51.77344779, 32.03851189, 37.95553436, 27.09366118,
                  26.33165196, 33.33120502, 23.19504878)
nickel_50_4h <- c(52.27232816, 51.85965188, 72.79733837, 64.31080373,
                  55.19044357, 34.45221629, 34.80376951, 30.31795033,
                  44.21367757, 42.65512493, 49.21745184, 49.21745184,
                  47.04509534, 41.41796493, 82.49782403)
nickel_50_24h <- c(17.57638384, 20.27451294, 25.34314118, 34.71901573,
                   18.4903558, 23.48876499, 4.567775643, 26.66878241,
                   13.3343912, 38.95440127, 37.68414906, 21.90800451,
                   15.27287098, 32.55344332, 36.4941233)

# Combine into one vector
values <- c(nickel_50_0h, nickel_50_1h, nickel_50_4h, nickel_50_24h)

# Create grouping factor
groups <- factor(c(
  rep("0.1h", length(nickel_50_0h)),
  rep("1.5h", length(nickel_50_1h)),
  rep("4h", length(nickel_50_4h)),
  rep("24h", length(nickel_50_24h))
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
write.csv(welch_summary, "nickel_25mgL_welch_anova_result.csv", row.names = FALSE)

# Conditional Games-Howell post hoc test
if (p_val <= 0.05) {
  cat("\nWelch's ANOVA is significant (p <= 0.05), conducting Games-Howell post-hoc test...\n")
  posthoc <- games_howell_test(df, value ~ timepoint)
  print(posthoc)
  # Round numeric values for cleaner CSV
  posthoc_rounded <- posthoc %>% mutate(across(where(is.numeric), ~ round(., 20)))
  write.csv(posthoc_rounded, "nickel_25mgL_games_howell_posthoc_results.csv", row.names = FALSE)
} else {
  cat("\nWelch's ANOVA is NOT significant (p > 0.05), skipping post-hoc test.\n")
}
