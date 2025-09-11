# Install and load required packages
if (!require("rstatix")) install.packages("rstatix")
if (!require("dplyr")) install.packages("dplyr")
library(rstatix)
library(dplyr)

# Define nickel 10 mg/L data vectors
nickel_10_0h <- c(142.8571429, 153.5714286, 166.0714286)
nickel_10_1h <- c(108.7155963, 108.7155963, 118.3486239)
nickel_10_4h <- c(104.8192771, 104.8192771, 86.74698795)
nickel_10_24h <- c(95.45454545, 90.90909091, 63.63636364)

# Combine into one vector and create grouping factor
values <- c(nickel_10_0h, nickel_10_1h, nickel_10_4h, nickel_10_24h)
groups <- factor(c(
  rep("0.1h", length(nickel_10_0h)),
  rep("1.5h", length(nickel_10_1h)),
  rep("4h", length(nickel_10_4h)),
  rep("24h", length(nickel_10_24h))
), levels = c("0.1h", "1.5h", "4h", "24h"))

# Build dataframe
df <- data.frame(timepoint = groups, value = values)
print(df)

# Kruskal-Wallis test
kw_test <- kruskal_test(df, value ~ timepoint)
print(kw_test)

# Save Kruskal–Wallis output rounded to 20 digits
kw_summary <- kw_test %>% mutate(across(where(is.numeric), ~ round(., 20)))
write.csv(kw_summary, "nickel_5mgL_kruskal_wallis_result.csv", row.names = FALSE)

# Dunn's posthoc test if KW is significant
if (kw_test$p <= 0.05) {
  cat("\nKruskal-Wallis is significant (p <= 0.05), conducting Dunn's test...\n")
  dunn_results <- dunn_test(df, value ~ timepoint, p.adjust.method = "holm")
  print(dunn_results)
  dunn_results_rounded <- dunn_results %>% mutate(across(where(is.numeric), ~ round(., 20)))
  write.csv(dunn_results_rounded, "nickel_5mgL_dunn_posthoc_results.csv", row.names = FALSE)
} else {
  cat("\nKruskal-Wallis is NOT significant (p > 0.05), skipping posthoc.\n")
}
