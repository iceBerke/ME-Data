# Install and load required packages
if (!require("rstatix")) install.packages("rstatix")
if (!require("dplyr")) install.packages("dplyr")
library(rstatix)
library(dplyr)

# Define zinc 50 mg/L data vectors
zinc_50_0h <- c(97.53694581, 66.50246305, 59.11330049)
zinc_50_1h <- c(35.02538071, 33.50253807, 42.63959391)
zinc_50_4h <- c(10.93117409, 6.923076923, 21.86234818, 12.63157895, 8.502024291, 6.315789474)
zinc_50_24h <- c(0.479233227, 0.095846645, 0.431309904, 0.095846645, 0.383386581)

# Combine into one vector and create grouping factor
values <- c(zinc_50_0h, zinc_50_1h, zinc_50_4h, zinc_50_24h)
groups <- factor(c(
  rep("0.1h", length(zinc_50_0h)),
  rep("1.5h", length(zinc_50_1h)),
  rep("4h", length(zinc_50_4h)),
  rep("24h", length(zinc_50_24h))
), levels = c("0.1h", "1.5h", "4h", "24h"))

# Build dataframe
df <- data.frame(timepoint = groups, value = values)
print(df)

# Kruskal-Wallis test
kw_test <- kruskal_test(df, value ~ timepoint)
print(kw_test)

# Save Kruskal–Wallis output rounded to 20 digits
kw_summary <- kw_test %>% mutate(across(where(is.numeric), ~ round(., 20)))
write.csv(kw_summary, "zinc_25mgL_kruskal_wallis_result.csv", row.names = FALSE)

# Dunn's posthoc test if KW is significant
if (kw_test$p <= 0.05) {
  cat("\nKruskal-Wallis is significant (p <= 0.05), conducting Dunn's test...\n")
  dunn_results <- dunn_test(df, value ~ timepoint, p.adjust.method = "holm")
  print(dunn_results)
  dunn_results_rounded <- dunn_results %>% mutate(across(where(is.numeric), ~ round(., 20)))
  write.csv(dunn_results_rounded, "zinc_25mgL_dunn_posthoc_results.csv", row.names = FALSE)
} else {
  cat("\nKruskal-Wallis is NOT significant (p > 0.05), skipping posthoc.\n")
}
