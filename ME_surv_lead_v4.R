# Install and load required packages
if (!require("rstatix")) install.packages("rstatix")
if (!require("dplyr")) install.packages("dplyr")
library(rstatix)
library(dplyr)

# Define lead 10 mg/L data vectors
lead_10_0h <- c(95.12195122, 43.90243902, 80.48780488, 76.82926829, 36.58536585, 52.68292683)
lead_10_1h <- c(92.57142857, 111.4285714, 72.85714286, 120, 99.42857143)
lead_10_4h <- c(117.0731707, 100.9756098, 139.0243902, 98.7804878, 124.3902439, 100.2439024)
lead_10_24h <- c(158.490566, 133.3333333, 144.0251572)

# Combine into one vector and create grouping factor
values <- c(lead_10_0h, lead_10_1h, lead_10_4h, lead_10_24h)
groups <- factor(c(
  rep("0.1h", length(lead_10_0h)),
  rep("1.5h", length(lead_10_1h)),
  rep("4h", length(lead_10_4h)),
  rep("24h", length(lead_10_24h))
), levels = c("0.1h", "1.5h", "4h", "24h"))

# Build dataframe
df <- data.frame(timepoint = groups, value = values)
print(df)

# Kruskal-Wallis test
kw_test <- kruskal_test(df, value ~ timepoint)
print(kw_test)

# Save Kruskal–Wallis output rounded to 20 digits
kw_summary <- kw_test %>% mutate(across(where(is.numeric), ~ round(., 20)))
write.csv(kw_summary, "lead_5mgL_kruskal_wallis_result.csv", row.names = FALSE)

# Dunn's posthoc test if KW is significant
if (kw_test$p <= 0.05) {
  cat("\nKruskal-Wallis is significant (p <= 0.05), conducting Dunn's test...\n")
  dunn_results <- dunn_test(df, value ~ timepoint, p.adjust.method = "holm")
  print(dunn_results)
  dunn_results_rounded <- dunn_results %>% mutate(across(where(is.numeric), ~ round(., 20)))
  write.csv(dunn_results_rounded, "lead_5mgL_dunn_posthoc_results.csv", row.names = FALSE)
} else {
  cat("\nKruskal-Wallis is NOT significant (p > 0.05), skipping posthoc.\n")
}
