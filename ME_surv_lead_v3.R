# Install and load required packages
if (!require("rstatix")) install.packages("rstatix")
if (!require("dplyr")) install.packages("dplyr")
library(rstatix)
library(dplyr)

# Define lead 50 mg/L data vectors
lead_50_0h <- c(61.76470588, 123.5294118, 52.94117647)
lead_50_1h <- c(113.5135135, 83.51351351, 72.97297297, 74.59459459, 81.08108108, 84.32432432)
lead_50_4h <- c(111.627907, 109.5348837, 118.6046512, 97.6744186, 111.627907, 103.9534884)
lead_50_24h <- c(86.14864865, 99.32432432, 167.2297297, 109.9662162, 106.4189189, 108.9527027)

# Combine into one vector and create grouping factor
values <- c(lead_50_0h, lead_50_1h, lead_50_4h, lead_50_24h)
groups <- factor(c(
  rep("0.1h", length(lead_50_0h)),
  rep("1.5h", length(lead_50_1h)),
  rep("4h", length(lead_50_4h)),
  rep("24h", length(lead_50_24h))
), levels = c("0.1h", "1.5h", "4h", "24h"))

# Build dataframe
df <- data.frame(timepoint = groups, value = values)
print(df)

# Kruskal-Wallis test
kw_test <- kruskal_test(df, value ~ timepoint)
print(kw_test)

# Save Kruskal–Wallis output rounded to 20 digits
kw_summary <- kw_test %>% mutate(across(where(is.numeric), ~ round(., 20)))
write.csv(kw_summary, "lead_25mgL_kruskal_wallis_result.csv", row.names = FALSE)

# Dunn's posthoc test if KW is significant
if (kw_test$p <= 0.05) {
  cat("\nKruskal-Wallis is significant (p <= 0.05), conducting Dunn's test...\n")
  dunn_results <- dunn_test(df, value ~ timepoint, p.adjust.method = "holm")
  print(dunn_results)
  dunn_results_rounded <- dunn_results %>% mutate(across(where(is.numeric), ~ round(., 20)))
  write.csv(dunn_results_rounded, "lead_25mgL_dunn_posthoc_results.csv", row.names = FALSE)
} else {
  cat("\nKruskal-Wallis is NOT significant (p > 0.05), skipping posthoc.\n")
}
