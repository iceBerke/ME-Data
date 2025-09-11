# Install and load required packages
if (!require("rstatix")) install.packages("rstatix")
if (!require("dplyr")) install.packages("dplyr")
library(rstatix)
library(dplyr)

# Define nickel 100 mg/L data vectors
nickel_100_0h <- c(63.96384699, 72.20161517, 74.87574906, 47.60546055, 63.63532184, 66.64764477, 65.70004793, 62.38219551, 56.50561187, 69.00685343, 59.34379329, 54.39404192, 52.05953368)
nickel_100_1h <- c(25.49672468, 21.26632642, 30.66200943, 28.68381527, 20.26662731, 26.94540222, 37.24390674, 9.698140677, 15.29803481, 24.39501436, 33.63397724, 42.49454114, 28.74176237, 36.59252154)
nickel_100_4h <- c(0, 0, 0, 0, 0, 13.33588204, 6.918615496, 0, 0, 0, 8.847844817, 0)
nickel_100_24h <- c(19.68399032, 13.63227808, 0, 0, 4.808646036, 0, 0, 0, 0, 4.680415475, 0, 0)

# Combine into one vector and create grouping factor for timepoints
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
