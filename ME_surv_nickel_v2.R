# Install and load required packages
if (!require("rstatix")) install.packages("rstatix")
if (!require("dplyr")) install.packages("dplyr")
library(rstatix)
library(dplyr)

# Define nickel 100 mg/L data vectors
nickel_100_0h <- c(128.5714286, 101.0204082, 117.3469388)
nickel_100_1h <- c(94.92537313, 93.13432836, 70.74626866)
nickel_100_4h <- c(23.3490566, 12.73584906, 12.02830189)
nickel_100_24h <- c(39.375, 18.5625, 25.3125, 18.75, 40.3125, 12.65625)

# Combine into one vector and create grouping factor
values <- c(nickel_100_0h, nickel_100_1h, nickel_100_4h, nickel_100_24h)
groups <- factor(c(
  rep("0.1h", length(nickel_100_0h)),
  rep("1.5h", length(nickel_100_1h)),
  rep("4h", length(nickel_100_4h)),
  rep("24h", length(nickel_100_24h))
), levels = c("0.1h", "1.5h", "4h", "24h"))

# Build dataframe
df <- data.frame(timepoint = groups, value = values)
print(df)

# Kruskal-Wallis test
kw_test <- kruskal_test(df, value ~ timepoint)
print(kw_test)

# Save Kruskal–Wallis output rounded to 20 digits
kw_summary <- kw_test %>% mutate(across(where(is.numeric), ~ round(., 20)))
write.csv(kw_summary, "nickel_50mgL_kruskal_wallis_result.csv", row.names = FALSE)

# Dunn's posthoc test if KW is significant
if (kw_test$p <= 0.05) {
  cat("\nKruskal-Wallis is significant (p <= 0.05), conducting Dunn's test...\n")
  dunn_results <- dunn_test(df, value ~ timepoint, p.adjust.method = "holm")
  print(dunn_results)
  dunn_results_rounded <- dunn_results %>% mutate(across(where(is.numeric), ~ round(., 20)))
  write.csv(dunn_results_rounded, "nickel_50mgL_dunn_posthoc_results.csv", row.names = FALSE)
} else {
  cat("\nKruskal-Wallis is NOT significant (p > 0.05), skipping posthoc.\n")
}
