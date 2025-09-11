# Install and load required packages
if (!require("rstatix")) install.packages("rstatix")
if (!require("dplyr")) install.packages("dplyr")
library(rstatix)
library(dplyr)

# Define nickel concentration data (0h)
nickel_200_0h <- c(57.17488308, 49.35300277, 59.41161477, 37.20819432,
                   90.60594845, 59.94096354, 84.01642492, 76.28849905,
                   47.75539901, 49.50967897, 35.12511008, 44.89219596,
                   27.21736279, 30.47706369)

nickel_100_0h <- c(63.96384699, 72.20161517, 74.87574906, 47.60546055,
                   63.63532184, 66.64764477, 65.70004793, 62.38219551,
                   56.50561187, 69.00685343, 59.34379329, 54.39404192,
                   52.05953368)

nickel_50_0h <- c(146.2412805, 117.2893343, 140.1639945, 83.0954596,
                  135.8196611, 115.7442054, 104.810606, 130.2831527,
                  90.7478042, 101.8045065, 45.02162025, 70.68554031,
                  43.40407701, 45.22225136)

nickel_10_0h <- c(142.1270757, 105.0504473, 101.3228507, 123.273484,
                  144.0095535, 83.31587196, 92.9292418, 142.6866311,
                  71.34331556, 111.7607181, 79.54437158, 90.01381461)

# Combine into one vector
values <- c(nickel_200_0h, nickel_100_0h, nickel_50_0h, nickel_10_0h)

# Create grouping factor for concentration
groups <- factor(c(
  rep("100", length(nickel_200_0h)),
  rep("50", length(nickel_100_0h)),
  rep("25", length(nickel_50_0h)),
  rep("5", length(nickel_10_0h))
), levels = c("5", "25", "50", "100"))

# Build dataframe
df <- data.frame(concentration = groups, value = values)
print(head(df))

# Welch's ANOVA
welch_test <- oneway.test(value ~ concentration, data = df, var.equal = FALSE)
print(welch_test)

# Extract p-value
p_val <- welch_test$p.value

# Save Welch ANOVA result
welch_summary <- data.frame(statistic = welch_test$statistic,
                            parameter = welch_test$parameter,
                            p.value = p_val)
write.csv(welch_summary, "nickel_0h_concentration_welch_anova_result.csv", row.names = FALSE)

# Conditional Games-Howell post hoc test if Welch ANOVA significant
if (p_val <= 0.05) {
  cat("\nWelch's ANOVA is significant (p <= 0.05), conducting Games-Howell post-hoc test...\n")
  posthoc <- games_howell_test(df, value ~ concentration)
  print(posthoc)
  # Round numeric values for cleaner CSV output
  posthoc_rounded <- posthoc %>% mutate(across(where(is.numeric), ~ round(., 20)))
  write.csv(posthoc_rounded, "nickel_0h_concentration_games_howell_posthoc_results.csv", row.names = FALSE)
} else {
  cat("\nWelch's ANOVA is NOT significant (p > 0.05), skipping post-hoc test.\n")
}
